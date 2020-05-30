"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #Aircraft,
	#superclass : #Object,
	#instVars : [
		'callsign',
		'position'
	],
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
Aircraft class >> new: callsign pos: position [

    ^ self new init: callsign pos: position
]

{ #category : #'as yet unclassified' }
Aircraft >> callsign [
 ^ callsign 
]

{ #category : #'as yet unclassified' }
Aircraft >> init: aCallsign pos: aPosition [

    callsign := aCallsign.
    position := aPosition.
]

{ #category : #'as yet unclassified' }
Aircraft >> position [
 ^ position 
]

