"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPActionParserTest,
	#superclass : #TestCase,
	#category : #Tests
}

{ #category : #all }
PPActionParserTest >> testFlatten [
	| p identifier |
	p := #letter asParser star flatten.
	self assert: (p parse: 'Hello0') = 'Hello'.
	identifier := (#letter asParser , (#letter asParser / #digit asParser) star) flatten.
	self assert: (identifier parse: 'foo12+') = 'foo12'
]

{ #category : #all }
PPActionParserTest >> testToken [
	| p |
	p := #letter asParser star token.
	self assert: (p parse: 'Hello0') class = PPToken
]

{ #category : #all }
PPActionParserTest >> testTransformation [
	| p number |
	p := #digit asParser.
	number := p ==> [:ch | ch digitValue].
	self assert: (number parse: '8') = 8.
	p := #letter asParser star
		==> [:array | array collect: [:ch | ch asLowercase]].
	self assert: (p parse: 'HELLO') = 'hello' asArray
]

{ #category : #all }
PPActionParserTest >> testTrim [
	| p number |
	p := #digit asParser.
	number := p trim ==> [:ch | ch digitValue].
	self assert: (number parse: ' 8') = 8
]

