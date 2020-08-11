"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HistogramFittingProblem,
	#superclass : #CombinatorialProblem,
	#instVars : [
		'fitting',
		'cost'
	],
	#category : #NumericalMethods
}

{ #category : #inquiries }
HistogramFittingProblem >> costAt: anHistogramFitting [
	^cost ifNil: [fitting slopeVariation]]

{ #category : #inquiries }
HistogramFittingProblem >> costScale [
	^2.0]

{ #category : #accessing }
HistogramFittingProblem >> fitting [
	^fitting]

{ #category : #accessing }
HistogramFittingProblem >> fitting: aHistogramFitting [
	fitting := aHistogramFitting]

{ #category : #accessing }
HistogramFittingProblem >> histogram: aCollection [
	fitting := HistogramFitting new.
	fitting histogram: aCollection]

{ #category : #inquiries }
HistogramFittingProblem >> initialSolution [
	^fitting fit]

{ #category : #services }
HistogramFittingProblem >> modify: anHistogramFitting with: deviation [
	anHistogramFitting deviateBin: deviation first at: deviation second.
	cost := anHistogramFitting slopeVariation]

