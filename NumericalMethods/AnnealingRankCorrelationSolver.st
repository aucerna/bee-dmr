"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #AnnealingRankCorrelationSolver,
	#superclass : #AnnealingAlgorithm,
	#instVars : [
		'solver'
	],
	#category : #NumericalMethods
}

{ #category : #accessing }
AnnealingRankCorrelationSolver >> currentCost [
	^solver currentCost]

{ #category : #execution }
AnnealingRankCorrelationSolver >> jump: delta [
	self triggerEvent: #jumped: with: delta]

{ #category : #accessing }
AnnealingRankCorrelationSolver >> neighborhoodSize [
	^solver neighborhoodSize]

{ #category : #accessing }
AnnealingRankCorrelationSolver >> problem: aCombinatorialProblem [
	super problem: aCombinatorialProblem.
	solver := AnnealingCorrelationSolver
		forProblem: aCombinatorialProblem copy useRankings.
	solver uniform: self uniform]

{ #category : #execution }
AnnealingRankCorrelationSolver >> solve [
	cost := problem initialCost.
	(problem sigmaX ~ 0.0 or: [problem sigmaY ~ 0.0]) ifTrue: [^self].
	solver solve.
	problem y sortAs: solver problem y]

{ #category : #accessing }
AnnealingRankCorrelationSolver >> uniform: aRandom [
	super uniform: aRandom.
	solver notNil ifTrue: [solver uniform: aRandom]]

