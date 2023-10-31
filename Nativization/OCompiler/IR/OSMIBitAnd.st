"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OSMIBitAnd,
	#superclass : #OSMIBinaryMath,
	#category : #IR
}

{ #category : #evaluating }
OSMIBitAnd >> evaluated [
	^(left value bitAnd: right value) asMoveConstant
]

{ #category : #services }
OSMIBitAnd >> identityValue [
	^-1
]

{ #category : #initialization }
OSMIBitAnd >> initialize [
	name := #_smiBitAnd:.
	super initialize
]

{ #category : #testing }
OSMIBitAnd >> isCommutative [
	^true
]

