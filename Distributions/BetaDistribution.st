"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BetaDistribution,
	#superclass : #ContinuousProbabilityDistribution,
	#instVars : [
		'a',
		'b',
		'incomplete'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
BetaDistribution class >> a: a b: b [
	| validation |
	validation := self runValidation: #validateBetaA:b: with: a with: b.
	^validation hasPassed ifTrue: [self new a: a b: b]]

{ #category : #'instance creation' }
BetaDistribution class >> around: aNumber [
	| p |
	p := aNumber = 0.0 ifTrue: [0.1] ifFalse: [aNumber].
	p = 1.0 ifTrue: [^self a: 0.9 b: 0.1].
	p := (p < 0.0 or: [p >= 1.0]) ifTrue: [0.5] ifFalse: [p].
	^self a: p b: 1.0 - p]

{ #category : #'instance creation' }
BetaDistribution class >> mean: mu deviation: sd [
	^self new mean: mu deviation: sd]

{ #category : #private }
BetaDistribution class >> percentile: p1
valued: x1
and: p2
valued: x2 [
	| finder |
	finder := BetaDistributionFinder
		x: x1
		p: p1
		x: x2
		p: p2.
	^finder find]

{ #category : #'instance creation' }
BetaDistribution class >> sampleInstance [
	^self a: 6 b: 7]

{ #category : #accessing }
BetaDistribution >> a [
	^a]

{ #category : #accessing }
BetaDistribution >> a: aNumber [
	a := aNumber]

{ #category : #accessing }
BetaDistribution >> a: aNumber b: anotherNumber [
	a := aNumber asFloat.
	b := anotherNumber asFloat.
	incomplete a: a b: b]

{ #category : #validation }
BetaDistribution >> addValidationSelectorsTo: aCollection [
	super addValidationSelectorsTo: aCollection.
	aCollection add: #betaValidation]

{ #category : #converting }
BetaDistribution >> asJson [
	^super asJson
		at: 'A' put: a;
		at: 'B' put: b;
		yourself]

{ #category : #converting }
BetaDistribution >> asPert [
	^PertDistribution min: self min max: self max mode: self mode]

{ #category : #accessing }
BetaDistribution >> b [
	^b]

{ #category : #accessing }
BetaDistribution >> b: aNumber [
	b := aNumber]

{ #category : #services }
BetaDistribution >> convertValuesWith: aNumber [
	"
	Do nothing, parameter units cannot change
	"
	]

{ #category : #'probability functions' }
BetaDistribution >> density: x [
	x <= 0.0 ifTrue: [^0.0].
	x < 1.0 ifTrue: [^incomplete density: x].
	^0.0]

{ #category : #'probability functions' }
BetaDistribution >> distribution: x [
	x < 0.0 ifTrue: [^0.0].
	x < 1.0 ifTrue: [^incomplete valueAt: x].
	^1.0]

{ #category : #estimators }
BetaDistribution >> excessKurtosis [
	| n d |
	n := a + b + 1.0 * (a - b) squared - (a + b + 2.0 * a * b) * 6.0.
	d := a + b + 2.0 * a * b * (a + b + 3.0).
	^n / d]

{ #category : #converting }
BetaDistribution >> fromJson: aJsonObject [
	self a: aJsonObject A b: aJsonObject B]

{ #category : #initialization }
BetaDistribution >> initialize [
	super initialize.
	self uniform: uniform.
	a := b := 0.5.
	incomplete := NormalizedIncompleteBetaFunction a: a b: b]

{ #category : #'probability functions' }
BetaDistribution >> inverseDistribution: y [
	| calculator |
	calculator := InverseFunctionInterval
		on: incomplete
		from: 0
		to: 1
		at: y.
	^calculator derivative: [:x | self density: x]; solve; inverse]

{ #category : #inquiries }
BetaDistribution >> isLike: aProbabilityDistribution [
	^(super isLike: aProbabilityDistribution)
		and: [a = aProbabilityDistribution a]
		and: [b = aProbabilityDistribution b]]

{ #category : #estimators }
BetaDistribution >> kurtosis [
	^self excessKurtosis + 3.0]

{ #category : #estimators }
BetaDistribution >> max [
	^b]

{ #category : #estimators }
BetaDistribution >> mean [
	^a / (a + b)]

{ #category : #accessing }
BetaDistribution >> mean: mu deviation: sd [
	(mu <= 0 or: [1.0 <= mu]) ifTrue: [^nil].
	sd <= 0.01 ifTrue: [^nil].
	a := 1.0 - mu * mu squared / sd squared - mu.
	b := 1.0 - mu / mu * a.
	self a: a b: b]

{ #category : #estimators }
BetaDistribution >> min [
	^a]

{ #category : #estimators }
BetaDistribution >> mode [
	(a <= 1.0 or: [b <= 1.0]) ifTrue: [^super mode].
	^a - 1.0 / (a + b - 2.0)]

{ #category : #printing }
BetaDistribution >> parameterArray [
	^{a. b}]

{ #category : #printing }
BetaDistribution >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		nextPutAll: ' a: ';
		nextPutAll: a printString;
		nextPutAll: ' b: ';
		nextPutAll: b printString]

{ #category : #'probability functions' }
BetaDistribution >> reverseDistribution: x [
	x < 0.0 ifTrue: [^1.0].
	x < 1.0 ifTrue: [^incomplete complementaryAt: x].
	^0.0]

{ #category : #estimators }
BetaDistribution >> skewness [
	^b - a * 2 * (a + b + 1) sqrt / (a + b + 2 * (a * b) sqrt)]

{ #category : #printing }
BetaDistribution >> storeString [
	^self class name , ' a: ' , a storeString , ' b: ' , b storeString]

{ #category : #operations }
BetaDistribution >> translateBy: delta [
	^self]

{ #category : #estimators }
BetaDistribution >> variance [
	^a * b / (a + b + 1.0 * (a + b) squared)]

