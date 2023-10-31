"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OJump,
	#superclass : #OInstruction,
	#instVars : [
		'target'
	],
	#category : #IR
}

{ #category : #'instance creation' }
OJump class >> to: aDestination [
	^self new target: aDestination
]

{ #category : #'adding / removing' }
OJump >> afterConnect: anInstruction [
	self _ASSERT: anInstruction isEnd.
	^super afterConnect: anInstruction
]

{ #category : #visitor }
OJump >> basicAcceptVisitor: aVisitor [
	^aVisitor visitJump: self
]

{ #category : #printing }
OJump >> basicPrintString [
	^'[jump to ' , target name , ']'
]

{ #category : #copying }
OJump >> copyTo: copy with: map [
	super copyTo: copy with: map.
	copy target: (target duplicateWith: map)
]

{ #category : #services }
OJump >> dissolve [
	target removePredecessor: self basicBlock.
	super dissolve
]

{ #category : #services }
OJump >> dissolveDeep [
	super dissolveDeep.
	target dissolveIfUnreachable
]

{ #category : #testing }
OJump >> isJump [
	^true
]

{ #category : #printing }
OJump >> primitivePrintString [
	^'{jump}'
]

{ #category : #printing }
OJump >> printStringUsing: names [
	^'jump to ' , (names at: target ifAbsent: ['?'])
]

{ #category : #services }
OJump >> retargetFrom: aBasicBlock to: otherBasicBlock [
	target := otherBasicBlock
]

{ #category : #enumerating }
OJump >> successorsDo: aBlock [
	aBlock value: target
]

{ #category : #accessing }
OJump >> target [
	^target
]

{ #category : #accessing }
OJump >> target: aBasicBlock [
	target := aBasicBlock
]

{ #category : #accessing }
OJump >> targets [
	^OrderedCollection with: target
]

{ #category : #testing }
OJump >> usesResultOf: anInstruction [
	^false
]

