"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OMoveConstant,
	#superclass : #OInstruction,
	#instVars : [
		'constant'
	],
	#category : #IR
}

{ #category : #'instance creation' }
OMoveConstant class >> valued: value [
	^self new value: value
]

{ #category : #visitor }
OMoveConstant >> basicAcceptVisitor: aVisitor [
	^aVisitor visitMoveConstant: self
]

{ #category : #printing }
OMoveConstant >> basicPrintString [
	^'[load cst ' , constant printString , ']'
]

{ #category : #testing }
OMoveConstant >> canHaveSideEffects [
	^false
]

{ #category : #copying }
OMoveConstant >> copyTo: copy with: map [
	super copyTo: copy with: map.
	copy value: constant
]

{ #category : #testing }
OMoveConstant >> isBoolean [
	^constant isBoolean
]

{ #category : #testing }
OMoveConstant >> isConstant [
	^true
]

{ #category : #copying }
OMoveConstant >> newCopy [
	^self class valued: constant
]

{ #category : #printing }
OMoveConstant >> primitivePrintString [
	^'{' , constant printString , '}'
]

{ #category : #printing }
OMoveConstant >> printStringUsing: names [
	^'load cst ' , constant printString
]

{ #category : #testing }
OMoveConstant >> usesResultOf: anInstruction [
	^false
]

{ #category : #accessing }
OMoveConstant >> value [
	^constant
]

{ #category : #accessing }
OMoveConstant >> value: value [
	constant := value
]

