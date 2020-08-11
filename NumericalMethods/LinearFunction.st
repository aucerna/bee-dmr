"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #LinearFunction,
	#superclass : #Object,
	#instVars : [
		'm',
		'b'
	],
	#category : #NumericalMethods
}

{ #category : #'instance creation' }
LinearFunction class >> new [
	^super new initialize]

{ #category : #'instance creation' }
LinearFunction class >> slope: m ordinate: b [
	^self new slope: m; ordinate: b]

{ #category : #'instance creation' }
LinearFunction class >> through: p1 and: p2 [
	^self new through: p1 and: p2]

{ #category : #'instance creation' }
LinearFunction class >> with: p1 with: p2 [
	^self new through: p1 and: p2]

{ #category : #evaluation }
LinearFunction >> at: x [
	^m isInfinity ifFalse: [x * m + b]]

{ #category : #initialization }
LinearFunction >> initialize [
	super initialize.
	m := 1.0.
	b := 0.0]

{ #category : #services }
LinearFunction >> integralFrom: t0 to: t1 [
	t0 ~ t1 ifTrue: [^0.0].
	t1 < t0 ifTrue: [^(self integralFrom: t1 to: t0) negated].
	^(self at: t0) + (self at: t1) / 2.0 * (t1 - t0)]

{ #category : #accessing }
LinearFunction >> inverseAt: value [
	^m ~ 0.0 ifFalse: [value - b / m]]

{ #category : #testing }
LinearFunction >> isVertical [
	^m isInfinite]

{ #category : #accessing }
LinearFunction >> ordinate: aNumber [
	b := aNumber]

{ #category : #printing }
LinearFunction >> printOn: aStream [
	self isVertical ifTrue: [
		aStream nextPutAll: 'x = '.
		b printOn: aStream.
		^self].
	aStream nextPutAll: 'y = '.
	m printOn: aStream.
	aStream nextPutAll: ' x '.
	b >= 0
		ifTrue: [aStream nextPutAll: '+ ']
		ifFalse: [aStream nextPutAll: '- '].
	b abs printOn: aStream]

{ #category : #accessing }
LinearFunction >> root [
	^m ~ 0.0 ifFalse: [b negated / m]]

{ #category : #accessing }
LinearFunction >> slope [
	^m]

{ #category : #accessing }
LinearFunction >> slope: aNumber [
	m := aNumber]

{ #category : #accessing }
LinearFunction >> through: p1 and: p2 [
	p1 x ~ p2 x
		ifTrue: [
			m := Number infinity.
			b := p1 x]
		ifFalse: [
			m := p2 y - p1 y / (p2 x - p1 x).
			b := p1 y - (m * p1 x)]]

