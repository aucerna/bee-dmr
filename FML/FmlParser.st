"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlParser,
	#superclass : #FmlScanner,
	#instVars : [
		'here',
		'hereType',
		'expression'
	],
	#category : #FML
}

{ #category : #'public access' }
FmlParser class >> parse: aStringOrStream [
	"
	FmlParser parse: ('0.1 * .02 + (-.003)' replaceAll: '.' with: Locale current decimalSeparator)
	"
	^self forLocale parse: aStringOrStream]

{ #category : #'public access' }
FmlParser class >> parse: aString for: aForeignNode [
	^self parseNormalized: aString]

{ #category : #'public access' }
FmlParser class >> parseNormalized: aStringOrStream [
	"
	FmlParser parseNormalized: '0.1 * .02 + (-.003)'
	"
	^self new beNormalized parse: aStringOrStream]

{ #category : #constants }
FmlParser class >> separatorError [
	FmlParserError signal: 'Decimal and Data separators should be different']

{ #category : #parsing }
FmlParser >> advance [
	| answer |
	answer := here.
	here := token.
	hereType := tokenType.
	self scanToken.
	^answer]

{ #category : #parsing }
FmlParser >> array [
	| numbers |
	self advance.
	hereType == #leftParenthesis
		ifTrue: [self advance]
		ifFalse: [self fail: 'Expecting opening parenthesis'].
	numbers := OrderedCollection new.
	[self hereIsNumber] whileTrue: [
		self number.
		numbers add: expression value value].
	numbers isEmpty ifTrue: [self fail: 'Expecting numeric parameter'].
	hereType == #rightParenthesis
		ifFalse: [self fail: 'Expecting numeric parameter or closing parenthesis'].
	self advance.
	expression := numbers asArray asFmlValue]

{ #category : #parsing }
FmlParser >> basicFactor [
	hereType == #leftParenthesis ifTrue: [^self parenthesizedExpression].
	hereType == #doubleQuoted ifTrue: [^self variableName].
	hereType == #word ifTrue: [^self function].
	self hereIsNumber ifTrue: [^self number].
	hereType == #literalQuote ifTrue: [^self array].
	hereType == #singleQuotedString ifTrue: [^self text].
	hereType == #unit ifTrue: [^self fail: 'Missing number'].
	self fail: 'Missing expression']

{ #category : #parsing }
FmlParser >> binaryExpression [
	"
	exprCont     -> op term | <eos> op                -> $+ | $- | $/ | $* | $//
	| $< | $> | $= | $<= | $>= | $<>
	"
	| op |
	tokenType == #endOfStream ifTrue: [self fail: 'Unfinished expression'].
	expression isNil ifTrue: [self fail: 'Missing left operand'].
	op := self advance.
	(op size > 2
		or: [op size = 2 andNot: [#(#~= #// #\\ #<= #>= #<>) includes: op]])
		ifTrue: [self fail: 'Invalid binary operator ' , op].
	^FmlBinaryExpression new left: expression; operator: op]

{ #category : #testing }
FmlParser >> checkValid [
	decimalSeparator = dataSeparator ifTrue: [self separatorError].
	(self typeOf: decimalSeparator) == #xDecimalSeparator
		ifFalse: [FmlParserError signal: 'the decimal separator is invalid'].
	(self typeOf: dataSeparator) = #dataSeparator
		ifFalse: [FmlParserError signal: 'the list separator is invalid'].
	^true]

{ #category : #parsing }
FmlParser >> composeMessage: aString [
	^String streamContents: [:strm | 
		strm
			nextPutAll: aString;
			nextPutAll: ' in ';
			nextPutAll: self scannedString]]

{ #category : #parsing }
FmlParser >> expression [
	| op |
	self member.
	[hereType == #operator and: [self isMemberSeparator: here]] whileTrue: [
		op := self binaryExpression.
		self member.
		expression notNil
			ifTrue: [op right: expression]
			ifFalse: [self
				fail: 'Missing right argument from ' , op operator printString].
		expression := op]]

{ #category : #parsing }
FmlParser >> expressionContinuation [
	| op |
	(#(#'+' #'-' #'/' #'*' #'//' #'<' #'=' #'>' #'<=' #'>=' #'<>')
		includes: here)
		ifFalse: [self fail: 'Unrecognized operator ' , here asString printString].
	tokenType == #endOfStream ifTrue: [self fail: 'Unfinished expression'].
	expression isNil ifTrue: [self fail: 'Missing left operand'].
	op := FmlBinaryExpression new left: expression; operator: self advance.
	self term.
	expression notNil
		ifTrue: [op right: expression]
		ifFalse: [self
			fail: 'Missing right argument for ' , op operator printString].
	expression := op]

{ #category : #parsing }
FmlParser >> factor [
	| op |
	self basicFactor.
	hereType == #dataSeparatorCandidate ifTrue: [
		self
			fail: 'Specified data separator ' , here asString
				, ' differs from National Language data separator '
				, dataSeparator asString].
	[hereType == #operator and: [here = #'^']] whileTrue: [
		op := self binaryExpression.
		self basicFactor.
		expression notNil
			ifTrue: [op right: expression]
			ifFalse: [self
				fail: 'Missing right argument for ' , op operator printString].
		expression := op]]

{ #category : #'error handling' }
FmlParser >> fail: aString [
	| msg |
	msg := self composeMessage: aString.
	^FmlParserError expression: self scannedString signal: msg]

{ #category : #parsing }
FmlParser >> function [
	| name args f msg call |
	name := self advance.
	(self global: name) ifNotNil: [:g | ^expression := g].
	args := OrderedCollection new.
	hereType == #leftParenthesis
		ifTrue: [
			self advance.
			expression := call := FmlFunctionCall named: name]
		ifFalse: [
			f := [FmlFunctionCall named: name] on: FmlUnknownFunction do: [].
			msg := f isNil
				ifTrue: ['Unknown identifier ']
				ifFalse: ['Missing opening parenthesis after function named '].
			self fail: msg , name storeString].
	hereType == #rightParenthesis ifTrue: [
		self advance.
		^expression arguments: #()].
	[
		self expression.
		args add: expression.
		hereType == #dataSeparator and: [tokenType ~= #rightParenthesis]]
		whileTrue: [self advance].
	hereType == #dataSeparator
		ifTrue: [tokenType == #rightParenthesis
			ifTrue: [self fail: 'Missing last argument']].
	hereType == #rightParenthesis
		ifTrue: [
			self advance.
			expression := call arguments: args]
		ifFalse: [self fail: 'Missing data separator or closing parenthesis']]

{ #category : #parsing }
FmlParser >> global: name [
	(name equalsCaseInsensitive: 'true') ifTrue: [^true asFmlValue].
	(name equalsCaseInsensitive: 'false') ifTrue: [^false asFmlValue].
	name = 'NAN' ifTrue: [^Float nan asFmlValue].
	name = 'Undefined' ifTrue: [^FmlUndefinedValue new].
	^nil]

{ #category : #testing }
FmlParser >> hereIsNumber [
	^hereType == #number or: [here == #'-' or: [here == #'+']]]

{ #category : #testing }
FmlParser >> isMemberSeparator: operator [
	^#(#< #> #<= #>= #= #<>) includes: operator]

{ #category : #testing }
FmlParser >> isTermSeparator: operator [
	^#(#+ #- #< #> #<= #>= #=) includes: operator]

{ #category : #parsing }
FmlParser >> member [
	| op |
	self term.
	[hereType == #operator andNot: [self isMemberSeparator: here]] whileTrue: [
		op := self binaryExpression.
		self term.
		expression notNil
			ifTrue: [op right: expression]
			ifFalse: [self
				fail: 'Missing right argument from ' , op operator printString].
		expression := op]]

{ #category : #parsing }
FmlParser >> number [
	| negate e |
	(negate := here == #'-') ifTrue: [self advance].
	here == #'+' ifTrue: [self advance].
	(hereType == #number or: [hereType == #word and: [here = 'infinite']])
		ifTrue: [
			e := self advance.
			e = 'infinite' ifTrue: [e := Number infinity].
			expression := e asFmlValue]
		ifFalse: [self fail: 'Number expected'].
	negate ifTrue: [expression negate].
	hereType == #unit ifTrue: [
		expression unitName: here.
		self advance]]

{ #category : #parsing }
FmlParser >> parenthesizedExpression [
	expression := nil.
	self advance; expression.
	hereType == #rightParenthesis ifTrue: [self advance] ifFalse: [
		self
			fail: 'Invalid ' , hereType prettyPrint asLowercase , ' '
				, here asString storeString
				, ' when right-parenthesis was expected']]

{ #category : #parsing }
FmlParser >> parse: aStringOrStream [
	aStringOrStream size = 0 ifTrue: [^nil].
	self checkValid ifFalse: [^nil].
	expression := nil.
	self
		scan: aStringOrStream;
		advance;
		advance;
		expression.
	hereType == #endOfStream
		ifTrue: [expression isNil ifTrue: [self fail: 'Unrecognized expression']]
		ifFalse: [
			self
				fail: 'Invalid ' , hereType prettyPrint asLowercase , ' follows '
					, expression printString].
	expression isNil ifTrue: [expression := FmlExpression new].
	^expression]

{ #category : #parsing }
FmlParser >> parseVariableName: aStringOrStream [
	| string |
	string := aStringOrStream doubleQuoted.
	expression := nil.
	self
		scan: string;
		advance;
		advance;
		variableName.
	^expression]

{ #category : #'error handling' }
FmlParser >> separatorError [
	self class separatorError]

{ #category : #parsing }
FmlParser >> term [
	| op |
	self factor.
	[hereType == #operator andNot: [self isTermSeparator: here]] whileTrue: [
		op := self binaryExpression.
		self factor.
		expression notNil
			ifTrue: [op right: expression]
			ifFalse: [self
				fail: 'Missing right argument from ' , op operator printString].
		expression := op]]

{ #category : #parsing }
FmlParser >> text [
	hereType == #singleQuotedString
		ifFalse: [self fail: 'Expecting quoted string'].
	^expression := FmlString new value: self advance]

{ #category : #parsing }
FmlParser >> variableName [
	hereType == #doubleQuoted ifFalse: [self fail: 'Expecting variable name'].
	^expression := self advance variableName]

