"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BernoulliDistribution,
	#superclass : #DiscreteProbabilityDistribution,
	#instVars : [
		'p',
		'success',
		'failure'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
BernoulliDistribution class >> around: aNumber [
	^self parameter: 0.5 success: aNumber failure: 0.0]

{ #category : #testing }
BernoulliDistribution class >> canSample: aCsrVariable [
	^aCsrVariable isBooleanValued]

{ #category : #'instance creation' }
BernoulliDistribution class >> defaultBooleanDistribution [
	^self parameter: 0.5 success: true failure: false]

{ #category : #examples }
BernoulliDistribution class >> example1 [
	"Cards"
	"
	self example1
	"
	^self parameter: 4 / 52

	"
	To be evaluated in the inspector
	| t |
	t := 1.
	[self next = 0]
		whileTrue: [t := t + 1].
	^ t
	"]

{ #category : #examples }
BernoulliDistribution class >> example2 [
	"Dice"
	"
	self example2
	"
	^self parameter: 1 / 2]

{ #category : #'instance creation' }
BernoulliDistribution class >> parameter: aNumber [
	^self parameter: aNumber success: 1 failure: 0]

{ #category : #'instance creation' }
BernoulliDistribution class >> parameter: aNumber success: anObject failure: otherObject [
	| validation |
	validation := self
		runValidation: #validateBernoulliParameter:
		with: aNumber.
	^validation hasPassed ifTrue: [
		self new
			parameter: aNumber;
			success: anObject;
			failure: otherObject]]

{ #category : #examples }
BernoulliDistribution class >> sampleInstance [
	^self parameter: 0.27]

{ #category : #examples }
BernoulliDistribution class >> sampleSize [
	^100]

{ #category : #'instance creation' }
BernoulliDistribution class >> with: p [
	^self parameter: p]

{ #category : #validation }
BernoulliDistribution >> addValidationSelectorsTo: aCollection [
	super addValidationSelectorsTo: aCollection.
	aCollection add: #bernoulliValidation]

{ #category : #converting }
BernoulliDistribution >> asJson [
	^super asJson
		at: 'P' put: p;
		at: 'Success' put: success;
		at: 'Failure' put: failure;
		yourself]

{ #category : #'probability functions' }
BernoulliDistribution >> density: quantity [
	quantity = success ifTrue: [^p].
	quantity = failure ifTrue: [^1 - p].
	self error: 'Cannot compute the density of ' , quantity printString]

{ #category : #'probability functions' }
BernoulliDistribution >> distribution: x [
	x = success ifTrue: [^p].
	x = failure ifTrue: [^1].
	self error: 'Cannot compute the distribution of ' , x printString]

{ #category : #printing }
BernoulliDistribution >> explain [
	^'Number of successes (1) and failures (0) when the probability of success is '
		, p printString]

{ #category : #accessing }
BernoulliDistribution >> failure [
	^failure]

{ #category : #accessing }
BernoulliDistribution >> failure: anObject [
	failure := anObject]

{ #category : #'file in/out' }
BernoulliDistribution >> fileInActivate [
	super fileInActivate.
	success isNil & failure isNil ifTrue: [
		success := 1.
		failure := 0]]

{ #category : #converting }
BernoulliDistribution >> fromJson: aJsonObject [
	self parameter: aJsonObject P]

{ #category : #initialization }
BernoulliDistribution >> initialize [
	super initialize.
	success := 1.
	failure := 0]

{ #category : #'probability functions' }
BernoulliDistribution >> inverseDistribution: u [
	^u <= p ifTrue: [success] ifFalse: [failure]]

{ #category : #testing }
BernoulliDistribution >> isBernoulli [
	^true]

{ #category : #testing }
BernoulliDistribution >> isBernoulliDistribution [
	^true]

{ #category : #inquiries }
BernoulliDistribution >> isConsistentWith: deterministicValue [
	^self isConsistentWithBounds: deterministicValue]

{ #category : #inquiries }
BernoulliDistribution >> isConsistentWithBounds: deterministicValue [
	^deterministicValue = failure or: [deterministicValue = success] or: [
		deterministicValue isNumber
			and: [super isConsistentWithBounds: deterministicValue]]]

{ #category : #testing }
BernoulliDistribution >> isFinite [
	^true]

{ #category : #testing }
BernoulliDistribution >> isIntegerDistribution [
	^true]

{ #category : #inquiries }
BernoulliDistribution >> isLike: aProbabilityDistribution [
	^(super isLike: aProbabilityDistribution)
		and: [self mean = aProbabilityDistribution mean]
		and: [success = aProbabilityDistribution success]
		and: [failure = aProbabilityDistribution failure]]

{ #category : #estimators }
BernoulliDistribution >> kurtosis [
	^(1 - p) reciprocal + p reciprocal - 6]

{ #category : #estimators }
BernoulliDistribution >> max [
	^1]

{ #category : #estimators }
BernoulliDistribution >> mean [
	^p]

{ #category : #accessing }
BernoulliDistribution >> mean: aNumber [
	p := aNumber]

{ #category : #estimators }
BernoulliDistribution >> min [
	^0]

{ #category : #estimators }
BernoulliDistribution >> mode [
	^p < 0.5 ifTrue: [failure] ifFalse: [success]]

{ #category : #accessing }
BernoulliDistribution >> mu [
	^self mean]

{ #category : #accessing }
BernoulliDistribution >> mu: aNumber [
	p := aNumber]

{ #category : #private }
BernoulliDistribution >> parameter: aNumber [
	p := aNumber asFloat]

{ #category : #printing }
BernoulliDistribution >> parameterArray [
	^{p. 1.0 - p}]

{ #category : #printing }
BernoulliDistribution >> parameterArrayInUnit: unit [
	^self parameterArray]

{ #category : #accessing }
BernoulliDistribution >> parameters [
	| answer |
	answer := Dictionary new.
	answer
		at: 'Mean' put: p;
		at: 'SD' put: self sd.
	^answer]

{ #category : #printing }
BernoulliDistribution >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		nextPutAll: '(';
		print: p;
		nextPut: $) ]

{ #category : #'probability functions' }
BernoulliDistribution >> quantile: u [
	| q |
	q := super quantile: u.
	^q = success ifTrue: [1] ifFalse: [0]]

{ #category : #estimators }
BernoulliDistribution >> skewness [
	"http://mathworld.wolfram.com/Skewness.html"
	^1 - (2 * p) / (1 - p * p) sqrt]

{ #category : #'random sampling' }
BernoulliDistribution >> statistics: n [
	^BooleanSampleStatistic on: (self sample: n)]

{ #category : #printing }
BernoulliDistribution >> storeString [
	^self class name , ' parameter: ' , p storeString
		, (success == 1 & (failure == 0)
			ifTrue: ['']
			ifFalse: [' success: ' , success printString , ' failure: '
				, failure printString])]

{ #category : #accessing }
BernoulliDistribution >> success [
	^success]

{ #category : #accessing }
BernoulliDistribution >> success: anObject [
	success := anObject]

{ #category : #validation }
BernoulliDistribution >> validateMean: aFloat [
	^self runValidation: #validateBernoulliParameter: with: aFloat]

{ #category : #accessing }
BernoulliDistribution >> values [
	^#(0 1)]

{ #category : #accessing }
BernoulliDistribution >> valuesSize [
	^2]

{ #category : #estimators }
BernoulliDistribution >> variance [
	^p * (1 - p)]

