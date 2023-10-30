"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #Character,
	#superclass : #Magnitude,
	#instVars : [
		'value'
	],
	#pools : [
		'CharacterConstants'
	],
	#category : #Kernel
}

{ #category : #unclassified }
Character class >> allCharacters [
	^ByteCharacters
]

{ #category : #'named characters' }
Character class >> ampersand [
	^$&
]

{ #category : #'named characters' }
Character class >> backspace [
	^self value: 8
]

{ #category : #'named characters' }
Character class >> backtick [
	^$`
]

{ #category : #'instance creation' }
Character class >> bee [
	^$🐝
]

{ #category : #'named characters' }
Character class >> belongs [
	^$∊
]

{ #category : #'named characters' }
Character class >> bullet [
	^Character value: 8226
]

{ #category : #'named characters' }
Character class >> comma [
	^$,
]

{ #category : #'named characters' }
Character class >> copyright [
	^$ⓒ
]

{ #category : #'named characters' }
Character class >> cr [
	^Cr
]

{ #category : #services }
Character class >> digitValue: anInteger [
	| n offset |
	n := anInteger asInteger.
	offset := n < 10 ifTrue: [48] ifFalse: [55].
	^self value: n + offset
]

{ #category : #'named characters' }
Character class >> dollar [
	^$$
]

{ #category : #'named characters' }
Character class >> doubleQuote [
	^$"
]

{ #category : #'named characters' }
Character class >> downArrow [
	^self value: 8595
]

{ #category : #'named characters' }
Character class >> ellipsis [
	^$…
]

{ #category : #'named characters' }
Character class >> emdash [
	^Emdash
]

{ #category : #'named characters' }
Character class >> emspace [
	^Character value: 8195
]

{ #category : #'named characters' }
Character class >> endash [
	^Endash
]

{ #category : #'named characters' }
Character class >> enspace [
	^Character value: 8194
]

{ #category : #'named characters' }
Character class >> equal [
	^$=
]

{ #category : #'named characters' }
Character class >> escape [
	^self value: 27
]

{ #category : #'named characters' }
Character class >> exclamation [
	^$!
]

{ #category : #'named characters' }
Character class >> exists [
	^$∃
]

{ #category : #'named characters' }
Character class >> ff [
	^self value: 12
]

{ #category : #'named characters' }
Character class >> forAll [
	^$∀
]

{ #category : #'named characters' }
Character class >> ge [
	^self value: 16r2265
]

{ #category : #'named characters' }
Character class >> greaterThan [
	^$>
]

{ #category : #initialization }
Character class >> initializeCharacterConstants [
	"
	Character initializeCharacterConstants
	"
	
	CharacterConstants := PoolDictionary new beConstantPool.
	CharacterConstants
		at: 'Bell' put: 7 asCharacter;
		at: 'Bs' put: 8 asCharacter;
		at: 'Tab' put: 9 asCharacter;
		at: 'Lf' put: 10 asCharacter;
		at: 'Ff' put: 12 asCharacter;
		at: 'Cr' put: 13 asCharacter;
		at: 'Esc' put: 27 asCharacter;
		at: 'Space' put: 32 asCharacter;
		at: 'Del' put: 127 asCharacter;
		at: 'TimerTick' put: 253 asCharacter;
		at: 'Emdash' put: 8212 asCharacter;
		at: 'Endash' put: 8211 asCharacter;
		at: 'Emspace' put: 8195 asCharacter;
		at: 'Enspace' put: 8194 asCharacter;
		at: 'Qmspace' put: 8197 asCharacter;
		at: 'Bullet' put: 8226 asCharacter;
		at: 'Lquote' put: 8216 asCharacter;
		at: 'Rquote' put: 8217 asCharacter;
		at: 'Ldblquote' put: 8220 asCharacter;
		at: 'Rdblquote' put: 8221 asCharacter
]

{ #category : #initialization }
Character class >> initializeCharacters [
	ByteCharacters := (0 to: 255) collect: [:i | super new setValue: i]
]

{ #category : #'named characters' }
Character class >> italicA [
	^Character value: 16r1D44E
]

{ #category : #'named characters' }
Character class >> ldblquote [
	^Character value: 8220
]

{ #category : #'named characters' }
Character class >> le [
	^self value: 16r2264
]

{ #category : #'named characters' }
Character class >> leftArrow [
	^self value: 16r2190
]

{ #category : #'named characters' }
Character class >> lessThan [
	^$<
]

{ #category : #'named characters' }
Character class >> lf [
	^self value: 10
]

{ #category : #'named characters' }
Character class >> lquote [
	^Character value: 8216
]

{ #category : #'named characters' }
Character class >> minus [
	^$-
]

{ #category : #'named characters' }
Character class >> muchGreater [
	^$≫
]

{ #category : #'instance creation' }
Character class >> new [
	^self shouldNotImplement
]

{ #category : #'named characters' }
Character class >> null [
	^self value: 0
]

{ #category : #'named characters' }
Character class >> oplus [
	"
	Character tensor
	"
	^8853 asCharacter
]

{ #category : #'named characters' }
Character class >> period [
	^$.
]

{ #category : #'named characters' }
Character class >> qmspace [
	^Character value: 8197
]

{ #category : #'named characters' }
Character class >> rdblquote [
	^Character value: 8221
]

{ #category : #'named characters' }
Character class >> rightArrow [
	^self value: 16r2192
]

{ #category : #'named characters' }
Character class >> rquote [
	^Character value: 8217
]

{ #category : #'named characters' }
Character class >> semicolon [
	^$;
]

{ #category : #'named characters' }
Character class >> singleQuote [
	^$'
]

{ #category : #inquiries }
Character class >> sizeInBytes [
	^1
]

{ #category : #'named characters' }
Character class >> space [
	^$ 
]

{ #category : #'named characters' }
Character class >> tab [
	^self value: 9
]

{ #category : #'named characters' }
Character class >> tensor [
	"
	Character tensor
	"
	^8855 asCharacter
]

{ #category : #'named characters' }
Character class >> underscore [
	^$_
]

{ #category : #'named characters' }
Character class >> upArrow [
	^self value: 16r2191
]

{ #category : #'instance creation' }
Character class >> value: anInteger [
	^(anInteger >= 0 and: [anInteger + 1 <= ByteCharacters _size])
		ifTrue: [ByteCharacters _basicAt: anInteger + 1]
		ifFalse: [Character basicNew setValue: anInteger]
]

{ #category : #arithmetic }
Character >> - aMagnitude [
	| subtraction |
	subtraction := aMagnitude isCharacter
		ifTrue: [aMagnitude asInteger]
		ifFalse: [aMagnitude].
	^value - subtraction
]

{ #category : #converting }
Character >> , characterOrString [
	^self asString , characterOrString asString
]

{ #category : #arithmetic }
Character >> + aMagnitude [
	| addend |
	addend := aMagnitude isCharacter
		ifTrue: [aMagnitude asInteger]
		ifFalse: [aMagnitude].
	^self class value: value + addend
]

{ #category : #comparing }
Character >> < aCharacter [
	^ActiveLocale isCharacter: self lessThan: aCharacter
]

{ #category : #comparing }
Character >> <~ aMagnitude [
	^self <= aMagnitude
]

{ #category : #comparing }
Character >> <= aCharacter [
	^ActiveLocale isCharacter: self lessThanOrEqualTo: aCharacter
]

{ #category : #comparing }
Character >> = aCharacter [
	^self class == aCharacter class and: [value = aCharacter codePoint]
]

{ #category : #comparing }
Character >> > aCharacter [
	^ActiveLocale isCharacter: self greaterThan: aCharacter
]

{ #category : #comparing }
Character >> >= aCharacter [
	^ActiveLocale isCharacter: self greaterThanOrEqualTo: aCharacter
]

{ #category : #converting }
Character >> asCharacter [
	^self
]

{ #category : #converting }
Character >> asInteger [
	^value
]

{ #category : #operations }
Character >> asLowercase [
	^ActiveLocale lowercaseOf: self
]

{ #category : #converting }
Character >> asParameter [
	^self codePoint
]

{ #category : #converting }
Character >> asString [
	| class |
	class := self isAnsi ifTrue: [String] ifFalse: [WideString].
	^class with: self
]

{ #category : #operations }
Character >> asUppercase [
	^ActiveLocale uppercaseOf: self
]

{ #category : #comparing }
Character >> between: min and: max [
	^min codePoint <= value and: [value <= max codePoint]
]

{ #category : #printing }
Character >> canBePrintedAsLiteral [
	^true
]

{ #category : #accessing }
Character >> codePoint [
	^value
]

{ #category : #copying }
Character >> deepCopy [
	^self
]

{ #category : #accessing }
Character >> digitValue [
	self isDigit ifTrue: [^value - 48].
	self isAsciiLetter ifFalse: [self error: 'Cannot calculate digitValue'].
	value > 96 ifTrue: [^value - 87].
	^value - 55
]

{ #category : #comparing }
Character >> hash [
	^value hash
]

{ #category : #accessing }
Character >> highByte [
	^value bitShift: -8
]

{ #category : #testing }
Character >> isAlphanumeric [
	value < 256 ifTrue: [^self isLetter or: [self isDigit]].
	^UserLibrary IsCharAlphaNumericW: value
]

{ #category : #testing }
Character >> isAlphaNumericOrUnderscore [
	^self isDigit or: [self isLetter] or: [self = $_]
]

{ #category : #testing }
Character >> isAnsi [
	^Ansi isAnsi: value
]

{ #category : #testing }
Character >> isAnsiCompliant [
	"
	8240 asCharacter isAnsiCompliant
	"
	value < 128 ifTrue: [^true].
	value < 160 ifTrue: [^false].
	^value < 256
]

{ #category : #testing }
Character >> isAsterisk [
	^value = 42
]

{ #category : #testing }
Character >> isBackslash [
	^value = 92
]

{ #category : #testing }
Character >> isBacktick [
	^value = 96
]

{ #category : #testing }
Character >> isBlank [
	value <= 32 ifTrue: [^true].
	value = 160 ifTrue: [^true].
	value < 16r2000 ifTrue: [^false].
	value < 16r200C ifTrue: [^true].
	value = 16r202F ifTrue: [^true].
	value = 16r205F ifTrue: [^true].
	value = 16r3000 ifTrue: [^true].
	^false
]

{ #category : #testing }
Character >> isByteCharacter [
	^value < 256
]

{ #category : #testing }
Character >> isCharacter [
	^true
]

{ #category : #testing }
Character >> isCircumflex [
	^value = 94
]

{ #category : #testing }
Character >> isColon [
	^value = 58
]

{ #category : #testing }
Character >> isCr [
	^value = 13
]

{ #category : #testing }
Character >> isDigit [
	^value >= 48 and: [value <= 57]
]

{ #category : #testing }
Character >> isDollar [
	^value = 36
]

{ #category : #testing }
Character >> isDollarSign [
	^value = 36
]

{ #category : #testing }
Character >> isDot [
	^value = 46
]

{ #category : #testing }
Character >> isDoubleQuote [
	^value = 34
]

{ #category : #testing }
Character >> isEndOfLine [
	^value = 13 | (value = 10)
]

{ #category : #testing }
Character >> isEsc [
	^self = self class escape
]

{ #category : #testing }
Character >> isFixedObject [
	^value < 256
]

{ #category : #testing }
Character >> isGreaterThan [
	^value = 62
]

{ #category : #testing }
Character >> isHash [
	^value = 35
]

{ #category : #testing }
Character >> isIdentifierCharacter [
	('$:_' includes: self) ifTrue: [^true].
	^self isAlphanumeric
]

{ #category : #testing }
Character >> isLeftBracket [
	^value = 91
]

{ #category : #testing }
Character >> isLeftCurlyBracket [
	^value = 123
]

{ #category : #testing }
Character >> isLessThan [
	^value = 60
]

{ #category : #testing }
Character >> isLetter [
	^ActiveLocale isLetter: self
]

{ #category : #testing }
Character >> isLf [
	^value = 10
]

{ #category : #testing }
Character >> isLowercase [
	^ActiveLocale isLowercase: self
]

{ #category : #testing }
Character >> isMinus [
	^value = 45
]

{ #category : #testing }
Character >> isNull [
	^value = 0
]

{ #category : #testing }
Character >> isNumeric [
	^ActiveLocale isNumeric: self
]

{ #category : #testing }
Character >> isPipe [
	^value = 124
]

{ #category : #testing }
Character >> isPlus [
	^value = 43
]

{ #category : #testing }
Character >> isPunctuationMark [
	self = $. ifTrue: [^true].
	self = $; ifTrue: [^true].
	self = $: ifTrue: [^true].
	self = $_ ifTrue: [^true].
	self = $, ifTrue: [^true].
	self = $! ifTrue: [^true].
	self = $? ifTrue: [^true].
	^false
]

{ #category : #testing }
Character >> isQuestionMark [
	^value = 63
]

{ #category : #testing }
Character >> isRightBracket [
	^value = 93
]

{ #category : #testing }
Character >> isRightCurlyBracket [
	^value = 125
]

{ #category : #testing }
Character >> isRightParenthesis [
	^value = 41
]

{ #category : #testing }
Character >> isSemiColon [
	^value = 59
]

{ #category : #testing }
Character >> isSeparator [
	self = Space ifTrue: [^true].
	self = Tab ifTrue: [^true].
	self = Cr ifTrue: [^true].
	self = Lf ifTrue: [^true].
	self = Ff ifTrue: [^true].
	^false
]

{ #category : #testing }
Character >> isSingleQuote [
	^value = 39
]

{ #category : #testing }
Character >> isSpace [
	^value = 32
]

{ #category : #testing }
Character >> isTab [
	^value = 9
]

{ #category : #testing }
Character >> isUnderscore [
	^value = 95
]

{ #category : #testing }
Character >> isUnicode [
	value < 128 ifTrue: [^false].
	(value between: 160 and: 255) ifTrue: [^true].
	^value > 255
]

{ #category : #testing }
Character >> isUppercase [
	^ActiveLocale isUppercase: self
]

{ #category : #testing }
Character >> isVowel [
	^'aAeEiIoOuU' includes: self
]

{ #category : #accessing }
Character >> lowByte [
	^value bitAnd: 16rFF
]

{ #category : #accessing }
Character >> numericValue [
	self isDigit ifTrue: [^value - 48].
	self isAsciiLetter ifFalse: [self error: 'Cannot calculate digitValue'].
	value > 96 ifTrue: [^value - 87].
	^value - 55
]

{ #category : #printing }
Character >> printOn: aStream [
	self isUnicode ifTrue: [aStream beUnicode].
	aStream nextPut: $$; nextPut: self
]

{ #category : #private }
Character >> setValue: anInteger [
	value := anInteger
]

{ #category : #copying }
Character >> shallowCopy [
	^self
]

{ #category : #services }
Character >> split: aString [
	^aString substringsSplitBy: self
]

{ #category : #printing }
Character >> storeOn: aStream [
	self printOn: aStream
]

{ #category : #converting }
Character >> storeUTF8On: aStream [
	"
	16r800 asCharacter utf8
	"
	| b1 b2 b3 b4 |
	value < 16r80 ifTrue: [^aStream nextBytePut: value].
	value < 16r800 ifTrue: [
		b1 := value bitShift: -6.
		b1 := b1 bitOr: 16rC0.
		b2 := value bitAnd: 16r3F.
		b2 := b2 bitOr: 16r80.
		^aStream nextBytePut: b1; nextBytePut: b2].
	value < 16r10000 ifTrue: [
		b1 := value bitShift: -12.
		b1 := b1 bitOr: 16rE0.
		b2 := value bitShift: -6.
		b2 := b2 bitAnd: 16r3F.
		b2 := b2 bitOr: 16r80.
		b3 := value bitAnd: 16r3F.
		b3 := b3 bitOr: 16r80.
		^aStream
			nextBytePut: b1;
			nextBytePut: b2;
			nextBytePut: b3].
	b1 := value bitShift: -18.
	b1 := b1 bitOr: 16rF0.
	b2 := value bitShift: -12.
	b2 := b2 bitAnd: 16r3F.
	b2 := b2 bitOr: 16r80.
	b3 := value bitShift: -6.
	b3 := b3 bitAnd: 16r3F.
	b3 := b3 bitOr: 16r80.
	b4 := value bitAnd: 16r3F.
	b4 := b4 bitOr: 16r80.
	^aStream
		nextBytePut: b1;
		nextBytePut: b2;
		nextBytePut: b3;
		nextBytePut: b4
]

{ #category : #converting }
Character >> utf8 [
	"
	16r800 asCharacter utf8
	"
	^UTF8 current encodeCharacter: self
]

