"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OCompare,
	#superclass : #OBinaryOperation,
	#category : #IR
}

{ #category : #services }
OCompare >> identityValue [
	^true
]

{ #category : #services }
OCompare >> inverted [
	^self subclassResponsibility
]

{ #category : #testing }
OCompare >> isCheck [
	^true
]

{ #category : #testing }
OCompare >> isCommutative [
	^true
]

{ #category : #testing }
OCompare >> isComparison [
	^true
]

{ #category : #arithmetic }
OCompare >> negated [
	^self subclassResponsibility
]

{ #category : #services }
OCompare >> optimized [
	right isConstant ifFalse: [
		^left isConstant
			ifTrue: [
				self isCommutative
					ifTrue: [self commuted optimized]
					ifFalse: [self inverted optimized]]
			ifFalse: [self]].
	left isConstant ifTrue: [^self evaluate].
	right value == true ifTrue: [^left].
	(right value == false and: [left isComparison])
		ifTrue: [^left negated optimized]
]

