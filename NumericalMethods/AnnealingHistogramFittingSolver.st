"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #AnnealingHistogramFittingSolver,
	#superclass : #AnnealingAlgorithm,
	#category : #NumericalMethods
}

{ #category : #examples }
AnnealingHistogramFittingSolver class >> example [
	"
	AnnealingHistogramFittingSolver example
	"
	| histogram problem solver |
	histogram := {100 @ 1000. 200 @ 500. 300 @ 300}.
	problem := HistogramFittingProblem new.
	problem histogram: histogram.
	solver := AnnealingHistogramFittingSolver forProblem: problem.
	solver solve.
	solver chart open]

{ #category : #examples }
AnnealingHistogramFittingSolver class >> example2 [
	"
	AnnealingHistogramFittingSolver example2
	"
	| problem solver |
	problem := HistogramFittingProblem new.
	problem histogram: {100 @ 1000. 200 @ 900. 300 @ 200. 400 @ 100}.
	solver := AnnealingHistogramFittingSolver forProblem: problem.
	solver solve.
	solver chart open]

{ #category : #examples }
AnnealingHistogramFittingSolver class >> example3 [
	"
	AnnealingHistogramFittingSolver example3
	"
	| problem solver |
	problem := HistogramFittingProblem new.
	problem histogram: {100 @ 1000. 200 @ 900. 300 @ 200. 400 @ 800}.
	solver := AnnealingHistogramFittingSolver forProblem: problem.
	solver solve.
	solver chart open]

{ #category : #inquiries }
AnnealingHistogramFittingSolver >> chart [
	^problem fitting chart]

{ #category : #inquiries }
AnnealingHistogramFittingSolver >> costIncrementFor: deviation [
	^current variationIncrementAtBin: deviation first for: deviation second]

{ #category : #execution }
AnnealingHistogramFittingSolver >> trialJump [
	| index range x |
	index := current adjustableBins atRandom: uniform.
	range := current rangeOfBin: index.
	x := range extent asFloat atRandom: uniform.
	^{index. range upperBound - x}]

