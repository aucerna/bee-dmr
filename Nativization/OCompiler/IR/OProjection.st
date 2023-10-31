"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OProjection,
	#superclass : #OInstruction,
	#instVars : [
		'input',
		'name',
		'register'
	],
	#category : #IR
}

{ #category : #'instance creation' }
OProjection class >> named: aSymbol [
	^self new name: aSymbol
]

{ #category : #'instance creation' }
OProjection class >> self [
	^self new name: #self
]

{ #category : #inquiries }
OProjection >> atOperand: operandName [
	(super atOperand: operandName) ifNotNil: [:op | ^op].
	^operandName == #input ifTrue: [input]
]

{ #category : #services }
OProjection >> atOperand: operandName put: instruction [
	(super atOperand: operandName put: instruction) ifNotNil: [^self].
	^operandName == #input ifTrue: [input := instruction]
]

{ #category : #visitor }
OProjection >> basicAcceptVisitor: aVisitor [
	^aVisitor visitProjection: self
]

{ #category : #printing }
OProjection >> basicPrintString [
	^self primitivePrintString
]

{ #category : #copying }
OProjection >> copyTo: copy with: map [
	super copyTo: copy with: map.
	copy
		input: (input duplicateWith: map);
		name: name;
		register: register
]

{ #category : #accessing }
OProjection >> input [
	^input
]

{ #category : #accessing }
OProjection >> input: anONode [
	input ifNotNil: [input removeUseBy: self].
	input := anONode.
	input addUse: self at: #input
]

{ #category : #testing }
OProjection >> isProjection [
	^true
]

{ #category : #testing }
OProjection >> isScheduled [
	^true
]

{ #category : #accessing }
OProjection >> name [
	^name
]

{ #category : #accessing }
OProjection >> name: aSymbol [
	name := aSymbol
]

{ #category : #enumerating }
OProjection >> operandsDo: aBlock [
	super operandsDo: aBlock.
	aBlock value: input
]

{ #category : #printing }
OProjection >> primitivePrintString [
	"
	^'<#' , source value printString , '>'
	"
	^'{projection #' , name printString , '}'
]

{ #category : #printing }
OProjection >> printStringUsing: names [
	^self primitivePrintString
]

{ #category : #accessing }
OProjection >> register [
	^register
]

{ #category : #accessing }
OProjection >> register: aRegister [
	register := aRegister.
	register isONode ifTrue: [self halt]
]

{ #category : #testing }
OProjection >> usesResultOf: anInstruction [
	^false
]

