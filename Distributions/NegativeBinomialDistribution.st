"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #NegativeBinomialDistribution,
	#superclass : #DiscreteProbabilityDistribution,
	#instVars : [
		'p',
		'failures',
		'gamma',
		'poisson',
		'solver',
		'p0'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
NegativeBinomialDistribution class >> failures: r p: p [
	^self new failures: r p: p]

{ #category : #examples }
NegativeBinomialDistribution class >> sampleInstance [
	^NegativeBinomialDistribution failures: 5 p: 0.2]

{ #category : #'probability functions' }
NegativeBinomialDistribution >> density: k [
	| coefficient |
	k < 0 ifTrue: [^0].
	coefficient := k ~ 0
		ifTrue: [1]
		ifFalse: [(GammaFunction a: k b: failures) / k].
	^coefficient * (p raisedTo: k) * (1 - p raisedTo: failures)]

{ #category : #'probability functions' }
NegativeBinomialDistribution >> distribution: k [
	| beta |
	k < 0 ifTrue: [^0].
	beta := NormalizedIncompleteBetaFunction a: k + 1 b: failures.
	^1 - (beta valueAt: p)]

{ #category : #estimators }
NegativeBinomialDistribution >> explain [
	^'Number of successes needed to obtain ' , failures printString
		, ' failures when the probability of success is '
		, p printString]

{ #category : #accessing }
NegativeBinomialDistribution >> failures [
	^failures]

{ #category : #accessing }
NegativeBinomialDistribution >> failures: r p: probability [
	p := probability.
	failures := r.
	gamma := ScaledGammaDistribution shape: failures scale: p / (1 - p).
	poisson := PoissonDistribution mean: 1.
	solver := DiscreteDistributionInverseFinder on: self.
	p0 := self distribution: 0]

{ #category : #'probability functions' }
NegativeBinomialDistribution >> inverseDistribution: u [
	^solver evaluateAt: u]

{ #category : #estimators }
NegativeBinomialDistribution >> kurtosis [
	^6 / failures + self variance reciprocal]

{ #category : #estimators }
NegativeBinomialDistribution >> mean [
	^p * failures / (1 - p)]

{ #category : #estimators }
NegativeBinomialDistribution >> mode [
	^failures > 1 ifTrue: [(p * (failures - 1) / (1 - p)) floor] ifFalse: [0]]

{ #category : #'random sampling' }
NegativeBinomialDistribution >> next [
	poisson mean: gamma next.
	^poisson next]

{ #category : #accessing }
NegativeBinomialDistribution >> p [
	^p]

{ #category : #printing }
NegativeBinomialDistribution >> parameterArray [
	^{p. failures}]

{ #category : #printing }
NegativeBinomialDistribution >> printOn: aStream [
	aStream
		nextPutAll: 'NegativeBinomialDistribution failures: ';
		print: failures;
		nextPutAll: 'p: ';
		print: p]

{ #category : #converting }
NegativeBinomialDistribution >> storeString [
	^self class name , ' failures: ' , failures storeString , ' p: '
		, p storeString]

{ #category : #accessing }
NegativeBinomialDistribution >> uniform: aRandom [
	super uniform: aRandom.
	gamma uniform: aRandom.
	poisson uniform: aRandom]

{ #category : #estimators }
NegativeBinomialDistribution >> variance [
	^self mean / (1 - p)]

