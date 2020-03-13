"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #BGRandomStream,
	#superclass : #BGRepeatStream,
	#instVars : [
		'random',
		'percentages',
		'randomNumFactory',
		'arrayFactory'
	],
	#category : #Game
}

{ #category : #'instance creation' }
BGRandomStream class >> new [
	^self basicNew initialize
]

{ #category : #'initialize-release' }
BGRandomStream >> initialize [
	randomNumFactory := BGRandomNumber.
	arrayFactory     := Array.
]

{ #category : #accessing }
BGRandomStream >> next [
	| r |
	r := random next.
	repeatPtr := repeatPtr + 1.
	1
		to: percentages size
		do: [:i | r < (percentages at: i) ifTrue: [^contents at: i]]
]

{ #category : #'initialize-release' }
BGRandomStream >> on: aCollection [
	| size cp |
	self initialize.
	repeatPtr := 0.
	random := randomNumFactory to: 1.0.
	size := aCollection size.
	percentages := arrayFactory new: size.
	contents := arrayFactory new: size.
	cp := 0.0.
	1 to: size do: [:i | 
		contents at: i put: (aCollection at: i) first.
		percentages at: i put: (cp := cp + (aCollection at: i) last)]
]

{ #category : #accessing }
BGRandomStream >> random: aRandomNumber [
"* Share the random number generator so we can get the expected results. *"
   random := aRandomNumber
]

