Class {
	#name : #ISAInstructionPartReader,
	#superclass : #Object,
	#instVars : [
		'contents'
	],
	#category : #Tools
}

{ #category : #accessing }
ISAInstructionPartReader >> contents [
	^contents contents
]

{ #category : #private }
ISAInstructionPartReader >> from: aStream [
	contents := #[] writeStream
]

