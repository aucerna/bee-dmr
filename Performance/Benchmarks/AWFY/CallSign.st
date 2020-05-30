"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #CallSign,
	#superclass : #Object,
	#instVars : [
		'value'
	],
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
CallSign class >> new: val [

    ^ self new init: val
]

{ #category : #'as yet unclassified' }
CallSign >> compareTo: other [

    ^ value = other value
        ifTrue:  [ 0 ]
        ifFalse: [
          value < other value ifTrue: [ -1 ] ifFalse: [ 1 ]]
]

{ #category : #'as yet unclassified' }
CallSign >> init: val [
 value := val 
]

{ #category : #'as yet unclassified' }
CallSign >> value [
 ^ value 
]

