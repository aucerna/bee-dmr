"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #SMarkResultTest,
	#superclass : #TestCase,
	#instVars : [
		'result'
	],
	#category : #Tests
}

{ #category : #running }
SMarkResultTest >> setUp [
	| runner |
	runner := SMarkTestRunner execute: SMarkTestRunnerSuite new.
	result := (runner results at: 'DoNothing') at: 1
]

{ #category : #tests }
SMarkResultTest >> testBenchmarkName [
	self assert: (result benchmarkName isKindOf: String)
]

{ #category : #tests }
SMarkResultTest >> testCriteria [
	self assert: (result criteria respondsTo: #at:).
	self assert: (result criteria size > 0).
]

{ #category : #tests }
SMarkResultTest >> testSuite [
	self assert: result suite notNil
]

{ #category : #tests }
SMarkResultTest >> testTotal [
	self assert: (result total isKindOf: Number)
]

