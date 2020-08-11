"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #OptimizationMethodTest,
	#superclass : #TestCase,
	#category : #'NumericalMethods\Tests'
}

{ #category : #'interval halving' }
OptimizationMethodTest >> testIntervalHalving [
	| epsilon method expected |
	epsilon := 0.00001.
	expected := 1.
	method := IntervalHalving
		minOf: [:x | (x - 1) squared]
		from: 0
		to: 2
		precision: epsilon.
	method compute.
	self
		assert: (method min - expected) abs < epsilon;
		assert: method minValue < epsilon squared]

