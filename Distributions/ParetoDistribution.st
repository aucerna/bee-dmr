"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ParetoDistribution,
	#superclass : #ContinuousProbabilityDistribution,
	#instVars : [
		'min',
		'alpha'
	],
	#category : #Distributions
}

{ #category : #estimation }
ParetoDistribution class >> from: aCollection [
	| min alpha |
	min := aCollection min.
	alpha := self unbiasedAlphaEstimation: aCollection.
	^self min: min alpha: alpha]

{ #category : #private }
ParetoDistribution class >> maxLikelihoodFrom: aCollection [
	| min sum |
	min := aCollection min.
	sum := aCollection sum: [:x | (x / min) ln].
	^aCollection size asFloat / sum]

{ #category : #'instance creation' }
ParetoDistribution class >> min: min alpha: alpha [
	^self new min: min; alpha: alpha]

{ #category : #estimation }
ParetoDistribution class >> min: min percentile: p value: x [
	^self min: min alpha: (1.0 - p) ln / (min / x) ln]

{ #category : #estimation }
ParetoDistribution class >> percentile: p1
valued: x1
and: p2
valued: x2 [
	| x a alpha min |
	x := x2 / x1.
	a := 1 - p1 / (1 - p2).
	alpha := a ln / x ln.
	min := (1 - p1) ln / alpha + x1 ln.
	^self min: min exp alpha: alpha]

{ #category : #examples }
ParetoDistribution class >> sampleInstance [
	^self min: 1.0 alpha: 2.0]

{ #category : #private }
ParetoDistribution class >> unbiasedAlphaEstimation: aCollection [
	| n alpha bias |
	n := aCollection size.
	alpha := self maxLikelihoodFrom: aCollection.
	bias := n / (n - 1).
	^alpha * bias reciprocal]

{ #category : #accessing }
ParetoDistribution >> alpha [
	^alpha]

{ #category : #initialization }
ParetoDistribution >> alpha: aNumber [
	alpha := aNumber asFloat]

{ #category : #'probability functions' }
ParetoDistribution >> density: x [
	^x < min ifTrue: [0.0] ifFalse: [alpha * min / (x raisedTo: alpha + 1.0)]]

{ #category : #'probability functions' }
ParetoDistribution >> distribution: x [
	^x < min ifTrue: [0.0] ifFalse: [1.0 - (min / x raisedTo: alpha)]]

{ #category : #'random sampling' }
ParetoDistribution >> inverseDistribution: u [
	^min / (1.0 - u raisedTo: alpha reciprocal)]

{ #category : #logarithms }
ParetoDistribution >> ln [
	self ASSERT: min = 1.0.
	^ExponentialDistribution around: alpha reciprocal]

{ #category : #statistics }
ParetoDistribution >> mean [
	^alpha <= 1.0
		ifTrue: [Number infinity]
		ifFalse: [alpha * min / (alpha - 1.0)]]

{ #category : #statistics }
ParetoDistribution >> median [
	^min * (2.0 raisedTo: alpha reciprocal)]

{ #category : #accessing }
ParetoDistribution >> min [
	^min]

{ #category : #initialization }
ParetoDistribution >> min: aNumber [
	min := aNumber asFloat]

{ #category : #statistics }
ParetoDistribution >> mode [
	^min]

{ #category : #printing }
ParetoDistribution >> parameterArray [
	^{min. alpha}]

{ #category : #printing }
ParetoDistribution >> storeString [
	^self class name , ' min: ' , min storeString , ' alpha: '
		, alpha storeString]

{ #category : #statistics }
ParetoDistribution >> variance [
	alpha <= 1.0 ifTrue: [^nil].
	alpha <= 2.0 ifTrue: [^Number infinity].
	^(min / (alpha - 1.0)) squared * alpha / (alpha - 2.0)]

