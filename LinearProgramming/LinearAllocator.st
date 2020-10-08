"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #LinearAllocator,
	#superclass : #Object,
	#instVars : [
		'simplex',
		'numSources',
		'numDestinies',
		'matrix'
	],
	#category : #LinearProgramming
}

{ #category : #'instance creation' }
LinearAllocator class >> allocate: resources upTo: limits bounds: boundMatrix [
	"
	LinearAllocator
		allocate: #(12.0 20.0)
		upTo: #(10.0 20.0)
		bounds: #(#(10.0 10.0) #(8.0 10.0))
	"
	^self new allocate: resources upTo: limits bounds: boundMatrix]

{ #category : #initialization }
LinearAllocator >> allocate: resources upTo: limits bounds: boundMatrix [
	| c k r |
	numSources := resources size.
	numDestinies := limits size.
	self updateMatrix.
	c := matrix numColumns.
	k := 1.
	1 to: numDestinies do: [:i | 
		matrix atRow: k column: c put: (limits at: i).
		k := k + 1].
	1 to: numSources do: [:i | 
		matrix atRow: k column: c put: (resources at: i).
		k := k + 1].
	1 to: numSources do: [:i | 
		r := boundMatrix at: i.
		1 to: numDestinies do: [:j | 
			matrix atRow: k column: c put: (r at: j).
			k := k + 1]].
	self updateSimplex]

{ #category : #outputs }
LinearAllocator >> allocationFrom: i [
	| answer |
	answer := 0.0.
	1
		to: numDestinies
		do: [:j | answer := answer + (self allocationFrom: i to: j)].
	^answer]

{ #category : #outputs }
LinearAllocator >> allocationFrom: i to: j [
	| k |
	k := i - 1 * numDestinies + j.
	^simplex solution: k]

{ #category : #unclassified }
LinearAllocator >> allocationsFrom: i [
	| answer |
	answer := 0.0.
	1 to: numDestinies collect: [:j | self allocationFrom: i to: j].
	^answer]

{ #category : #outputs }
LinearAllocator >> allocationTo: j [
	| answer |
	answer := 0.0.
	1
		to: numSources
		do: [:i | answer := answer + (self allocationFrom: i to: j)].
	^answer]

{ #category : #initialization }
LinearAllocator >> initializeMatrix [
	| n m i j boolean |
	n := numSources.
	m := numDestinies.
	matrix := FloatMatrix
		fromBlock: [:a :b | 
			a = (n * m + n + m + 1)
				ifTrue: [b <= (n * m) ifTrue: [-1.0] ifFalse: [0.0]]
				ifFalse: [
					boolean := b <= (n * m)
						ifTrue: [
							i := b - 1 // m + 1.
							j := b - 1 \\ m + 1.
							a <= m
								ifTrue: [a = j]
								ifFalse: [a <= (n + m) ifTrue: [a - m = i] ifFalse: [a - n - m = b]]]
						ifFalse: [a = (b - (n * m))].
					boolean ifTrue: [1.0] ifFalse: [0.0]]]
		numRows: self numRows
		columns: self numColumns]

{ #category : #accessing }
LinearAllocator >> numColumns [
	^numSources + 1 * (numDestinies + 1) + (numSources * numDestinies)]

{ #category : #accessing }
LinearAllocator >> numRows [
	^numSources + 1 * (numDestinies + 1)]

{ #category : #solving }
LinearAllocator >> solve [
	simplex run.
	]

{ #category : #outputs }
LinearAllocator >> totalAllocation [
	| answer |
	answer := 0.0.
	1 to: numSources do: [:i | answer := answer + (self allocationFrom: i)].
	^answer]

{ #category : #initialization }
LinearAllocator >> updateMatrix [
	(matrix notNil
		and: [matrix numRows = self numRows
			and: [matrix numColumns = self numColumns]])
		ifFalse: [
			self initializeMatrix.
			simplex := nil]]

{ #category : #initialization }
LinearAllocator >> updateSimplex [
	simplex isNil ifTrue: [simplex := SimplexAlgorithm new].
	simplex matrix: matrix; numVariables: numSources * numDestinies]

