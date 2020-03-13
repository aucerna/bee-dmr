"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #DBEditConstraint,
	#superclass : #DBUnaryConstraint,
	#category : #SMDeltaBlue
}

{ #category : #'instance creation' }
DBEditConstraint class >> var: aVariable strength: strengthSymbol [
	"Install an edit constraint with the given strength on the given
	 variable."

	^(self new) var: aVariable strength: strengthSymbol
]

{ #category : #planning }
DBEditConstraint >> execute [
	"Edit constraints do nothing."
]

{ #category : #testing }
DBEditConstraint >> isInput [
	"I indicate that a variable is to be changed by imperative code."

	^true
]

