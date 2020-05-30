"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #Collision,
	#superclass : #Object,
	#instVars : [
		'aircraftA',
		'aircraftB',
		'position'
	],
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
Collision class >> a: aircraftA b: aircraftB pos: position [

    ^ self new init: aircraftA b: aircraftB pos: position
]

{ #category : #'as yet unclassified' }
Collision >> aircraftA [
 ^ aircraftA 
]

{ #category : #'as yet unclassified' }
Collision >> aircraftB [
 ^ aircraftB 
]

{ #category : #'as yet unclassified' }
Collision >> init: anA b: aB pos: aPos [

    aircraftA := anA.
    aircraftB := aB.
    position  := aPos
]

{ #category : #'as yet unclassified' }
Collision >> position [
 ^ position 
]

