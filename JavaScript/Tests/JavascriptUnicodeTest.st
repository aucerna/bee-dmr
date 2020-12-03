"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JavascriptUnicodeTest,
	#superclass : #TestCase,
	#category : #'JavaScript\Tests'
}

{ #category : #tests }
JavascriptUnicodeTest >> testUnicodeCategory [
	self assert: (JSEUnicodeTables unicodeCategoryOf: $A) = 'Lu'.
	self assert: (JSEUnicodeTables unicodeCategoryOf: $A codePoint) = 'Lu'.
	self assert: (JSEUnicodeTables unicodeCategoryOf: $a) = 'Ll'.
	self assert: (JSEUnicodeTables unicodeCategoryOf: $() = 'Ps'.
	self assert: (JSEUnicodeTables unicodeCategoryOf: 16rFFFF) isNil]

{ #category : #tests }
JavascriptUnicodeTest >> testUnicodeCategoryPredicate [
	| parser |
	parser := #letter asParser.
	self assert: (parser matches: 'A').
	self assert: (parser matches: 'a').
	self assert: (parser matches: '1') not]

