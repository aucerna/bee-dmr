"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #ReBenchHarnessArgumentParser,
	#superclass : #SMarkHarnessArgumentParser,
	#category : #SMark
}

{ #category : #'argument parsing' }
ReBenchHarnessArgumentParser >> determineBenchmarkParametersFromArguments [
	i := i + 1.
	i <= numParams ifTrue: [
		processes := (arguments at: i) asInteger.
		i := i + 1.
		i <= numParams ifTrue: [
			iterations := (arguments at: i) asInteger.
			i := i + 1.
			i <= numParams ifTrue: [
				problemSize := arguments at: i.
			]
		]
	].
]

{ #category : #'argument parsing' }
ReBenchHarnessArgumentParser >> determineReporter [
	reporter := harness defaultReporter new.
]

{ #category : #'argument parsing' }
ReBenchHarnessArgumentParser >> determineRunner [
	runner := harness defaultRunner new.
]

{ #category : #helper }
ReBenchHarnessArgumentParser >> instructRunner [
	super instructRunner.
	
	runner iterations: runner class defaultNumberOfIterations.
	runner innerIterations: iterations.
]

