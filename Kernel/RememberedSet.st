"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #RememberedSet,
	#superclass : #Object,
	#instVars : [
		'base',
		'tally',
		'size'
	],
	#category : #Kernel
}

{ #category : #private }
RememberedSet >> add: anObject [
	"
	We first check if grow is needed, then increment the tally and 
	finally grow. If not done this way, if growing adds something to
	the remembered set it could cause an infinite recursion
	"
	| grow |
	grow := tally + 10 = size.
	tally := tally + 1.
	base _asObject _basicAt: tally put: anObject.
	grow ifTrue: [self grow: size * 2]
]

{ #category : #private }
RememberedSet >> at: anInteger [
	^base _asObject _basicAt: anInteger
]

{ #category : #private }
RememberedSet >> at: anInteger put: anObject [
	^base _asObject _basicAt: anInteger put: anObject
]

{ #category : #private }
RememberedSet >> base [
	^base
]

{ #category : #private }
RememberedSet >> base: anInteger [
	base := anInteger
]

{ #category : #private }
RememberedSet >> bufferSize [
	^size
]

{ #category : #private }
RememberedSet >> grow: anInteger [
	| new old |
	new := (OS reserveAndCommit: anInteger * WordSize) // 2.
	1
		to: tally
		do: [:i | new _asObject _basicAt: i put: (base _asObject _basicAt: i)].
	old := base.
	base := new.
	size := anInteger.
	OS release: old * 2
]

{ #category : #private }
RememberedSet >> includesIdentical: anObject [
	1 to: size do: [:i | anObject == (self at: i) ifTrue: [^true]].
	^false
]

{ #category : #private }
RememberedSet >> initialize: anInteger [
	tally := 0.
	base := (OS reserveAndCommit: anInteger * WordSize) // 2.
	size := anInteger
]

{ #category : #private }
RememberedSet >> release [
	OS release: base * 2.
	base := nil.
	tally := size := 0
]

{ #category : #private }
RememberedSet >> size [
	^tally
]

{ #category : #private }
RememberedSet >> size: anInteger [
	tally := anInteger
]

