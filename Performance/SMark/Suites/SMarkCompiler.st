"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #SMarkCompiler,
	#superclass : #SMarkSuite,
	#category : #Suites
}

{ #category : #'script entry' }
SMarkCompiler class >> defaultNumberOfIterations [
	^ 50
]

{ #category : #'script entry' }
SMarkCompiler class >> defaultNumberOfProcesses [
	^ 8
]

{ #category : #benchmarking }
SMarkCompiler >> benchCompiler [
	"was Benchmark>>testCompiler"
	SMarkCompilerTargetClass new compile:
		'somethingDummy: aBlock repeated: nTimes | i emptyBlock emptyTime blockTime |
		nTimes > 1000 ifTrue: [^self time: aBlock repeatedK: nTimes // 1000].
		emptyBlock := [].
		emptyTime := Time millisecondsToRun:
						[i := 0.
						 [(i := i + 1) <= nTimes] whileTrue: [emptyBlock value]].
		blockTime := Time millisecondsToRun:
						[i := 0.
						 [(i := i + 1) <= nTimes] whileTrue: [aBlock value]].
		^blockTime - emptyTime'.
]

