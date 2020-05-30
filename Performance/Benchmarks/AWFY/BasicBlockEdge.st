"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #BasicBlockEdge,
	#superclass : #Object,
	#instVars : [
		'from',
		'to'
	],
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
BasicBlockEdge class >> for: cfg from: fromName to: toName [

    ^ self new init: cfg from: fromName to: toName 
]

{ #category : #'as yet unclassified' }
BasicBlockEdge >> init: cfg from: fromName to: toName [

    from := cfg createNode: fromName.
    to   := cfg createNode: toName.

    from addOutEdge: to.
    to   addInEdge:  from.
    cfg  addEdge:    self
]

