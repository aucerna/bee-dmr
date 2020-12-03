"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSENumericStringParser,
	#superclass : #JSECharactersParser,
	#instVars : [
		'strDecimalLiteral',
		'stringNumericLiteral',
		'strNumericLiteral',
		'strUnsignedDecimalLiteral',
		'strWhiteSpace',
		'strWhiteSpaceChar'
	],
	#category : #JavaScript
}

{ #category : #accessing }
JSENumericStringParser >> start [

	^  stringNumericLiteral end]

{ #category : #'9 Type Conversion and Testing' }
JSENumericStringParser >> strDecimalLiteral [
	^strUnsignedDecimalLiteral
		/ ($+ asParser , strUnsignedDecimalLiteral
			map: [:sign :unsignedDecimal | unsignedDecimal])
		/ ($- asParser , strUnsignedDecimalLiteral
			map: [:sign :unsignedDecimal | unsignedDecimal negated])]

{ #category : #'9 Type Conversion and Testing' }
JSENumericStringParser >> stringNumericLiteral [

	^  strWhiteSpace, strNumericLiteral optional, strWhiteSpace
		map: [ : w1 : numeric : w2 | numeric ifNil: [ 0 ] ]]

{ #category : #'9 Type Conversion and Testing' }
JSENumericStringParser >> strNumericLiteral [

	^ 
	hexIntegerLiteral
	/ strDecimalLiteral]

{ #category : #'9 Type Conversion and Testing' }
JSENumericStringParser >> strUnsignedDecimalLiteral [
	^('Infinity' asParser map: [:inf | Float infinity])
		/ (decimalDigits , $. asParser , decimalDigits optional
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
		/ (decimalDigits , exponentPart optional
			map: [:int :exp | self
				numberFromIntegerCharacters: int
				decimalPlaces: nil
				exponent: exp])]

{ #category : #'9 Type Conversion and Testing' }
JSENumericStringParser >> strWhiteSpace [

	^ strWhiteSpaceChar star]

{ #category : #'9 Type Conversion and Testing' }
JSENumericStringParser >> strWhiteSpaceChar [

	^ whiteSpace 
		/ lineTerminator]

