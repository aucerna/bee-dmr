"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssCompilingTest,
	#superclass : #TestCase,
	#category : #'CSS\Tests'
}

{ #category : #compilation }
CssCompilingTest class >> configureCompiler: aCompiler [
	aCompiler optionAt: #compilerClass put: HybridCompiler]

{ #category : #all }
CssCompilingTest >> testInlinedTag [
	| cm |
	cm := self
		compile: 'm 
^<css>p {
    font-family: verdana;
    font-size: 20px;
}
</css>'.
	self
		assert: cm notNil;
		assert: (cm executeOn: self) trimBlanks
			= 'p {
    font-family: verdana;
    font-size: 20px;
}']

{ #category : #all }
CssCompilingTest >> testMethod [
	| cm |
	cm := self
		compile: 'm <css>
body {
    background-color: lightblue;
}

h1 {
    color: white;
    text-align: center;
}

p {
    font-family: verdana;
    font-size: 20px;
}
'.
	self
		assert: cm notNil;
		assert: (cm executeOn: self) trimBlanks
			= 'body {
    background-color: lightblue;
}

h1 {
    color: white;
    text-align: center;
}

p {
    font-family: verdana;
    font-size: 20px;
}']

