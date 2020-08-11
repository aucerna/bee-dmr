"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ContinuedFractionTest,
	#superclass : #TestCase,
	#category : #'NumericalMethods\Tests'
}

{ #category : #testing }
ContinuedFractionTest >> testGoldenRatio [
	| fraction |
	fraction := GoldenRatioContinuedFraction new
		epsilon: 0.0000000001;
		iterations: 10000.
	self assert: fraction value ~ 1.61803398875]

{ #category : #testing }
ContinuedFractionTest >> testPI [
	| fraction |
	fraction := PiContinuedFraction new epsilon: 0.00000001; iterations: 10000.
	self
		assert: (fraction value - 3.14) abs < 0.01;
		assert: fraction n > 10000]

