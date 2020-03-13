"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #LogicalSection,
	#superclass : #Object,
	#category : #PE
}

{ #category : #'instance creation' }
LogicalSection class >> fromStream: aStream [
	^self new fromStream: aStream
]

{ #category : #labels }
LogicalSection >> @ offset [
	^LogicalAddress in: self atOffset: offset
]

