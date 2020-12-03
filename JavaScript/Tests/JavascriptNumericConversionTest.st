"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JavascriptNumericConversionTest,
	#superclass : #JavascriptParserTest,
	#category : #'JavaScript\Tests'
}

{ #category : #private }
JavascriptNumericConversionTest >> parser [
	^self class parserResource numericStringParser]

{ #category : #testing }
JavascriptNumericConversionTest >> testDecimalInteger [

	self parse: '1' equals: 1.
	self parse: ' 123 ' equals: 123.
	self parse: ' +123 ' equals: 123.
	self parse: ' -123 ' equals: -123.
	self parse: '1.' equals: 1.


	self assertParseFailure: '- 123'.]

{ #category : #testing }
JavascriptNumericConversionTest >> testDouble [

	self parse: '1.2' equals: (self floatFrom: '1.2').
	self parse: ' 12.3 ' equals: (self floatFrom: '12.3').

	self assertParseFailure: '1.2.3'.
	self assertParseFailure: '1..3'.
	self assertParseFailure: '1,3'.]

{ #category : #testing }
JavascriptNumericConversionTest >> testEmptyString [

	self parse: '' equals: 0.
	" whitespace "
	self parse: ' ' equals: 0.]

{ #category : #testing }
JavascriptNumericConversionTest >> testHexInteger [

	self parse: '0x12345' equals: 16r12345.
	self parse: '0Xabcdef' equals: 16rabcdef.

	self assertParseFailure: '0x'.
	self assertParseFailure: '0xy'.]

{ #category : #testing }
JavascriptNumericConversionTest >> testInfinity [
	self parse: 'Infinity' equals: Float infinity.
	self parse: '-Infinity' equals: Float infinity negated]

