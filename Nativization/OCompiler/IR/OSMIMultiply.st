"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OSMIMultiply,
	#superclass : #OSMIBinaryMath,
	#category : #IR
}

{ #category : #evaluating }
OSMIMultiply >> evaluated [
	^(left value * right value) asMoveConstant
]

{ #category : #services }
OSMIMultiply >> identityValue [
	^1
]

{ #category : #initialization }
OSMIMultiply >> initialize [
	name := #_smiMultiply:.
	super initialize
]

{ #category : #testing }
OSMIMultiply >> isCommutative [
	^true
]

{ #category : #services }
OSMIMultiply >> optimized [
	| value power |
	right isConstant ifFalse: [^super optimized].
	left isConstant ifTrue: [^self evaluated].
	value := right value.
	power := value powerOfTwo.
	^power
		ifNil: [super optimized]
		ifNotNil: [OSMIBitShift left: left right: power asMoveConstant]
]

