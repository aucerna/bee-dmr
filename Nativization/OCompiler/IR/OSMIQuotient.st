"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OSMIQuotient,
	#superclass : #OSMIBinaryMath,
	#category : #IR
}

{ #category : #evaluating }
OSMIQuotient >> evaluated [
	^(left value // right value) asMoveConstant
]

{ #category : #services }
OSMIQuotient >> identityValue [
	^1
]

{ #category : #initialization }
OSMIQuotient >> initialize [
	name := #_smiQuotient:.
	super initialize
]

{ #category : #services }
OSMIQuotient >> optimized [
	| value power |
	right isConstant ifFalse: [^super optimized].
	left isConstant ifTrue: [^self evaluated].
	value := right value.
	power := value powerOfTwo.
	^power
		ifNil: [super optimized]
		ifNotNil: [OSMIBitShift left: left right: power negated asMoveConstant]
]

