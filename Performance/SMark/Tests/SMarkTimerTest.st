"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #SMarkTimerTest,
	#superclass : #TestCase,
	#category : #Tests
}

{ #category : #tests }
SMarkTimerTest >> testName [
	| timer |
	timer := SMarkTimer new.
	
	self assert: timer name equals: nil.
	
	timer name: #foo.
	
	self assert: timer name equals: #foo.
]

{ #category : #tests }
SMarkTimerTest >> testReset [
	| timer |
	timer := SMarkTimer new.
	
	timer start.
	(Delay forMilliseconds: 10) wait.
	timer stop.
	
	self assert: (timer totalTime >= 10).
	
	timer reset.
	
	self assert: timer totalTime equals: 0.
]

{ #category : #tests }
SMarkTimerTest >> testStartStop [
	| timer |
	timer := SMarkTimer new.
	
	self assert: timer totalTime equals: 0.
	
	timer start.
	
	(Delay forMilliseconds: 10) wait.
	
	timer stop.
	
	self assert: (timer totalTime >= 10).
]

{ #category : #tests }
SMarkTimerTest >> testTotalTimeWithResume [
	| timer |
	timer := SMarkTimer new.
	self assert: timer totalTime equals: 0.
	
	timer start.
	(Delay forMilliseconds: 10) wait.
	timer stop.
	
	self assert: (timer totalTime >= 10).
	
	timer start.
	(Delay forMilliseconds: 10) wait.
	timer stop.
	
	self assert: (timer totalTime >= 20).
	
	timer start.
	(Delay forMilliseconds: 10) wait.
	timer stop.
	
	self assert: (timer totalTime >= 30).
]

