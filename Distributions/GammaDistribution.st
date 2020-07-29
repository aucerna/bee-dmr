"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GammaDistribution,
	#superclass : #ContinuousProbabilityDistribution,
	#instVars : [
		'a',
		'exponential',
		'normal',
		'incomplete'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
GammaDistribution class >> around: aNumber [
	^self order: aNumber]

{ #category : #'instance creation' }
GammaDistribution class >> order: aNumber [
	^self shape: aNumber]

{ #category : #examples }
GammaDistribution class >> sampleInstance [
	^self around: 6]

{ #category : #'instance creation' }
GammaDistribution class >> shape: aNumber [
	| validation |
	self disableCode: [
		validation := self runValidation: #validateGammaShape: with: aNumber.
		^validation hasPassed ifTrue: [self new shape: aNumber]].
	^self new shape: aNumber]

{ #category : #validation }
GammaDistribution >> addValidationSelectorsTo: aCollection [
	super addValidationSelectorsTo: aCollection.
	aCollection add: #gammaValidation]

{ #category : #converting }
GammaDistribution >> asJson [
	^super asJson at: 'Shape' put: self shape; yourself]

{ #category : #'probability functions' }
GammaDistribution >> density: x [
	^x > 0.0 ifTrue: [incomplete derivativeAt: x] ifFalse: [0.0]]

{ #category : #'probability functions' }
GammaDistribution >> distribution: x [
	^x <= 0 ifTrue: [0] ifFalse: [incomplete at: x]]

{ #category : #printing }
GammaDistribution >> explain [
	| mu |
	mu := self mean.
	^'Number of seconds for the next ' , a printString
		, ' events when the average lapse between events is '
		, mu printString
		, ' second'
		pluralize: mu != 1]

{ #category : #converting }
GammaDistribution >> fromJson: aJsonObject [
	self shape: aJsonObject Shape]

{ #category : #initialization }
GammaDistribution >> initialize [
	super initialize.
	exponential := ExponentialDistribution parameter: 1.0.
	normal := NormalDistribution mean: 0.0 deviation: 1.0.
	self uniform: uniform]

{ #category : #'probability functions' }
GammaDistribution >> inverseDistribution: u [
	| f lower upper calculator |
	f := [:x | self distribution: x].
	lower := 0.
	upper := self mean.
	[(f value: upper) < u] whileTrue: [
		lower := upper.
		upper := upper > 1 ifTrue: [upper squared] ifFalse: [upper * 2]].
	calculator := InverseFunctionInterval
		on: f
		from: lower
		to: upper
		at: u.
	^calculator
		derivative: [:x | self density: x];
		tolerance: 0.000000000001;
		solve;
		inverse]

{ #category : #'probability functions' }
GammaDistribution >> inverseDistribution1: u [
	| f derivative xi |
	f := [:x | (self distribution: x) - u].
	derivative := [:x | self density: x].
	xi := self mean.
	[| delta |
		delta := (f value: xi) / (derivative value: xi).
		xi := xi - delta.
		delta abs > 0.00000000001] whileTrue.
	^xi]

{ #category : #inquiries }
GammaDistribution >> isLike: aProbabilityDistribution [
	^(super isLike: aProbabilityDistribution)
		and: [self shape = aProbabilityDistribution shape]]

{ #category : #estimators }
GammaDistribution >> kurtosis [
	"
	http://mathworld.wolfram.com/Kurtosis.html
	"
	^6.0 / a]

{ #category : #estimators }
GammaDistribution >> mean [
	^a]

{ #category : #'random sampling' }
GammaDistribution >> next [
	a < 1 ifTrue: [^self next1].
	a = 1 ifTrue: [^exponential next].
	^self next2]

{ #category : #'random sampling' }
GammaDistribution >> next1 [
	| c d x |
	c := 1.0 / a.
	d := (a raisedTo: a / (1.0 - a)) * (1.0 - a).
	[| z e |
		z := exponential next.
		e := exponential next.
		x := z raisedTo: c.
		z + e <= (d + x)] whileTrue.
	^x]

{ #category : #'random sampling' }
GammaDistribution >> next2 [
	| d v c |
	d := a - (1.0 / 3.0).
	c := 1.0 / (3.0 * d sqrt).
	[| x u |
		x := normal next.
		v := 1.0 + (c * x) raisedToInteger: 3.
		u := uniform next ln.
		v > 0.0 and: [u < (0.5 * x squared + d - (d * v) + (d * v ln))]] whileFalse.
	^d * v]

{ #category : #accessing }
GammaDistribution >> order [
	^self shape]

{ #category : #private }
GammaDistribution >> order: aNumber [
	self shape: aNumber]

{ #category : #printing }
GammaDistribution >> parameterArray [
	^{self shape}]

{ #category : #printing }
GammaDistribution >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		nextPutAll: '(';
		nextPut: $,;
		print: a;
		nextPut: $)]

{ #category : #'probability functions' }
GammaDistribution >> reverseDistribution: x [
	^incomplete complementaryAt: x]

{ #category : #accessing }
GammaDistribution >> shape [
	^a]

{ #category : #accessing }
GammaDistribution >> shape: aNumber [
	a := aNumber.
	incomplete := IncompleteGammaFunction normalizedA: a]

{ #category : #estimators }
GammaDistribution >> skewness [
	"
	http://mathworld.wolfram.com/Skewness.html
	"
	^2.0 / a sqrt]

{ #category : #printing }
GammaDistribution >> storeString [
	^self class name , ' shape: ' , self shape storeString]

{ #category : #accessing }
GammaDistribution >> uniform: random [
	super uniform: random.
	exponential uniform: uniform.
	normal uniform: uniform]

{ #category : #estimators }
GammaDistribution >> variance [
	^a]

