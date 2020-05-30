"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #SomIdentityDictionary,
	#superclass : #SomDictionary,
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
SomIdentityDictionary class >> new [
 ^ super new: 16 
]

{ #category : #'as yet unclassified' }
SomIdentityDictionary class >> new: size [

    ^ self new: size
]

{ #category : #'as yet unclassified' }
SomIdentityDictionary >> newEntry: aKey value: value hash: hash [

    ^ DictIdEntry new: hash key: aKey value: value next: nil
]

