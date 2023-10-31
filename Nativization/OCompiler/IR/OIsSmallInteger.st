"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OIsSmallInteger,
	#superclass : #OUnaryOperation,
	#category : #IR
}

{ #category : #initialization }
OIsSmallInteger >> initialize [
	name := #_isSmallInteger.
	super initialize
]

{ #category : #testing }
OIsSmallInteger >> isCheck [
	^true
]

{ #category : #services }
OIsSmallInteger >> optimized [
	^receiver isConstant
		ifTrue: [(receiver value class == SmallInteger) asMoveConstant]
		ifFalse: [self]
]

