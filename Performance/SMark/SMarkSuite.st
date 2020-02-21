Class {
	#name : #SMarkSuite,
	#superclass : #Object,
	#instVars : [
		'#runner',
		'#selectedBenchmarks'
	],
	#category : #SMark
}

{ #category : #defaults }
SMarkSuite class >> defaultProblemSize [
	^ nil
]

{ #category : #defaults }
SMarkSuite class >> defaultRunner [
	^self onBee: [SMarkRunner] else: [SMarkBeeRunner]
]

{ #category : #benchmarking }
SMarkSuite class >> isAbstractClass [
	"This is a hack that is necessary in Squeak since it does not provide #isAbstractClass.
	 Actually this class is supposed to be abstract, but well, inheritance..."
	
	^ false
]

{ #category : #'platform support' }
SMarkSuite class >> onBee: beeBlock else: otherBlock [
	^Smalltalk isBee ifTrue: [beeBlock value] ifFalse: [otherBlock value]
]

{ #category : #'platform support' }
SMarkSuite class >> onCog: cogSpecificBlock else: general [
	^ (Smalltalk vm isRunningCogit)
		ifTrue:  [cogSpecificBlock value]
		ifFalse: [general value]
]

{ #category : #profiling }
SMarkSuite class >> profile: aSelector [
	^ self profileRunner 
		execute: self new selector: aSelector.
]

{ #category : #profiling }
SMarkSuite class >> profile: aSelector iterations: nIterations [
	^ self profileRunner 
		execute: self new selector: aSelector iterations: nIterations.
]

{ #category : #profiling }
SMarkSuite class >> profileAll [
	^ self profileRunner 
		execute: self new.
]

{ #category : #profiling }
SMarkSuite class >> profileRunner [
	^ SMarkProfileRunner
]

{ #category : #benchmarking }
SMarkSuite class >> run [
	"Execute the suite one time."
	^ self defaultRunner execute: self new.
]

{ #category : #benchmarking }
SMarkSuite class >> run: nIterations [
	"Execute the suite a given number of iterations."
	
	^ self defaultRunner execute: self new with: nIterations.
]

{ #category : #benchmarking }
SMarkSuite class >> runOnly: aSelector [
  "aSelector should refer to a benchmark method.
   Example:
     SMarkLoops runOnly: #benchFloatLoop
  "
  ^ self defaultRunner execute: (self new runOnly: aSelector)
]

{ #category : #benchmarking }
SMarkSuite class >> runOnly: aSelector iterations: anInteger [
	"Execute only the bench name aSelector from the suite."
	
	^ self defaultRunner execute: (self new runOnly: aSelector) with: anInteger
]

{ #category : #helper }
SMarkSuite >> benchmarkNameForSelector: selector [
	"Extracts the actual name of the benchmark from the selector"
	(selector beginsWith: #bench) ifTrue: [ ^ selector copyFrom: 6 to: selector size].
	^ selector asSymbol
	
]

{ #category : #running }
SMarkSuite >> cleanUpInstanceVariables [
	"Make sure all variables that are 'user variables' get cleaned"
	
	self class allInstVarNames do: [ :name |
		name = 'runner' ifFalse: [
			self instVarNamed: name put: nil ] ]
]

{ #category : #unclassified }
SMarkSuite >> descriptionOf: benchmarkName [
	^benchmarkName
]

{ #category : #benchmarking }
SMarkSuite >> performCustomSelector: aSelector with: aPrefix [
	| customSelector |
	customSelector := (aPrefix, aSelector capitalized) asSymbol.
	(self respondsTo: customSelector) ifTrue: [ 
		self perform: customSelector].
]

{ #category : #benchmarking }
SMarkSuite >> problemSize [
	#omniUnenforced "Hint for the OMOP that it is part of the meta infrastructure".
	runner ifNil: [^self class defaultProblemSize].
	runner problemSize ifNil: [^self class defaultProblemSize].
	^runner problemSize
]

{ #category : #benchmarking }
SMarkSuite >> processResult: anObject withTimer: aSMarkTimer [
	"subclass responsability. You can verify your results here, or do things with the timer."
	^self.
]

{ #category : #benchmarking }
SMarkSuite >> run [
	"Executes all the benchmarks in the suite, 
	 coordinating with the runner when necessary"
	
	| potentialBenchmarkSelectors |
	selectedBenchmarks
		ifNotNil: [ potentialBenchmarkSelectors := selectedBenchmarks ]
		ifNil:    [ potentialBenchmarkSelectors := self class allSelectors ].				
	
	potentialBenchmarkSelectors
		do: [ :selector |
			(self shouldRunSelector: selector)
				ifTrue: [
					runner performBenchmark: selector ]
		].
	
]

{ #category : #benchmarking }
SMarkSuite >> runBenchmark: aSelector [
	
	[self setUp.
	 self performCustomSelector: aSelector with: #setUp.
	 runner timedBenchmarkExecution: aSelector] ensure: [
		self performCustomSelector: aSelector with: #tearDown.
		self tearDown.
		self cleanUpInstanceVariables]
]

{ #category : #accessing }
SMarkSuite >> runner [
	^ runner
]

{ #category : #accessing }
SMarkSuite >> runner: aRunner [
	runner := aRunner.
]

{ #category : #benchmarking }
SMarkSuite >> runOnly: aSymbol [
	selectedBenchmarks := IdentitySet newFrom: (Array with: aSymbol)
]

{ #category : #benchmarking }
SMarkSuite >> selectedBenchmarks [
	^ selectedBenchmarks
]

{ #category : #running }
SMarkSuite >> setUp [
	"It is the subclass' responsibility to set up the necessary environment for a benchmark"
	^ self
]

{ #category : #testing }
SMarkSuite >> shouldRunSelector: selector [
	"Tells whether the given selector is in the form bench*, and thus is a benchmark that should be executed."
	
	(selector includes: $:) ifTrue: [ ^ false ].
	^ selector beginsWith: #bench
]

{ #category : #running }
SMarkSuite >> tearDown [
	"It is the subclass' responsibility to clean up the environment after a benchmark"
	^ self
]

