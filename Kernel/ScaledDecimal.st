Class {
	#name : #ScaledDecimal,
	#superclass : #Fraction,
	#instVars : [
		'#scale'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
ScaledDecimal class >> fromNumber: aNumber scale: anInteger [
	| fraction |
]

{ #category : #'instance creation' }
ScaledDecimal class >> fromString: aString [
	| value i n num den |
]

{ #category : #'instance creation' }
ScaledDecimal class >> numerator: numerator denominator: denominator scale: scale [
	"
]

{ #category : #arithmetic }
ScaledDecimal >> - aNumber [
	^aNumber class == self class
]

{ #category : #arithmetic }
ScaledDecimal >> * aNumber [
	^aNumber class == self class
]

{ #category : #arithmetic }
ScaledDecimal >> / aNumber [
	^aNumber class == self class
]

{ #category : #arithmetic }
ScaledDecimal >> // aNumber [
	| q quo |
]

{ #category : #arithmetic }
ScaledDecimal >> + aNumber [
	^aNumber class == self class
]

{ #category : #comparing }
ScaledDecimal >> < aNumber [
	aNumber = 0 ifTrue: [^numerator < 0].
]

{ #category : #comparing }
ScaledDecimal >> <= aNumber [
	^self < aNumber or: [self = aNumber]
]

{ #category : #comparing }
ScaledDecimal >> = aNumber [
	self class == aNumber class ifTrue: [^self asFraction = aNumber asFraction].
]

{ #category : #comparing }
ScaledDecimal >> > aNumber [
	aNumber = 0 ifTrue: [^numerator > 0].
]

{ #category : #comparing }
ScaledDecimal >> >= aNumber [
	^self > aNumber or: [self = aNumber]
]

{ #category : #private }
ScaledDecimal >> addToScaledDecimal: aScaledDecimal [
	| s den fraction |
]

{ #category : #converting }
ScaledDecimal >> asFloat [
	^numerator asFloat / denominator
]

{ #category : #converting }
ScaledDecimal >> asFraction [
	^Fraction numerator: numerator denominator: denominator
]

{ #category : #private }
ScaledDecimal >> coerce: aNumber [
	^self class fromNumber: aNumber scale: scale
]

{ #category : #private }
ScaledDecimal >> divideIntoScaledDecimal: aScaledDecimal [
	| s fraction |
]

{ #category : #testing }
ScaledDecimal >> isFraction [
	^false
]

{ #category : #private }
ScaledDecimal >> multiplyScaledDecimal: aScaledDecimal [
	| s fraction |
]

{ #category : #arithmetic }
ScaledDecimal >> negated [
	^self class fromNumber: self asFraction negated scale: scale
]

{ #category : #printing }
ScaledDecimal >> printOn: aStream [
	| scaler scaled quo rem |
]

{ #category : #arithmetic }
ScaledDecimal >> raisedTo: aNumber [
	| fraction |
]

{ #category : #arithmetic }
ScaledDecimal >> raisedToInteger: aNumber [
	| fraction |
]

{ #category : #arithmetic }
ScaledDecimal >> reciprocal [
	^self class fromNumber: self asFraction reciprocal scale: scale
]

{ #category : #private }
ScaledDecimal >> reduced [
	| gcd |
]

{ #category : #private }
ScaledDecimal >> retry: selector with: argument [
	^argument isFloat
]

{ #category : #accessing }
ScaledDecimal >> scale [
	^scale
]

{ #category : #accessing }
ScaledDecimal >> scale: anInteger [
	scale := anInteger
]

{ #category : #private }
ScaledDecimal >> setNumerator: num denominator: den scale: s [
	den = 0 ifTrue: [^self zeroDivisorOn: #setNumerator:denominator:scale:].
]

{ #category : #arithmetic }
ScaledDecimal >> sqrt [
	| sqrt |
]

{ #category : #arithmetic }
ScaledDecimal >> squared [
	^super squared scale: scale
]

{ #category : #printing }
ScaledDecimal >> storeOn: aStream [
	(denominator = 1 or: [(10 raisedTo: scale) \\ denominator = 0])
]

{ #category : #private }
ScaledDecimal >> subtractFromScaledDecimal: aScaledDecimal [
	| s den fraction |
]
