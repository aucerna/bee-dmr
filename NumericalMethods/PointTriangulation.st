"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PointTriangulation,
	#superclass : #Object,
	#instVars : [
		'A',
		'B',
		'C',
		'D',
		'a',
		'b',
		'c',
		'h',
		'c1',
		'theta'
	],
	#category : #NumericalMethods
}

{ #category : #accessing }
PointTriangulation >> A: aPoint [
	A := aPoint]

{ #category : #accessing }
PointTriangulation >> a: aNumber [
	a := aNumber]

{ #category : #accessing }
PointTriangulation >> B: aPoint [
	B := aPoint]

{ #category : #accessing }
PointTriangulation >> b: aNumber [
	b := aNumber]

{ #category : #accessing }
PointTriangulation >> C [
	^C]

{ #category : #computing }
PointTriangulation >> compute [
	self computeTheta; computeD; computeC]

{ #category : #private }
PointTriangulation >> computeC [
	C := A y - B y * h / c @ (B x - A x * h / c) + D]

{ #category : #private }
PointTriangulation >> computeD [
	h := b * theta sin.
	c1 := b * theta cos.
	D := B - A * c1 / c + A]

{ #category : #private }
PointTriangulation >> computeTheta [
	| cos |
	c := A distanceTo: B.
	cos := b squared + c squared - a squared / 2 / b / c.
	theta := cos arcCos]

{ #category : #accessing }
PointTriangulation >> D [
	^D]

