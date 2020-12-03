"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSECharactersParser,
	#superclass : #JSEAbstractParser,
	#instVars : [
		'whiteSpace',
		'lineTerminator',
		'decimalDigit',
		'decimalDigits',
		'hexIntegerLiteral',
		'hexDigit',
		'exponentPart',
		'exponentIndicator',
		'signedInteger'
	],
	#category : #JavaScript
}

{ #category : #constants }
JSECharactersParser class >> lineTerminatorCodeUnitValues [

	^ #( 16r000A 16r000D 16r2028 16r2029 )]

{ #category : #constants }
JSECharactersParser class >> whiteSpaceCodeValues [

	^ #(16r0009 16r000B 16r000C 16r0020 16r00A0 16rFEFF)]

{ #category : #constants }
JSECharactersParser class >> zeroWidthCodeValues [
	^#(16r200C 16r200D)]

{ #category : #utilities }
JSECharactersParser >> alphabeticCharacter [
	^PPPredicateObjectParser
		on: [:char | | codePoint |
			codePoint := char codePoint.
			(codePoint >= $a codePoint and: [codePoint <= $z codePoint])
				or: [codePoint >= $A codePoint and: [codePoint <= $Z codePoint]]]
		message: 'any of a-z,A-Z expected']

{ #category : #utilities }
JSECharactersParser >> anyCodeUnitValue: codeUnitValues [

	^ self anyOf: (codeUnitValues collect: [ : codeUnitValue | Character codePoint: codeUnitValue ])]

{ #category : #utilities }
JSECharactersParser >> anyExceptAnyCodeUnitValueOf: codeUnitValues [

	^ PPPredicateObjectParser anyExceptAnyOf: (codeUnitValues collect: [ : codeUnitValue | Character codePoint: codeUnitValue ])]

{ #category : #utilities }
JSECharactersParser >> anyOf: anArray [

	^ PPPredicateObjectParser anyOf: anArray]

{ #category : #utilities }
JSECharactersParser >> anyOfStrings: strings [

	^ JSELiteralSequenceChoiceParser on: strings]

{ #category : #'7.8 Literals' }
JSECharactersParser >> decimalDigit [

	^ PPPredicateObjectParser digit]

{ #category : #'7.8 Literals' }
JSECharactersParser >> decimalDigits [

	^ decimalDigit plus]

{ #category : #utilities }
JSECharactersParser >> epsilon [

	^ PPEpsilonParser new]

{ #category : #'7.8 Literals' }
JSECharactersParser >> exponentIndicator [

	^ self anyOf: 'eE']

{ #category : #'7.8 Literals' }
JSECharactersParser >> exponentPart [

	^ exponentIndicator, signedInteger ==> [ : s |  (s at: 2) ]]

{ #category : #'7.8 Literals' }
JSECharactersParser >> hexDigit [

	^ self anyOf: '0123456789abcdefABCDEF']

{ #category : #'7.8 Literals' }
JSECharactersParser >> hexIntegerLiteral [

	^ 
	(self anyOfStrings: #('0x' '0X')) , hexDigit plus 
		==> [ : s | self integerFromHexCharacters: (s at: 2) ]]

{ #category : #private }
JSECharactersParser >> integerFromDecimalCharacters: characterArray [

	^ Integer readFrom: characterArray readStream]

{ #category : #private }
JSECharactersParser >> integerFromHexCharacters: characterArray [

	^ Integer readFrom: characterArray readStream radix: 16]

{ #category : #'7.3 Line Terminators' }
JSECharactersParser >> lineTerminator [

	^ (self anyCodeUnitValue: self class lineTerminatorCodeUnitValues) jseToken: #lineTerminator]

{ #category : #private }
JSECharactersParser >> numberFromIntegerCharacters: integerCharacters decimalPlaces: decimalPlaces exponent: exponentCharacters [
	| integer numberString |
	^(decimalPlaces isNil or: [decimalPlaces isEmpty])
		ifTrue: [| exponent |
			integer := self integerFromDecimalCharacters: integerCharacters.
			exponentCharacters notNil
				ifTrue: [
					exponent := self integerFromDecimalCharacters: exponentCharacters.
					integer * (10 raisedTo: exponent)]
				ifFalse: [integer]]
		ifFalse: [
			numberString := String streamContents: [:stream | 
				stream
					nextPutAll: (integerCharacters ifNil: ['0']);
					nextPut: $.;
					nextPutAll: decimalPlaces.
				exponentCharacters notNil ifTrue: [
					stream nextPut: $e.
					exponentCharacters first = $+
						ifTrue: [
							stream
								nextPutAll: (exponentCharacters
									copyFrom: 2
									to: exponentCharacters size)]
						ifFalse: [stream nextPutAll: exponentCharacters]]].
			Float fromString: numberString]]

{ #category : #'7.8 Literals' }
JSECharactersParser >> signedInteger [
	^decimalDigits / ($+ asParser , decimalDigits ==> [:s | s at: 2])
		/ ($- asParser , decimalDigits ==> [:s | '-' , (s at: 2)])]

{ #category : #private }
JSECharactersParser >> stringFromElements: elements [
	" elements are either characters or strings "

	| writeStream readStream |
	writeStream := ( String new: elements size  ) writeStream.
	readStream := elements readStream.
	[ readStream atEnd ] whileFalse: 
		[ | element |
			element := readStream next.
			element isString 
				ifTrue: [ writeStream nextPutAll: element ]
				ifFalse: [ writeStream nextPut: element ]
		].
	^ writeStream contents]

{ #category : #'7.2 White Space' }
JSECharactersParser >> whiteSpace [
	" todo:
		<USP> Any other Unicode space separator "

	^ (self anyCodeUnitValue: self class whiteSpaceCodeValues) ==> [ : w | nil ]]

