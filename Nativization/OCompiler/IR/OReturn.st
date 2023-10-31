"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OReturn,
	#superclass : #OInstruction,
	#instVars : [
		'source',
		'frame'
	],
	#category : #IR
}

{ #category : #'adding / removing' }
OReturn >> addReturnValue: anONode from: anOBasicBlock [
	| block preds size phi |
	block := self basicBlock.
	preds := block predecessors.
	size := preds size.
	anOBasicBlock endWithJumpTo: block.
	size = 0 ifTrue: [^self source: anONode].
	size = 1
		ifTrue: [
			phi := OPhi new.
			block addFront: phi.
			phi addVariable: source from: preds first.
			source removeUse: self at: #source.
			self source: phi]
		ifFalse: [phi := source].
	phi addVariable: anONode from: anOBasicBlock
]

{ #category : #inquiries }
OReturn >> atOperand: name [
	(super atOperand: name) ifNotNil: [:op | ^op].
	^name == #source ifTrue: [source] ifFalse: [frame]
]

{ #category : #services }
OReturn >> atOperand: operandName put: instruction [
	(super atOperand: operandName put: instruction) ifNotNil: [^self].
	^operandName == #source
		ifTrue: [source := instruction]
		ifFalse: [frame := instruction]
]

{ #category : #visitor }
OReturn >> basicAcceptVisitor: aVisitor [
	^aVisitor visitReturn: self
]

{ #category : #printing }
OReturn >> basicPrintString [
	^String streamContents: [:strm | 
		strm
			nextPutAll: '[ret ';
			nextPutAll: source primitivePrintString;
			nextPut: $]]
]

{ #category : #copying }
OReturn >> copyTo: copy with: map [
	super copyTo: copy with: map.
	copy
		source: (source duplicateWith: map);
		frame: (frame duplicateWith: map)
]

{ #category : #accessing }
OReturn >> frame: anInstruction [
	frame := anInstruction.
	frame addUse: self at: #frame
]

{ #category : #testing }
OReturn >> isNonLocal [
	^false
]

{ #category : #testing }
OReturn >> isReturn [
	^true
]

{ #category : #enumerating }
OReturn >> operandsDo: aBlock [
	super operandsDo: aBlock.
	aBlock value: source; value: frame
]

{ #category : #printing }
OReturn >> primitivePrintString [
	^'{ret}'
]

{ #category : #printing }
OReturn >> printStringUsing: names [
	| s |
	s := names at: source ifAbsent: '?'.
	^'ret ' , s
]

{ #category : #accessing }
OReturn >> source [
	^source
]

{ #category : #accessing }
OReturn >> source: anInstruction [
	source := anInstruction.
	source addUse: self at: #source
]

{ #category : #testing }
OReturn >> usesResultOf: anInstruction [
	^source == anInstruction or: [frame == anInstruction]
]

