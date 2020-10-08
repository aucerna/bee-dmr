"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RandomTest,
	#superclass : #TestCase,
	#category : #'Distributions\Tests'
}

{ #category : #all }
RandomTest >> testAtRandom [
	| r n float m |
	r := self random.
	1000 timesRepeat: [
		n := r integerBetween: -100 and: 100.
		self assert: n isInteger.
		self assert: n = 0 | ((m := n abs atRandom: r) between: 1 and: n abs).
		float := r next.
		self assert: (float atRandom: r) < float]]

{ #category : #all }
RandomTest >> testDictionaryAtRandom [
	| dictionary |
	dictionary := Dictionary
		withAll: (($a codePoint to: $z codePoint) collect: [:c | c
			-> c asCharacter]).
	100
		timesRepeat: [self assert: (dictionary atRandom: self random) isCharacter]]

{ #category : #all }
RandomTest >> testMethodDictionaryAtRandom [
	| cls md |
	100 timesRepeat: [
		cls := Object subclasses atRandom: self random.
		md := cls methodDictionary.
		md notEmpty
			ifTrue: [100
				timesRepeat: [self assert: (md atRandom: self random) isCompiledMethod]]]]

{ #category : #all }
RandomTest >> testNullSeed [
	| r |
	r := Random new.
	r seed: 0.
	self deny: r next = 1.0.
	r seed: 0.
	self assert: ((10 atRandom: r) between: 0 and: 10)]

