Class {
	#name : #SMarkResult,
	#superclass : #Object,
	#instVars : [
		'time',
		'benchName',
		'suite',
		'criteria'
	],
	#category : #SMark
}

{ #category : #accessing }
SMarkResult >> benchmarkName [
	^ benchName
]

{ #category : #accessing }
SMarkResult >> benchmarkName: aString [
	benchName := aString
]

{ #category : #accessing }
SMarkResult >> criteria [
	^ criteria
]

{ #category : #accessing }
SMarkResult >> criteria: aCollectionOfTimers [
	criteria := aCollectionOfTimers
]

{ #category : #accessing }
SMarkResult >> suite [
	^ suite
]

{ #category : #accessing }
SMarkResult >> suite: aBenchmarkSuite [
	suite := aBenchmarkSuite
]

{ #category : #accessing }
SMarkResult >> total [
	^ time
]

{ #category : #accessing }
SMarkResult >> total: aTime [
	time := aTime
]

