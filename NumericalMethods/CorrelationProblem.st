"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CorrelationProblem,
	#superclass : #CombinatorialProblem,
	#instVars : [
		'x',
		'y',
		'sigmaX',
		'sigmaY'
	],
	#category : #NumericalMethods
}

{ #category : #examples }
CorrelationProblem class >> sampleInstance [
	^self new randomSamples: 24; goal: 0.75]

{ #category : #inquiries }
CorrelationProblem >> costAt: sample [
	| s |
	s := SampleStatistic on: sample.
	^(x correlationCoefficient: s) value]

{ #category : #inquiries }
CorrelationProblem >> costIncrementFor: swap on: sample [
	| i j xi xj yi yj |
	i := swap first.
	j := swap second.
	xi := self xAt: i.
	xj := self xAt: j.
	yi := sample at: i.
	yj := sample at: j.
	^xj - xi * (yi - yj) / (sigmaX * sigmaY) / sample size]

{ #category : #inquiries }
CorrelationProblem >> costScale [
	^2.0]

{ #category : #accessing }
CorrelationProblem >> goal: value [
	super goal: value value asNumber]

{ #category : #inquiries }
CorrelationProblem >> initialSolution [
	^y]

{ #category : #services }
CorrelationProblem >> modify: sample with: swap [
	sample swap: swap first with: swap second]

{ #category : #services }
CorrelationProblem >> randomSamples: size [
	| normal log xs ys |
	normal := NormalDistribution mean: 60 deviation: 10.
	log := LogNormalDistribution mean: 50 deviation: 14.
	xs := normal sample: size.
	ys := log sample: size.
	xs := xs collect: #asInteger.
	ys := ys collect: #asInteger.
	self x: xs y: ys]

{ #category : #accessing }
CorrelationProblem >> sigmaX [
	^sigmaX]

{ #category : #accessing }
CorrelationProblem >> sigmaY [
	^sigmaY]

{ #category : #inquiries }
CorrelationProblem >> size [
	^x size]

{ #category : #accessing }
CorrelationProblem >> solverClass [
	^AnnealingCorrelationSolver]

{ #category : #accessing }
CorrelationProblem >> useRankings [
	self x: x ranking y: y ranking]

{ #category : #accessing }
CorrelationProblem >> x [
	^x]

{ #category : #accessing }
CorrelationProblem >> x: aCollection y: anotherCollection [
	| s |
	x := SampleStatistic on: aCollection.
	y := anotherCollection.
	s := SampleStatistic on: y.
	sigmaX := x populationSD value.
	sigmaY := s populationSD value]

{ #category : #accessing }
CorrelationProblem >> xAt: index [
	^x dataAt: index]

{ #category : #accessing }
CorrelationProblem >> y [
	^y]

