"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PoissonDistribution,
	#superclass : #DiscreteProbabilityDistribution,
	#instVars : [
		'mu',
		'exp',
		'p0',
		'solver'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
PoissonDistribution class >> around: aNumber [
	^self mean: aNumber]

{ #category : #'instance creation' }
PoissonDistribution class >> mean: mu [
	"
	Average number of events per unit time interval.
	"
	| validation |
	validation := self runValidation: #validatePoissonMean: with: mu.
	^validation hasPassed ifTrue: [self new mean: mu]]

{ #category : #examples }
PoissonDistribution class >> sampleInstance [
	^ self around: 15]

{ #category : #examples }
PoissonDistribution class >> sampleSize [
	^ 2000]

{ #category : #validation }
PoissonDistribution >> addValidationSelectorsTo: aCollection [
	super addValidationSelectorsTo: aCollection.
	aCollection add: #poissonValidation]

{ #category : #'probability functions' }
PoissonDistribution >> density: x [
	| gamma |
	gamma := GammaFunction new valueAt: x + 1.
	^(mu raisedTo: x) * exp / gamma]

{ #category : #'probability functions' }
PoissonDistribution >> distribution: x [
	| gamma |
	gamma := GammaDistribution around: x + 1.
	^gamma reverseDistribution: mu]

{ #category : #printing }
PoissonDistribution >> explain [
	^'Number of events that will occur in the next second when the average rate is '
		, mu printString
		, ' events per second']

{ #category : #'probability functions' }
PoissonDistribution >> inverseDistribution: u [
	^solver evaluateAt: u]

{ #category : #inquiries }
PoissonDistribution >> isConsistentWith: deterministicValue [
	^deterministicValue isNumber and: [
		self min <~ deterministicValue
			and: [self isConsistentWithMean: deterministicValue]]]

{ #category : #testing }
PoissonDistribution >> isIntegerDistribution [
	^true]

{ #category : #inquiries }
PoissonDistribution >> isLike: aProbabilityDistribution [
	^(super isLike: aProbabilityDistribution)
		and: [self mean = aProbabilityDistribution mean]
		and: [(self density: 0) = (aProbabilityDistribution density: 0)]]

{ #category : #estimators }
PoissonDistribution >> kurtosis [
	"http://mathworld.wolfram.com/Kurtosis.html"
	^mu reciprocal]

{ #category : #estimators }
PoissonDistribution >> max [
	^nil]

{ #category : #estimators }
PoissonDistribution >> mean [
	^mu]

{ #category : #private }
PoissonDistribution >> mean: mean [
	mu := mean.
	exp := mu negated exp.
	p0 := self distribution: 0.
	solver := DiscreteDistributionInverseFinder on: self]

{ #category : #estimators }
PoissonDistribution >> min [
	^0]

{ #category : #'random sampling' }
PoissonDistribution >> next [
	| u k |
	u := uniform next.
	k := 0.
	exp = 0.0 ifTrue: [^0].
	[u < exp] whileFalse: [
		u := u * uniform next.
		k := k + 1].
	^k]

{ #category : #printing }
PoissonDistribution >> parameterArray [
	^{mu}]

{ #category : #printing }
PoissonDistribution >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		nextPutAll: '(';
		print: mu;
		nextPut: $)]

{ #category : #estimators }
PoissonDistribution >> skewness [
	"http://mathworld.wolfram.com/Skewness.html"
	^mu reciprocal sqrt]

{ #category : #printing }
PoissonDistribution >> storeString [
	^self class name , ' mean: ' , mu storeString]

{ #category : #estimators }
PoissonDistribution >> variance [
	^mu]

