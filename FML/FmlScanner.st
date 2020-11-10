"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlScanner,
	#superclass : #Object,
	#instVars : [
		'tokenType',
		'token',
		'hereChar',
		'aheadChar',
		'source',
		'buffer',
		'dataSeparator',
		'decimalSeparator',
		'typeTable'
	],
	#classVars : [
		'TypeTable'
	],
	#category : #FML
}

{ #category : #constants }
FmlScanner class >> defaultDataSeparator [
	^$,]

{ #category : #constants }
FmlScanner class >> defaultDecimalSeparator [
	^$.]

{ #category : #'instance creation' }
FmlScanner class >> forLocale [
	^self new useLocale]

{ #category : #initialization }
FmlScanner class >> initialize [
	"
	FmlScanner initialize
	"
	super initialize.
	self initializeTypesTable]

{ #category : #initialization }
FmlScanner class >> initializeTypesTable [
	"
	FmlScanner initializeTypesTable
	"
	TypeTable := self
		typesForSeparator: self defaultDataSeparator
		decimal: self defaultDecimalSeparator]

{ #category : #'instance creation' }
FmlScanner class >> new [
	^super new initialize]

{ #category : #initialization }
FmlScanner class >> typesForSeparator: dataSeparator decimal: decimalSeparator [
	| table binaries |
	binaries := #($* $+ $- $/ $< $= $> $\ $^ $~ $& $|)
		collect: [:c | c asInteger].
	table := Array new: 256 withAll: #xInvalid.
	table
		atAll: binaries put: #xBinary;
		atAll: #(9 10 12 13 32) put: #xDelimiter;
		atAll: ($0 asInteger to: $9 asInteger) put: #xDigit;
		atAll: ($A asInteger to: $Z asInteger) put: #xLetter;
		atAll: ($a asInteger to: $z asInteger) put: #xLetter;
		at: 30 put: #xEndOfStream;
		at: $_ asInteger put: #xLetter;
		at: $" asInteger put: #xDoubleQuote;
		at: $[ asInteger put: #xLeftSquareBracket;
		at: $] asInteger put: #xRightSquareBracket;
		at: $: asInteger put: #colon;
		at: $( asInteger put: #leftParenthesis;
		at: $) asInteger put: #rightParenthesis;
		at: $# asInteger put: #literalQuote;
		at: $' asInteger put: #xSingleQuote;
		at: dataSeparator asInteger put: #dataSeparator;
		at: decimalSeparator asInteger put: #xDecimalSeparator.
	^table]

{ #category : #accessing }
FmlScanner >> beNormalized [
	typeTable := TypeTable.
	dataSeparator := self class defaultDataSeparator.
	decimalSeparator := self class defaultDecimalSeparator]

{ #category : #accessing }
FmlScanner >> contents [
	^self contentsWith: #tokensDo:]

{ #category : #accessing }
FmlScanner >> contentsWith: aSelector [
	| answer |
	answer := OrderedCollection new: source size // 6.
	self perform: aSelector with: [:each | answer add: each].
	^ answer]

{ #category : #accessing }
FmlScanner >> dataSeparator: aCharacter decimalSeparator: anotherCharacter [
	(aCharacter == dataSeparator and: [anotherCharacter == decimalSeparator])
		ifTrue: [^self].
	(aCharacter == self class defaultDataSeparator
		and: [anotherCharacter == self class defaultDecimalSeparator])
		ifTrue: [^self beNormalized].
	typeTable := self class
		typesForSeparator: aCharacter
		decimal: anotherCharacter.
	dataSeparator := aCharacter.
	decimalSeparator := anotherCharacter]

{ #category : #initialization }
FmlScanner >> initialize [
	super initialize.
	self beNormalized]

{ #category : #testing }
FmlScanner >> isBinary: aCharacter [
	^(self typeOf: aCharacter) == #xBinary]

{ #category : #testing }
FmlScanner >> isDigit: aCharacter [
	^(self typeOf: aCharacter) == #xDigit ]

{ #category : #testing }
FmlScanner >> isLetter: aCharacter [
	^(self typeOf: aCharacter) == #xLetter ]

{ #category : #testing }
FmlScanner >> isPunctuation: aCharacter [
	^aCharacter == dataSeparator or: [
		aCharacter == decimalSeparator
			or: [(self typeOf: aCharacter) == #xPunctuation]]]

{ #category : #scanning }
FmlScanner >> scan: aStringOrStream [
	buffer := (String new: 40) writeStream.
	source := aStringOrStream readStream.
	self step; step]

{ #category : #scanning }
FmlScanner >> scannedString [
	| end |
	source isNil ifTrue: [^''].
	end := 1 max: source position.
	^source collection copyFrom: 1 to: end]

{ #category : #scanning }
FmlScanner >> scanScientificNotation [
	| peek sign ng m exp float |
	hereChar asLowercase = $e ifFalse: [^self].
	peek := source atEnd ifFalse: [source peek].
	sign := #($+ $-) includes: aheadChar.
	ng := sign and: [aheadChar == $-].
	((sign and: [self isDigit: peek]) or: [self isDigit: aheadChar])
		ifFalse: [^self].
	m := token.
	self step.
	sign ifTrue: [self step].
	self xDigit.
	exp := ng ifTrue: [token negated] ifFalse: [token].
	float := [m * (10 raisedTo: exp)]
		on: ArithmeticError
		do: [:e | self fail: e description].
	token := float]

{ #category : #scanning }
FmlScanner >> scanToken [
	[
		tokenType := self typeOf: hereChar.
		tokenType == #xDelimiter]
		whileTrue: [self step].
	tokenType first == $x
		ifTrue: [self perform: tokenType]
		ifFalse: [token := self step asString asSymbol].
	^token]

{ #category : #scanning }
FmlScanner >> step [
	| char |
	char := hereChar.
	hereChar := aheadChar.
	aheadChar := source atEnd ifTrue: [30 asCharacter] ifFalse: [source next].
	^char]

{ #category : #enumerating }
FmlScanner >> tokensDo: aBlock [
	[self scanToken == #endOfStream]
		whileFalse: [aBlock value: token]]

{ #category : #accessing }
FmlScanner >> typeOf: aCharacter [
	^typeTable at: aCharacter asInteger ifAbsent: #xLetter]

{ #category : #accessing }
FmlScanner >> useLocale [
	self
		dataSeparator: Locale current dataSeparator anyone
		decimalSeparator: Locale current decimalSeparator anyone]

{ #category : #actions }
FmlScanner >> xBinary [
	buffer reset.
	[self isBinary: hereChar] whileTrue: [buffer nextPut: self step].
	tokenType := #operator.
	token := buffer contents asSymbol]

{ #category : #actions }
FmlScanner >> xDecimalSeparator [
	^(self isDigit: aheadChar)
		ifTrue: [self xDigit]
		ifFalse: [self xPunctuation]]

{ #category : #actions }
FmlScanner >> xDigit [
	| decimals numeric |
	decimals := false.
	buffer reset.
	[
		(self isDigit: hereChar)
			or: [hereChar = decimalSeparator and: [self isDigit: aheadChar]]]
		whileTrue: [
			hereChar = decimalSeparator
				ifTrue: [
					decimals ifTrue: [self fail: 'More than one decimal separator'].
					decimals := true.
					self step.
					buffer nextPut: decimalSeparator]
				ifFalse: [buffer nextPut: self step]].
	tokenType := #number.
	numeric := buffer contents.
	numeric first = decimalSeparator ifTrue: [numeric := '0' , numeric].
	token := Float
		fastFromString: numeric
		decimalSeparator: decimalSeparator asString.
	self scanScientificNotation]

{ #category : #actions }
FmlScanner >> xDoubleQuote [
	| type |
	buffer reset.
	self step.
	[
		type := self typeOf: hereChar.
		type = #xDoubleQuote or: [type = #xEndOfStream]]
		whileFalse: [buffer nextPutAll: self step asString].
	self step.
	tokenType := #doubleQuoted.
	token := buffer contents.
	type == #xEndOfStream ifTrue: [self fail: 'Missing double quote']]

{ #category : #actions }
FmlScanner >> xEndOfStream [
	tokenType := token := #endOfStream]

{ #category : #actions }
FmlScanner >> xInvalid [
	self fail: 'Invalid character ' , hereChar asString]

{ #category : #actions }
FmlScanner >> xLeftSquareBracket [
	| type |
	buffer reset.
	self step.
	[
		type := self typeOf: hereChar.
		type = #xRightSquareBracket or: [type = #xEndOfStream]]
		whileFalse: [buffer nextPut: self step].
	self step.
	tokenType := #unit.
	token := buffer contents]

{ #category : #actions }
FmlScanner >> xLetter [
	buffer reset.
	[
		(self isLetter: hereChar)
			or: [self isDigit: hereChar]
			or: [(self isPunctuation: hereChar) and: [hereChar != dataSeparator]]]
		whileTrue: [buffer nextPut: self step].
	tokenType := #word.
	token := buffer contents]

{ #category : #actions }
FmlScanner >> xPunctuation [
	tokenType := #xPunctuation.
	token := self step asString]

{ #category : #actions }
FmlScanner >> xRightSquareBracket [
	self fail: 'Unexpected character: ]']

{ #category : #actions }
FmlScanner >> xSingleQuote [
	| type escape |
	buffer reset.
	self step.
	[
		escape := false.
		type := self typeOf: hereChar.
		(type == #xSingleQuote
			andNot: [escape := (self typeOf: aheadChar) == type])
			or: [type == #xEndOfStream]]
		whileFalse: [
			escape ifTrue: [self step].
			buffer nextPut: self step].
	self step.
	tokenType := #singleQuotedString.
	token := buffer contents.
	type == #xEndOfStream ifTrue: [self fail: 'Mising single quote']]

