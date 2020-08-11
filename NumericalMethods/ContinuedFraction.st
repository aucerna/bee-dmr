"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ContinuedFraction,
	#superclass : #Object,
	#instVars : [
		'epsilon',
		'iterations',
		'n',
		'an',
		'bn'
	],
	#category : #NumericalMethods
}

{ #category : #'instance creation' }
ContinuedFraction class >> new [
	^super new initialize]

{ #category : #streaming }
ContinuedFraction >> advance [
	^self subclassResponsibility]

{ #category : #accessing }
ContinuedFraction >> epsilon [
	^epsilon]

{ #category : #construction }
ContinuedFraction >> epsilon: e [
	epsilon := e]

{ #category : #initialization }
ContinuedFraction >> initialize [
	super initialize.
	epsilon := 1.0e-10.
	iterations := 100]

{ #category : #accessing }
ContinuedFraction >> iterations [
	^iterations]

{ #category : #construction }
ContinuedFraction >> iterations: anInteger [
	iterations := anInteger]

{ #category : #accessing }
ContinuedFraction >> n [
	^n]

{ #category : #services }
ContinuedFraction >> reset [
	n := 0]

{ #category : #evaluation }
ContinuedFraction >> value [
	| x c d count |
	self reset; advance.
	x := bn asFloat.
	c := x.
	d := 0.0.
	count := 1.
	[| delta |
		self advance.
		c := bn + (an / c).
		d := bn + (an * d).
		d := 1.0 / d.
		delta := c * d.
		x := x * delta.
		epsilon < (delta - 1.0) abs and: [count < iterations]]
		whileTrue: [count := count + 1].
	^x]

