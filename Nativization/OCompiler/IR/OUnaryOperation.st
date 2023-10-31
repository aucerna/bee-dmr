"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OUnaryOperation,
	#superclass : #OPrimitiveOperation,
	#instVars : [
		'receiver'
	],
	#category : #IR
}

{ #category : #'instance creation' }
OUnaryOperation class >> receiver: receiver [
	^self new receiver: receiver
]

{ #category : #'instance creation' }
OUnaryOperation class >> receiver: receiver name: aString [
	^self new name: aString; receiver: receiver
]

{ #category : #inquiries }
OUnaryOperation >> atOperand: named [
	(super atOperand: named) ifNotNil: [:op | ^op].
	^receiver
]

{ #category : #services }
OUnaryOperation >> atOperand: operandName put: instruction [
	(super atOperand: operandName put: instruction) ifNotNil: [^self].
	^receiver := instruction
]

{ #category : #visitor }
OUnaryOperation >> basicAcceptVisitor: aVisitor [
	^aVisitor visitUnary: self
]

{ #category : #printing }
OUnaryOperation >> basicPrintString [
	^'['
		, (receiver isONode
			ifTrue: [receiver primitivePrintString]
			ifFalse: [receiver printString]) , ' ' , name , ']'
]

{ #category : #testing }
OUnaryOperation >> canHaveSideEffects [
	^name == #push or: [name == #pop]
]

{ #category : #copying }
OUnaryOperation >> copyTo: copy with: map [
	super copyTo: copy with: map.
	copy receiver: (receiver duplicateWith: map)
]

{ #category : #testing }
OUnaryOperation >> isBoolean [
	^name == #_isSmallInteger or: [name == #copy and: [receiver isBoolean]]
]

{ #category : #testing }
OUnaryOperation >> isUnaryOperation [
	^true
]

{ #category : #enumerating }
OUnaryOperation >> operandsDo: aBlock [
	super operandsDo: aBlock.
	aBlock value: receiver
]

{ #category : #printing }
OUnaryOperation >> printStringUsing: names [
	^(receiver isONode
		ifTrue: [names at: receiver ifAbsent: '?']
		ifFalse: [receiver printString]) , ' ' , name
]

{ #category : #accessing }
OUnaryOperation >> receiver [
	^receiver
]

{ #category : #accessing }
OUnaryOperation >> receiver: operation [
	receiver := operation.
	operation addUse: self at: #receiver
]

{ #category : #testing }
OUnaryOperation >> usesResultOf: anInstruction [
	^receiver == anInstruction
]

