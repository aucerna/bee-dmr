"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #AWFYJsonObject,
	#superclass : #AWFYJsonValue,
	#instVars : [
		'names',
		'values',
		'table'
	],
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
AWFYJsonObject class >> new [
 ^ super new initialize 
]

{ #category : #'as yet unclassified' }
AWFYJsonObject class >> readFrom: string [

    ^ (JsonValue readFrom: string) asObject
]

{ #category : #'as yet unclassified' }
AWFYJsonObject >> add: name with: aJsonValue [

    name ifNil: [ self error: 'name is null'  ].
    aJsonValue ifNil: [ self error: 'aJsonValue is null' ].

    table at: name put: names size + 1. "+ 1 for 1-based indexing"
    names  append: name.
    values append: aJsonValue.
]

{ #category : #'as yet unclassified' }
AWFYJsonObject >> asObject [
 ^ self 
]

{ #category : #'as yet unclassified' }
AWFYJsonObject >> at: name [

    | idx |
    name ifNil: [ self error: 'name is null'  ].
    idx := self indexOf: name.
    idx = 0
      ifTrue:  [ ^ nil ]
      ifFalse: [ ^ values at: idx ]
]

{ #category : #'as yet unclassified' }
AWFYJsonObject >> indexOf: name [

    | idx |
    idx := table at: name.    
    (idx ~= 0 and: [name = (names at: idx)]) ifTrue: [ ^ idx ].
    ^ self error: 'not implement'
]

{ #category : #'as yet unclassified' }
AWFYJsonObject >> initialize [

    names  := Vector new.
    values := Vector new.
    table  := HashIndexTable new
]

{ #category : #'as yet unclassified' }
AWFYJsonObject >> isEmpty [

    ^ names isEmpty
]

{ #category : #'as yet unclassified' }
AWFYJsonObject >> isObject [
 ^ true 
]

{ #category : #'as yet unclassified' }
AWFYJsonObject >> size [

    ^ names size
]

