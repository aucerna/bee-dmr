"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #TruncatedNormalDistribution,
	#superclass : #TruncatedDistribution,
	#category : #Distributions
}

{ #category : #'instance creation' }
TruncatedNormalDistribution class >> around: aNumber [
	"
	TruncatedNormalDistribution around: 1
	"
	| mu min max swap |
	mu := aNumber asFloat.
	^mu = 0.0
		ifTrue: [
			self
				mean: mu
				deviation: 1.0
				min: -0.25
				max: 0.25]
		ifFalse: [
			min := mu * 0.75.
			max := mu * 1.25.
			max < min ifTrue: [
				swap := min.
				min := max.
				max := swap].
			self
				mean: mu
				deviation: mu abs * 0.05
				min: min
				max: max]]

{ #category : #'instance creation' }
TruncatedNormalDistribution class >> between: n and: m [
	| validation |
	validation := self
		runValidation: #validateTruncatedNormalBetween:and:
		with: n
		with: m.
	^validation hasPassed
		ifTrue: [(NormalDistribution between: n and: m) truncateFrom: (n max: 0) to: m]]

{ #category : #private }
TruncatedNormalDistribution class >> entireDistributionClass [
	^NormalDistribution]

{ #category : #'instance creation' }
TruncatedNormalDistribution class >> mean: mu
deviation: sigma
min: a
max: b [
	| validation |
	validation := self
		runValidation: #validateTruncatedNormalMean:deviation:min:max:
		withArguments: {mu. sigma. a. b}.
	^validation hasPassed
		ifTrue: [(NormalDistribution mean: mu deviation: sigma)
			truncateFrom: a
			to: b]]

{ #category : #examples }
TruncatedNormalDistribution class >> sampleInstance [
	^self around: 100.0]

{ #category : #'instance creation' }
TruncatedNormalDistribution class >> withPercentiles: p1
valued: x1
and: p2
valued: x2
min: min
max: max [
	| solver |
	solver := TruncatedNormalSolver
		x1: x1
		p1: p1
		x2: x2
		p2: p2
		min: min
		max: max
		steps: 100.
	solver run.
	^solver answer]

{ #category : #validation }
TruncatedNormalDistribution >> addValidationSelectorsTo: aCollection [
	super addValidationSelectorsTo: aCollection.
	aCollection add: #truncatedNormalValidation]

{ #category : #estimators }
TruncatedNormalDistribution >> deviation [
	"
	http://www.econ.umn.edu/~kortum/courses/fall02/lecture4k.pdf
	"
	| s mu sigma c d alpha beta |
	(a = b and: [min notNil]) ifTrue: [^0.0].
	s := deviate class standard.
	mu := deviate mean.
	sigma := deviate deviation.
	alpha := min isNil ifTrue: [0.0] ifFalse: [min - mu / sigma].
	beta := max isNil ifTrue: [0.0] ifFalse: [max - mu / sigma].
	c := min isNil ifTrue: [0.0] ifFalse: [s density: alpha].
	d := max isNil ifTrue: [0.0] ifFalse: [s density: beta].
	^sigma
		* (1.0 - (beta * d - (alpha * c) / (b - a)) - (d - c / (b - a)) squared) sqrt]

{ #category : #printing }
TruncatedNormalDistribution >> graph [
	"
	(TruncatedNormalDistribution mean: 1 deviation: 2 min: 3 max: 4) graph
	"
	| freq |
	freq := ((self sample: 500) collect: [:x |x roundTo: 0.1]) asBag frequencies.
	"Transcript contents: ''."
	freq keys asSortedCollection do: [:x |
		Transcript cr.
		Transcript show: x printString; tab.
		(freq at: x) timesRepeat: [Transcript show: '.']]

	]

{ #category : #comparing }
TruncatedNormalDistribution >> isLike: aProbabilityDistribution [
	^self class == aProbabilityDistribution class]

{ #category : #testing }
TruncatedNormalDistribution >> isTruncatedNormal [
	^true]

{ #category : #estimators }
TruncatedNormalDistribution >> mean [
	"
	http://www.econ.umn.edu/~kortum/courses/fall02/lecture4k.pdf
	"
	| s mu sigma c d |
	(a = b and: [min notNil]) ifTrue: [^min + max / 2.0].
	s := deviate class standard.
	mu := deviate mean.
	sigma := deviate deviation.
	c := min isNil ifTrue: [0.0] ifFalse: [s density: min - mu / sigma].
	d := max isNil ifTrue: [0.0] ifFalse: [s density: max - mu / sigma].
	^mu - (d - c / (b - a) * sigma)]

{ #category : #estimators }
TruncatedNormalDistribution >> mode [
	^deviate mode]

{ #category : #estimators }
TruncatedNormalDistribution >> sd [
	^self deviation]

{ #category : #printing }
TruncatedNormalDistribution >> storeString [
	^self class name , ' mean: ' , deviate mean storeString , ' deviation: '
		, deviate deviation storeString
		, ' min: '
		, min storeString
		, ' max: '
		, self max storeString]

{ #category : #validation }
TruncatedNormalDistribution >> validateDeviation: aFloat [
	^self
		runValidation: #validateNormalMean:deviation:
		with: self mu
		with: aFloat]

{ #category : #validation }
TruncatedNormalDistribution >> validateMean: aFloat [
	^self
		runValidation: #validateNormalMean:deviation:
		with: aFloat
		with: self sigma]

