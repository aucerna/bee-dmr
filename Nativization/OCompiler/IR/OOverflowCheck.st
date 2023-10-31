"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OOverflowCheck,
	#superclass : #OUnaryOperation,
	#category : #IR
}

{ #category : #initialization }
OOverflowCheck >> initialize [
	name := #_overflowed.
	super initialize
]

{ #category : #testing }
OOverflowCheck >> isCheck [
	^true
]

{ #category : #metaprocessing }
OOverflowCheck >> optimized [
	^receiver isConstant ifTrue: [false asMoveConstant] ifFalse: [self]
]

