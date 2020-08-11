"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MetalogDistributionTest,
	#superclass : #TestCase,
	#category : #'NumericalMethods\Tests'
}

{ #category : #'testing estimators' }
MetalogDistributionTest >> testTP53239 [
	| random normal sample cdf distribution |
	random := self random.
	normal := NormalDistribution mean: 2 deviation: 0.5.
	normal uniform: random.
	sample := normal sample: 500.
	cdf := SampleSpace on: sample.
	distribution := MetalogDistribution on: cdf.
	distribution computeCoefficients: 15.
	0.1 to: 0.9 by: 0.1 do: [:p | | n d |
		n := normal inverseDistribution: p.
		d := distribution inverseDistribution: p.
		self assert: (d - n / n) abs < 0.05]]

{ #category : #'testing estimators' }
MetalogDistributionTest >> testTP53262 [
	| random normal sample cdf distribution |
	random := self random.
	normal := NormalDistribution mean: 2 deviation: 0.5.
	normal uniform: random.
	sample := normal sample: 500.
	cdf := SampleSpace on: sample.
	distribution := MetalogDistribution on: cdf.
	distribution computeCoefficients: 7.
	0.1 to: 0.9 by: 0.1 do: [:y | | x n d |
		x := normal inverseDistribution: y.
		n := normal density: x.
		d := distribution densityAtCum: y.
		self assert: (d - n / n) abs < 0.3]]

