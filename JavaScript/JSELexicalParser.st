"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSELexicalParser,
	#superclass : #JSECharactersParser,
	#instVars : [
		'sourceCharacter',
		'inputElementDiv',
		'comment',
		'tokenParser',
		'divPunctuator',
		'multiLineComment',
		'singleLineComment',
		'multiLineCommentChars',
		'multiLineNotAsteriskChar',
		'postAsteriskCommentChars',
		'multiLineNotForwardSlashOrAsteriskChar',
		'singleLineCommentChars',
		'singleLineCommentChar',
		'identifierName',
		'punctuator',
		'numericLiteral',
		'stringLiteral',
		'reservedWord',
		'identifierStart',
		'identifierPart',
		'unicodeLetter',
		'unicodeEscapeSequence',
		'unicodeCombiningMark',
		'unicodeDigit',
		'unicodeConnectorPunctuation',
		'keyword',
		'futureReservedWord',
		'nullLiteral',
		'booleanLiteral',
		'decimalLiteral',
		'decimalIntegerLiteral',
		'nonZeroDigit',
		'doubleStringCharacters',
		'singleStringCharacters',
		'doubleStringCharacter',
		'singleStringCharacter',
		'escapeSequence',
		'lineContinuation',
		'lineTerminatorSequence',
		'characterEscapeSequence',
		'hexEscapeSequence',
		'singleEscapeCharacter',
		'nonEscapeCharacter',
		'escapeCharacter',
		'identifier',
		'literal',
		'regularExpressionFlags',
		'regularExpressionNonTerminator',
		'regularExpressionBackslashSequence',
		'regularExpressionClassChars',
		'regularExpressionClassChar',
		'regularExpressionLiteral',
		'inputElementRegExp',
		'pattern',
		'alternative',
		'assertion',
		'atom',
		'quantifier',
		'disjunction',
		'quantifierPrefix',
		'patternCharacter',
		'atomEscape',
		'characterClass',
		'decimalEscape',
		'characterEscape',
		'characterClassOrAnchorEscape',
		'controlEscape',
		'controlLetter',
		'identityEscape',
		'term',
		'macro'
	],
	#category : #JavaScript
}

