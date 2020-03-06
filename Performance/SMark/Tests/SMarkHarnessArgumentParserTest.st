Class {
	#name : #SMarkHarnessArgumentParserTest,
	#superclass : #TestCase,
	#instVars : [
		'parser'
	],
	#category : #Tests
}

{ #category : #running }
SMarkHarnessArgumentParserTest >> setUp [
	parser := SMarkHarnessArgumentParser new.
	parser harness: SMarkHarness.
]

{ #category : #tests }
SMarkHarnessArgumentParserTest >> testParseArgumentsOnlyBench [
	| arguments runnerAndReporter runner reporter runOnly |
	arguments := Array with: #ignored with: 'SMarkTestSuite.benchA'.
	runnerAndReporter := parser parse: arguments.
	runner := runnerAndReporter first.
	reporter := runnerAndReporter second.
	self assert: runner notNil.
	self assert: reporter notNil.
	self assert: (runner suite isKindOf: SMarkTestSuite).
	runOnly := runner suite selectedBenchmarks.
	self assert: 1 equals: runOnly size.
	self assert: (runOnly includes: #benchA)
]

{ #category : #tests }
SMarkHarnessArgumentParserTest >> testParseArgumentsOnlySuite [
	| arguments runnerAndReporter runner reporter |
	arguments := Array with: #ignored with: 'SMarkTestSuite'.
	runnerAndReporter := parser parse: arguments.
	runner := runnerAndReporter first.
	reporter := runnerAndReporter second.
	self assert: runner notNil.
	self assert: reporter notNil.
	self assert: (runner suite isKindOf: SMarkTestSuite).
	self assert: runner suite selectedBenchmarks isNil
]

{ #category : #tests }
SMarkHarnessArgumentParserTest >> testParseArgumentsReporterSuiteIterations [
	| arguments runnerAndReporter runner reporter |
	arguments := Array
		with: #ignored
		with: 'SMarkSimpleStatisticsReporter'
		with: 'SMarkTestSuite'
		with: '13'.
	runnerAndReporter := parser parse: arguments.
	runner := runnerAndReporter first.
	reporter := runnerAndReporter second.
	self assert: runner notNil.
	self assert: reporter notNil.
	self assert: (reporter isKindOf: SMarkSimpleStatisticsReporter).
	self assert: (runner suite isKindOf: SMarkTestSuite).
	self assert: runner suite selectedBenchmarks isNil.
	self assert: 13 equals: runner iterations
]

{ #category : #tests }
SMarkHarnessArgumentParserTest >> testParseArgumentsRunnerReporterSuiteIterations [
	| arguments runnerAndReporter runner reporter |
	arguments := Array
		with: #ignored
		with: 'SMarkTestRunner'
		with: 'SMarkSimpleStatisticsReporter'
		with: 'SMarkTestSuite'
		with: '13'.
	runnerAndReporter := parser parse: arguments.
	runner := runnerAndReporter first.
	reporter := runnerAndReporter second.
	self assert: runner notNil.
	self assert: reporter notNil.
	self assert: (runner isKindOf: SMarkTestRunner).
	self assert: (reporter isKindOf: SMarkSimpleStatisticsReporter).
	self assert: (runner suite isKindOf: SMarkTestSuite).
	self assert: runner suite selectedBenchmarks isNil.
	self assert: 13 equals: runner iterations
]

{ #category : #tests }
SMarkHarnessArgumentParserTest >> testParseArgumentsRunnerSuiteIterations [
	| arguments runnerAndReporter runner reporter |
	arguments := Array
		with: #ignored
		with: 'SMarkTestRunner'
		with: 'SMarkTestSuite'
		with: '13'.
	runnerAndReporter := parser parse: arguments.
	runner := runnerAndReporter first.
	reporter := runnerAndReporter second.
	self assert: runner notNil.
	self assert: reporter notNil.
	self assert: (runner isKindOf: SMarkTestRunner).
	self assert: (runner suite isKindOf: SMarkTestSuite).
	self assert: runner suite selectedBenchmarks isNil.
	self assert: 13 equals: runner iterations
]

{ #category : #tests }
SMarkHarnessArgumentParserTest >> testParseArgumentsSuiteAndIterations [
	| arguments runnerAndReporter runner reporter |
	arguments := Array with: #ignored with: 'SMarkTestSuite' with: '13'.
	runnerAndReporter := parser parse: arguments.
	runner := runnerAndReporter first.
	reporter := runnerAndReporter second.
	self assert: runner notNil.
	self assert: reporter notNil.
	self assert: (runner suite isKindOf: SMarkTestSuite).
	self assert: runner suite selectedBenchmarks isNil.
	self assert: 13 equals: runner iterations
]

{ #category : #tests }
SMarkHarnessArgumentParserTest >> testParseArgumentsSuiteIterationsProcesses [
	| arguments runnerAndReporter runner reporter |
	arguments := Array
		with: #ignored
		with: 'SMarkTestSuite'
		with: '13'
		with: '91'.
	runnerAndReporter := parser parse: arguments.
	runner := runnerAndReporter first.
	reporter := runnerAndReporter second.
	self assert: runner notNil.
	self assert: reporter notNil.
	self assert: (runner suite isKindOf: SMarkTestSuite).
	self assert: runner suite selectedBenchmarks isNil.
	self assert: 13 equals: runner iterations.
	self assert: 91 equals: runner processes
]

{ #category : #tests }
SMarkHarnessArgumentParserTest >> testParseArgumentsSuiteIterationsProcessesProblemSize [
	| arguments runnerAndReporter runner reporter |
	arguments := Array
		with: #ignored
		with: 'SMarkTestSuite'
		with: '13'
		with: '91'
		with: 'SSS'.
	runnerAndReporter := parser parse: arguments.
	runner := runnerAndReporter first.
	reporter := runnerAndReporter second.
	self assert: runner notNil.
	self assert: reporter notNil.
	self assert: (runner suite isKindOf: SMarkTestSuite).
	self assert: runner suite selectedBenchmarks isNil.
	self assert: 13 equals: runner iterations.
	self assert: 91 equals: runner processes.
	self assert: 'SSS' equals: runner problemSize
]

{ #category : #tests }
SMarkHarnessArgumentParserTest >> testParseBenchmarkOrSuite [
	| example1 example2 example3 example4 example5 |
	example1 := 'String>>findTokens:'.
	example2 := 'SMarkTestSuite'.
	example3 := Array with: SMarkTestSuite with: #benchA.
	example4 := SMarkTestSuite.
	example5 := 'String.findTokens:'.
	". (dot) notation is required to avoid quoting in bash"
	
	self
		assert: (Array with: String with: #findTokens:)
		equals: (parser parseBenchmarkOrSuite: example1).
	self assert: SMarkTestSuite equals: (parser parseBenchmarkOrSuite: example2).
	self
		assert: (Array with: SMarkTestSuite with: #benchA)
		equals: (parser parseBenchmarkOrSuite: example3).
	self assert: SMarkTestSuite equals: (parser parseBenchmarkOrSuite: example4).
	self
		assert: (Array with: String with: #findTokens:)
		equals: (parser parseBenchmarkOrSuite: example5).
	"What to do when the input is not a symbol, array, or class?"
	
	"What to do when the class does not exist"
	self
		should: [parser parseBenchmarkOrSuite: 'FooBarClassThatDoesNotExist']
		raise: Error
]

