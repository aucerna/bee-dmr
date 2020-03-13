"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #BGRandomNumber,
	#superclass : #Object,
	#instVars : [
		'seed',
		'scale'
	],
	#classVars : [
		'FModulus',
		'Increment',
		'Modulus',
		'Multiplier'
	],
	#category : #Game
}

{ #category : #'class initialization' }
BGRandomNumber class >> initialize [
	FModulus := 139968.0.
	Increment := 29573.
	Modulus := 139968.
	Multiplier := 3877
]

{ #category : #'initialize-release' }
BGRandomNumber class >> to: anInteger [
   ^self basicNew to: anInteger
]

{ #category : #accessing }
BGRandomNumber >> next [
   seed := (seed * Multiplier + Increment) \\ Modulus.
   ^(seed * scale) / FModulus
]

{ #category : #private }
BGRandomNumber >> to: anInteger [
   seed := 42.
   scale := anInteger
]

