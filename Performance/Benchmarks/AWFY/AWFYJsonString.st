"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #AWFYJsonString,
	#superclass : #AWFYJsonValue,
	#instVars : [
		'string'
	],
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
AWFYJsonString class >> new: str [
 ^ self new initializeWith: str 
]

{ #category : #'as yet unclassified' }
AWFYJsonString >> initializeWith: str [
 string := str 
]

{ #category : #'as yet unclassified' }
AWFYJsonString >> isString [

    ^ true
]

