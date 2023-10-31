"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OMemoryOperation,
	#superclass : #OPrimitiveOperation,
	#instVars : [
		'base',
		'index'
	],
	#category : #IR
}

{ #category : #accessing }
OMemoryOperation >> atOperand: operandName [
	(super atOperand: operandName) ifNotNil: [:op | ^op].
	operandName == #base ifTrue: [^base].
	^operandName == #index ifTrue: [index]
]

{ #category : #services }
OMemoryOperation >> atOperand: operandName put: instruction [
	(super atOperand: operandName put: instruction) ifNotNil: [^self].
	operandName == #base ifTrue: [^base := instruction].
	^operandName == #index ifTrue: [index := instruction]
]

{ #category : #accessing }
OMemoryOperation >> base [
	^base
]

{ #category : #accessing }
OMemoryOperation >> base: anInstruction [
	base ifNotNil: [base removeUse: self at: #base].
	base := anInstruction.
	anInstruction addUse: self at: #base
]

{ #category : #copying }
OMemoryOperation >> copyTo: copy with: map [
	| i |
	super copyTo: copy with: map.
	copy base: (base duplicateWith: map).
	index isONode
		ifTrue: [
			i := index duplicateWith: map.
			copy index: i]
		ifFalse: [copy indexImm: index]
]

{ #category : #accessing }
OMemoryOperation >> index [
	^index
]

{ #category : #accessing }
OMemoryOperation >> index: anInstruction [
	index := anInstruction.
	anInstruction addUse: self at: #index
]

{ #category : #accessing }
OMemoryOperation >> indexImm: anInteger [
	index := anInteger
]

{ #category : #testing }
OMemoryOperation >> isMemoryOperation [
	^true
]

{ #category : #enumerating }
OMemoryOperation >> operandsDo: aBlock [
	super operandsDo: aBlock.
	aBlock value: base.
	index isONode ifTrue: [aBlock value: index]
]

{ #category : #testing }
OMemoryOperation >> usesResultOf: anInstruction [
	^base == anInstruction or: [index == anInstruction]
]

