"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #LowerIncompleteGammaSeries,
	#superclass : #ConvergentSeries,
	#instVars : [
		'a',
		'z',
		'result'
	],
	#category : #NumericalMethods
}

{ #category : #'instance creation' }
LowerIncompleteGammaSeries class >> epsilon: epsilon
iterations: iterations
a: a
z: z [
	"
	LowerIncompleteGammaSeries a: 10 z: 4
	"
	| series |
	series := self epsilon: epsilon iterations: iterations.
	^series
		a: a z: z;
		initialValue: 0.0]

{ #category : #construction }
LowerIncompleteGammaSeries >> a: aNumber z: anotherNumber [
	a := aNumber asFloat.
	z := anotherNumber asFloat.
	self reset]

{ #category : #reading }
LowerIncompleteGammaSeries >> next [
	| r |
	r := result.
	result := result * z / (a + n).
	n := n + 1.0.
	^r]

{ #category : #actions }
LowerIncompleteGammaSeries >> reset [
	super reset.
	result := 1.0]

{ #category : #evaluation }
LowerIncompleteGammaSeries >> value [
	^super value / a]

