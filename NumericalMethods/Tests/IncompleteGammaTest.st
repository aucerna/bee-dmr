"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #IncompleteGammaTest,
	#superclass : #TestCase,
	#category : #'NumericalMethods\Tests'
}

{ #category : #testing }
IncompleteGammaTest >> testIncompleteGamma [
	| gamma ratio |
	gamma := IncompleteGammaFunction a: 10.2.
	self
		assert: (gamma at: 0.3) ~ 0.34634830486357e-6;
		assert: (gamma complementaryAt: 0.3) ~ 570499.027840689;
		assert: (gamma at: 0.97) ~ 0.0298014573225;
		assert: (gamma complementaryAt: 0.97) ~ 570498.998039578;
		assert: (gamma at: 20) ~ 567147.63677382;
		assert: (gamma complementaryAt: 20) ~ 3351.39106721473;
		assert: (gamma at: 10.2) ~ 309013.959340303;
		assert: (gamma complementaryAt: 10.2) ~ 261485.068500732.
	gamma := IncompleteGammaFunction a: 0.3.
	self
		assert: (gamma at: 0.3) ~ 2.17474304481568;
		assert: (gamma complementaryAt: 0.3) ~ 0.81682594287191;
		assert: (gamma at: 0.4) ~ 2.32259606881224;
		assert: (gamma complementaryAt: 0.4) ~ 0.66897291887535;
		assert: (gamma at: 0.6) ~ 2.52252517008673;
		assert: (gamma complementaryAt: 0.6) ~ 0.46904381760086.
	ratio := IncompleteGammaFunction new trueGamma: 3.5 deltaRatio: 4.
	gamma := GammaFunction new.
	self assert: ratio ~ ((gamma valueAt: 3.5) / (gamma valueAt: 3.5 + 4))]

{ #category : #testing }
IncompleteGammaTest >> testIncompleteGammaDerivativeLargeNormalized [
	| gamma |
	gamma := IncompleteGammaFunction normalizedA: 5.
	self
		assert: (gamma derivativeAt: 4) ~ 0.19536681481316454;
		assert: (gamma derivativeAt: 6) ~ 0.13385261753998332.
	gamma := IncompleteGammaFunction normalizedA: 11.
	self
		assert: (gamma derivativeAt: 4) ~ 0.0052924766764201169;
		assert: (gamma derivativeAt: 12) ~ 0.10483725588365922.
	gamma := IncompleteGammaFunction new
		iterations: 1000;
		a: 1344;
		normalized: true.
	self
		assert: ((gamma derivativeAt: 1300) relativeDistanceTo: 0.0053869750896218)
			< 1.0e-11;
		assert: (gamma derivativeAt: 1344) ~ 0.010881368135493992;
		assert: (gamma derivativeAt: 1345) ~ 0.010869235537680596.
	gamma := IncompleteGammaFunction new
		iterations: 10000;
		a: 100000;
		normalized: true.
	self
		assert: (gamma derivativeAt: 100000 - 1) ~ 0.0012615715175816544;
		assert: ((gamma derivativeAt: 100000 + 2) - 0.0012615147488833015) abs
			< 1.0e-10;
		assert: (gamma derivativeAt: 0.8) ~ 0.0;
		assert: (gamma derivativeAt: 0.0) ~ 0.0.
	gamma := IncompleteGammaFunction normalizedA: 0.15.
	self
		assert: (gamma derivativeAt: 0.1) ~ 1.0298195089221558;
		assert: (gamma derivativeAt: 0.45) ~ 0.20208189672172322]

{ #category : #testing }
IncompleteGammaTest >> testIncompleteGammaLargeNormalized [
	| gamma |
	gamma := IncompleteGammaFunction normalizedA: 5.
	self
		assert: (gamma at: 4) ~ 0.37116306482012645;
		assert: (gamma at: 6) ~ 0.71494349968336901.
	gamma := IncompleteGammaFunction normalizedA: 11.
	self
		assert: (gamma at: 4) ~ 0.0028397661205137414;
		assert: (gamma at: 12) ~ 0.65277058244582831.
	gamma := IncompleteGammaFunction new
		iterations: 1000;
		a: 1344;
		normalized: true.
	self
		assert: (gamma at: 1346) / (gamma at: 1345) ~ 1.021107376441762;
		assert: (gamma at: 1345) / (gamma at: 1344) ~ 1.0215952802610597;
		assert: (gamma at: 1300) ~ 0.11421091415180867;
		assert: (gamma at: 1344) ~ 0.50362736258407836;
		assert: (gamma at: 1345) ~ 0.51450333662621983.
	gamma := IncompleteGammaFunction new
		iterations: 10000;
		a: 100000;
		normalized: true.
	self
		assert: (gamma at: 100000 - 1) ~ 0.49915895264904897;
		assert: (gamma at: 100000 + 2) ~ 0.502943610499067;
		assert: (gamma complementaryAt: 100000 - 1) ~ (1 - 0.49915895264904897);
		assert: (gamma at: 0.8) ~ 0.0;
		assert: (gamma at: 0.0) ~ 0.0;
		assert: (gamma complementaryAt: 0.0) ~ 1.0]

