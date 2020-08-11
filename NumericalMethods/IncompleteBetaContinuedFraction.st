"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #IncompleteBetaContinuedFraction,
	#superclass : #ContinuedFractionB,
	#instVars : [
		'a',
		'b',
		'x',
		'y'
	],
	#category : #NumericalMethods
}

{ #category : #'instance creation' }
IncompleteBetaContinuedFraction class >> args: args [
	^super new args: args]

{ #category : #streaming }
IncompleteBetaContinuedFraction >> advance [
	| d |
	an := a + n - 1.0 * (a + b + n - 1.0) * n * (b - n) * x * x.
	d := a + (2.0 * n) - 1.0.
	an := an / (d * d).
	bn := n + (n * (b - n) * x / (a + (2.0 * n) - 1.0)).
	bn := bn
		+ (a + n * (a * y - (b * x) + 1.0 + (n * (2.0 - x))) / (a + (2.0 * n) + 1.0)).
	n := n + 1.0]

{ #category : #accessing }
IncompleteBetaContinuedFraction >> args: args [
	a := args a.
	b := args b.
	x := args x.
	y := args y]

