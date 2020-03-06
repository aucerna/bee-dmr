Class {
	#name : #SMarkSmopstone,
	#superclass : #SMarkSuite,
	#instVars : [
		'smopstone'
	],
	#category : #Suites
}

{ #category : #benchmarking }
SMarkSmopstone >> benchArithmeticAndCollections [
	| n |
	n := self problemSize.
	smopstone sorcerersApprentice: n
]

{ #category : #benchmarking }
SMarkSmopstone >> benchFractonacci [
	| n |
	"time taken by this benchmark looks exponential in relation to n, we 'linearize' it."
	n := self problemSize.
	smopstone fractonacci: (n log: 2) asInteger
]

{ #category : #benchmarking }
SMarkSmopstone >> benchPrimesProcessing [
	| n primes |
	n := self problemSize.
	primes := smopstone primesProcessing: n * 100 "7351 - 1" "9000"
]

{ #category : #benchmarking }
SMarkSmopstone >> benchStringsAndCollections [
	| n |
	n := self problemSize.
	smopstone stringsAndCollections: n * 100
]

{ #category : #defaults }
SMarkSmopstone >> defaultProblemSize [
	^150
]

{ #category : #benchmarking }
SMarkSmopstone >> problemSize [
	| ps |
	#omniUnenforced "Hint for the OMOP that it is part of the meta infrastructure".
	ps := super problemSize.
	ps isInteger ifFalse: [^self defaultProblemSize].
	^ps
]

{ #category : #benchmarking }
SMarkSmopstone >> setUp [
	smopstone := (Smalltalk at: #Smopstone) new
]

