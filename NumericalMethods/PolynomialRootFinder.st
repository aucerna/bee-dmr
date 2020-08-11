"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PolynomialRootFinder,
	#superclass : #Object,
	#instVars : [
		'p',
		'sturm',
		'derivative',
		'roots',
		'bounds'
	],
	#category : #NumericalMethods
}

{ #category : #'instance creation' }
PolynomialRootFinder class >> for: aRealPolynomial [
	^self new polynomial: aRealPolynomial]

{ #category : #'instance creation' }
PolynomialRootFinder class >> on: aRealPolynomial [
	^self new on: aRealPolynomial]

{ #category : #private }
PolynomialRootFinder >> addInterval: aRealPolynomialInterval [
	roots add: aRealPolynomialInterval normalize]

{ #category : #inputs }
PolynomialRootFinder >> between: a and: b [
	| m min max |
	p isZero ifTrue: [^self].
	m := self bound.
	min := a max: m negated.
	max := b min: m.
	bounds := self intervalFrom: min to: max.
	self compute]

{ #category : #private }
PolynomialRootFinder >> bound [
	| m coefficients |
	m := 0.
	coefficients := p coefficients.
	1 to: coefficients size - 1 do: [:i | | ai |
		ai := coefficients at: i.
		ai := ai abs.
		m < ai ifTrue: [m := ai]].
	^m / coefficients last abs + 1.0]

{ #category : #computing }
PolynomialRootFinder >> compute [
	| intervals |
	intervals := OrderedCollection with: bounds.
	roots := OrderedCollection new: p degree.
	[
		intervals copy do: [:interval | | r |
			r := p rootsBetween: interval first and: interval last.
			intervals remove: interval.
			r > 1
				ifTrue: [intervals addAll: interval subintervals]
				ifFalse: [r = 1 ifTrue: [self addInterval: interval]]].
		intervals isEmpty] whileFalse.
	roots sortBy: [:a :b | | c d |
		c := a isNumber ifTrue: [a] ifFalse: [a first].
		d := b isNumber ifTrue: [b] ifFalse: [b first].
		c < d]]

{ #category : #outputs }
PolynomialRootFinder >> error [
	^(1 to: roots size) maxValue: [:i | self errorAt: i]]

{ #category : #outputs }
PolynomialRootFinder >> errorAt: i [
	| interval |
	interval := roots at: i.
	^interval error]

{ #category : #testing }
PolynomialRootFinder >> hasRoots [
	^roots notEmpty]

{ #category : #private }
PolynomialRootFinder >> intervalFrom: a to: b [
	| interval |
	interval := FunctionRootInterval on: p from: a to: b.
	interval derivative: derivative.
	^interval]

{ #category : #private }
PolynomialRootFinder >> numberOfRoots [
	| m |
	m := self bound.
	^p rootsBetween: m negated and: m]

{ #category : #inputs }
PolynomialRootFinder >> on: aRealPolynomial [
	self polynomial: aRealPolynomial; updateBounds; compute]

{ #category : #inputs }
PolynomialRootFinder >> polynomial: aRealPolynomial [
	p := aRealPolynomial.
	self updateSturm; updateDerivative]

{ #category : #computing }
PolynomialRootFinder >> refineBelow: epsilon [
	roots
		withIndexDo: [:interval :i | interval isNumber
			ifFalse: [self refineRoot: i below: epsilon]]]

{ #category : #computing }
PolynomialRootFinder >> refineRoot: i [
	| interval |
	interval := roots at: i.
	interval isNumber ifTrue: [^self].
	interval newtonRaphson]

{ #category : #computing }
PolynomialRootFinder >> refineRoot: i below: epsilon [
	| prev |
	prev := nil.
	[| interval error |
		interval := roots at: i.
		error := interval error.
		(prev notNil and: [prev = error]) ifTrue: [^self] ifFalse: [prev := error].
		error <= epsilon]
		whileFalse: [self refineRoot: i]]

{ #category : #outputs }
PolynomialRootFinder >> roots [
	^roots]

{ #category : #computing }
PolynomialRootFinder >> solve [
	^self refineBelow: 0.0]

{ #category : #private }
PolynomialRootFinder >> updateBounds [
	| m |
	m := self bound.
	bounds := FunctionRootInterval on: p from: m negated to: m.
	bounds derivative: derivative]

{ #category : #private }
PolynomialRootFinder >> updateDerivative [
	derivative := sturm first degree = p degree
		ifTrue: [sturm second]
		ifFalse: [p derivative]]

{ #category : #private }
PolynomialRootFinder >> updateSturm [
	sturm := p sturmChain]

