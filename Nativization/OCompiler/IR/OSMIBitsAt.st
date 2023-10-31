"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OSMIBitsAt,
	#superclass : #OSMIBinaryMath,
	#category : #IR
}

{ #category : #evaluating }
OSMIBitsAt >> evaluated [
	^(left value bitsAt: right value) asMoveConstant
]

{ #category : #services }
OSMIBitsAt >> identityValue [
	^nil
]

{ #category : #initialization }
OSMIBitsAt >> initialize [
	name := #_smiBitsAt:.
	super initialize
]

{ #category : #services }
OSMIBitsAt >> optimized [
	| stretch mask and cshift |
	right isConstant ifFalse: [^super optimized].
	left isConstant ifTrue: [^self evaluated].
	stretch := right value.
	mask := stretch mask asMoveConstant.
	and := OSMIBitAnd left: left right: mask.
	cshift := stretch shift asMoveConstant.
	^OSMIBitShift left: and right: cshift
]

