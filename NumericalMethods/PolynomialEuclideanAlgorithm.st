"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PolynomialEuclideanAlgorithm,
	#superclass : #Object,
	#instVars : [
		'p',
		'q',
		's',
		't',
		'gcd'
	],
	#category : #NumericalMethods
}

{ #category : #'instance creation' }
PolynomialEuclideanAlgorithm class >> for: p and: q [
	^self new for: p and: q]

{ #category : #services }
PolynomialEuclideanAlgorithm class >> gcdOf: p and: q [
	| euclid |
	euclid := self for: p and: q.
	^euclid gcd]

{ #category : #references }
PolynomialEuclideanAlgorithm class >> references [
	ShellDLL current
		openWebPage: 'http://en.wikipedia.org/wiki/B%C3%A9zout%27s_identity']

{ #category : #outputs }
PolynomialEuclideanAlgorithm >> bezout1 [
	^s]

{ #category : #outputs }
PolynomialEuclideanAlgorithm >> bezout2 [
	^t]

{ #category : #computing }
PolynomialEuclideanAlgorithm >> compute [
	| div aa c bb quo rem swap lc |
	div := RealPolynomialDivisionAlgorithm new.
	s := RealPolynomial zero.
	aa := RealPolynomial unity.
	c := p.
	t := RealPolynomial unity.
	bb := RealPolynomial zero.
	gcd := q.
	[
		div divide: c by: gcd.
		quo := div quotient.
		rem := div remainder.
		rem isZero]
		whileFalse: [
			c := gcd.
			gcd := rem.
			swap := aa.
			aa := s.
			s := swap - (quo * s).
			swap := bb.
			bb := t.
			t := swap - (quo * t)].
	lc := gcd leadingCoefficient reciprocal.
	s *= lc.
	t *= lc.
	gcd beMonic]

{ #category : #inputs }
PolynomialEuclideanAlgorithm >> for: aPolynomial and: anotherPolynomial [
	p := aPolynomial.
	q := anotherPolynomial.
	self compute]

{ #category : #outputs }
PolynomialEuclideanAlgorithm >> gcd [
	^gcd]

