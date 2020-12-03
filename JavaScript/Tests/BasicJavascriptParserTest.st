"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BasicJavascriptParserTest,
	#superclass : #JavascriptParserTest,
	#instVars : [
		'leftRecursiveProductions'
	],
	#category : #'JavaScript\Tests'
}

{ #category : #tests }
BasicJavascriptParserTest >> testNewParser [

	JSEParser new]

{ #category : #tests }
BasicJavascriptParserTest >> testNoLeftRecursions [

	JSEParser new allParsersDo: [ : p |
		self assert: p jseIsLeftRecursiveProduction not description: 'Left recursive: ', p printString
	].]

