"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #SomRandom,
	#superclass : #Object,
	#instVars : [
		'seed'
	],
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
SomRandom class >> new [
 ^ super new initialize 
]

{ #category : #'as yet unclassified' }
SomRandom >> initialize [
 seed := 74755 
]

{ #category : #'as yet unclassified' }
SomRandom >> next [

    seed := ((seed * 1309) + 13849) & 65535.
    ^ seed
]

