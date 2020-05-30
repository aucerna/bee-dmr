"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #Plan,
	#superclass : #Vector,
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
Plan class >> new [
 ^ self new: 15 
]

{ #category : #'as yet unclassified' }
Plan >> execute [

    "Execute my constraints in order."

    self forEach: [: c | c execute ]
]

