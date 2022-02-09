"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #CriticalQueue,
	#superclass : #SequenceableCollection,
	#instVars : [
		'head',
		'limit',
		'top',
		'buffers',
		'bufferIndex'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
CriticalQueue class >> emptyReserving: anInteger [
	| buffers |
	buffers := CriticalArray new growTo: 40.
	^self new buffers: buffers initialSize: anInteger
]

{ #category : #'adding/removing' }
CriticalQueue >> addBuffer: size [
	| address |
	address := OS reserveAndCommit: size * WordSize.
	buffers
		push: size;
		push: address // 2
]

{ #category : #actions }
CriticalQueue >> at: anInteger [
	^self errorNotIndexable
]

{ #category : #accessing }
CriticalQueue >> buffers: aCriticalArray initialSize: anInteger [
	buffers := aCriticalArray.
	self addBuffer: anInteger.
	top := 0.
	bufferIndex := 2.
	head := buffers at: bufferIndex.
	limit := anInteger
]

{ #category : #private }
CriticalQueue >> grow [
	bufferIndex = buffers size ifTrue: [self addBuffer: limit * 2].
	bufferIndex := bufferIndex + 2.
	head := buffers at: bufferIndex.
	limit := buffers at: bufferIndex - 1.
	top := 0
]

{ #category : #testing }
CriticalQueue >> isEmpty [
	^top = 0 and: [bufferIndex = 2]
]

{ #category : #'adding/removing' }
CriticalQueue >> pop [
	| answer |
	top = 0 ifTrue: [self shrink].
	answer := head _asObject _basicAt: top.
	top := top - 1.
	^answer
]

{ #category : #'adding/removing' }
CriticalQueue >> push: anObject [
	top = limit ifTrue: [self grow].
	top := top + 1.
	^head _asObject _basicAt: top put: anObject
]

{ #category : #finalization }
CriticalQueue >> release [
	2 to: buffers size by: 2 do: [:i | | address |
		address := buffers at: i.
		OS release: address * 2].
	buffers reset
]

{ #category : #actions }
CriticalQueue >> reset [
	[buffers size > 2] whileTrue: [| address |
		address := buffers pop.
		buffers pop.
		OS release: address * 2].
	bufferIndex := 2.
	head := buffers at: bufferIndex.
	limit := buffers at: bufferIndex - 1.
	top := 0
]

{ #category : #private }
CriticalQueue >> shrink [
	bufferIndex < 2 ifTrue: [self error: 'cannot shrink empty queue'].
	bufferIndex := bufferIndex - 2.
	head := buffers at: bufferIndex.
	limit := top := buffers at: bufferIndex - 1
]

