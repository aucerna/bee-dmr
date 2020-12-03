"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JavascriptFormattingTest,
	#superclass : #TestCase,
	#category : #'JavaScript\Tests'
}

{ #category : #compilation }
JavascriptFormattingTest class >> configureCompiler: aCompiler [
	aCompiler optionAt: #compilerClass put: HybridCompiler]

{ #category : #all }
JavascriptFormattingTest >> testInlinedTrailingSemicolon [
	| m |
	m := Compiler compile: 'm ^String new , <js>v = 1</js>' in: self class.
	self assert: (m executeOn: self) = 'v = 1'.
	m := Compiler compile: 'm ^String new , <js>v = 1;</js>' in: self class.
	self assert: (m executeOn: self) = 'v = 1;']

{ #category : #all }
JavascriptFormattingTest >> testObjectPropertiesSeparation [
	| m js |
	#testTP52014.
	m := Compiler compile: 'm <js> return {p1: "a", p2: 123}' in: self class.
	js := m executeOn: self.
	js := js reject: #isBlank.
	self deny: (js includesString: ';,')]

{ #category : #all }
JavascriptFormattingTest >> testTP53133 [
	| m js |
	m := Compiler compile: 'm <js> var x = "\"";' in: self class.
	js := m executeOn: self.
	js := js reject: #isBlank.
	self assert: (js includesString: '\"')]

{ #category : #all }
JavascriptFormattingTest >> testTrailingSemicolon [
	| m |
	m := Compiler compile: 'm <js> v = 1' in: self class.
	self assert: (m executeOn: self) = 'v = 1'.
	m := Compiler compile: 'm <js> v = 1;' in: self class.
	self assert: (m executeOn: self) = 'v = 1;']

