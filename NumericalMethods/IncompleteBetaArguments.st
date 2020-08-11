"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #IncompleteBetaArguments,
	#superclass : #Object,
	#instVars : [
		'a',
		'b',
		'x',
		'y',
		'invert',
		'epsilon',
		'iterations'
	],
	#category : #NumericalMethods
}

{ #category : #'instance creation' }
IncompleteBetaArguments class >> a: a b: b x: x [
	^self
		a: a
		b: b
		x: x
		invert: false]

{ #category : #'instance creation' }
IncompleteBetaArguments class >> a: a
b: b
x: x
invert: invert [
	| class |
	class := self classForA: a b: b x: x.
	^class new
		a: a;
		b: b;
		x: x;
		invert: invert]

{ #category : #private }
IncompleteBetaArguments class >> classForA: a b: b x: x [
	1 - x * x ~ 0.0 ifTrue: [^IncompleteBetaArguments].
	(a min: b) > 1 ifTrue: [^LargeIncompleteBetaArguments].
	(a = 1 or: [b = 1]) ifTrue: [^IncompleteBetaArguments].
	(a max: b) <= 1 ifTrue: [^SmallIncompleteBetaArguments].
	^IncompleteBetaArguments]

{ #category : #'instance creation' }
IncompleteBetaArguments class >> new [
	^super new initialize]

{ #category : #accessing }
IncompleteBetaArguments >> a [
	^a]

{ #category : #accessing }
IncompleteBetaArguments >> a: aNumber [
	a := aNumber]

{ #category : #accessing }
IncompleteBetaArguments >> b [
	^b]

{ #category : #accessing }
IncompleteBetaArguments >> b: aNumber [
	b := aNumber]

{ #category : #evaluating }
IncompleteBetaArguments >> computedValueFor: aNormalizedIncompleteBetaFunction [
	| n |
	b = 1 ifTrue: [^self regularizedValue].
	x > 0.5 ifTrue: [self swap].
	b <= 1 ifTrue: [^self series].
	(x < 0.1 and: [(b * x raisedTo: a) <= 0.7]) ifTrue: [^self series].
	self swap.
	y >= 0.3 ifTrue: [^self series].
	n := self hasVeryLargeA ifTrue: [0] ifFalse: [20].
	^aNormalizedIncompleteBetaFunction smallB: self steps: n]

{ #category : #accessing }
IncompleteBetaArguments >> density [
	| g |
	g := GammaFunction a: a b: b.
	^g * (x raisedTo: a - 1) * (y raisedTo: b - 1)]

{ #category : #accessing }
IncompleteBetaArguments >> effectiveX [
	^invert ifTrue: [y] ifFalse: [x]]

{ #category : #accessing }
IncompleteBetaArguments >> epsilon [
	^epsilon]

{ #category : #accessing }
IncompleteBetaArguments >> epsilon: aNumber [
	epsilon := aNumber asFloat]

{ #category : #testing }
IncompleteBetaArguments >> hasBothSmall [
	^1 >= (a max: b)]

{ #category : #testing }
IncompleteBetaArguments >> hasVeryLargeA [
	^a >= 15]

{ #category : #initialization }
IncompleteBetaArguments >> initialize [
	super initialize.
	epsilon := 1.0e-10.
	iterations := 100]

{ #category : #accessing }
IncompleteBetaArguments >> invert [
	^invert]

{ #category : #accessing }
IncompleteBetaArguments >> invert: aBoolean [
	invert := aBoolean]

{ #category : #testing }
IncompleteBetaArguments >> isArcSin [
	^a = 0.5 and: [b = 0.5]]

{ #category : #testing }
IncompleteBetaArguments >> isExtreme [
	^x * y ~ 0 or: [1 - x * (1 - y) ~ 0]]

{ #category : #testing }
IncompleteBetaArguments >> isUniform [
	^a = 1 and: [b = 1]]

{ #category : #accessing }
IncompleteBetaArguments >> iterations [
	^iterations]

{ #category : #accessing }
IncompleteBetaArguments >> iterations: anInteger [
	iterations := anInteger]

{ #category : #accessing }
IncompleteBetaArguments >> lambda [
	self disableCode: [^a * y - (b * x)].
	^a < b ifTrue: [a - (a + b * x)] ifFalse: [a + b * y - b]]

{ #category : #accessing }
IncompleteBetaArguments >> powerTerms [
	| g |
	g := GammaFunction a: a b: b.
	^g * (x raisedTo: a) * (y raisedTo: b)]

{ #category : #evaluating }
IncompleteBetaArguments >> regularizedValue [
	"
	http://functions.wolfram.com/GammaBetaErf/BetaRegularized/03/01/01/
	"
	^y < 0.5 ifTrue: [((1.0 - y) ln * a) exp] ifFalse: [x raisedTo: a]]

{ #category : #evaluating }
IncompleteBetaArguments >> series [
	| gamma mult a0 series |
	gamma := GammaFunction a: a b: b.
	mult := gamma * (x raisedTo: a).
	a0 := invert ifTrue: [-1] ifFalse: [0].
	series := IncompleteBetaSeries arguments: self mult: mult initialValue: a0.
	^invert
		ifTrue: [
			invert := false.
			series value negated]
		ifFalse: [series value]]

{ #category : #evaluating }
IncompleteBetaArguments >> steps: k [
	| terms prefix term sum |
	k = 0 ifTrue: [^0].
	terms := self powerTerms.
	prefix := terms / a.
	prefix = 0 ifTrue: [^prefix].
	sum := term := 1.
	(1 to: k - 1) do: [:i | | j |
		j := i - 1.
		term := a + b + j * x / (a + j + 1) * term.
		sum := sum + term].
	^prefix * sum]

{ #category : #actions }
IncompleteBetaArguments >> swap [
	| swap |
	swap := b.
	b := a.
	a := swap.
	self x: y.
	invert := invert not]

{ #category : #evaluating }
IncompleteBetaArguments >> valueFor: aNormalizedIncompleteBetaFunction [
	| computed |
	self isUniform
		ifTrue: [^aNormalizedIncompleteBetaFunction
			uniformDistributionAt: self effectiveX].
	self isExtreme
		ifTrue: [^aNormalizedIncompleteBetaFunction
			extremeDistributionAt: self effectiveX].
	self isArcSin
		ifTrue: [^aNormalizedIncompleteBetaFunction
			arcSinDistributionAt: self effectiveX].
	computed := self computedValueFor: aNormalizedIncompleteBetaFunction.
	^invert ifTrue: [1 - computed] ifFalse: [computed]]

{ #category : #accessing }
IncompleteBetaArguments >> x [
	^x]

{ #category : #accessing }
IncompleteBetaArguments >> x: aNumber [
	x := aNumber.
	y := 1 - x]

{ #category : #accessing }
IncompleteBetaArguments >> y [
	^y]

