"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #SMarkResult,
	#superclass : #Object,
	#instVars : [
		'time',
		'benchName',
		'suite',
		'criteria'
	],
	#category : #SMark
}

{ #category : #accessing }
SMarkResult >> benchmarkName [
	^ benchName
]

{ #category : #accessing }
SMarkResult >> benchmarkName: aString [
	benchName := aString
]

{ #category : #accessing }
SMarkResult >> criteria [
	^ criteria
]

{ #category : #accessing }
SMarkResult >> criteria: aCollectionOfTimers [
	criteria := aCollectionOfTimers
]

{ #category : #accessing }
SMarkResult >> suite [
	^ suite
]

{ #category : #accessing }
SMarkResult >> suite: aBenchmarkSuite [
	suite := aBenchmarkSuite
]

{ #category : #accessing }
SMarkResult >> total [
	^ time
]

{ #category : #accessing }
SMarkResult >> total: aTime [
	time := aTime
]

