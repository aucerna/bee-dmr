"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PolynomialCoolingDevice,
	#superclass : #CoolingDevice,
	#instVars : [
		'sum',
		'sum2',
		'delta',
		'f',
		'c',
		'epsilon',
		'f0',
		's',
		'm2',
		'stillCycles'
	],
	#category : #NumericalMethods
}

{ #category : #private }
PolynomialCoolingDevice >> computeF0 [
	f0 isNil ifTrue: [trials > 0 ifTrue: [f0 := sum / trials]]]

{ #category : #'heating / cooling' }
PolynomialCoolingDevice >> cool [
	| n sigma factor |
	f
		at: 1 put: f second;
		at: 2 put: f third;
		at: 3 put: f fourth;
		at: 4 put: sum / trials.
	c
		at: 1 put: c second;
		at: 2 put: c third;
		at: 3 put: c fourth;
		at: 4 put: temperature.
	n := trials + 1.
	sigma := (sum2 / n - (sum / n) squared) sqrt.
	factor := 1.0 + ((1.0 + delta) ln * temperature / (3.0 * sigma)).
	temperature := temperature / factor]

{ #category : #private }
PolynomialCoolingDevice >> derivative [
	| d1 d2 d3 |
	f first isNil ifTrue: [^nil].
	d1 := f second - f first / (c second - c first).
	d2 := f third - f second / (c third - c second).
	d3 := f fourth - f third / (c fourth - c third).
	^d1 + d2 + d3 / 3.0]

{ #category : #accessing }
PolynomialCoolingDevice >> distanceParameter [
	^delta]

{ #category : #inputs }
PolynomialCoolingDevice >> distanceParameter: aNumber [
	delta := aNumber asNumber]

{ #category : #initialization }
PolynomialCoolingDevice >> initialize [
	super initialize.
	delta := 3.
	f := Array new: 4.
	c := Array new: 4.
	epsilon := 0.01]

{ #category : #testing }
PolynomialCoolingDevice >> isFrozen [
	| d |
	solver relativeDistanceToGoal < 0.001 ifTrue: [^true].
	jumps = 0 ifTrue: [
		stillCycles := stillCycles + 1.
		stillCycles > 2 ifTrue: [^true]].
	d := self derivative.
	d isNil ifTrue: [
		self computeF0.
		^false].
	f0 = 0.0 ifTrue: [^true].
	^temperature / f0 * d < epsilon]

{ #category : #accessing }
PolynomialCoolingDevice >> justJumped [
	super justJumped.
	stillCycles := 0]

{ #category : #private }
PolynomialCoolingDevice >> reset [
	super reset.
	f0 := nil.
	stillCycles := 0]

{ #category : #testing }
PolynomialCoolingDevice >> shouldJump: increment [
	| cost accept |
	cost := solver cost + increment.
	sum := sum + cost.
	sum2 := sum2 + cost squared.
	accept := super shouldJump: increment.
	increment > 0 ifTrue: [
		s := s + cost.
		m2 := m2 + 1].
	^accept]

{ #category : #testing }
PolynomialCoolingDevice >> shouldTryAgain [
	^trials < solver neighborhoodSize sqrt]

{ #category : #'heating / cooling' }
PolynomialCoolingDevice >> startCycling [
	super startCycling.
	sum := sum2 := s := 0.0.
	m2 := 0.
	f := Array new: 4.
	c := Array new: 4]

{ #category : #accessing }
PolynomialCoolingDevice >> stopParameter [
	^epsilon]

{ #category : #inputs }
PolynomialCoolingDevice >> stopParameter: aNumber [
	epsilon := aNumber]

