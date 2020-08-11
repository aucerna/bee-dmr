"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #IntervalHalving,
	#superclass : #OptimizationMethod,
	#instVars : [
		'xlm',
		'xm',
		'xmr',
		'ylm',
		'ym',
		'ymr'
	],
	#category : #NumericalMethods
}

{ #category : #testing }
IntervalHalving >> isInFirstHalf [
	xlm := xl + xm / 2.0.
	ylm := self valueAt: xlm.
	^ylm > ym]

{ #category : #testing }
IntervalHalving >> isInSecondHalf [
	xmr := xm + xr / 2.0.
	ymr := self valueAt: xmr.
	^ymr > ym]

{ #category : #outputs }
IntervalHalving >> max [
	^xm]

{ #category : #calculation }
IntervalHalving >> selectCentralHalf [
	xl := xlm.
	xr := xmr]

{ #category : #calculation }
IntervalHalving >> selectFirstHalf [
	xr := xm.
	xm := xlm.
	ym := ylm]

{ #category : #calculation }
IntervalHalving >> selectSecondHalf [
	xl := xm.
	xm := xmr.
	ym := ymr]

{ #category : #calculation }
IntervalHalving >> startUp [
	super startUp.
	xm := xl + xr / 2.0.
	ym := self valueAt: xm]

{ #category : #calculation }
IntervalHalving >> step [
	self isInFirstHalf ifTrue: [^self selectFirstHalf].
	self isInSecondHalf
		ifTrue: [self selectSecondHalf]
		ifFalse: [self selectCentralHalf]]

