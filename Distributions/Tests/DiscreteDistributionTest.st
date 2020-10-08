"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #DiscreteDistributionTest,
	#superclass : #TestCase,
	#category : #'Distributions\Tests'
}

{ #category : #all }
DiscreteDistributionTest >> testCleanValuesProbabilities [
	| values probabilities array array2 indexes sum index validation |
	values := #(1.0 1.0 1.0 2.0 2.0 2.0 2.0 2.0 3.0 3.0 3.0 3.0 4.0 4.0 4.0 4.0 5.0 5.0 5.0 5.0).
	probabilities := #(0.05 0.05 0.05 0.05 0.05 0.05 0.05 0.05 0.02 0.02 0.02 0.02 0.08 0.08 0.08 0.08 0.05 0.05 0.05 0.05).
	array := DiscreteDistribution
		cleanValues: values
		probabilities: probabilities.
	self assert: array notNil.
	self assert: array first asSet size = array first size.
	self assert: array second sum = 1.0.
	array first do: [:v | 
		indexes := (1 to: values size) select: [:i | (values at: i) = v].
		sum := indexes sum: [:i | probabilities at: i].
		index := array first indexOf: v.
		self assert: (array second at: index) = sum].
	array2 := DiscreteDistribution
		cleanValues: array first
		probabilities: array second.
	self assert: array2 notNil.
	self assert: array2 first = array first.
	self assert: array2 second = array second.
	validation := DiscreteDistribution
		runValidation: #validateDiscreteDistribution:on:
		with: array second
		with: array first.
	self assert: validation hasPassed.
	validation := DiscreteDistribution
		runValidation: #validateDiscreteDistribution:on:
		with: probabilities
		with: values.
	self assert: validation hasPassed]

{ #category : #all }
DiscreteDistributionTest >> testCleanValuesProbabilities2 [
	| array |
	array := DiscreteDistribution
		cleanValues: #(2.0 3.0 1.0)
		probabilities: #(0.2 0.3 0.5).
	self assert: array notNil.
	self assert: array first = #(1.0 2.0 3.0).
	self assert: array second = #(0.5 0.2 0.3)]

{ #category : #all }
DiscreteDistributionTest >> testCopy [
	| values probabilities distribution copy |
	values := #(1.0 1.0 1.0 2.0 2.0 2.0 2.0 2.0 3.0 3.0 3.0 3.0 4.0 4.0 4.0 4.0 5.0 5.0 5.0 5.0).
	probabilities := #(0.05 0.05 0.05 0.05 0.05 0.05 0.05 0.05 0.02 0.02 0.02 0.02 0.08 0.08 0.08 0.08 0.05 0.05 0.05 0.05).
	distribution := DiscreteDistribution
		values: values
		probabilities: probabilities.
	copy := distribution copy.
	distribution
		probabilityAt: 1 put: 0.04;
		probabilityAt: 2 put: 0.06.
	self
		deny: (copy probabilityAt: 1 ifAbsent: nil) = 0.04;
		deny: (copy probabilityAt: 2 ifAbsent: nil) = 0.06]

{ #category : #all }
DiscreteDistributionTest >> testSameProbability [
	| discrete |
	discrete := DiscreteDistribution values: #(2 4 6).
	#(2 4 6) do: [:v | self assert: (discrete density: v) ~ (1 / 3)]]

{ #category : #parameters }
DiscreteDistributionTest >> testTP14597 [
	| d p |
	d := BernoulliDistribution parameter: 0.25.
	p := d parameters.
	self
		assert: (p at: 'SD') ~ d sd;
		assert: (p at: 'Mean') ~ d mean]

{ #category : #parameters }
DiscreteDistributionTest >> testTP7165 [
	| dd |
	dd := DiscreteDistribution between: 0.0 and: 6.0 steps: 1.
	self shouldnt: [dd parameters] raise: Error]

{ #category : #all }
DiscreteDistributionTest >> testTP8251 [
	| dd max |
	dd := DiscreteDistribution between: 0.0 and: 6.0 steps: 3.
	self shouldnt: [max := dd inverseDistribution: 1.0] raise: Error.
	self assert: max = 6.0]

{ #category : #all }
DiscreteDistributionTest >> testValidatePdfCollection [
	| validation |
	validation := DiscreteDistribution
		runValidation: #validateDiscreteDistribution:on:
		with: #(0.2 0.2 0.2)
		with: #(1.0 2.0 3.0).
	self deny: validation hasPassed.
	validation := DiscreteDistribution
		runValidation: #validateDiscreteDistribution:on:
		with: #(0.2 0.2 0.6)
		with: #(1.0 2.0 3.0).
	self assert: validation hasPassed.
	validation := DiscreteDistribution
		runValidation: #validateDiscreteDistribution:on:
		with: #(-10.0 0.2 10.8)
		with: #(1.0 2.0 3.0).
	self
		deny: validation hasPassed
		description: 'Values out of [0, 1] are not valid for probabilities']

