"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RealPolynomialDivisionAlgorithm,
	#superclass : #Object,
	#instVars : [
		'p',
		'q',
		'quotient',
		'remainder'
	],
	#category : #NumericalMethods
}

{ #category : #'instance creation' }
RealPolynomialDivisionAlgorithm class >> divide: p by: q [
	^self new divide: p by: q]

{ #category : #services }
RealPolynomialDivisionAlgorithm class >> quotientOf: p by: q [
	| algorithm |
	algorithm := self divide: p by: q.
	^algorithm quotient]

{ #category : #services }
RealPolynomialDivisionAlgorithm class >> remainderOf: p by: q [
	| algorithm |
	algorithm := self divide: p by: q.
	^algorithm remainder]

{ #category : #computing }
RealPolynomialDivisionAlgorithm >> compute [
	| n m bm an c d mono |
	remainder := p copy.
	quotient := RealPolynomial zero.
	q isZero ifTrue: [^self].
	m := q degree.
	bm := q leadingCoefficient.
	[
		n := remainder degree.
		n < m]
		whileFalse: [
			an := remainder leadingCoefficient.
			c := an / bm.
			d := n - m.
			mono := RealPolynomial monomial: d coefficient: c.
			remainder removeHead -= (q tail byMono: mono).
			quotient appendMonomial: mono]]

{ #category : #input }
RealPolynomialDivisionAlgorithm >> divide: aRealPolynomial by: anotherRealPolynomial [
	p := aRealPolynomial.
	q := anotherRealPolynomial.
	self compute]

{ #category : #outputs }
RealPolynomialDivisionAlgorithm >> quotient [
	^quotient]

{ #category : #outputs }
RealPolynomialDivisionAlgorithm >> remainder [
	^remainder]

