"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #InverseFunctionInterval,
	#superclass : #Object,
	#instVars : [
		'f',
		'y',
		'interval',
		'tolerance'
	],
	#category : #NumericalMethods
}

{ #category : #'instance creation' }
InverseFunctionInterval class >> new [
	^super new initialize]

{ #category : #'instance creation' }
InverseFunctionInterval class >> on: evaluable
from: a
to: b
at: y [
	^self new
		on: evaluable
		from: a
		to: b
		at: y]

{ #category : #outputs }
InverseFunctionInterval >> derivative: evaluable [
	interval derivative: evaluable]

{ #category : #outputs }
InverseFunctionInterval >> evaluateWith: x [
	| fx |
	fx := f evaluateWith: x.
	^fx - y]

{ #category : #accessing }
InverseFunctionInterval >> from: a to: b at: value [
	interval on: self from: a to: b.
	y := value]

{ #category : #accessing }
InverseFunctionInterval >> function [
	^f]

{ #category : #initialization }
InverseFunctionInterval >> initialize [
	super initialize.
	tolerance := 0.00001.
	interval := FunctionRootInterval new]

{ #category : #accessing }
InverseFunctionInterval >> inverse [
	| fa fb a b |
	a := interval first.
	b := interval last.
	fa := self valueAt: a.
	fb := self valueAt: b.
	^fa abs < fb abs ifTrue: [a] ifFalse: [b]]

{ #category : #accessing }
InverseFunctionInterval >> on: evaluable [
	f := evaluable.
	interval on: self]

{ #category : #accessing }
InverseFunctionInterval >> on: evaluable
from: a
to: b
at: value [
	interval on: self from: a to: b.
	y := value.
	f := evaluable]

{ #category : #solving }
InverseFunctionInterval >> refineBelow: epsilon [
	interval refineBelow: epsilon]

{ #category : #solving }
InverseFunctionInterval >> solve [
	self refineBelow: tolerance]

{ #category : #accessing }
InverseFunctionInterval >> tolerance: aNumber [
	tolerance := aNumber asFloat]

{ #category : #outputs }
InverseFunctionInterval >> valueAt: x [
	^self evaluateWith: x]

