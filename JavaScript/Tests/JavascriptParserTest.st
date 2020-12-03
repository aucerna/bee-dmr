"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JavascriptParserTest,
	#superclass : #TestCase,
	#instVars : [
		'parser'
	],
	#category : #'JavaScript\Tests'
}

{ #category : #testing }
JavascriptParserTest class >> isAbstract [
	^self = JavascriptParserTest]

{ #category : #accessing }
JavascriptParserTest class >> parserResource [

	^ JSETestParserResource current]

{ #category : #accessing }
JavascriptParserTest class >> resources [
	^{JSETestParserResource}]

{ #category : #private }
JavascriptParserTest >> assertParseFailure: aString [
	| result |
	result := self parser parse: aString.
	self
		assert: result isPetitFailure
		description: aString printString , ' : Expected parser failure, got '
			, result printString]

{ #category : #private }
JavascriptParserTest >> floatFrom: aString [
	^Float fromString: aString]

{ #category : #private }
JavascriptParserTest >> parse: aString [
	^self parser parse: aString]

{ #category : #private }
JavascriptParserTest >> parse: aString equals: expectedParsedValue [
	| parsedValue |
	parsedValue := self parser parse: aString.
	self
		assert: parsedValue isPetitFailure not
		description: aString , ' : ' , parsedValue storeString.
	self
		assert: parsedValue = expectedParsedValue
		description: aString printString , ' : Parsed: ' , parsedValue storeString
			, ', expected: '
			, expectedParsedValue storeString]

{ #category : #private }
JavascriptParserTest >> parse: aString onError: aBlock [
	self parser parse: aString onError: aBlock]

{ #category : #private }
JavascriptParserTest >> parser [
	^self class parserResource parser copy
		factory: JSETestFactory new;
		yourself]

