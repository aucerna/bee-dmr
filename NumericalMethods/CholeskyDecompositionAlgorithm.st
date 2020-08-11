"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CholeskyDecompositionAlgorithm,
	#superclass : #Object,
	#instVars : [
		'matrix',
		'lower',
		'state'
	],
	#category : #NumericalMethods
}

{ #category : #'instance creation' }
CholeskyDecompositionAlgorithm class >> on: matrix [
	^self new on: matrix]

{ #category : #computing }
CholeskyDecompositionAlgorithm >> computeDiagonal: k [
	| product akk diff |
	product := self dotProductLimitedTo: k withRow: k.
	akk := matrix atRow: k column: k.
	diff := akk - product.
	diff < 0.0 ifTrue: [
		state := #fail.
		^self halt].
	lower atRow: k column: k put: diff sqrt]

{ #category : #computing }
CholeskyDecompositionAlgorithm >> computeLowerAtRow: i column: k [
	| akk aik product |
	akk := lower atRow: k column: k.
	akk ~ 0.0 ifTrue: [
		state := #fail.
		^self].
	aik := matrix atRow: i column: k.
	product := self dotProductLimitedTo: k withRow: i.
	lower atRow: i column: k put: aik - product / akk]

{ #category : #computing }
CholeskyDecompositionAlgorithm >> dotProductLimitedTo: k withRow: i [
	| sum |
	sum := 0.0.
	1 to: k do: [:j | | aij akj |
		aij := lower atRow: i column: j.
		akj := lower atRow: k column: j.
		sum := aij * akj + sum].
	^sum]

{ #category : #output }
CholeskyDecompositionAlgorithm >> inverse [
	| inv |
	^(state == #fail or: [
		inv := self inverseLower.
		inv isNil])
		ifTrue: [self nonHermitianInverse]
		ifFalse: [inv transposed * inv]]

{ #category : #output }
CholeskyDecompositionAlgorithm >> inverseLower [
	| algorithm |
	state == #calculated ifFalse: [^nil].
	algorithm := LowerTriangularInversionAlgorithm on: lower.
	^algorithm run; inverse]

{ #category : #output }
CholeskyDecompositionAlgorithm >> lowerTriangular [
	^state == #calculated ifTrue: [lower]]

{ #category : #output }
CholeskyDecompositionAlgorithm >> nonHermitianInverse [
	| transposed cholesky inv |
	transposed := matrix transposed.
	cholesky := self class on: matrix * transposed.
	inv := cholesky run inverse ifNil: [^nil].
	^transposed * inv]

{ #category : #input }
CholeskyDecompositionAlgorithm >> on: aMatrix [
	matrix := aMatrix.
	lower := matrix class zero: matrix numRows]

{ #category : #computing }
CholeskyDecompositionAlgorithm >> run [
	state := #calculating.
	1 to: matrix numRows do: [:i | 
		state == #cancelling ifTrue: [
			state := #cancelled.
			^self].
		state == #fail ifTrue: [^self].
		1 to: i - 1 do: [:j | self computeLowerAtRow: i column: j].
		self computeDiagonal: i].
	state := #calculated]

