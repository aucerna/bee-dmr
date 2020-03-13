"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #SMarkTestSuiteWithBaseBenchmark,
	#superclass : #SMarkTestSuite,
	#category : #Tests
}

{ #category : #'as yet unclassified' }
SMarkTestSuiteWithBaseBenchmark >> baseBenchmark [
	runner didRunBaseBenchmark.
]

