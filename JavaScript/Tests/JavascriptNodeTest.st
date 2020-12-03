"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JavascriptNodeTest,
	#superclass : #TestCase,
	#category : #'JavaScript\Tests'
}

{ #category : #private }
JavascriptNodeTest >> testLiterals [
	| source cm |
	source := '__
	^<js>variable.ValueType</js>'.
	cm := Compiler compile: source in: self class.
	self assert: (cm includes: #ValueType)]

