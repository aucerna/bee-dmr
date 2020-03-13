"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPIdentifierTest,
	#superclass : #TestCase,
	#instVars : [
		'identifier'
	],
	#category : #Tests
}

{ #category : #setup }
PPIdentifierTest >> setUp [
	super setUp.
	identifier := #letter asParser , (#letter asParser / #digit asParser) star
]

{ #category : #all }
PPIdentifierTest >> testIdentifierMatches [
	self
		assert: (identifier matches: 'foo');
		deny: (identifier matches: '123')
]

{ #category : #all }
PPIdentifierTest >> testIdentifierMatchesIn [
	| answer |
	answer := identifier matchesIn: 'foo 123 bar12'.
	self
		assert: answer first = (identifier parse: 'foo');
		assert: answer second = (identifier parse: 'oo');
		assert: answer third = (identifier parse: 'o');
		assert: answer fourth = (identifier parse: 'bar12');
		assert: answer fifth = (identifier parse: 'ar12');
		assert: answer sixth = (identifier parse: 'r12')
]

{ #category : #all }
PPIdentifierTest >> testIdentifierParse [
	| ast |
	ast := identifier parse: 'yeah'.
	self assert: ast = #($y #($e $a $h)).
	ast := identifier parse: 'f12'.
	self assert: ast = #($f #($1 $2))
]

{ #category : #all }
PPIdentifierTest >> testIdentifierParseError [
	| error position |
	identifier parse: '123' onError: [:msg :pos | 
		error := msg.
		position := pos].
	self assert: error = 'letter expected'; assert: position = 0
]

{ #category : #all }
PPIdentifierTest >> testIdentifierStructure [
	self
		assert: identifier class = PPSequenceParser;
		assert: identifier children size = 2;
		assert: identifier children first class == PPPredicateObjectParser;
		assert: identifier children second class == PPRepeatingParser;
		assert: identifier children second children size = 1
]

