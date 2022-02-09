"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OReturn,
	#superclass : #OInstruction,
	#instVars : [
		'source',
		'frame',
		'argumentsCount'
	],
	#category : #IR
}

{ #category : #unclassified }
OReturn >> argumentsCount [
	^argumentsCount
]

{ #category : #unclassified }
OReturn >> argumentsCount: anInteger [
	argumentsCount := anInteger
]

{ #category : #unclassified }
OReturn >> atOperand: name [
	^name == #source ifTrue: [source] ifFalse: [frame]
]

{ #category : #unclassified }
OReturn >> atOperand: name put: instruction [
	^name == #source
		ifTrue: [source := instruction]
		ifFalse: [frame := instruction]
]

{ #category : #unclassified }
OReturn >> basicAcceptVisitor: aVisitor [
	^aVisitor visitReturn: self
]

{ #category : #unclassified }
OReturn >> basicPrintString [
	^'[ret ' , source primitivePrintString , ']'
]

{ #category : #private }
OReturn >> doDuplicateWith: map [
	| copy |
	copy := super doDuplicateWith: map.
	copy
		argumentsCount: argumentsCount;
		source: (source duplicateWith: map);
		frame: (frame duplicateWith: map).
	^copy
]

{ #category : #unclassified }
OReturn >> frame: anInstruction [
	frame := anInstruction.
	frame addUse: self at: #frame
]

{ #category : #unclassified }
OReturn >> isReturn [
	^true
]

{ #category : #unclassified }
OReturn >> operandsDo: aBlock [
	aBlock value: source.
	aBlock value: frame
]

{ #category : #unclassified }
OReturn >> primitivePrintString [
	^'{ret}'
]

{ #category : #unclassified }
OReturn >> printStringUsing: names [
	^'ret ' , (names at: source ifAbsent: ['?']) , ''
]

{ #category : #unclassified }
OReturn >> source [
	^source
]

{ #category : #unclassified }
OReturn >> source: anInstruction [
	source := anInstruction.
	source addUse: self at: #source
]

{ #category : #unclassified }
OReturn >> usesResultOf: anInstruction [
	^source == anInstruction or: [frame == anInstruction]
]

