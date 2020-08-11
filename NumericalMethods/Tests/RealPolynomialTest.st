"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RealPolynomialTest,
	#superclass : #TestCase,
	#instVars : [
		'x'
	],
	#category : #'NumericalMethods\Tests'
}

{ #category : #setup }
RealPolynomialTest >> setUp [
	super setUp.
	x := RealPolynomial x]

{ #category : #services }
RealPolynomialTest >> testBezout [
	| p q euclid |
	p := x * x - 1 * (x + 2) * (x + 2).
	q := p derivative.
	euclid := PolynomialEuclideanAlgorithm for: p and: q.
	self assert: euclid bezout1 * p + (euclid bezout2 * q) = euclid gcd]

{ #category : #arithmetic }
RealPolynomialTest >> testByMonomial [
	| polynomial mono product |
	polynomial := RealPolynomial withCoefficients: #(1 2 3 4 0).
	self assert: polynomial = (x * x * x * 4 + (x * x * 3) + (x * 2) + 1).
	mono := RealPolynomial monomial: 17 coefficient: -3.0.
	product := polynomial byMonomial: mono.
	self
		assert: product degree = (polynomial degree + mono degree);
		assert: product leadingCoefficient
			= (polynomial leadingCoefficient * mono leadingCoefficient)]

{ #category : #'instance creation' }
RealPolynomialTest >> testCreation [
	| polynomial |
	polynomial := RealPolynomial withCoefficients: #(1 2 3 4 0).
	self
		assert: polynomial degree = 3;
		assert: polynomial leadingCoefficient = 4.0]

{ #category : #services }
RealPolynomialTest >> testDerivative [
	| p |
	p := x * x * 3 + (x * 2) + 1.
	self
		assert: p derivative = (RealPolynomial withCoefficients: #(2 6));
		assert: RealPolynomial x derivative = (RealPolynomial constant: 1.0);
		assert: (RealPolynomial constant: 1.0) derivative isZero]

{ #category : #services }
RealPolynomialTest >> testDerivative2 [
	| p q |
	p := RealPolynomial withCoefficients: #(1 2 3).
	q := RealPolynomial withCoefficients: #(4 5 6).
	self
		assert: (p * q) derivative = (p derivative * q + (p * q derivative));
		assert: (p + q) derivative = (p derivative + q derivative);
		assert: (p * Number pi) derivative = (p derivative * Number pi)]

{ #category : #arithmetic }
RealPolynomialTest >> testDivision [
	| p q alg |
	p := x * 2 + 1.
	q := RealPolynomial x.
	alg := RealPolynomialDivisionAlgorithm divide: p by: q.
	self
		assert: alg quotient = (RealPolynomial constant: 2.0);
		assert: alg remainder = (RealPolynomial constant: 1.0)]

{ #category : #evaluation }
RealPolynomialTest >> testEvaluation [
	| zero unity u |
	zero := x - x.
	self assert: (zero valueAt: nil) = 0.0.
	unity := x + 1 - x.
	u := self random next.
	self
		assert: (unity valueAt: u) = 1.0;
		assert: (x valueAt: u) = u;
		assert: (x + 1 valueAt: u) = (u + 1);
		assert: (x * 2 + 3 valueAt: u) = (u * 2 + 3);
		assert: (x * x * 4 valueAt: u) = (u squared * 4);
		assert: (x * 5 valueAt: u) = (u * 5);
		assert: (x * x * 4 + (x * 5) valueAt: u) ~ (u squared * 4 + (u * 5));
		assert: (x * x * 4 + (x * 5) + 3 valueAt: u) ~ (u squared * 4 + (u * 5) + 3);
		assert: (x - 3 * (x - 4) valueAt: 3) = 0.0;
		assert: (x - 3 * (x - 4) valueAt: 4) = 0.0]

{ #category : #'instance creation' }
RealPolynomialTest >> testMonomial [
	| zero mono |
	zero := RealPolynomial monomial: -1 coefficient: 0.0.
	self assert: zero isZero.
	zero := RealPolynomial monomial: 17 coefficient: 0.0.
	self assert: zero isZero.
	mono := RealPolynomial monomial: 17 coefficient: -3.0.
	self assert: mono degree = 17; assert: mono leadingCoefficient = -3.0]

{ #category : #arithmetic }
RealPolynomialTest >> testMultiplication [
	self
		assert: x + 1 * (x + 1) = (x * x + (x * 2) + 1);
		assert: x + 1 * (x - 1) = (x * x - 1);
		assert: x * 1 = x;
		assert: (x * 0) isZero]

{ #category : #services }
RealPolynomialTest >> testOrder [
	| x2 x4 x5 p finder |
	x2 := x * x.
	x4 := x2 * x2.
	x5 := x4 * x.
	p := x5 - (x * 3) - 1.
	finder := PolynomialRootFinder on: p.
	self
		shouldnt: [finder solve]
		send: #refineRoot:
		moreThan: 1000
		timesTo: finder.
	self assert: finder roots copy sort = finder roots]

{ #category : #services }
RealPolynomialTest >> testRefine [
	| x2 x4 x5 p finder |
	x2 := x * x.
	x4 := x2 * x2.
	x5 := x4 * x.
	p := x5 - (x * 3) - 1.
	finder := PolynomialRootFinder on: p.
	self
		shouldnt: [finder solve]
		send: #refineRoot:
		moreThan: 1000
		timesTo: finder.
	self assert: finder error = 0.0]

{ #category : #services }
RealPolynomialTest >> testRefineRoot [
	| x2 x4 x5 p finder error |
	x2 := x * x.
	x4 := x2 * x2.
	x5 := x4 * x.
	p := x5 - (x * 3) - 1.
	finder := PolynomialRootFinder on: p.
	error := finder errorAt: 1.
	finder refineRoot: 1.
	self assert: (finder errorAt: 1) < error.
	finder refineRoot: 1 below: error / 1000000.
	self assert: (finder errorAt: 1) < (error / 1000000).
	self
		shouldnt: [finder refineRoot: 1 below: 0.0]
		send: #refineRoot:
		moreThan: 1000
		timesTo: finder]

{ #category : #services }
RealPolynomialTest >> testRootFinder [
	| x2 x4 x5 p finder |
	x2 := x * x.
	x4 := x2 * x2.
	x5 := x4 * x.
	p := x5 - (x * 3) - 1.
	finder := PolynomialRootFinder on: p.
	self assert: finder roots size = 3]

{ #category : #services }
RealPolynomialTest >> testSquareFree [
	| p |
	p := x * x - 1 * (x + 2).
	self
		assert: p isSquareFree;
		deny: (p * (x + 2)) isSquareFree;
		assert: (p * (x + 2) gcd: (p * (x + 2)) derivative) = (x + 2)]

{ #category : #services }
RealPolynomialTest >> testSquareFree2 [
	| p |
	p := x * x - 1 * (x + 2).
	self assert: p squareFree = p; assert: (p * (x + 2)) squareFree = p]

{ #category : #services }
RealPolynomialTest >> testSturm [
	| x2 x4 x5 p |
	x2 := x * x.
	x4 := x2 * x2.
	x5 := x4 * x.
	p := x5 - (x * 3) - 1.
	self
		assert: (p rootsBetween: -2 and: 2) = 3;
		assert: (p rootsBetween: -2 and: -1) = 1;
		assert: (p rootsBetween: -1 and: 1) = 1;
		assert: (p rootsBetween: 1 and: 2) = 1;
		assert: (PolynomialRootFinder on: p) numberOfRoots = 3]

{ #category : #'instance creation' }
RealPolynomialTest >> testUnity [
	| unity |
	unity := RealPolynomial unity.
	self
		assert: unity degree = 0;
		deny: unity isZero;
		assert: unity leadingCoefficient = 1.0]

{ #category : #'instance creation' }
RealPolynomialTest >> testZero [
	| zero |
	zero := RealPolynomial zero.
	self
		assert: zero degree = -1;
		assert: zero isZero;
		assert: zero leadingCoefficient isNil]

