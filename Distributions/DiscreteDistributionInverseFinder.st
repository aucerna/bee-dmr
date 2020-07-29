"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #DiscreteDistributionInverseFinder,
	#superclass : #Object,
	#instVars : [
		'distribution'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
DiscreteDistributionInverseFinder class >> on: distribution [
	^self new on: distribution]

{ #category : #private }
DiscreteDistributionInverseFinder >> deltaAt: x from: p [
	^(distribution distribution: x) - p]

{ #category : #accessing }
DiscreteDistributionInverseFinder >> evaluateAt: p [
	| delta interval x0 x1 |
	delta := self deltaAt: 0 from: p.
	delta >~ 0 ifTrue: [^0].
	interval := self intervalFor: p.
	x0 := interval x.
	x1 := interval y.
	100 timesRepeat: [| distance mid |
		distance := x1 - x0.
		mid := x0 + (distance * 0.5) floor.
		delta := self deltaAt: mid from: p.
		delta < 0 ifTrue: [x0 := mid] ifFalse: [x1 := mid].
		distance = 1 ifTrue: [^x1]].
	^x1 halt]

{ #category : #private }
DiscreteDistributionInverseFinder >> intervalFor: p [
	| x0 x1 factor d0 d1 |
	x0 := 0.
	x1 := distribution mean ceiling.
	factor := 2.
	d0 := self deltaAt: x0 from: p.
	[
		d1 := self deltaAt: x1 from: p.
		d0 * d1 > 0]
		whileTrue: [| temp |
			temp := x1.
			x1 := x1 + (x1 - x0 * factor).
			x0 := temp.
			d0 := d1].
	^x0 @ x1]

{ #category : #accessing }
DiscreteDistributionInverseFinder >> on: aProbabilityDistribution [
	distribution := aProbabilityDistribution]

