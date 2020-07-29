"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ContinuousProbabilityDistribution,
	#superclass : #ProbabilityDistribution,
	#category : #Distributions
}

{ #category : #converting }
ContinuousProbabilityDistribution >> asJson [
	^super asJson at: 'Continuous' put: true; yourself]

{ #category : #testing }
ContinuousProbabilityDistribution >> isDiscrete [
	^false]

{ #category : #inquiries }
ContinuousProbabilityDistribution >> p90P10Ratio [
	| p90 p10 |
	p90 := self percentile: 0.9.
	p10 := self percentile: 0.1.
	p10 ~ 0.0
		ifTrue: [^p90 positive
			ifTrue: [Float infinity]
			ifFalse: [Float minusInfinity]].
	^p90 / p10]

