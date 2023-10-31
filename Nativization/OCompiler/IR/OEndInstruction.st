"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OEndInstruction,
	#superclass : #OControlInstruction,
	#category : #IR
}

{ #category : #visitor }
OEndInstruction >> acceptVisitor: aVisitor [
	
]

{ #category : #'adding / removing' }
OEndInstruction >> addLast: anInstruction [
	prev next: anInstruction.
	anInstruction prev: prev.
	anInstruction next: self.
	prev := anInstruction
]

{ #category : #enumerating }
OEndInstruction >> detect: aBlock ifNone: absentBlock [
	^absentBlock value
]

{ #category : #enumerating }
OEndInstruction >> do: aBlock [
	
]

{ #category : #testing }
OEndInstruction >> hasNext [
	^false
]

{ #category : #testing }
OEndInstruction >> isEnd [
	^true
]

{ #category : #accessing }
OEndInstruction >> last [
	^prev
]

{ #category : #printing }
OEndInstruction >> printForwardOn: aStream [
	
]

{ #category : #printing }
OEndInstruction >> printForwardOn: aStream using: names [
	
]

{ #category : #printing }
OEndInstruction >> printOn: aStream [
	"
	prev printBackwardOn: aStream
	"
	
]

{ #category : #services }
OEndInstruction >> replace: one with: other [
	
]

{ #category : #enumerating }
OEndInstruction >> reverseDo: aBlock [
	prev reverseDo: aBlock
]

