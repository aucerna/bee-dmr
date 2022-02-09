"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #MemoryMeter,
	#superclass : #Object,
	#instVars : [
		'memory',
		'runs',
		'time',
		'maxPause',
		'youngFreed',
		'oldGrown',
		'grows',
		'shrinks',
		'rescued'
	],
	#category : #Kernel
}

{ #category : #accessing }
MemoryMeter >> initialize [
	runs := OrderedCollection new: 1000
]

{ #category : #accessing }
MemoryMeter >> memory: aMemory [
	memory := aMemory
]

{ #category : #accessing }
MemoryMeter >> runs [
	^runs
]

{ #category : #accessing }
MemoryMeter >> statistics [
	^'GC passes: ' , runs size asString
]

