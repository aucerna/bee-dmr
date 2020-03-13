"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #BGMeteor,
	#superclass : #Object,
	#instVars : [
		'meteorBoardFactory'
	],
	#category : #Game
}

{ #category : #defaults }
BGMeteor class >> defaultProblemSize [
	^ 2098
]

{ #category : #benchmarking }
BGMeteor class >> meteor [
	^ self meteor: 2098
]

{ #category : #benchmarking }
BGMeteor class >> meteor: n [
	| output |
	output := '' writeStream.
	self new meteor: n to: output.
	^output
]

{ #category : #'instance creation' }
BGMeteor class >> new [
	^self basicNew initialize
]

{ #category : #'test data' }
BGMeteor class >> output [
	^'2098 solutions found

0 0 0 0 1 
 2 2 2 0 1 
2 6 6 1 1 
 2 6 1 5 5 
8 6 5 5 5 
 8 6 3 3 3 
4 8 8 9 3 
 4 4 8 9 3 
4 7 4 7 9 
 7 7 7 9 9 

9 9 9 9 8 
 9 6 6 8 5 
6 6 8 8 5 
 6 8 2 5 5 
7 7 7 2 5 
 7 4 7 2 0 
1 4 2 2 0 
 1 4 4 0 3 
1 4 0 0 3 
 1 1 3 3 3 

'
]

{ #category : #'initialize-release' }
BGMeteor >> initialize [
	meteorBoardFactory := BGMeteorBoard
]

{ #category : #benchmarking }
BGMeteor >> meteor: nMax to: outputStream [
	^ self meteor: nMax with: meteorBoardFactory default to: outputStream
]

{ #category : #benchmarking }
BGMeteor >> meteor: nMax with: aBoard to: outputStream [
	| board count minSolution maxSolution |
	count := 0.
	minSolution := String new: 50 withAll: $9.
	maxSolution := String new: 50 withAll: $0.
	aBoard solvedPuzzleDo: [:aString | 
		count := count + 1.
		aString < minSolution ifTrue: [minSolution := aString].
		aString > maxSolution ifTrue: [maxSolution := aString]].
	outputStream
		print: count;
		nextPutAll: ' solutions found';
		cr;
		cr.
	aBoard printSolution: minSolution on: outputStream.
	outputStream cr.
	aBoard printSolution: maxSolution on: outputStream.
	outputStream cr
]

