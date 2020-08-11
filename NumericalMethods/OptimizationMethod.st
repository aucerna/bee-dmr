"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #OptimizationMethod,
	#superclass : #Object,
	#instVars : [
		'function',
		'maximizer',
		'xl',
		'xr',
		'epsilon',
		'count'
	],
	#category : #NumericalMethods
}

{ #category : #'instance creation' }
OptimizationMethod class >> maxOf: function
from: a
to: b
precision: epsilon [
	^self new
		function: function;
		from: a to: b;
		precision: epsilon;
		maximize]

{ #category : #'instance creation' }
OptimizationMethod class >> minOf: function
from: a
to: b
precision: epsilon [
	^self new
		function: function;
		from: a to: b;
		precision: epsilon;
		minimize]

{ #category : #'instance creation' }
OptimizationMethod class >> new [
	^super new initialize]

{ #category : #testing }
OptimizationMethod >> atEnd [
	^xr - xl <= epsilon]

{ #category : #calculation }
OptimizationMethod >> compute [
	self startUp.
	[self atEnd] whileFalse: [
		count := count + 1.
		self step]]

{ #category : #outputs }
OptimizationMethod >> count [
	^count]

{ #category : #calculation }
OptimizationMethod >> derivativeAt: x [
	| y |
	y := function derivativeAt: x.
	^maximizer ifTrue: [y] ifFalse: [y negated]]

{ #category : #inputs }
OptimizationMethod >> from: x1 to: x2 [
	xl := x1.
	xr := x2]

{ #category : #accessing }
OptimizationMethod >> function: f [
	function := f]

{ #category : #initialization }
OptimizationMethod >> initialize [
	super initialize.
	maximizer := true]

{ #category : #outputs }
OptimizationMethod >> max [
	^self min]

{ #category : #accessing }
OptimizationMethod >> maximize [
	maximizer := true]

{ #category : #outputs }
OptimizationMethod >> maxValue [
	^self minValue]

{ #category : #outputs }
OptimizationMethod >> min [
	^xl]

{ #category : #accessing }
OptimizationMethod >> minimize [
	maximizer := false]

{ #category : #outputs }
OptimizationMethod >> minValue [
	^function evaluateWith: self min]

{ #category : #inputs }
OptimizationMethod >> precision: aNumber [
	epsilon := aNumber]

{ #category : #calculation }
OptimizationMethod >> startUp [
	count := 0]

{ #category : #calculation }
OptimizationMethod >> valueAt: x [
	| y |
	y := function evaluateWith: x.
	^maximizer ifTrue: [y] ifFalse: [y negated]]

