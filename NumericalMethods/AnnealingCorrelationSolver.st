"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #AnnealingCorrelationSolver,
	#superclass : #AnnealingAlgorithm,
	#category : #NumericalMethods
}

{ #category : #initialization }
AnnealingCorrelationSolver >> initialize [
	super initialize.
	problem := CorrelationProblem new]

{ #category : #initialization }
AnnealingCorrelationSolver >> initializeHeater [
	heater := cooler]

{ #category : #accessing }
AnnealingCorrelationSolver >> neighborhoodSize [
	^current size]

{ #category : #execution }
AnnealingCorrelationSolver >> shuffle [
	| goal count |
	self solve.
	current isNil ifTrue: [^self].
	goal := problem goal.
	count := 3.
	[| error |
		error := goal - self currentCost.
		error abs < 0.01 or: [count < 1]]
		whileFalse: [
			self shake: count * 10.
			count := count - 1]]

{ #category : #execution }
AnnealingCorrelationSolver >> solve [
	(problem sigmaX ~ 0.0 or: [problem sigmaY ~ 0.0]) ifTrue: [^self].
	super solve]

{ #category : #accessing }
AnnealingCorrelationSolver >> target: aNumber [
	problem goal: aNumber]

{ #category : #execution }
AnnealingCorrelationSolver >> trialJump [
	| i j n |
	n := current size.
	i := n atRandom: uniform.
	[
		j := n atRandom: uniform.
		j = i] whileTrue.
	^{i. j}]

{ #category : #services }
AnnealingCorrelationSolver >> useDefaultParameters [
	| n |
	n := problem x size.
	n < 50 ifTrue: [^self].
	cooler
		maxJumps: (2.0 * n) sqrt;
		maxTrials: 2.0 * n sqrt;
		maxCoolings: 100;
		coolingFactor: 0.9]

{ #category : #accessing }
AnnealingCorrelationSolver >> x: aCollection y: anotherCollection [
	problem isNil ifTrue: [problem := CorrelationProblem new].
	problem x: aCollection y: anotherCollection]

