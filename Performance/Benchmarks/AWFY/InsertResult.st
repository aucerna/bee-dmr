"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #InsertResult,
	#superclass : #Object,
	#instVars : [
		'isNewEntry',
		'newNode',
		'oldValue'
	],
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
InsertResult class >> new: isNewEntry node: newNode value: oldValue [

    ^ self new init: isNewEntry node: newNode value: oldValue
]

{ #category : #'as yet unclassified' }
InsertResult >> init: aBool node: aNode value: val [

    isNewEntry := aBool.
    newNode    := aNode.
    oldValue   := val.
]

{ #category : #'as yet unclassified' }
InsertResult >> isNewEntry [
 ^ isNewEntry 
]

{ #category : #'as yet unclassified' }
InsertResult >> newNode [
 ^ newNode 
]

{ #category : #'as yet unclassified' }
InsertResult >> oldValue [
 ^ oldValue 
]

