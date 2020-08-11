"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CholeskyDecompositionTest,
	#superclass : #TestCase,
	#category : #'NumericalMethods\Tests'
}

{ #category : #rosetta }
CholeskyDecompositionTest >> testRosetta1 [
	| matrix triangular expected |
	matrix := '
		25  15  -5
		15  18   0
		-5   0  11' asFloatMatrix.
	triangular := matrix cholesky run lowerTriangular.
	expected := '
		5   0   0
		3   3   0
		-1   1   3' asFloatMatrix.
	self
		assert: triangular = expected;
		assert: matrix ~ (triangular * triangular transposed)]

{ #category : #rosetta }
CholeskyDecompositionTest >> testRosetta2 [
	| matrix cholesky triangular expected diff factor inv |
	matrix := '
		18  22   54   42
		22  70   86   62
		54  86  174  134
		42  62  134  106' asFloatMatrix.
	cholesky := matrix cholesky.
	triangular := cholesky run lowerTriangular.
	expected := '
		4.24264    0.00000    0.00000    0.00000
		5.18545    6.56591    0.00000    0.00000
		12.72792    3.04604    1.64974    0.00000
		9.89949    1.62455    1.84971    1.39262' asFloatMatrix.
	diff := triangular - expected.
	factor := 10 raisedToInteger: -5.
	self
		assert: diff max < factor;
		assert: diff min abs < factor;
		assert: matrix ~ (triangular * triangular transposed).
	inv := cholesky inverseLower.
	diff := inv transposed * inv * matrix - (FloatMatrix id: 4).
	factor := 10 raisedToInteger: -13.
	self
		assert: diff max < factor;
		assert: diff min abs < factor]

{ #category : #rosetta }
CholeskyDecompositionTest >> testTP53251 [
	| matrix cholesky triangular |
	matrix := '
		1  4
		1  1' asFloatMatrix.
	cholesky := matrix cholesky.
	triangular := cholesky run lowerTriangular.
	self
		assert: triangular det = 0.0;
		assert: cholesky inverse notNil]

