"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #TruncatedDistribution,
	#superclass : #ProbabilityDistribution,
	#instVars : [
		'deviate',
		'min',
		'max',
		'a',
		'b'
	],
	#category : #Distributions
}

{ #category : #private }
TruncatedDistribution class >> entireDistributionClass [
	self subclassResponsibility]

{ #category : #'instance creation' }
TruncatedDistribution class >> mean: mu
deviation: sigma
percent1: p
percent2: q [
	| lognormal a b |
	lognormal := self entireDistributionClass mean: mu deviation: sigma.
	lognormal isNil ifTrue: [^nil].
	a := lognormal percentile: p.
	b := lognormal percentile: q.
	^self mean: mu deviation: sigma min: a max: b]

{ #category : #'instance creation' }
TruncatedDistribution class >> sampleInstance [
	"
	TruncatedDistribution sampleInstance
	"
	| deviate |
	deviate := TriangularDistribution sampleInstance.
	^self
		with: deviate
		between: deviate left + deviate mid / 2.0
		and: deviate mid + deviate right / 2.0]

{ #category : #'instance creation' }
TruncatedDistribution class >> with: aProbabilityDistribution between: min and: max [
	| answer validation |
	answer := self new
		deviate: aProbabilityDistribution;
		min: min max: max.
	validation := aProbabilityDistribution
		runValidation: #validateTruncatedDistribution:
		with: answer.
	^validation hasPassed ifTrue: [answer]]

{ #category : #validation }
TruncatedDistribution >> addValidationSelectorsTo: aCollection [
	super addValidationSelectorsTo: aCollection.
	aCollection add: #truncatedValidation]

{ #category : #accessing }
TruncatedDistribution >> checkMinMax [
	| minA maxB |
	minA := min isNil ifTrue: [0.0] ifFalse: [deviate distribution: min].
	a = minA ifFalse: [a := minA].
	maxB := max isNil ifTrue: [1.0] ifFalse: [deviate distribution: max].
	b = maxB ifFalse: [b := maxB]]

{ #category : #services }
TruncatedDistribution >> convertValuesWith: aNumber [
	| u v |
	deviate convertValuesWith: aNumber.
	u := min notNil ifTrue: [min * aNumber].
	v := max notNil ifTrue: [max * aNumber].
	self min: u max: v]

{ #category : #'probability functions' }
TruncatedDistribution >> density: x [
	^(self isAdmissible: x)
		ifTrue: [(deviate density: x) / (b - a)]
		ifFalse: [0.0]]

{ #category : #accessing }
TruncatedDistribution >> deviate [
	^deviate]

{ #category : #accessing }
TruncatedDistribution >> deviate: probabilityDistribution [
	deviate := probabilityDistribution.
	uniform := probabilityDistribution uniform]

{ #category : #'probability functions' }
TruncatedDistribution >> distribution: x [
	(min notNil and: [x < min]) ifTrue: [^0.0].
	(max notNil and: [max <= x]) ifTrue: [^1.0].
	^(deviate distribution: x) - a / (b - a)]

{ #category : #'probability functions' }
TruncatedDistribution >> distributionLeft: x [
	(min notNil and: [x <= min]) ifTrue: [^0.0].
	(max notNil and: [max < x]) ifTrue: [^1.0].
	^(deviate distributionLeft: x) - a / (b - a)]

{ #category : #'file in/out' }
TruncatedDistribution >> fileInActivate [
	deviate fileInActivate.
	self checkMinMax]

{ #category : #'probability functions' }
TruncatedDistribution >> inverseDistribution: u [
	^deviate inverseDistribution: b - a * u + a]

{ #category : #testing }
TruncatedDistribution >> isAdmissible: x [
	^(min isNil or: [min <= x])
		and: [max isNil or: [x < max]]]

{ #category : #inquiries }
TruncatedDistribution >> isConsistentWith: deterministicValue [
	^deterministicValue isNumber and: [
		(self isConsistentWithBounds: deterministicValue)
			and: [self isConsistentWithMean: deterministicValue]]]

{ #category : #testing }
TruncatedDistribution >> isDiscrete [
	^deviate isDiscrete]

{ #category : #inquiries }
TruncatedDistribution >> isLike: aProbabilityDistribution [
	^(super isLike: aProbabilityDistribution)
		and: [self min = aProbabilityDistribution min]
		and: [self max = aProbabilityDistribution max]
		and: [self totalDistribution
			isLike: aProbabilityDistribution totalDistribution]]

{ #category : #accessing }
TruncatedDistribution >> max [
	| m |
	m := deviate max.
	max isNil ifTrue: [^m].
	m isNil ifTrue: [^max].
	^max min: m]

{ #category : #arithmetic }
TruncatedDistribution >> max: aNumber [
	self min: min max: aNumber]

{ #category : #estimators }
TruncatedDistribution >> mean [
	^self totalMean]

{ #category : #accessing }
TruncatedDistribution >> min [
	| m |
	m := deviate min.
	min isNil ifTrue: [^m].
	m isNil ifTrue: [^min].
	^min max: m]

{ #category : #accessing }
TruncatedDistribution >> min: aNumber [
	self min: aNumber max: max]

{ #category : #accessing }
TruncatedDistribution >> min: left max: right [
	min := left.
	max := right.
	a := min isNil ifTrue: [0.0] ifFalse: [deviate distributionLeft: min].
	b := max isNil ifTrue: [1.0] ifFalse: [deviate distribution: max]]

{ #category : #estimators }
TruncatedDistribution >> mu [
	^self totalMean]

{ #category : #estimators }
TruncatedDistribution >> mu: aNumber [
	deviate mu: aNumber]

{ #category : #'random sampling' }
TruncatedDistribution >> next [
	| x |
	[
		x := deviate next.
		self isAdmissible: x] whileFalse.
	^x]

{ #category : #printing }
TruncatedDistribution >> parameterArray [
	^deviate parameterArray , {self min. self max}]

{ #category : #printing }
TruncatedDistribution >> parameterArrayForDateDistribution: aDateDistribution [
	| output1 output2 |
	output1 := deviate parameterArrayForDateDistribution: aDateDistribution.
	output2 := {self min. self max}
		collect: [:v | aDateDistribution dateFrom: v].
	^output1 , output2]

{ #category : #printing }
TruncatedDistribution >> parameterArrayInUnit: unit [
	| v1 v2 |
	v1 := unit convert: self min.
	v2 := unit convert: self max.
	^(deviate parameterArrayInUnit: unit) , {v1. v2}]

{ #category : #accessing }
TruncatedDistribution >> parameters [
	| answer |
	answer := deviate parameters.
	answer
		at: 'Min' put: self min;
		at: 'Max' put: self max.
	^answer]

{ #category : #'probability functions' }
TruncatedDistribution >> percentile: p [
	^deviate percentile: b - a * p + a]

{ #category : #copying }
TruncatedDistribution >> postCopy [
	super postCopy.
	deviate := deviate copy]

{ #category : #estimators }
TruncatedDistribution >> sd [
	^self totalDeviation]

{ #category : #estimators }
TruncatedDistribution >> sigma [
	^self totalDeviation]

{ #category : #estimators }
TruncatedDistribution >> sigma: aNumber [
	deviate sigma: aNumber]

{ #category : #printing }
TruncatedDistribution >> storeString [
	^self class name , ' with: (' , deviate storeString , ') between: '
		, min storeString
		, ' and: '
		, max storeString]

{ #category : #accessing }
TruncatedDistribution >> totalDeviation [
	^self totalDistribution totalDeviation]

{ #category : #accessing }
TruncatedDistribution >> totalDistribution [
	^deviate]

{ #category : #accessing }
TruncatedDistribution >> totalMean [
	^self totalDistribution mean]

{ #category : #operations }
TruncatedDistribution >> translateBy: delta [
	| left right |
	deviate translateBy: delta.
	left := self min isNil ifFalse: [self min + delta].
	right := self max isNil ifFalse: [self max + delta].
	self min: left max: right]

{ #category : #accessing }
TruncatedDistribution >> uniform: aRandom [
	deviate uniform: aRandom.
	super uniform: aRandom]

{ #category : #testing }
TruncatedDistribution >> usesPert [
	^deviate usesPert]

{ #category : #validation }
TruncatedDistribution >> validateMax: aNumber [
	^self runValidation: #validateTruncatedMax: with: aNumber]

{ #category : #validation }
TruncatedDistribution >> validateMin: aNumber [
	^self runValidation: #validateTruncatedMin: with: aNumber]

