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

