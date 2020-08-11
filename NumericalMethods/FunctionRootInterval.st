"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FunctionRootInterval,
	#superclass : #Object,
	#instVars : [
		'f',
		'a',
		'b',
		'fa',
		'fb',
		'derivative'
	],
	#category : #NumericalMethods
}

{ #category : #'instance creation' }
FunctionRootInterval class >> on: evaluable from: a to: b [
	^self new on: evaluable from: a to: b]

{ #category : #comparing }
FunctionRootInterval >> <= aFunctionRootInterval [
	^a <= aFunctionRootInterval first]

{ #category : #private }
FunctionRootInterval >> beFirstHalf [
	b := a + b / 2.0.
	fb := nil]

{ #category : #private }
FunctionRootInterval >> beSecondHalf [
	a := a + b / 2.0.
	fa := nil]

{ #category : #accessing }
FunctionRootInterval >> derivative: evaluable [
	derivative := evaluable]

{ #category : #accessing }
FunctionRootInterval >> error [
	^a ~ b ifTrue: [0.0] ifFalse: [(self fb - self fa) abs]]

{ #category : #accessing }
FunctionRootInterval >> fa [
	fa isNil ifTrue: [fa := f evaluateWith: a].
	^fa]

{ #category : #accessing }
FunctionRootInterval >> fb [
	fb isNil ifTrue: [fb := f evaluateWith: b].
	^fb]

{ #category : #accessing }
FunctionRootInterval >> first [
	^a]

{ #category : #accessing }
FunctionRootInterval >> from: min to: max [
	a := min min: max.
	b := max max: min]

{ #category : #services }
FunctionRootInterval >> halve [
	| c fc |
	c := a + b / 2.0.
	(a = c or: [b = c]) ifTrue: [
		a := b := c.
		fa := fb := nil.
		^self].
	fc := self valueAt: c.
	self splitAt: c f: fc]

{ #category : #accessing }
FunctionRootInterval >> last [
	^b]

{ #category : #services }
FunctionRootInterval >> newtonRaphson [
	| c fc der newton raphson delta |
	c := a + b / 2.0.
	(a = c or: [b = c]) ifTrue: [
		a := b := c.
		fa := fb := nil.
		^self].
	fc := self valueAt: c.
	fc isNil ifTrue: [^self].
	fc = 0.0 ifTrue: [
		a := b := c.
		fa := fb := fc.
		^self].
	der := derivative evaluateWith: c.
	der ~ 0.0 ifTrue: [^self splitAt: c f: fc].
	newton := c - (fc / der).
	(newton between: a and: b) ifFalse: [^self splitAt: c f: fc].
	raphson := self valueAt: newton.
	raphson = 0.0 ifTrue: [
		a := b := newton.
		fa := fb := 0.0.
		^self].
	delta := self fa > 0.0 = (raphson > 0.0)
		ifTrue: [b - newton]
		ifFalse: [newton - a].
	delta < (b - a / 2.0)
		ifTrue: [self splitAt: newton f: raphson]
		ifFalse: [self splitAt: c f: fc]]

{ #category : #accessing }
FunctionRootInterval >> normalize [
	self fb = 0.0 ifTrue: [
		a := b.
		fa := fb := 0.0]]

{ #category : #accessing }
FunctionRootInterval >> on: evaluable [
	f := evaluable.
	fa := fb := nil]

{ #category : #accessing }
FunctionRootInterval >> on: evaluable from: min to: max [
	self
		on: evaluable;
		from: min to: max]

{ #category : #printing }
FunctionRootInterval >> printTextOn: rtf [
	a = b ifTrue: [a printTextOn: rtf] ifFalse: [
		rtf nextPut: $[.
		a printTextOn: rtf.
		rtf nextPutAll: ', '.
		b printTextOn: rtf.
		rtf nextPut: $]]]

{ #category : #services }
FunctionRootInterval >> refineBelow: epsilon [
	| delta0 prev count |
	prev := delta0 := nil.
	count := 0.
	[| error delta |
		error := self error.
		delta := b - a.
		(delta0 notNil and: [delta0 - delta < epsilon] and: [prev = error])
			ifTrue: [^count].
		prev := error.
		delta0 := delta.
		error <= epsilon]
		whileFalse: [
			count := count + 1.
			self newtonRaphson].
	^count]

{ #category : #services }
FunctionRootInterval >> root [
	^fb abs < fa abs ifTrue: [b] ifFalse: [a]]

{ #category : #services }
FunctionRootInterval >> splitAt: c f: fc [
	fc = 0.0 ifTrue: [
		a := b := c.
		fa := fb := fc.
		^self].
	self fa > 0.0 = (fc > 0.0)
		ifTrue: [
			a := c.
			fa := fc]
		ifFalse: [
			b := c.
			fb := fc]]

{ #category : #services }
FunctionRootInterval >> splitAt: newton f: raphson orHalf: fc [
	| delta |
	delta := self fa > 0.0 = (raphson > 0.0)
		ifTrue: [b - newton]
		ifFalse: [newton - a].
	delta < (b - a / 2.0)
		ifTrue: [self splitAt: newton f: raphson]
		ifFalse: [self splitAt: a + b / 2.0 f: fc]]

{ #category : #services }
FunctionRootInterval >> subintervals [
	^{self copy beFirstHalf. self copy beSecondHalf}]

{ #category : #accessing }
FunctionRootInterval >> valueAt: aNumber [
	aNumber = a ifTrue: [^self fa].
	aNumber = b ifTrue: [^self fb].
	^f evaluateWith: aNumber]

