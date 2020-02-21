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

