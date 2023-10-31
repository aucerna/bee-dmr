"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OJumpFalse,
	#superclass : #OConditionalJump,
	#category : #IR
}

{ #category : #visitor }
OJumpFalse >> basicAcceptVisitor: aVisitor [
	^aVisitor visitJumpFalse: self
]

{ #category : #printing }
OJumpFalse >> basicPrintString [
	^'[jump false ' , variable primitivePrintString , ' to ' , target name
		, ' or fall to '
		, implicitTarget name
		, ']'
]

{ #category : #testing }
OJumpFalse >> isJumpFalse [
	^true
]

{ #category : #testing }
OJumpFalse >> isJumpTrue [
	^false
]

{ #category : #printing }
OJumpFalse >> primitivePrintString [
	^'{jump false}'
]

{ #category : #printing }
OJumpFalse >> printStringUsing: names [
	^'jump false ' , (names at: variable ifAbsent: ['?']) , ' to '
		, (names at: target ifAbsent: ['?'])
		, ' or fall to '
		, (names at: implicitTarget ifAbsent: ['?'])
]

