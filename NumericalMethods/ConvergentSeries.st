"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ConvergentSeries,
	#superclass : #Object,
	#instVars : [
		'epsilon',
		'iterations',
		'a0',
		'n'
	],
	#classVars : [
		'Factorials'
	],
	#category : #NumericalMethods
}

{ #category : #'instance creation' }
ConvergentSeries class >> epsilon: epsilon iterations: iterations [
	| series |
	series := self initialValue: 0.
	^series epsilon: epsilon; iterations: iterations]

{ #category : #services }
ConvergentSeries class >> factorialOf: anInteger [
	anInteger = 0 ifTrue: [^1.0].
	^Factorials at: anInteger ifAbsent: [Number infinity]]

{ #category : #initialization }
ConvergentSeries class >> initializeFactorials [
	| n f k |
	n := 170.
	Factorials := Array new: n.
	k := f := 1.
	[k <= n] whileTrue: [
		Factorials at: k put: f asFloat.
		k := k + 1.
		f := f * k]]

{ #category : #'instance creation' }
ConvergentSeries class >> initialValue: initialValue [
	^self new initialValue: initialValue]

{ #category : #'instance creation' }
ConvergentSeries class >> new [
	^super new initialize]

{ #category : #accessing }
ConvergentSeries >> epsilon: aNumber [
	epsilon := aNumber]

{ #category : #services }
ConvergentSeries >> factorialOf: anInteger [
	^self class factorialOf: anInteger]

{ #category : #evaluation }
ConvergentSeries >> hasConverged: an sum: sum [
	^an abs < epsilon]

{ #category : #initialization }
ConvergentSeries >> initialize [
	super initialize.
	epsilon := 1.0e-10.
	iterations := 100.0]

{ #category : #accessing }
ConvergentSeries >> initialValue: s0 [
	a0 := s0]

{ #category : #accessing }
ConvergentSeries >> iterations: anInteger [
	iterations := anInteger asFloat]

{ #category : #streaming }
ConvergentSeries >> next [
	self subclassResponsibility]

{ #category : #actions }
ConvergentSeries >> reset [
	n := 1]

{ #category : #evaluation }
ConvergentSeries >> value [
	| sum |
	self reset.
	sum := a0.
	[| an |
		an := self next.
		sum := sum + an.
		iterations < n or: [self hasConverged: an sum: sum]] whileFalse.
	^sum]

