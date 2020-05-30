"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #RbtEntry,
	#superclass : #Object,
	#instVars : [
		'key',
		'value'
	],
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
RbtEntry class >> key: key value: value [

    ^ self new init: key value: value
]

{ #category : #'as yet unclassified' }
RbtEntry >> init: aKey value: val [

    key   := aKey.
    value := val.
]

{ #category : #'as yet unclassified' }
RbtEntry >> key [
 ^ key 
]

{ #category : #'as yet unclassified' }
RbtEntry >> value [
 ^ value 
]

