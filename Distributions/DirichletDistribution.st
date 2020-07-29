"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #DirichletDistribution,
	#superclass : #MultivariatedDistribution,
	#instVars : [
		'alphas',
		'scale',
		'gammas',
		'beta',
		'tail'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
DirichletDistribution class >> on: aCollection [
	^self new on: aCollection]

{ #category : #samples }
DirichletDistribution class >> sample [
	"
	DirichletDistribution sample
	"
	^self sampleInstance transposedSample: 1000]

{ #category : #samples }
DirichletDistribution class >> sampleInstance [
	"
	DirichletDistribution sampleInstance
	"
	^self on: #(2 3 5)]

{ #category : #estimators }
DirichletDistribution >> covariance [
	| n matrix normalizer |
	n := alphas size.
	matrix := FloatMatrix newRows: n columns: n.
	normalizer := scale * scale * (scale + 1).
	1 to: n do: [:i | | ai |
		ai := alphas at: i.
		1 to: i do: [:j | | aj aij |
			aj := (alphas at: j) negated.
			aij := ai * aj.
			i = j ifTrue: [aij := ai * scale + aij].
			aij := aij / normalizer.
			matrix atRow: i column: j put: aij.
			i = j ifFalse: [matrix atRow: j column: i put: aij]]].
	^matrix]

{ #category : #'probability functions' }
DirichletDistribution >> density: x [
	^(self logDensity: x) exp]

{ #category : #accessing }
DirichletDistribution >> dimension [
	^alphas size]

{ #category : #'random sampling' }
DirichletDistribution >> fastNext [
	| x sum |
	x := gammas collect: #next.
	sum := x sum.
	^x collect: [:y | y / sum]]

{ #category : #inquiries }
DirichletDistribution >> isConsistentWithMean: anArray [
	(anArray conform: #isNumber) ifFalse: [^false].
	^super isConsistentWithMean: anArray]

{ #category : #'random sampling' }
DirichletDistribution >> latinHypercubeSample: iterations [
	| samples lhc |
	samples := gammas
		collect: [:gamma | gamma latinHypercubeSample: iterations].
	lhc := OrderedCollection new.
	1 to: iterations do: [:i | | x sum sample |
		x := samples collect: [:gamma | gamma at: i].
		sum := x sum.
		sample := x collect: [:xi | xi / sum].
		lhc add: sample].
	^lhc]

{ #category : #private }
DirichletDistribution >> logBeta [
	^self sumOfLogs - self logOfSums]

{ #category : #private }
DirichletDistribution >> logDensity: xs [
	| log |
	log := 0.
	xs with: alphas do: [:x :alpha | log := log + (alpha - 1.0 * x ln)].
	^log - self logBeta]

{ #category : #private }
DirichletDistribution >> logOfSums [
	^GammaFunction new lnGamma: scale]

{ #category : #estimators }
DirichletDistribution >> mean [
	^alphas collect: [:alpha | alpha / scale]]

{ #category : #'random sampling' }
DirichletDistribution >> next [
	^self fastNext]

{ #category : #'random sampling' }
DirichletDistribution >> next: n [
	^(1 to: n) collect: [:i | self next]]

{ #category : #private }
DirichletDistribution >> on: aCollection [
	| a1 |
	alphas := aCollection.
	gammas := alphas collect: [:alpha | GammaDistribution shape: alpha].
	scale := alphas sum.
	a1 := alphas first.
	beta := BetaDistribution a: a1 b: scale - a1.
	tail := alphas size > 2
		ifTrue: [DirichletDistribution on: alphas allButFirst]]

{ #category : #printing }
DirichletDistribution >> parameterArray [
	^alphas]

{ #category : #estimators }
DirichletDistribution >> sd [
	^self variance collect: #sqrt]

{ #category : #'random sampling' }
DirichletDistribution >> slowNext [
	| x1 complement rest |
	x1 := beta next.
	complement := 1.0 - x1.
	tail isNil ifTrue: [^{x1. complement}].
	rest := tail slowNext collect: [:xi | xi * complement].
	^Array with: x1 withAll: rest]

{ #category : #printing }
DirichletDistribution >> storeString [
	^self class name , ' on: ' , alphas literalString]

{ #category : #private }
DirichletDistribution >> sumOfLogs [
	| gamma |
	gamma := GammaFunction new.
	^alphas sum: [:alpha | gamma lnGamma: alpha]]

{ #category : #'random sampling' }
DirichletDistribution >> transposedSample: n [
	| sample dim samples |
	sample := self sample: n.
	dim := self dimension.
	samples := Array new: dim.
	1 to: dim do: [:i | | s |
		s := Array new: n.
		samples at: i put: s].
	sample
		withIndexDo: [:tuple :i | tuple
			withIndexDo: [:sj :j | (samples at: j) at: i put: sj]].
	^samples]

{ #category : #accessing }
DirichletDistribution >> uniform: aRandom [
	super uniform: aRandom.
	gammas do: [:gamma | gamma uniform: aRandom].
	beta uniform: aRandom]

{ #category : #estimators }
DirichletDistribution >> variance [
	| normalizer |
	normalizer := scale * scale * (scale + 1.0).
	^alphas collect: [:alpha | alpha * (scale - alpha) / normalizer]]

