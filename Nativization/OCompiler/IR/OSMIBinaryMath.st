"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OSMIBinaryMath,
	#superclass : #OBinaryOperation,
	#category : #IR
}

{ #category : #evaluating }
OSMIBinaryMath >> evaluated [
	^self subclassResponsibility
]

{ #category : #services }
OSMIBinaryMath >> identityValue [
	^self subclassResponsibility
]

{ #category : #arithmetic }
OSMIBinaryMath >> inverted [
	^self commuted
]

{ #category : #testing }
OSMIBinaryMath >> isInvertible [
	^self isCommutative
]

{ #category : #services }
OSMIBinaryMath >> optimized [
	right isConstant ifFalse: [
		^(left isConstant and: [self isCommutative])
			ifTrue: [self commuted optimized]
			ifFalse: [self]].
	left isConstant ifTrue: [^self evaluated].
	right value = self identityValue ifTrue: [^left]
]

