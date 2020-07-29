"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ContingencyTable,
	#superclass : #Collection,
	#instVars : [
		'index',
		'matrix',
		'columns',
		'mapping',
		'expected'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
ContingencyTable class >> index: index [
	^self new index: index]

{ #category : #'instance creation' }
ContingencyTable class >> new [
	^super new initialize]

{ #category : #accessing }
ContingencyTable >> at: name put: values [
	self ASSERT: values size = index size.
	columns at: name put: values]

{ #category : #private }
ContingencyTable >> computeMatrix [
	| j |
	matrix := FloatMatrix newRows: index size columns: columns size.
	mapping := Dictionary new: columns size.
	j := 1.
	columns keysAndValuesDo: [:name :values | 
		values withIndexDo: [:value :i | matrix atRow: i column: j put: value].
		mapping at: name put: j.
		j := j + 1]]

{ #category : #accessing }
ContingencyTable >> degreeOfFreedom [
	| n m |
	n := matrix numRows - 1.
	m := matrix numColumns - 1.
	^n * m > 0 ifTrue: [n * m] ifFalse: [n max: m]]

{ #category : #statistics }
ContingencyTable >> expectedMatrix [
	| marginal subtotals total |
	marginal := matrix rows collect: #sum.
	subtotals := matrix columns collect: #sum.
	total := subtotals sum.
	expected := FloatMatrix
		fromBlock: [:i :j | | ri cj |
			ri := marginal at: i.
			cj := subtotals at: j.
			ri * cj / total]
		numRows: matrix numRows
		columns: matrix numColumns]

{ #category : #statistics }
ContingencyTable >> expectedMatrix: aMatrix [
	expected := aMatrix]

{ #category : #'instance creation' }
ContingencyTable >> index: aCollection [
	index := aCollection]

{ #category : #initialization }
ContingencyTable >> initialize [
	columns := Dictionary new]

{ #category : #accessing }
ContingencyTable >> matrix [
	^matrix]

{ #category : #statistics }
ContingencyTable >> pvalue [
	| chi2 difference variance normalized |
	matrix isNil ifTrue: [self computeMatrix].
	expected ifNil: [self expectedMatrix].
	chi2 := ChiSquaredDistribution dof: self degreeOfFreedom.
	difference := matrix - expected.
	variance := difference tensor: difference.
	normalized := variance tensorReciprocal: expected.
	^1.0 - (chi2 distribution: normalized sum)]

{ #category : #statistics }
ContingencyTable >> rejected: alpha [
	^self pvalue < alpha]

