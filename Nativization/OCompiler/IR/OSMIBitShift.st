"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OSMIBitShift,
	#superclass : #OSMIBinaryMath,
	#category : #IR
}

{ #category : #evaluating }
OSMIBitShift >> evaluated [
	^(left value bitShift: right value) asMoveConstant
]

{ #category : #services }
OSMIBitShift >> identityValue [
	^0
]

{ #category : #initialization }
OSMIBitShift >> initialize [
	name := #_smiBitShift:.
	super initialize
]

