"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GammaFunction,
	#superclass : #Object,
	#classVars : [
		'C',
		'P'
	],
	#category : #NumericalMethods
}

{ #category : #'instance creation' }
GammaFunction class >> a: a b: b [
	^self new a: a b: b]

{ #category : #initialization }
GammaFunction class >> initialize [
	"
	GammaFunction initialize
	"
	super initialize.
	self initializeP]

{ #category : #initialization }
GammaFunction class >> initializeC [
	C := Array new: 8.
	C
		at: 1 put: 1.0 / 12.0;
		at: 2 put: -1.0 / 360.0;
		at: 3 put: 1.0 / 1260.0;
		at: 4 put: -1.0 / 1680.0;
		at: 5 put: 1.0 / 1188.0;
		at: 6 put: -691.0 / 360360.0;
		at: 7 put: 1.0 / 156.0;
		at: 8 put: -3617.0 / 122400.0]

{ #category : #initialization }
GammaFunction class >> initializeP [
	P := #(0.99999999999980993 676.5203681218851 -1259.1392167224028
		771.32342877765313 -176.61502916214059 12.507343278686905
		-0.13857109526572012 9.9843695780195716e-6 1.5056327351493116e-7)]

{ #category : #references }
GammaFunction class >> references [
	ShellDLL current
		openWebPage: 'http://en.wikipedia.org/wiki/Lanczos_approximation']

{ #category : #'instance creation' }
GammaFunction >> a: a b: b [
	| numerator denominator |
	a + b < 12.0 ifTrue: [
		numerator := self valueAt: a + b.
		denominator := (self valueAt: a) * (self valueAt: b).
		^numerator / denominator].
	numerator := self lnGamma: a + b.
	denominator := (self lnGamma: a) + (self lnGamma: b).
	^(numerator - denominator) exp]

{ #category : #evaluating }
GammaFunction >> evaluateWith: x [
	^self valueAt: x]

{ #category : #private }
GammaFunction >> lnGamma: x [
	| gamma z sum series pi2ln05 |
	x <= 0.0 ifTrue: [self error: 'argument must be positive'].
	x < 12.0 ifTrue: [
		gamma := self valueAt: x.
		^gamma abs ln].
	z := 1.0 / (x * x).
	sum := C at: 8.
	7 to: 1 by: -1 do: [:i | sum := sum * z + (C at: i)].
	series := sum / x.
	pi2ln05 := 0.91893853320467274178032973640562.
	^x - 0.5 * x ln - x + pi2ln05 + series]

{ #category : #evaluating }
GammaFunction >> valueAt: x [
	| pi gamma z v n t |
	pi := Number pi.
	x < 0.5 ifTrue: [
		gamma := self evaluateWith: 1.0 - x.
		^pi / (pi * x) sin / gamma].
	z := x - 1.
	v := P at: 1.
	n := P size.
	2 to: n do: [:i | | ci |
		ci := P at: i.
		v := ci / (z + i - 1) + v].
	t := z + n - 2.0 + 0.5.
	^(2.0 * pi) sqrt * (t raisedTo: z + 0.5) * t negated exp * v]

