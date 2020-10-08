"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RayleighQuotientLeastSquares,
	#superclass : #LeastSquares,
	#instVars : [
		'normalizedX',
		'normalizedY',
		'a',
		'b'
	],
	#category : #CurvesFitting
}

{ #category : #calculations }
RayleighQuotientLeastSquares >> calculate [
	| matrix a12 eigenvector k |
	defined := true.
	self isHorizontal ifTrue: [
		self isVertical ifTrue: [defined := false].
		c := yMean.
		^self].
	self isVertical ifTrue: [^self].
	matrix := self matrix.
	a12 := matrix atRow: 1 column: 2.
	a12 ~ 0.0 ifTrue: [defined := false] ifFalse: [
		eigenvector := matrix eigenvectors first.
		a := eigenvector first.
		b := eigenvector second.
		b ~ 0.0 ifTrue: [^defined := false].
		k := a * xMean + (b * yMean).
		c := k / b]]

{ #category : #private }
RayleighQuotientLeastSquares >> matrix [
	| xy matrix |
	xy := (normalizedX * normalizedY) sum.
	matrix := FloatMatrix square: 2.
	matrix
		atRow: 1 column: 1 put: normalizedX squared sum;
		atRow: 1 column: 2 put: xy;
		atRow: 2 column: 1 put: xy;
		atRow: 2 column: 2 put: normalizedY squared sum.
	^matrix]

{ #category : #outputs }
RayleighQuotientLeastSquares >> slope [
	horizontal ifTrue: [^0.0].
	^vertical ifFalse: [a / b negated]]

{ #category : #inputs }
RayleighQuotientLeastSquares >> xValues: aCollection [
	super xValues: aCollection.
	normalizedX := aCollection collect: [:x | x - xMean].
	normalizedX := normalizedX asFloatArray]

{ #category : #accessing }
RayleighQuotientLeastSquares >> yValues: aCollection [
	super yValues: aCollection.
	normalizedY := aCollection collect: [:y | y - yMean].
	normalizedY := normalizedY asFloatArray]

