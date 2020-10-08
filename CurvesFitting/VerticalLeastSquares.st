"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #VerticalLeastSquares,
	#superclass : #LeastSquares,
	#instVars : [
		'ssx',
		'ssy',
		'ssxy',
		'slope'
	],
	#category : #CurvesFitting
}

{ #category : #calculations }
VerticalLeastSquares >> calculate [
	self ensureBounds.
	xMean := xValues mean.
	yMean := yValues mean.
	ssxy := 0.0.
	ssx := 0.0.
	ssy := 0.0.
	vertical := false.
	horizontal := false.
	xValues with: yValues do: [:x :y | 
		ssxy := ssxy + (x - xMean * (y - yMean)).
		ssx := ssx + (x - xMean) squared.
		ssy := ssy + (y - yMean) squared].
	vertical := ssx ~ 0.0.
	vertical ifTrue: [^self].
	slope := ssxy / ssx.
	c := yMean - (slope * xMean).
	horizontal := ssy ~ 0.0 or: [slope ~ 0.0]]

{ #category : #outputs }
VerticalLeastSquares >> slope [
	^slope]

