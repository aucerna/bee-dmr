"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #SMarkReporterTest,
	#superclass : #TestCase,
	#instVars : [
		'runner'
	],
	#category : #Tests
}

{ #category : #running }
SMarkReporterTest >> setUp [
	runner := SMarkTestRunnerSuiteForAutosizing run.
]

{ #category : #'compatibility Pharo 1.4 vs. 2.0' }
SMarkReporterTest >> string: str includes: subStr [
	"To be compatible with Pharo 1.4 and 2.0"
	(str respondsTo: #includesSubstring:)
		ifTrue:  [ ^ str includesSubstring: subStr ] "2.0"
		ifFalse: [ ^ str includesSubString: subStr ] "1.4"
]