{ #category : #constants }
JSELexicalParser class >> divPunctuators [
	"
	sorted by size
	"
	^#( '/=' '/' )]

{ #category : #constants }
JSELexicalParser class >> futureReservedWords [
	^#(
		'class'
		'enum'
		'extends'
		'super'
		'export'
		'import'	
	)]

{ #category : #constants }
JSELexicalParser class >> keywords [
	^#(
		'break'
		'do'
		'instanceof'
		'typeof'
		'case'
		'else'
		'new'
		'var'
		'const'
		'let'
		'catch'
		'finally'
		'return'
		'void'
		'continue'
		'for'
		'switch'
		'while'
		'debugger'
		'function'
		'this'
		'with'
		'default'
		'if'
		'throw'
		'delete'
		'in'
		'try'
	)]

{ #category : #constants }
JSELexicalParser class >> literalReservedWords [
	^#('false' 'true' 'null')]

{ #category : #'instance creation' }
JSELexicalParser class >> newNoRegex [
	" returns a parser that does not allow regular expressions "

	^ self newStartingAt: #startNoRegex]

{ #category : #constants }
JSELexicalParser class >> punctuators [
	^#('>>>=' '===' '!==' '>>>' '<<=' '>>='
		'<=' '>=' '==' '!=' '++' '--' '<<' '>>' '&&' '||' '+=' '-=' '*=' '%=' '&=' '|=' '^='
		'{' '}' '(' ')' '[' ']' '.' ';' ',' '<' '>' '+' '-' '*' '%' '&' '|' '^' '!' '~' '?' ':' '=')]

{ #category : #constants }
JSELexicalParser class >> reservedWords [
	^self keywords , self futureReservedWords , self literalReservedWords]

{ #category : #'A.7 Regular Expressions' }
JSELexicalParser >> alternative [
	^term star]

{ #category : #'A.7 Regular Expressions' }
JSELexicalParser >> assertion [
	^$^ asParser / $$ asParser / ($\ asParser , ($b asParser / $B asParser))
		/ ($( asParser , $? asParser , ($= asParser / $! asParser) , disjunction
			, $) asParser)]

{ #category : #'A.7 Regular Expressions' }
JSELexicalParser >> atom [
	^patternCharacter / $. asParser / ($\ asParser , atomEscape) / characterClass
		/ ($( asParser , ($? asParser , $: asParser) optional , disjunction
			, $) asParser)]

{ #category : #'A.7 Regular Expressions' }
JSELexicalParser >> atomEscape [
	^decimalEscape / characterEscape / characterClassOrAnchorEscape]

{ #category : #'7.8 Literals' }
JSELexicalParser >> booleanLiteral [
	^('true' asParser jseToken: #boolean valueBlock: [true])
		/ ('false' asParser jseToken: #boolean valueBlock: [false])]

{ #category : #'A.7 Regular Expressions' }
JSELexicalParser >> characterClass [
	^$[ asParser , regularExpressionClassChars , $] asParser]

{ #category : #'A.7 Regular Expressions' }
JSELexicalParser >> characterClassOrAnchorEscape [
	^self anyOf: #($d $D $s $S $w $W $c $A $Z $B $< $>)]

{ #category : #'A.7 Regular Expressions' }
JSELexicalParser >> characterEscape [
	^controlEscape / ($c asParser , controlLetter) / hexEscapeSequence
		/ unicodeEscapeSequence
		/ identityEscape]

{ #category : #'7.8 Literals' }
JSELexicalParser >> characterEscapeSequence [
	^singleEscapeCharacter / nonEscapeCharacter]

{ #category : #'7.4 Comments' }
JSELexicalParser >> comment [
	^multiLineComment / singleLineComment]

{ #category : #'A.7 Regular Expressions' }
JSELexicalParser >> controlEscape [
	^self anyOf: #($f $n $r $t $v $a $e)]

{ #category : #'A.7 Regular Expressions' }
JSELexicalParser >> controlLetter [
	^self alphabeticCharacter]

{ #category : #'A.7 Regular Expressions' }
JSELexicalParser >> decimalEscape [
	^decimalIntegerLiteral , decimalDigit not
		map: [:decIntLiteral :n | decIntLiteral]]

{ #category : #'7.8 Literals' }
JSELexicalParser >> decimalIntegerLiteral [
	^$0 asParser ==> [:s | '0']
		/ (nonZeroDigit , decimalDigits optional
			==> [:s | (s at: 2) notNil
				ifTrue: [{s at: 1} , (s at: 2)]
				ifFalse: [{s at: 1}]])]

{ #category : #'7.8 Literals' }
JSELexicalParser >> decimalLiteral [
	^(decimalIntegerLiteral , $. asParser , decimalDigits optional
		, exponentPart optional
		map: [:int :dot :dec :exp | self
			numberFromIntegerCharacters: int
			decimalPlaces: dec
			exponent: exp])
		/ ($. asParser , decimalDigits , exponentPart optional
			map: [:dot :dec :exp | self
				numberFromIntegerCharacters: nil
				decimalPlaces: dec
				exponent: exp])
		/ (decimalIntegerLiteral , exponentPart optional
			map: [:int :exp | self
				numberFromIntegerCharacters: int
				decimalPlaces: nil
				exponent: exp])]

{ #category : #'A.7 Regular Expressions' }
JSELexicalParser >> disjunction [
	^alternative , ($| asParser , alternative) star]

{ #category : #'7.5 Tokens' }
JSELexicalParser >> divPunctuator [
	^(self anyOfStrings: self class divPunctuators) jseToken: #punctuator]

{ #category : #'7.8 Literals' }
JSELexicalParser >> doubleStringCharacter [
	^self stringCharacterWithQuoteChar: $"]

{ #category : #'7.8 Literals' }
JSELexicalParser >> doubleStringCharacters [
	^doubleStringCharacter plus
		==> [:characterArray | self stringFromCharacters: characterArray]]

{ #category : #'7.8 Literals' }
JSELexicalParser >> escapeCharacter [
	^singleEscapeCharacter / decimalDigit / $x asParser / $u asParser]

{ #category : #'7.8 Literals' }
JSELexicalParser >> escapeSequence [
	^characterEscapeSequence
		/ ($0 asParser , decimalDigit not ==> [:s | Character codePoint: 0])
		/ hexEscapeSequence
		/ unicodeEscapeSequence]

{ #category : #'7.6 Identifier Names and Identifiers' }
JSELexicalParser >> futureReservedWord [
	^self anyOfStrings: self class futureReservedWords]

{ #category : #'7.8 Literals' }
JSELexicalParser >> hexEscapeSequence [
	^$x asParser , (hexDigit min: 2 max: 2)
		==> [:s | Character codePoint: (self integerFromHexCharacters: (s at: 2))]]

{ #category : #'7.6 Identifier Names and Identifiers' }
JSELexicalParser >> identifier [
	^identifierName butNot: reservedWord]

{ #category : #'7.6 Identifier Names and Identifiers' }
JSELexicalParser >> identifierName [
	^(identifierStart , identifierPart star
		==> [:s | (String with: (s at: 1)) , (s at: 2)]
		jseToken: #identifierName) ==> [:token | 
		(" production 'identifier' is not reachable by the start rule, so tweak the token type here "
			self class reservedWords includes: token literalValue)
			ifFalse: [token type: #identifier].
		token]]

{ #category : #'7.6 Identifier Names and Identifiers' }
JSELexicalParser >> identifierPart [

	^ identifierStart
	 / unicodeCombiningMark 
	/ unicodeDigit 
	/ unicodeConnectorPunctuation 
	/ (self anyCodeUnitValue: self class zeroWidthCodeValues)]

{ #category : #'7.6 Identifier Names and Identifiers' }
JSELexicalParser >> identifierStart [
	^unicodeLetter / $$ asParser / $_ asParser
		/ ($\ asParser , unicodeEscapeSequence ==> [:s | s at: 2])]

{ #category : #'A.7 Regular Expressions' }
JSELexicalParser >> identityEscape [
	^(sourceCharacter butNot: identifierPart)
		/ (self anyCodeUnitValue: self class zeroWidthCodeValues)]

{ #category : #'7 Lexcial Conventions' }
JSELexicalParser >> inputElementDiv [
	^whiteSpace / lineTerminator / comment / tokenParser / divPunctuator]

{ #category : #'7 Lexcial Conventions' }
JSELexicalParser >> inputElementRegExp [
	" patched: regularExpressionLiteral fails for a single $/ , so divPunctuator was added "

	^ 
	whiteSpace
	/ lineTerminator 
	/ comment 
	/ tokenParser 
	/ regularExpressionLiteral
	/ divPunctuator]

{ #category : #private }
JSELexicalParser >> isPossibleRegexPredecessorToken: aToken [
	"
	would aToken and a regular expression token be a valid sequence?
	assume that a regular expression only appears 
		- in variable assignments
		- function calls
		- as a base expression (e.g. /\w+/.match(foo)
	"
	(#(#identifier #numeric #boolean #null) includes: aToken type)
		ifTrue: [^false].
	aToken type = #punctuator ifTrue: [
		(#('>>>=' '===' '!==' '>>>' '<<=' '>>='
			'<=' '>=' '==' '!=' '++' '--' '<<' '>>' '+=' '-=' '*=' '%=' '&=' '|=' '^='
			'}' ')' ']' '.' ',' '<' '>' '+' '-' '*' '%' '&' '|' '^' '~' )
			includes: aToken literalValue)
			ifTrue: [^false]].
	^true]

{ #category : #'7.6 Identifier Names and Identifiers' }
JSELexicalParser >> keyword [
	^self anyOfStrings: self class keywords]

{ #category : #'7.8 Literals' }
JSELexicalParser >> lineContinuation [
	^$\ asParser , lineTerminatorSequence ==> [:s | nil]]

{ #category : #'7.3 Line Terminators' }
JSELexicalParser >> lineTerminatorSequence [
	^(String with: Character cr with: Character lf) asParser
		/ (self anyCodeUnitValue: self class lineTerminatorCodeUnitValues)]

{ #category : #'7.8 Literals' }
JSELexicalParser >> literal [
	^nullLiteral / booleanLiteral / numericLiteral / stringLiteral]

{ #category : #'Bee extensions' }
JSELexicalParser >> macro [
	^$# asParser , $# asParser optional , identifierStart , identifierPart star
		==> [:s | 
			(s at: 2) isNil
				ifTrue: [(String with: (s at: 3)) , (s at: 4)]
				ifFalse: [(String with: $# with: (s at: 3)) , (s at: 4)]]
		jseToken: #macro]

{ #category : #'7.4 Comments' }
JSELexicalParser >> multiLineComment [
	^'/*' asParser , (multiLineCommentChars optional jseToken: #lineTerminator)
		, '*/' asParser
		==> [:s | | token lt |
			" check if a line terminator is present "
				token := s at: 2.
			lt := self class lineTerminatorCodeUnitValues.
			(token notNil
				and: [token value anySatisfy: [:ch | lt includes: ch codePoint]])
				ifTrue: [token]
				ifFalse: [nil]]]

{ #category : #'7.4 Comments' }
JSELexicalParser >> multiLineCommentChars [
	"
	bug or feature? ECMA-262 states that postAsteriskCommentChars is optional, 
	but that makes parsing very hard, because it consumes the asterisk of the closing */ 
	resolution: added  
		, $/ asParser not
	"
	^multiLineNotAsteriskChar , multiLineCommentChars optional
		/ ($* asParser , postAsteriskCommentChars optional , $/ asParser not)]

{ #category : #'7.4 Comments' }
JSELexicalParser >> multiLineNotAsteriskChar [

	^ PPPredicateObjectParser anyExceptAnyOf: '*']

{ #category : #'7.4 Comments' }
JSELexicalParser >> multiLineNotForwardSlashOrAsteriskChar [

	^ PPPredicateObjectParser anyExceptAnyOf: '/*']

{ #category : #'7.8 Literals' }
JSELexicalParser >> nonEscapeCharacter [

	^ sourceCharacter butNot: (escapeCharacter | lineTerminator )]

{ #category : #'7.8 Literals' }
JSELexicalParser >> nonZeroDigit [

	^ self anyOf: '123456789']

{ #category : #'7.8 Literals' }
JSELexicalParser >> nullLiteral [
	^'null' asParser ==> [:n | nil] jseToken: #null]

{ #category : #'7.8 Literals' }
JSELexicalParser >> numericLiteral [
	^hexIntegerLiteral / decimalLiteral jseToken: #numeric]

{ #category : #'private - regular expressions' }
JSELexicalParser >> parseReplacementsForRegexToken: regexToken [
	" yucky hack "

	| replacementTokens lastString lastTokens |
	replacementTokens := self parse: '/' , regexToken literalValue.
	replacementTokens isPetitFailure
		ifTrue: [ ^ replacementTokens ].
	lastString := '/'.
	regexToken flags notNil 
		ifTrue: [ lastString := lastString , regexToken flags ].
	lastTokens := self parse: lastString.
	^ replacementTokens , lastTokens.]

{ #category : #'A.7 Regular Expressions' }
JSELexicalParser >> pattern [
	" do not allow $=  because it is ambiguous (/= operator) "

	^ "$= jseParser not," disjunction]

{ #category : #'A.7 Regular Expressions' }
JSELexicalParser >> patternCharacter [

	^ sourceCharacter butNot: (lineTerminator / (self anyOf: #($^ $$ $\ $. $* $+ $? $( $) $[ $] ${ $} $| $/))).]

{ #category : #'7.4 Comments' }
JSELexicalParser >> postAsteriskCommentChars [
	^multiLineNotForwardSlashOrAsteriskChar , multiLineCommentChars optional
		/ ($* asParser , postAsteriskCommentChars optional , $/ asParser not)]

{ #category : #private }
JSELexicalParser >> processTokens: aRawTokenCollection [

	| tokens writeStream |
	tokens := OrderedCollection new: aRawTokenCollection size.
	writeStream := tokens writeStream.
	self processTokens: aRawTokenCollection on: writeStream preceedingLineTerminator: false. 
	^ writeStream contents]

{ #category : #private }
JSELexicalParser >> processTokens: aRawTokenCollection on: writeStream preceedingLineTerminator: preceedingLineTerminator [
	" removes gaps and line terminators. 
	do a sanity check for regular expressions (blame the ambiguous syntax for this)
	tokens are flagged if they are preceeded by a line terminator "

	| readStream hasPreceedingLineTerminator lastToken replacementTokens |
	readStream := aRawTokenCollection readStream.
	hasPreceedingLineTerminator := preceedingLineTerminator.
	lastToken := nil.
	[ readStream atEnd ] whileFalse: 
		[ | token |
			token := readStream next.
			token notNil 
				ifTrue: 
				[	token type = #lineTerminator 
						ifTrue: [ hasPreceedingLineTerminator := true ]
						ifFalse: 
						[	hasPreceedingLineTerminator 
								ifTrue: 
								[	token hasPreceedingLineTerminator: true.
									hasPreceedingLineTerminator := false
								].
							" check if a regular expression is expected here "
							( token type = #regex and: [ lastToken isNil or: [ (self isPossibleRegexPredecessorToken: lastToken) not ]]) 
								ifTrue: 
								[	replacementTokens := self parseReplacementsForRegexToken: token.
									replacementTokens isPetitFailure 
										ifTrue: [ writeStream nextPut: token ]
										ifFalse: 
										[	self processTokens: replacementTokens on: writeStream preceedingLineTerminator: hasPreceedingLineTerminator.
											hasPreceedingLineTerminator := false.
											token := replacementTokens last
										]
								]
								ifFalse: [ writeStream nextPut: token ]
						].
					lastToken := token
				]
		].]

{ #category : #'7.7 Punctuators' }
JSELexicalParser >> punctuator [
	^(self anyOfStrings: self class punctuators) jseToken: #punctuator]

{ #category : #'A.7 Regular Expressions' }
JSELexicalParser >> quantifier [
	^quantifierPrefix , $? asParser optional]

{ #category : #'A.7 Regular Expressions' }
JSELexicalParser >> quantifierPrefix [
	^$* asParser / $+ asParser / $? asParser
		/ (${ asParser , decimalDigits
			, ($, asParser , decimalDigits optional) optional
			, $} asParser)]

{ #category : #'private - regular expressions' }
JSELexicalParser >> regexStringFromFirst: firstElement elements: regexElements [
	" firstElement and regexElements are either characters or strings "

	| writeStream readStream |
	writeStream := ( String new: regexElements size + 1 ) writeStream.
	firstElement isString 
		ifTrue: [ writeStream nextPutAll: firstElement ]
		ifFalse: [ writeStream nextPut: firstElement ].
	readStream := regexElements readStream.
	[ readStream atEnd ] whileFalse: 
		[ | element |
			element := readStream next.
			element isString 
				ifTrue: [ writeStream nextPutAll: element ]
				ifFalse: [ writeStream nextPut: element ]
		].
	^ writeStream contents]

{ #category : #'private - regular expressions' }
JSELexicalParser >> regexTokenFrom: aStream with: parseBlock [
	" parse and complete the regex token "

	| token elements |
	elements := parseBlock value.
	^ elements isPetitFailure 
		ifTrue: [ elements ]
		ifFalse: 
		[	token := elements at: 2.
			token flags: ( elements at: 4 ).
			token
		]]

{ #category : #'private - regular expressions' }
JSELexicalParser >> regexTokenOn: aParser [
	" returns a parser that creates a JSE token for a regular expression "

	^ (JSETokenParser on: aParser) type: #regex; tokenClass: JSERegexToken; yourself]

{ #category : #'7.8.5 Regular Expression Literals' }
JSELexicalParser >> regularExpressionBackslashSequence [
	^$\ asParser , regularExpressionNonTerminator]

{ #category : #'7.8.5 Regular Expression Literals' }
JSELexicalParser >> regularExpressionClassChar [

	^ (regularExpressionNonTerminator butNot: (self anyOf: #($] $\)))
		/ regularExpressionBackslashSequence]

{ #category : #'7.8.5 Regular Expression Literals' }
JSELexicalParser >> regularExpressionClassChars [

	^ regularExpressionClassChar star]

{ #category : #'7.8.5 Regular Expression Literals' }
JSELexicalParser >> regularExpressionFlags [

	^   identifierPart star
		==> [ : elements | self stringFromCharacters: elements ]]

{ #category : #'7.8.5 Regular Expression Literals' }
JSELexicalParser >> regularExpressionLiteral [
	^$/ asParser , (self regexTokenOn: pattern) , $/ asParser
		, regularExpressionFlags
		>=> [:aStream :parseBlock | self regexTokenFrom: aStream with: parseBlock]]

{ #category : #'7.8.5 Regular Expression Literals' }
JSELexicalParser >> regularExpressionNonTerminator [

	^ (sourceCharacter butNot: lineTerminator)]

{ #category : #'7.6 Identifier Names and Identifiers' }
JSELexicalParser >> reservedWord [

	^ keyword / futureReservedWord / nullLiteral / booleanLiteral]

{ #category : #'7.8 Literals' }
JSELexicalParser >> singleEscapeCharacter [
	^$b asParser ==> [:c | Character codePoint: 16r8]
		/ ($t asParser ==> [:c | Character codePoint: 16r9])
		/ ($n asParser ==> [:c | Character codePoint: 16rA])
		/ ($v asParser ==> [:c | Character codePoint: 16rB])
		/ ($f asParser ==> [:c | Character codePoint: 16rC])
		/ ($r asParser ==> [:c | Character codePoint: 16rD])
		/ $" asParser
		/ $' asParser
		/ $\ asParser]

{ #category : #'7.4 Comments' }
JSELexicalParser >> singleLineComment [
	^'//' asParser , singleLineCommentChars optional ==> [:s | nil]]

{ #category : #'7.4 Comments' }
JSELexicalParser >> singleLineCommentChar [

	^ self anyExceptAnyCodeUnitValueOf: self class lineTerminatorCodeUnitValues]

{ #category : #'7.4 Comments' }
JSELexicalParser >> singleLineCommentChars [

	^ singleLineCommentChar, singleLineCommentChars optional]

{ #category : #'7.8 Literals' }
JSELexicalParser >> singleStringCharacter [

	^ self stringCharacterWithQuoteChar: $']

{ #category : #'7.8 Literals' }
JSELexicalParser >> singleStringCharacters [

	^ singleStringCharacter plus ==> [: characterArray | self stringFromCharacters: characterArray ]]

{ #category : #'7 Lexcial Conventions' }
JSELexicalParser >> sourceCharacter [

	^ PPPredicateObjectParser any]

{ #category : #accessing }
JSELexicalParser >> start [
	^(inputElementRegExp star ==> [:tokens | self processTokens: tokens]) end]

{ #category : #accessing }
JSELexicalParser >> startNoRegex [
	"
	do not allow regular expressions
	"
	^(inputElementDiv star ==> [:tokens | self processTokens: tokens]) end]

{ #category : #private }
JSELexicalParser >> stringCharacterWithQuoteChar: quoteChar [
	^(sourceCharacter butNot: (self anyOf: {quoteChar. $\}) | lineTerminator)
		/ ($\ asParser , escapeSequence ==> [:s | s at: 2])
		/ lineContinuation]

{ #category : #private }
JSELexicalParser >> stringFromCharacters: characterArray [
	" todo: move lineContinuation to avoid nil characters "

	^ String withAll: (( characterArray includes: nil ) 
				ifTrue: [ characterArray copyWithout: nil ]
				ifFalse: [ characterArray ])]

{ #category : #'7.8 Literals' }
JSELexicalParser >> stringLiteral [
	^$" asParser
		, (doubleStringCharacters optional
			jseToken: #string
			valueBlock: [:token | token literalValue ifNil: ['']]) , $" asParser
		/ ($' asParser
			, (singleStringCharacters optional
				jseToken: #string
				valueBlock: [:token | token literalValue ifNil: ['']]) , $' asParser)
		==> [:s | s at: 2]]

{ #category : #'A.7 Regular Expressions' }
JSELexicalParser >> term [

	^ assertion
	/ (atom, quantifier optional)]

{ #category : #'7.5 Tokens' }
JSELexicalParser >> tokenParser [
	"
	odd: original spec does not include nullLiteral and booleanLiteral here
	"
	^nullLiteral / booleanLiteral / identifierName / numericLiteral
		/ stringLiteral
		/ punctuator
		/ macro]

{ #category : #'7.6 Identifier Names and Identifiers' }
JSELexicalParser >> unicodeCombiningMark [
	^$ः asParser]

{ #category : #'7.6 Identifier Names and Identifiers' }
JSELexicalParser >> unicodeConnectorPunctuation [
	^PPPredicateObjectParser anyOf: #($_ $‿ $⁀ $⁔ $︳ $︴ $﹍ $﹎ $﹏ $＿)]

{ #category : #'7.6 Identifier Names and Identifiers' }
JSELexicalParser >> unicodeDigit [
	^#digit asParser]

{ #category : #'7.8 Literals' }
JSELexicalParser >> unicodeEscapeSequence [
	^$u asParser , (hexDigit min: 4 max: 4)
		==> [:s | Character codePoint: (self integerFromHexCharacters: (s at: 2))]]

{ #category : #'7.6 Identifier Names and Identifiers' }
JSELexicalParser >> unicodeLetter [
	^#letter asParser]

