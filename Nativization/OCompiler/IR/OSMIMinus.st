"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OSMIMinus,
	#superclass : #OSMIBinaryMath,
	#category : #IR
}

{ #category : #evaluating }
OSMIMinus >> evaluated [
	^(left value - right value) asMoveConstant
]

{ #category : #services }
OSMIMinus >> identityValue [
	^0
]

{ #category : #initialization }
OSMIMinus >> initialize [
	name := #_smiMinus:.
	super initialize
]

{ #category : #testing }
OSMIMinus >> isInvertible [
	"
	maybe we can change this one to true (would require implementing inverted
      to convert `a - b` into `b negated + a`)
	"
	^false
]

