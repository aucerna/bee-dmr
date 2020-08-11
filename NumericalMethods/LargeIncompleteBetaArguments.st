"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #LargeIncompleteBetaArguments,
	#superclass : #IncompleteBetaArguments,
	#category : #NumericalMethods
}

{ #category : #evaluating }
LargeIncompleteBetaArguments >> computedValueFor: aNormalizedIncompleteBetaFunction [
	self lambda < 0 ifTrue: [self swap].
	self hasVeryLargeB
		ifTrue: [^aNormalizedIncompleteBetaFunction fraction: self].
	self hasBothIntegers
		ifTrue: [^aNormalizedIncompleteBetaFunction usingBinomial: self].
	b * x <= 0.7 ifTrue: [^self series].
	self hasVeryLargeA
		ifTrue: [^aNormalizedIncompleteBetaFunction smallBLargeA: self].
	^aNormalizedIncompleteBetaFunction fraction: self]

{ #category : #accessing }
LargeIncompleteBetaArguments >> density [
	^self powerTerms / (x * y)]

{ #category : #accessing }
LargeIncompleteBetaArguments >> gammaFactor [
	| gamma sa sb sc |
	gamma := IncompleteGammaFunction new
		epsilon: epsilon;
		iterations: iterations.
	sa := gamma upperAndLowerSum: a limit: a + 5.
	sb := gamma upperAndLowerSum: b limit: b + 5.
	sc := gamma upperAndLowerSum: a + b limit: a + b + 5.
	^sc / (sa * sb)]

{ #category : #testing }
LargeIncompleteBetaArguments >> hasBothIntegers [
	^a floor = a and: [b floor = b]]

{ #category : #testing }
LargeIncompleteBetaArguments >> hasVeryLargeB [
	^b >= 40]

{ #category : #testing }
LargeIncompleteBetaArguments >> overflows: aFloat [
	^aFloat >= Float maxForExp or: [aFloat <= Float maxNegativeForExp]]

{ #category : #accessing }
LargeIncompleteBetaArguments >> powerTerms [
	| c la lb lc b1 b2 lb1 lb2 phi p1 p2 |
	c := a + b.
	la := a + 5.
	lb := b + 5.
	lc := c + 5.
	b1 := x * lc / la.
	b2 := y * lc / lb.
	lb1 := a * b1 ln.
	lb2 := b * b2 ln.
	phi := self gammaFactor.
	((self overflows: lb1) or: [self overflows: lb2])
		ifTrue: [^(lb1 + lb2 + 5) exp * phi].
	p1 := ((b1 - 1) abs * a < 10 and: [a > 1])
		ifTrue: [((x * b - (y * la) / la + 1) ln * a) exp]
		ifFalse: [b1 raisedTo: a].
	p2 := ((b2 - 1) abs * b < 10 and: [b > 1])
		ifTrue: [((y * a - (x * lb) / lb + 1) ln * b) exp]
		ifFalse: [b2 raisedTo: b].
	^p1 * p2 / -5.0 exp * phi]

