"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BetaDistributionFinderTest,
	#superclass : #TestCase,
	#category : #'Distributions\Tests'
}

{ #category : #beta }
BetaDistributionFinderTest >> testTP32132 [
	"
	[BetaDistributionFinderTest new testTP32132] timeToRun
	"
	| a b original pLow pHigh selected |
	a := 10.
	b := 20.
	original := BetaDistribution a: a b: b.
	pLow := original distribution: 0.3.
	pHigh := original distribution: 0.6.
	selected := (BetaDistributionFinder
		x: 0.3
		p: pLow
		x: 0.6
		p: pHigh) find.
	self
		assert: (selected a - a) abs < 1;
		assert: (selected b - b) abs < 1;
		assert: ((selected distribution: 0.3) - pLow) abs < 0.1;
		assert: ((selected distribution: 0.6) - pHigh) abs < 0.1]

{ #category : #beta }
BetaDistributionFinderTest >> testTP32132Large [
	"
	[BetaDistributionFinderTest new testTP32132Large] timeToRun
	"
	| a b original pLow pHigh selected x1 x2 |
	a := 100.
	b := 200.
	original := BetaDistribution a: a b: b.
	x1 := 0.3.
	x2 := 0.4.
	pLow := original distribution: x1.
	pHigh := original distribution: x2.
	selected := (BetaDistributionFinder
		x: x1
		p: pLow
		x: x2
		p: pHigh) find.
	self
		assert: ((selected distribution: x1) - pLow) abs < 0.1;
		assert: ((selected distribution: x2) - pHigh) abs < 0.1]

