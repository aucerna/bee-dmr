"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #SMarkBeeRunner,
	#superclass : #SMarkRunner,
	#instVars : [
		'warmingUp'
	],
	#category : #SMark
}

{ #category : #unclassified }
SMarkBeeRunner class >> new [
	^self basicNew initialize
]

{ #category : #initialization }
SMarkBeeRunner >> initialize [
	super initialize.
	warmingUp := false.
]

{ #category : #initialization }
SMarkBeeRunner >> performBenchmark: aSelector [
	"
	First, free all memory we can.
	Then run once to cause jitting of compiled methods and also to get call sites patched.
	Thus, the second time it should be executed in the steady state.
	"
	warmingUp := true.
	Smalltalk garbageCollect.
	suite runBenchmark: aSelector.
	warmingUp := false.
	^super performBenchmark: aSelector
]

{ #category : #initialization }
SMarkBeeRunner >> recordResults: timer for: aSelector [
	"Only record the results when we are not in warmup mode."
	warmingUp ifFalse: [
		super recordResults: timer for: aSelector.
	].
]

