"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #ListElement,
	#superclass : #Object,
	#instVars : [
		'val',
		'next'
	],
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
ListElement class >> new: n [
 ^ self new initialize: n 
]

{ #category : #'as yet unclassified' }
ListElement >> initialize: n [

    val  := n.
    next := nil.
]

{ #category : #'as yet unclassified' }
ListElement >> length [
 next isNil ifTrue: [ ^ 1 ] ifFalse: [ ^ (1 + next length) ] 
]

{ #category : #'as yet unclassified' }
ListElement >> next [
 ^ next 
]

{ #category : #'as yet unclassified' }
ListElement >> next: element [
 next := element 
]

{ #category : #'as yet unclassified' }
ListElement >> val [
 ^ val 
]

{ #category : #'as yet unclassified' }
ListElement >> val: n [
 val := n 
]

