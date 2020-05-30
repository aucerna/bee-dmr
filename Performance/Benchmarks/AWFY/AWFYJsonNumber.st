"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #AWFYJsonNumber,
	#superclass : #AWFYJsonValue,
	#instVars : [
		'string'
	],
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
AWFYJsonNumber class >> new: string [

    string ifNil: [ self error: 'string is null' ].
    ^ self new initializeWith: string
]

{ #category : #'as yet unclassified' }
AWFYJsonNumber >> asString [
 ^ string 
]

{ #category : #'as yet unclassified' }
AWFYJsonNumber >> initializeWith: str [
 string := str 
]

{ #category : #'as yet unclassified' }
AWFYJsonNumber >> isNumber [
 ^ true 
]

