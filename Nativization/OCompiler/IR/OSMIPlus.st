"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OSMIPlus,
	#superclass : #OSMIBinaryMath,
	#category : #IR
}

{ #category : #evaluating }
OSMIPlus >> evaluated [
	^(left value + right value) asMoveConstant
]

{ #category : #services }
OSMIPlus >> identityValue [
	^0
]

{ #category : #initialization }
OSMIPlus >> initialize [
	name := #_smiPlus:.
	super initialize
]

{ #category : #testing }
OSMIPlus >> isCommutative [
	^true
]

