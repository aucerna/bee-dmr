"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OBeginInstruction,
	#superclass : #OControlInstruction,
	#category : #IR
}

{ #category : #visitor }
OBeginInstruction >> basicAcceptVisitor: aVisitor [
	
]

{ #category : #enumerating }
OBeginInstruction >> detect: aBlock ifNone: absentBlock [
	^next detect: aBlock ifNone: absentBlock
]

{ #category : #enumerating }
OBeginInstruction >> do: aBlock [
	next do: aBlock
]

{ #category : #printing }
OBeginInstruction >> printBackwardOn: aStream [
	
]

{ #category : #printing }
OBeginInstruction >> printStringUsing: names [
	| stream |
	stream := '' writeStream.
	next printForwardOn: stream using: names.
	^stream contents
]

{ #category : #enumerating }
OBeginInstruction >> realReverseDo: aBlock [
	
]

{ #category : #enumerating }
OBeginInstruction >> reverseDo: aBlock [
	
]

