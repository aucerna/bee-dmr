Class {
	#name : #SMarkReporter,
	#superclass : #Object,
	#instVars : [
		'runner',
		'stream'
	],
	#category : #SMark
}

{ #category : #defaults }
SMarkReporter class >> defaultOutputDestination [
	^Transcript
]

{ #category : #defaults }
SMarkReporter class >> defaultReporter [
	^ SMarkSimpleStatisticsReporter
]

{ #category : #unclassified }
SMarkReporter class >> new [
	^self basicNew initialize
]

{ #category : #reporting }
SMarkReporter class >> reportFor: aRunner [
	self reportFor: aRunner on: self defaultOutputDestination.
]

{ #category : #reporting }
SMarkReporter class >> reportFor: aRunner on: aStream [
	| reporter |
	reporter := self new.
	reporter runner: aRunner.
	reporter outputStream: aStream.
	reporter report.
	^ reporter.
]

{ #category : #reporting }
SMarkReporter >> benchmarkFooter: aName [
	stream cr.
]

{ #category : #reporting }
SMarkReporter >> benchmarkHeader: aName [
	| description |
	description := (runner suite descriptionOf: aName) , String cr.
	stream << 'Benchmark ' << description
]

{ #category : #reporting }
SMarkReporter >> footer [
	"No output at the moment"
	^ self
]

{ #category : #reporting }
SMarkReporter >> header [
	| suiteName |
	suiteName := runner suite class name asString.
	stream << 'Report for: ' << suiteName; cr.
]

{ #category : #initialization }
SMarkReporter >> initialize [
	super initialize.
	stream := self class defaultOutputDestination.
]

{ #category : #accessing }
SMarkReporter >> outputStream: aStream [
	stream := aStream  
]

{ #category : #accessing }
SMarkReporter >> report [
	| sorted |
	self header.
	sorted := runner results associations asOrderedCollection
		sortBy: [:a :b | a key < b key].
	sorted do: [:association | 
		self benchmarkHeader: association key.
		self reportAllRuns: association value of: association key.
		self benchmarkFooter: association key].
	self footer.
	^self
]

{ #category : #reporting }
SMarkReporter >> reportAllRuns: aListOfResults of: benchmark [
	aListOfResults do: [:result |
		result criteria keysAndValuesDo: [:benchName :timer |
			stream << benchName << ': ' << (timer totalTime asString, 'ms'); cr.]]
]

{ #category : #accessing }
SMarkReporter >> runner: aRunner [
	runner := aRunner.
]

