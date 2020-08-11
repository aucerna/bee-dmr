"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #IncompleteBetaSeriesSmallB,
	#superclass : #ConvergentSeries,
	#instVars : [
		'p',
		'prefix',
		'a',
		'b',
		'x',
		'y',
		'ln2',
		'lxp',
		'u',
		'mult',
		'j',
		't4',
		's0'
	],
	#category : #NumericalMethods
}

{ #category : #accessing }
IncompleteBetaSeriesSmallB >> args: args [
	a := args a.
	b := args b.
	x := args x.
	y := args y]

{ #category : #inquiries }
IncompleteBetaSeriesSmallB >> hasConverged: an sum: sum [
	^an > 1
		ifTrue: [an abs < (epsilon * sum) abs]
		ifFalse: [(an / epsilon) abs < sum abs]]

{ #category : #accessing }
IncompleteBetaSeriesSmallB >> mult: aNumber [
	mult := aNumber]

{ #category : #reading }
IncompleteBetaSeriesSmallB >> next [
	| bn sigma f |
	bn := b + (n - 1 * 2).
	sigma := (1 to: n - 1) sum: [:m | self partialTerm: m].
	f := self factorialOf: n * 2 + 1.
	sigma := sigma / n + (b - 1 / f).
	p add: sigma.
	j := bn * (bn + 1 * j) + (u + bn + 1 * lxp) / t4.
	lxp := lxp * ln2.
	n := n + 1.
	^prefix * sigma * j]

{ #category : #private }
IncompleteBetaSeriesSmallB >> partialTerm: m [
	| term f |
	term := p at: n - m.
	f := self factorialOf: m * 2 + 1.
	^m * b - n * term asFloat / f]

{ #category : #actions }
IncompleteBetaSeriesSmallB >> reset [
	| t ln gamma f h |
	super reset.
	t := a + (b - 1 / 2).
	ln := y < 0.3 ifTrue: [(y negated + 1) ln] ifFalse: [x ln].
	u := t negated * ln.
	gamma := IncompleteGammaFunction new
		a: b;
		epsilon: epsilon;
		iterations: iterations.
	f := gamma prefix: u.
	h := f / (gamma trueGamma: b).
	j := f = 0.0 ifTrue: [0.0] ifFalse: [(gamma complementaryAt: u) / f].
	prefix := h / (gamma trueGamma: a deltaRatio: b).
	prefix := prefix * mult / (t raisedTo: b).
	p := OrderedCollection new.
	a0 := s0 + (prefix * j).
	ln2 := ln / 2.0.
	ln2 := ln2 * ln2.
	lxp := 1.
	t4 := 4 * t * t]

{ #category : #accessing }
IncompleteBetaSeriesSmallB >> s0: aNumber [
	s0 := aNumber]

