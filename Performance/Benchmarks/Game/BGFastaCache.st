"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #BGFastaCache,
	#superclass : #Object,
	#instVars : [
		'cache'
	],
	#classVars : [
		'Cache'
	],
	#category : #Game
}

{ #category : #accessing }
BGFastaCache class >> forFasta: anInteger [
	<omniUnenforced>
	Cache ifNil: [Cache := self new].
	^ Cache forFasta: anInteger
]

{ #category : #'instance creation' }
BGFastaCache class >> new [
	^self basicNew initialize
]

{ #category : #accessing }
BGFastaCache class >> primeForFasta: anInteger [
	<omniUnenforced>
	Cache ifNil: [Cache := self new].
	^ Cache primeForFasta: anInteger
]

{ #category : #cache }
BGFastaCache >> forFasta: anInteger [
	"
	This will throw an error if the cache is not initialized properly.
	"
	^cache at: anInteger ifAbsentPut: [
		Error
			signal: 'Cache not properly initialized for given problem size: '
				, anInteger asString
				, '. You have to doit the following line once:
BGFastaCache primeForFasta: '
				, anInteger printString]
]

{ #category : #'initialize-release' }
BGFastaCache >> initialize [
	cache := Dictionary new.
]

{ #category : #cache }
BGFastaCache >> primeForFasta: anInteger [
	| out result |
	out := '' writeStream.
	BGFasta fasta: anInteger to: out.
	result := out contents.
	cache at: anInteger put: result.
	^result
]

