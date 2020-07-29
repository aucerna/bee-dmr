"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MultivariatedDistribution,
	#superclass : #ContinuousProbabilityDistribution,
	#category : #Distributions
}

{ #category : #inquiries }
MultivariatedDistribution >> isConsistentWith: anArray [
	| array |
	array := (anArray respondsTo: #asArray)
		ifTrue: [anArray asArray]
		ifFalse: [{anArray}].
	^self isConsistentWithMean: array]

{ #category : #inquiries }
MultivariatedDistribution >> isConsistentWithMean: anArray [
	"
	Knuth V1 1.2.10: p(|X - mu| < (r*sd)) < r reciprocal squared
	"
	| r mu sd i |
	r := 4.
	mu := self mean.
	sd := self sd.
	i := 0.
	^anArray conform: [:ai | | mi si |
		i := i + 1.
		mi := mu at: i.
		si := sd at: i.
		ai between: mi - (r * si) and: mi + (r * si)]]

