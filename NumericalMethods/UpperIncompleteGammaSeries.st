"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #UpperIncompleteGammaSeries,
	#superclass : #ConvergentSeries,
	#instVars : [
		'result',
		'z',
		'a'
	],
	#category : #NumericalMethods
}

{ #category : #'instance creation' }
UpperIncompleteGammaSeries class >> epsilon: epsilon
iterations: iterations
a: a
z: z [
	"
	UpperIncompleteGammaSeries a: 3 z: 0.2
	"
	| series |
	series := self epsilon: epsilon iterations: iterations.
	^series
		a: a z: z;
		initialValue: 0.0]

{ #category : #construction }
UpperIncompleteGammaSeries >> a: aNumber z: anotherNumber [
	a := aNumber.
	z := anotherNumber negated]

{ #category : #reading }
UpperIncompleteGammaSeries >> next [
	| r |
	result := result / n.
	r := result / (a + n).
	result := result * z.
	n := n + 1.
	^r]

{ #category : #actions }
UpperIncompleteGammaSeries >> reset [
	super reset.
	result := z]

