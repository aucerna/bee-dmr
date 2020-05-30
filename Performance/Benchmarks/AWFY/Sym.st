"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #Sym,
	#superclass : #Object,
	#instVars : [
		'hash'
	],
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
Sym class >> new: aHash [

    ^ self new init: aHash
]

{ #category : #'as yet unclassified' }
Sym >> customHash [
 ^ hash 
]

{ #category : #'as yet unclassified' }
Sym >> init: aHash [
 hash := aHash 
]

