"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #TruncatedLogNormalDistribution,
	#superclass : #TruncatedDistribution,
	#category : #Distributions
}

{ #category : #'instance creation' }
TruncatedLogNormalDistribution class >> around: aNumber [
	| mu |
	aNumber <= 0 ifTrue: [mu := 1.0] ifFalse: [mu := aNumber asFloat].
	^self
		mean: mu
		deviation: mu abs * 0.05
		min: mu * 0.75
		max: mu * 1.25]

{ #category : #'instance creation' }
TruncatedLogNormalDistribution class >> between: n and: m [
	| validation |
	validation := self
		runValidation: #validateTruncatedLogNormalBetween:and:
		with: n
		with: m.
	^validation hasPassed
		ifTrue: [(LogNormalDistribution between: n and: m)
			truncateFrom: (n max: 0)
			to: m]]

{ #category : #private }
TruncatedLogNormalDistribution class >> entireDistributionClass [
	^LogNormalDistribution]

{ #category : #examples }
TruncatedLogNormalDistribution class >> graph [
	"
	(TruncatedLogNormalDistribution mean: 2 deviation: 0.5 min: 3 max: 4) graph
	"
	| freq |
	freq := ((self sample: 500) collect: [:x |x roundTo: 0.1])  frequencies.
	Transcript contents: ''.
	freq keys asSortedCollection do: [:x |
		Transcript cr.
		Transcript show: x printString; tab.
		(freq at: x) timesRepeat: [Transcript show: '.']]

	]

{ #category : #'instance creation' }
TruncatedLogNormalDistribution class >> mean: mu
deviation: sigma
min: a
max: b [
	| validation |
	validation := self
		runValidation: #validateTruncatedLogNormalMean:deviation:min:max:
		withArguments: {mu. sigma. a. b}.
	^validation hasPassed
		ifTrue: [(LogNormalDistribution mean: mu deviation: sigma)
			truncateFrom: a
			to: b]]

{ #category : #examples }
TruncatedLogNormalDistribution class >> sampleInstance [
	^self around: 100.0]

{ #category : #validation }
TruncatedLogNormalDistribution >> addValidationSelectorsTo: aCollection [
	super addValidationSelectorsTo: aCollection.
	aCollection add: #truncatedLogNormalValidation]

{ #category : #printing }
TruncatedLogNormalDistribution >> graph [
	"
	(TruncatedLogNormalDistribution mean: 2 deviation: 1 min: 3 max: 4) graph
	"
	| freq |
	freq := ((self sample: 500) collect: [:x |x roundTo: 0.1]) asBag frequencies.
	Transcript contents: ''.
	freq keys asSortedCollection do: [:x |
		Transcript cr.
		Transcript show: x printString; tab.
		(freq at: x) timesRepeat: [Transcript show: '.']]

	]

{ #category : #testing }
TruncatedLogNormalDistribution >> isAdmissible: x [
	^(min isNil or: [min <= x])
		and: [max isNil or: [x < max]]]

{ #category : #inquiries }
TruncatedLogNormalDistribution >> isConsistentWithMean: deterministicValue [
	^deviate isConsistentWithMean: deterministicValue]

{ #category : #testing }
TruncatedLogNormalDistribution >> isConstant [
	^deviate isConstant or: [min notNil and: [max notNil] and: [min >= max]]]

{ #category : #inquiries }
TruncatedLogNormalDistribution >> isLike: aProbabilityDistribution [
	^self class == aProbabilityDistribution class]

{ #category : #testing }
TruncatedLogNormalDistribution >> isTruncatedLogNormal [
	^true]

{ #category : #printing }
TruncatedLogNormalDistribution >> storeString [
	^self class name , ' mean: ' , deviate mean storeString , ' deviation: '
		, deviate deviation storeString
		, ' min: '
		, min storeString
		, ' max: '
		, self max storeString]

{ #category : #validation }
TruncatedLogNormalDistribution >> validateDeviation: aFloat [
	^self
		runValidation: #validateLogNormalMean:deviation:
		with: self mu
		with: aFloat]

{ #category : #validation }
TruncatedLogNormalDistribution >> validateMean: aFloat [
	^self
		runValidation: #validateLogNormalMean:deviation:
		with: aFloat
		with: self sigma]

