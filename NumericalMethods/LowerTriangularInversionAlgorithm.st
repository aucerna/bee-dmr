"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #LowerTriangularInversionAlgorithm,
	#superclass : #Object,
	#instVars : [
		'matrix',
		'input',
		'inverse',
		'n',
		'state'
	],
	#category : #NumericalMethods
}

{ #category : #'instance creation' }
LowerTriangularInversionAlgorithm class >> on: aMatrix [
	^self new matrix: aMatrix]

{ #category : #computing }
LowerTriangularInversionAlgorithm >> basicRun [
	1 to: n do: [:j | self computeColumn: j]]

{ #category : #computing }
LowerTriangularInversionAlgorithm >> computeColumn: j [
	| ajj |
	ajj := matrix atRow: j column: j.
	ajj ~ 0.0 ifTrue: [
		state := #fail.
		^self].
	self divideRow: j by: ajj.
	j + 1 to: n do: [:i | | aij |
		aij := matrix atRow: i column: j.
		self subtractRow: j multipliedBy: aij toRow: i.
		matrix atRow: i column: j put: 0.0]]

{ #category : #private }
LowerTriangularInversionAlgorithm >> divideRow: i by: lambda [
	| mu |
	mu := lambda reciprocal.
	matrix multiplyRow: i by: mu.
	inverse multiplyRow: i by: mu]

{ #category : #output }
LowerTriangularInversionAlgorithm >> inverse [
	^state == #calculated ifTrue: [inverse]]

{ #category : #input }
LowerTriangularInversionAlgorithm >> matrix: aMatrix [
	input := aMatrix.
	matrix := input copy.
	n := matrix numRows.
	inverse := aMatrix class id: n]

{ #category : #computing }
LowerTriangularInversionAlgorithm >> run [
	state := #calculating.
	1 to: n do: [:j | 
		self computeColumn: j.
		state == #calculating ifFalse: [^self]].
	state := #calculated]

{ #category : #private }
LowerTriangularInversionAlgorithm >> subtractRow: i multipliedBy: lambda toRow: j [
	| mu |
	mu := lambda negated.
	matrix addRow: i multipliedBy: mu toRow: j.
	inverse addRow: i multipliedBy: mu toRow: j]

