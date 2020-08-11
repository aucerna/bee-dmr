"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #IncompleteGammaPrefix,
	#superclass : #Object,
	#instVars : [
		'a',
		'epsilon',
		'iterations'
	],
	#category : #NumericalMethods
}

{ #category : #'instance creation' }
IncompleteGammaPrefix class >> a: a [
	^self new a: a]

{ #category : #'instance creation' }
IncompleteGammaPrefix class >> new [
	^super new initialize]

{ #category : #accessing }
IncompleteGammaPrefix >> a: aNumber [
	a := aNumber]

{ #category : #accessing }
IncompleteGammaPrefix >> epsilon: aNumber [
	epsilon := aNumber asFloat]

{ #category : #services }
IncompleteGammaPrefix >> fullAt: z [
	^(z raisedTo: a) * z negated exp]

{ #category : #initialization }
IncompleteGammaPrefix >> initialize [
	super initialize.
	epsilon := 1.0e-10.
	iterations := 100]

{ #category : #accessing }
IncompleteGammaPrefix >> iterations: aNumber [
	iterations := aNumber asFloat]

{ #category : #private }
IncompleteGammaPrefix >> overflowsOn: aFloat [
	^aFloat <= Float maxNegativeForExp or: [aFloat >= Float maxForExp]]

{ #category : #private }
IncompleteGammaPrefix >> overflowsOn: left or: right [
	^(left min: right) <= Float maxNegativeForExp
		or: [(left max: right) >= Float maxForExp]]

{ #category : #services }
IncompleteGammaPrefix >> regularizedAt: z [
	| limit sum prefix |
	limit := 10 max: a.
	sum := IncompleteGammaFunction new
		epsilon: epsilon;
		iterations: iterations;
		upperAndLowerSum: a limit: limit.
	prefix := a < 10
		ifTrue: [self regularizedSmallA: z]
		ifFalse: [self regularizedLargeA: z].
	^prefix / sum]

{ #category : #private }
IncompleteGammaPrefix >> regularizedLargeA: z [
	| zeta delta lambda alpha |
	zeta := z / a asFloat.
	delta := a - z.
	lambda := a * zeta ln.
	^(self overflowsOn: lambda or: delta)
		ifTrue: [
			alpha := delta / a.
			(self overflowsOn: alpha)
				ifTrue: [(lambda + delta) exp]
				ifFalse: [alpha exp * zeta raisedTo: a]]
		ifFalse: [(zeta raisedTo: a) * delta exp]]

{ #category : #private }
IncompleteGammaPrefix >> regularizedSmallA: z [
	| prefix |
	prefix := z / 10.0 raisedTo: a.
	prefix := prefix * (10.0 - z) exp.
	^prefix ~ 0.0
		ifTrue: [z * (10.0 - z / a) exp / 10.0 raisedTo: a]
		ifFalse: [prefix]]

