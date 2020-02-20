Class {
	#name : #ISAModRMReader,
	#superclass : #ISAInstructionPartReader,
	#category : #Tools
}

{ #category : #accessing }
ISAModRMReader >> contents [
	^contents
]

{ #category : #private }
ISAModRMReader >> from: aStream [
	contents := aStream atEnd ifFalse: [ModRM new on: aStream next]
]

