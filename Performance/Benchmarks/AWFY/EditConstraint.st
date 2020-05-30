"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #EditConstraint,
	#superclass : #UnaryConstraint,
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
EditConstraint class >> var: aVariable strength: strengthSymbol addTo: planner [

      "Install an edit constraint with the given strength on the given
       variable."

      ^ self new initializeVar: aVariable strength: strengthSymbol addTo: planner
]

{ #category : #'as yet unclassified' }
EditConstraint >> execute [

]

{ #category : #'as yet unclassified' }
EditConstraint >> isInput [

    "I indicate that a variable is to be changed by imperative code."
    ^ true
]

