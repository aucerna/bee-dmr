"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PerpendicularLeastSquares,
	#superclass : #LeastSquares,
	#instVars : [
		'bigB',
		'normalizedX'
	],
	#category : #CurvesFitting
}

{ #category : #private }
PerpendicularLeastSquares >> basicSlope [
	| error1 error2 slope1 slope2 |
	bigB isNil ifTrue: [^nil].
	slope1 := 0 - bigB + (bigB * bigB + 1) sqrt.
	slope2 := 0 - bigB - (bigB * bigB + 1) sqrt.
	error1 := self distanceUsing: slope1.
	error2 := self distanceUsing: slope2.
	^error1 < error2 ifTrue: [slope1] ifFalse: [slope2]]

{ #category : #calculations }
PerpendicularLeastSquares >> calculate [
	| n ssx ssy ssxy numerator denominator |
	yMean := yValues mean.
	horizontal := yValues min ~ yMean.
	n := xValues size.
	ssx := (normalizedX * normalizedX) sum.
	ssy := (yValues * yValues) sum.
	ssxy := (normalizedX * yValues) sum.
	numerator := ssy - (n * yMean squared) - ssx.
	denominator := 0 - ssxy.
	bigB := denominator ~ 0.0 ifFalse: [1.0 / 2.0 * numerator / denominator].
	c := yMean - (self slope * xMean)]

{ #category : #private }
PerpendicularLeastSquares >> distanceUsing: b [
	| a n ssx ssy ssxy numerator denominator |
	a := yMean - (b * normalizedX mean).
	n := xValues size.
	ssx := (normalizedX * normalizedX) sum.
	ssy := (yValues * yValues) sum.
	ssxy := (normalizedX * yValues) sum.
	numerator := ssy + (b squared * ssx) + (n * a * a)
		+ (2 * a * b * normalizedX sum)
		- (2 * a * yValues sum)
		- (2 * b * ssxy).
	denominator := b squared + 1.
	^numerator / denominator]

{ #category : #testing }
PerpendicularLeastSquares >> isHorizontal [
	^super isHorizontal or: [self basicSlope = 0]]

{ #category : #calculations }
PerpendicularLeastSquares >> mean: aCollection [
	^vertical ifTrue: [aCollection first] ifFalse: [aCollection mean]]

{ #category : #outputs }
PerpendicularLeastSquares >> slope [
	self isHorizontal ifTrue: [^0.0].
	^self basicSlope]

{ #category : #outputs }
PerpendicularLeastSquares >> slopeInverse [
	self isVertical ifTrue: [^0.0].
	^1 / self slope]

{ #category : #inputs }
PerpendicularLeastSquares >> xValues: aCollection [
	super xValues: aCollection.
	normalizedX := aCollection collect: [:x | x - xMean].
	normalizedX := normalizedX asFloatArray]

