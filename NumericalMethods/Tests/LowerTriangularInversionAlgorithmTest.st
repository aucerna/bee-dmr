"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #LowerTriangularInversionAlgorithmTest,
	#superclass : #TestCase,
	#category : #'NumericalMethods\Tests'
}

{ #category : #all }
LowerTriangularInversionAlgorithmTest >> testDim2 [
	| matrix algorithm id |
	id := FloatMatrix id: 2.
	matrix := '
	1    0
	2    3' asFloatMatrix.
	algorithm := LowerTriangularInversionAlgorithm on: matrix.
	algorithm run.
	self assert: algorithm inverse * matrix = id.
	matrix := '
	2    0
	3    4' asFloatMatrix.
	algorithm := LowerTriangularInversionAlgorithm on: matrix.
	algorithm run.
	self assert: algorithm inverse * matrix = id]

{ #category : #all }
LowerTriangularInversionAlgorithmTest >> testDim3 [
	| matrix algorithm id |
	id := FloatMatrix id: 3.
	matrix := '
	2    0    0
	3    4    0
	5    6    7' asFloatMatrix.
	algorithm := LowerTriangularInversionAlgorithm on: matrix.
	algorithm run.
	self assert: algorithm inverse * matrix = id]

{ #category : #all }
LowerTriangularInversionAlgorithmTest >> testDim7 [
	| matrix algorithm id |
	id := FloatMatrix id: 7.
	matrix := '
	2    0    0    0    0    0    0
	3    4    0    0    0    0    0
	5    6    7    0    0    0    0
	8    9    1    2    0    0    0
     3    4    5    6    7    0    0
     8    9    1    2    3    4    0
     5    6    7    8    9    1    2' asFloatMatrix.
	algorithm := LowerTriangularInversionAlgorithm on: matrix.
	algorithm run.
	self
		assert: (algorithm inverse * matrix relativeDistanceTo: id) < 0.000000001]

{ #category : #all }
LowerTriangularInversionAlgorithmTest >> testIdentity [
	| id algorithm |
	id := FloatMatrix id: 100.
	algorithm := LowerTriangularInversionAlgorithm on: id.
	algorithm run.
	self assert: algorithm inverse = id]

{ #category : #all }
LowerTriangularInversionAlgorithmTest >> testRandom [
	| n id algorithm random |
	n := 25.
	id := FloatMatrix id: n.
	algorithm := LowerTriangularInversionAlgorithm new.
	random := self random.
	5 timesRepeat: [| matrix |
		matrix := FloatMatrix lowerTriangularRandom: n uniform: random.
		algorithm matrix: matrix; run.
		self assert: (algorithm inverse * matrix relativeDistanceTo: id) < 0.00001]]

