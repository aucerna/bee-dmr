"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #IncompleteBetaSeries,
	#superclass : #ConvergentSeries,
	#instVars : [
		'a',
		'result',
		'x',
		'poch',
		'b',
		'mult'
	],
	#category : #NumericalMethods
}

{ #category : #'instance creation' }
IncompleteBetaSeries class >> arguments: args mult: mult [
	^self arguments: args mult: mult initialValue: 0]

{ #category : #'instance creation' }
IncompleteBetaSeries class >> arguments: args mult: mult initialValue: s0 [
	| series |
	series := self initialValue: s0.
	^series arguments: args mult: mult]

{ #category : #accessing }
IncompleteBetaSeries >> arguments: arguments mult: aNumber [
	a := arguments a.
	b := arguments b.
	x := arguments x.
	mult := aNumber.
	epsilon := arguments epsilon.
	iterations := arguments iterations]

{ #category : #reading }
IncompleteBetaSeries >> next [
	| r |
	r := result / (a + n - 1).
	result := result * (poch * x) / n.
	poch := poch + 1.
	n := n + 1.
	^r]

{ #category : #actions }
IncompleteBetaSeries >> reset [
	super reset.
	poch := 1 - b.
	result := mult]

