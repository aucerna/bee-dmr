"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSETestParserResource,
	#superclass : #TestResource,
	#instVars : [
		'parser',
		'lexicalParser',
		'numericStringParser'
	],
	#category : #'JavaScript\Tests'
}

{ #category : #accessing }
JSETestParserResource >> lexicalParser [

	^ lexicalParser]

{ #category : #accessing }
JSETestParserResource >> numericStringParser [

	numericStringParser isNil
		ifTrue: [
			numericStringParser := JSENumericStringParser new.
		].
	^ numericStringParser]

{ #category : #accessing }
JSETestParserResource >> parser [
	^parser]

{ #category : #Running }
JSETestParserResource >> setUp [

	parser := JSEParser new.
	lexicalParser := parser lexicalParser.]

