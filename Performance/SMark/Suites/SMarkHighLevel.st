Class {
	#name : #SMarkHighLevel,
	#superclass : #SMarkSuite,
	#instVars : [
		'#cd',
		'#deltaBlue',
		'#havlak',
		'#json',
		'#richards'
	],
	#classVars : [
		'#defaultSizes'
	],
	#category : #Suites
}

{ #category : #private }
SMarkHighLevel >> benchDeltaBlue [
	| size |
	size := self problemSizeOf: #DeltaBlue.
	deltaBlue new innerBenchmarkLoop: size
]

{ #category : #private }
SMarkHighLevel >> benchHavlak [
	| size |
	size := self problemSizeOf: #Havlak.
	havlak new innerBenchmarkLoop: size
]

{ #category : #private }
SMarkHighLevel >> benchJson [
	| size |
	size := self problemSizeOf: #Json.
	json new innerBenchmarkLoop: size
]

{ #category : #private }
SMarkHighLevel >> benchRichards [
	| size |
	size := self problemSizeOf: #Richards.
	richards new innerBenchmarkLoop: size
]

{ #category : #private }
SMarkHighLevel >> defaultProblemSizeOf: bench [
	^defaultSizes at: bench
]

{ #category : #unclassified }
SMarkHighLevel >> descriptionOf: benchmarkName [
	^benchmarkName , ' (problem: '
		, (self problemSizeOf: benchmarkName asSymbol) printString
		, ')'
]

{ #category : #benchmarking }
SMarkHighLevel >> problemSizeOf: bench [
	| ps |
	ps := self problemSize.
	ps isNil ifTrue: [^self defaultProblemSizeOf: bench].
	^ps
]

{ #category : #running }
SMarkHighLevel >> setUp [
	cd := Smalltalk at: #CD.
	deltaBlue := Smalltalk at: #DeltaBlue.
	havlak := Smalltalk at: #Havlak.
	json := Smalltalk at: #Json.
	richards := Smalltalk at: #Richards.
	defaultSizes := Dictionary new.
	defaultSizes
		at: #CD put: 100;
		at: #DeltaBlue put: 5000;
		at: #Havlak put: 500;
		at: #Json put: 100;
		at: #Richards put: 100
]

