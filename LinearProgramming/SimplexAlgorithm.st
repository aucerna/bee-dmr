"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SimplexAlgorithm,
	#superclass : #Object,
	#instVars : [
		'matrix',
		'numVariables',
		'pivots'
	],
	#category : #LinearProgramming
}

{ #category : #running }
SimplexAlgorithm >> enterColumn [
	| lastRow |
	lastRow := matrix numRows.
	1
		to: numVariables
		do: [:k | (matrix atRow: lastRow column: k) < 0.0 ifTrue: [^k]].
	^nil]

{ #category : #running }
SimplexAlgorithm >> killColumn: j usingRow: i [
	| a |
	1 to: matrix numRows do: [:k | 
		k = i ifFalse: [
			a := matrix atRow: k column: j.
			a = 1.0 ifTrue: [matrix subtractRow: i fromRow: k] ifFalse: [
				a = -1.0
					ifTrue: [matrix addRow: i toRow: k]
					ifFalse: [a = 0.0
						ifFalse: [matrix addRow: i multipliedBy: a negated toRow: k]]]]]]

{ #category : #accessing }
SimplexAlgorithm >> lastColumn [
	^matrix lastColumn]

{ #category : #accessing }
SimplexAlgorithm >> lastRow [
	^matrix numRows]

{ #category : #input }
SimplexAlgorithm >> matrix: aMatrix [
	matrix isNil
		ifTrue: [matrix := aMatrix copy]
		ifFalse: [matrix copyFrom: aMatrix]]

{ #category : #input }
SimplexAlgorithm >> numVariables: n [
	numVariables := n]

{ #category : #running }
SimplexAlgorithm >> pivotIn: j [
	| c b min pivot |
	c := matrix numColumns.
	1 to: matrix numRows - 1 do: [:i | 
		0.0 < (matrix atRow: i column: j) ifTrue: [
			b := matrix atRow: i column: c.
			(min isNil or: [b < min]) ifTrue: [
				min := b.
				pivot := i]]].
	^pivot]

{ #category : #running }
SimplexAlgorithm >> run [
	| i pivot j |
	pivots := ByteArray new: numVariables.
	[
		j := self enterColumn.
		j notNil]
		whileTrue: [
			i := self pivotIn: j.
			i notNil ifTrue: [
				pivots at: j put: i.
				pivot := matrix atRow: i column: j.
				pivot = 1.0 ifFalse: [matrix multiplyRow: i by: pivot reciprocal].
				self killColumn: j usingRow: i]]]

{ #category : #output }
SimplexAlgorithm >> solution: j [
	| i |
	i := pivots at: j.
	i = 0 ifTrue: [^0.0].
	^matrix atRow: i column: matrix numColumns]

