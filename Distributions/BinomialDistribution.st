"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BinomialDistribution,
	#superclass : #BernoulliDistribution,
	#instVars : [
		'N'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
BinomialDistribution class >> events: n mean: m [
	| validation |
	validation := self
		runValidation: #validateBinomialEvents:mean:
		with: n
		with: m.
	^validation hasPassed ifTrue: [self new events: n mean: m]]

{ #category : #'instance creation' }
BinomialDistribution class >> events: n probability: p [
	^self events: n mean: n * p]

{ #category : #examples }
BinomialDistribution class >> example1 [
	"
	How many heads did I get in 5 trials?
	"
	"
	self example
	"
	| instance |
	instance := self events: 5 mean: 2.5.
	^{instance. instance next}]

{ #category : #examples }
BinomialDistribution class >> sampleInstance [
	^self events: 10 mean: 1]

{ #category : #examples }
BinomialDistribution class >> sampleSize [
	^500]

{ #category : #validation }
BinomialDistribution >> addValidationSelectorsTo: aCollection [
	super addValidationSelectorsTo: aCollection.
	aCollection add: #binomialValidation]

{ #category : #'probability functions' }
BinomialDistribution >> density: x [
	^(x between: 0 and: N)
		ifTrue: [(self take: x) * (p raisedTo: x) * (1 - p raisedTo: N - x)]
		ifFalse: [0.0]]

{ #category : #'probability functions' }
BinomialDistribution >> distribution: x [
	| incomplete |
	incomplete := NormalizedIncompleteBetaFunction a: N - x b: x + 1.
	^incomplete evaluateWith: 1.0 - p]

{ #category : #private }
BinomialDistribution >> events: n mean: m [
	N := n truncated.
	self parameter: m / N]

{ #category : #printing }
BinomialDistribution >> explain [
	^'Number of successes (1) and failures (0) in ' , N printString
		, ' tries when the probability of success is '
		, p printString]

{ #category : #'probability functions' }
BinomialDistribution >> inverseDistribution: x [
	"Not implemented yet"
	^super inverseDistribution: x]

{ #category : #testing }
BinomialDistribution >> isBernoulliDistribution [
	^false]

{ #category : #inquiries }
BinomialDistribution >> isConsistentWith: deterministicValue [
	^deterministicValue isNumber
		and: [self isConsistentWithBounds: deterministicValue]]

{ #category : #inquiries }
BinomialDistribution >> isLike: aProbabilityDistribution [
	^(super isLike: aProbabilityDistribution)
		and: [self max = aProbabilityDistribution max]]

{ #category : #estimators }
BinomialDistribution >> kurtosis [
	"http://mathworld.wolfram.com/Kurtosis.html"
	^6 * p squared - (6 * p) + 1 / (1 - p * N * p)]

{ #category : #estimators }
BinomialDistribution >> max [
	^N]

{ #category : #estimators }
BinomialDistribution >> mean [
	^p * N]

{ #category : #estimators }
BinomialDistribution >> min [
	^0]

{ #category : #'random sampling' }
BinomialDistribution >> next [
	| next |
	next := 0.
	N timesRepeat: [uniform next < p ifTrue: [next := next + 1]].
	^next]

{ #category : #printing }
BinomialDistribution >> parameterArray [
	^{N. p}]

{ #category : #printing }
BinomialDistribution >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		nextPutAll: '(';
		print: p;
		nextPut: $,;
		print: N;
		nextPut: $) ]

{ #category : #estimators }
BinomialDistribution >> skewness [
	"http://mathworld.wolfram.com/Skewness.html"
	^1 - (2 * p) / (1 - p * N * p) sqrt]

{ #category : #printing }
BinomialDistribution >> storeString [
	^self class name , ' events: ' , N storeString , ' probability: '
		, p storeString]

{ #category : #private }
BinomialDistribution >> take: kk [
	"
	(BinomialDistribution events: 6 mean: 2.5) take: 3
	"
	| num denom |
	kk < 0 ifTrue: [^0].
	kk > N ifTrue: [^0].
	num := 1.
	N to: (kk max: N - kk) + 1 by: -1 do: [:factor | num := num * factor].
	denom := 1.
	1 to: (kk min: N - kk) do: [:factor | denom := denom * factor].
	^num // denom]

{ #category : #estimators }
BinomialDistribution >> variance [
	^N * super variance]

