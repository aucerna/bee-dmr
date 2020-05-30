"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #DictIdEntry,
	#superclass : #DictEntry,
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
DictIdEntry class >> new: hash key: key value: val next: next [

    ^ self new init: hash key: key value: val next: next
]

{ #category : #'as yet unclassified' }
DictIdEntry >> match: aHash key: aKey [

    ^ hash = aHash and: [key == aKey]
]

