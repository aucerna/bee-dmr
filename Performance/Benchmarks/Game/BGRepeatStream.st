"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #BGRepeatStream,
	#superclass : #InternalReadStream,
	#instVars : [
		'repeatPtr',
		'repeatLimit'
	],
	#category : #Game
}

{ #category : #'instance creation' }
BGRepeatStream class >> to: anInteger on: aCollection [
   ^(super on: aCollection) to: anInteger
]

{ #category : #testing }
BGRepeatStream >> atEnd [
   ^repeatPtr >= repeatLimit
]

{ #category : #accessing }
BGRepeatStream >> next [
	position >= limit ifTrue: [self position: 0].
	repeatPtr := repeatPtr + 1.
	^contents at: (position := position + 1)
]

{ #category : #'initialize-release' }
BGRepeatStream >> to: anInteger [
   repeatPtr := 0.
   repeatLimit := anInteger
]

