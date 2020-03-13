"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #ISASibReader,
	#superclass : #ISAInstructionPartReader,
	#category : #Tools
}

{ #category : #accessing }
ISASibReader >> contents [
	^contents
]

{ #category : #private }
ISASibReader >> from: aStream [
	contents := SIB new on: aStream next
]

