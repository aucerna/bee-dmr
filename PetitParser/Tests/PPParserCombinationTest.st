"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPParserCombinationTest,
	#superclass : #TestCase,
	#category : #Tests
}

{ #category : #all }
PPParserCombinationTest >> testAnd [
	| p |
	p := #letter asParser and , #uppercase asParser.
	self
		assert: (p matches: 'A');
		deny: (p matches: 'a')
]

{ #category : #all }
PPParserCombinationTest >> testEnd [
	| p |
	p := #uppercase asParser end.
	self
		assert: (p matches: 'A');
		deny: (p matches: 'AB')
]

{ #category : #all }
PPParserCombinationTest >> testNot [
	| p |
	p := #uppercase asParser not , #letter asParser.
	self
		assert: (p matches: 'a');
		deny: (p matches: 'A')
]

{ #category : #all }
PPParserCombinationTest >> testOptional [
	| p |
	p := $+ asParser optional , $- asParser optional , #digit asParser.
	self
		assert: (p matches: '1');
		assert: (p matches: '+1');
		assert: (p matches: '-1');
		deny: (p matches: '/1')
]

{ #category : #all }
PPParserCombinationTest >> testOrderedChoice [
	| p1 p2 |
	p1 := #letter asParser.
	p2 := #digit asParser.
	self
		assert: (p1 / p2 matches: 'a0');
		assert: (p2 / p1 matches: 'X9');
		deny: (p1 / p2 matches: ' B1')
]

{ #category : #all }
PPParserCombinationTest >> testPlus [
	| p |
	p := #letter asParser plus.
	self
		assert: (p matches: 'a');
		deny: (p matches: '0');
		deny: (p matches: '')
]

{ #category : #all }
PPParserCombinationTest >> testSequence [
	| p1 p2 |
	p1 := #letter asParser.
	p2 := #digit asParser.
	self
		assert: (p1 , p2 matches: 'a0');
		deny: (p2 , p1 matches: 'X9')
]

{ #category : #all }
PPParserCombinationTest >> testStar [
	| p |
	p := #letter asParser star.
	self
		assert: (p matches: 'a');
		assert: (p matches: '0');
		assert: (p matches: '')
]

