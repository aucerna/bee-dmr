"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #SMarkTestRunnerSuiteForAutosizing,
	#superclass : #SMarkSuite,
	#category : #Tests
}

{ #category : #'as yet unclassified' }
SMarkTestRunnerSuiteForAutosizing class >> defaultRunner [
	^ SMarkTestRunner
]

{ #category : #'as yet unclassified' }
SMarkTestRunnerSuiteForAutosizing >> baseBenchmark [
	(Delay forMilliseconds: 5) wait.
]

{ #category : #'as yet unclassified' }
SMarkTestRunnerSuiteForAutosizing >> benchBig [
	(Delay forMilliseconds: 100) wait.
]

{ #category : #'as yet unclassified' }
SMarkTestRunnerSuiteForAutosizing >> benchSmall [
	(Delay forMilliseconds: 5) wait.
]

