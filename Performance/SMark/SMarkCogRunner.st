"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #SMarkCogRunner,
	#superclass : #SMarkRunner,
	#instVars : [
		'warmingUp'
	],
	#category : #SMark
}

{ #category : #unclassified }
SMarkCogRunner class >> new [
	^self basicNew initialize
]

{ #category : #initialization }
SMarkCogRunner >> initialize [
	super initialize.
	warmingUp := false.
]

{ #category : #initialization }
SMarkCogRunner >> performBenchmark: aSelector [
	"Based on an email by Eliot from May 16th, 2011.
	 The first time a method is executed it will get into the inline cache.
	 The second time, it is found in the inline cache, which triggers the JIT compiler to produce code.
	 Thus, the third time it should be executed in the steady state."
	warmingUp := true.
		suite runBenchmark: aSelector.
		Smalltalk garbageCollect.
		suite runBenchmark: aSelector.
		Smalltalk garbageCollect.
	warmingUp := false.
	
	^ super performBenchmark: aSelector.
]

{ #category : #initialization }
SMarkCogRunner >> recordResults: timer for: aSelector [
	"Only record the results when we are not in warmup mode."
	warmingUp ifFalse: [
		super recordResults: timer for: aSelector.
	].
]

