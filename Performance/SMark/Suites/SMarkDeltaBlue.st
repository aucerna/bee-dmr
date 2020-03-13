"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #SMarkDeltaBlue,
	#superclass : #SMarkSuite,
	#category : #Suites
}

{ #category : #benchmarking }
SMarkDeltaBlue >> benchDeltaBlue [
	"
	This the combined benchmark.
	"
	| n |
	n := self problemSize.
	self dbStrength initialize.
	self dbPlanner chainTest: n; projectionTest: n.
	^true
]

{ #category : #benchmarking }
SMarkDeltaBlue >> dbPlanner [
	^Smalltalk at: #DBPlanner
]

{ #category : #benchmarking }
SMarkDeltaBlue >> dbStrength [
	^Smalltalk at: #DBStrength
]

{ #category : #defaults }
SMarkDeltaBlue >> defaultProblemSize [
	^ 5000
]

{ #category : #accessing }
SMarkDeltaBlue >> problemSize [
	| ps |
	ps := super problemSize.
	ps isInteger ifFalse: [^self defaultProblemSize].
	^ps
]

