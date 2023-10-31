"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OJumpTrue,
	#superclass : #OConditionalJump,
	#category : #IR
}

{ #category : #visitor }
OJumpTrue >> basicAcceptVisitor: aVisitor [
	^aVisitor visitJumpTrue: self
]

{ #category : #printing }
OJumpTrue >> basicPrintString [
	^'[jump true ' , variable primitivePrintString , ' to ' , target name
		, ' or fall to '
		, implicitTarget name
		, ']'
]

{ #category : #testing }
OJumpTrue >> isJumpFalse [
	^false
]

{ #category : #testing }
OJumpTrue >> isJumpTrue [
	^true
]

{ #category : #printing }
OJumpTrue >> primitivePrintString [
	^'{jump true}'
]

{ #category : #printing }
OJumpTrue >> printStringUsing: names [
	^'jump true ' , (names at: variable ifAbsent: ['?']) , ' to '
		, (names at: target ifAbsent: ['?'])
		, ' or fall to '
		, (names at: implicitTarget ifAbsent: ['?'])
]

