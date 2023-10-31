"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OSMIBitOr,
	#superclass : #OSMIBinaryMath,
	#category : #IR
}

{ #category : #evaluating }
OSMIBitOr >> evaluated [
	^(left value bitOr: right value) asMoveConstant
]

{ #category : #services }
OSMIBitOr >> identityValue [
	^0
]

{ #category : #initialization }
OSMIBitOr >> initialize [
	name := #_smiBitOr:.
	super initialize
]

{ #category : #testing }
OSMIBitOr >> isCommutative [
	^true
]

