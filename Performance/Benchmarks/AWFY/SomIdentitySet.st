"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #SomIdentitySet,
	#superclass : #SomSet,
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
SomIdentitySet class >> new: size [

    ^ super new initialize: size.
]

{ #category : #'as yet unclassified' }
SomIdentitySet >> contains: anObject [

    ^ self hasSome: [ :it |  it == anObject ]
]

