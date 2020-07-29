"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BetaBinomialDistribution,
	#superclass : #BinomialDistribution,
	#instVars : [
		'alpha',
		'beta'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
BetaBinomialDistribution class >> events: n alpha: alpha beta: beta [
	^self new events: n alpha: alpha beta: beta]

{ #category : #estimation }
BetaBinomialDistribution class >> events: n firstMoment: m1 second: m2 [
	| factor alpha beta |
	factor := n * (m2 / m1 - m1 - 1) + m1.
	alpha := n * m1 - m2 * factor reciprocal.
	beta := n - m1 * (n - (m2 / m1)) * factor reciprocal.
	^self events: n alpha: alpha beta: beta]

{ #category : #'instance creation' }
BetaBinomialDistribution class >> from: aCollection [
	| n m1 m2 sum |
	n := aCollection size - 1.
	m1 := m2 := 0.
	sum := aCollection sum.
	aCollection withIndexDo: [:x :index | 
		m1 := m1 + (index - 1 * x).
		m2 := m2 + ((index - 1) squared * x)].
	^self
		events: n
		firstMoment: m1 * sum reciprocal
		second: m2 * sum reciprocal]

{ #category : #examples }
BetaBinomialDistribution class >> histogramFrom: n alpha: alpha beta: beta [
	| distribution data statistic histogram |
	distribution := self events: n alpha: alpha beta: beta.
	data := (1 to: 10000) collect: [:i | distribution next].
	statistic := SampleStatistic on: data.
	histogram := (Smalltalk at: #DiscreteHistogram) on: statistic.
	^histogram chart open]

{ #category : #examples }
BetaBinomialDistribution class >> sampleInstance [
	^self events: 10 alpha: 1 beta: 2]

{ #category : #accessing }
BetaBinomialDistribution >> alpha [
	^alpha]

{ #category : #accessing }
BetaBinomialDistribution >> beta [
	^beta]

{ #category : #'probability functions' }
BetaBinomialDistribution >> density: x [
	| choices gamma1 gamma2 |
	^(x between: 0 and: N)
		ifTrue: [
			choices := self take: x.
			gamma1 := GammaFunction a: alpha b: beta.
			gamma2 := GammaFunction a: x + alpha b: N - x + beta.
			^choices * gamma1 / gamma2]
		ifFalse: [0.0]]

{ #category : #'probability functions' }
BetaBinomialDistribution >> distribution: x [
	^(0 to: x) sum: [:i | self density: i]]

{ #category : #accessing }
BetaBinomialDistribution >> events: n alpha: a beta: b [
	N := n.
	alpha := a.
	beta := b.
	p := BetaDistribution a: alpha b: beta]

{ #category : #estimators }
BetaBinomialDistribution >> kurtosis [
	"
	ShellDLL current openWebPage: 'http://en.wikipedia.org/wiki/Beta-binomial_distribution'
	"
	| s f1 t1 t2 t3 t4 t5 f2 |
	s := alpha + beta.
	f1 := 1 + s * s squared / (s + 2 * (s + 3) * (s + N) * N * alpha * beta).
	t1 := 6 * N - 1 + s * s.
	t2 := N - 2 * 3 * alpha * beta.
	t3 := 6 * N squared.
	t4 := 6 - N * 3 * alpha * beta * N / s.
	t5 := 18 * alpha * beta * N squared / s squared.
	f2 := t1 + t2 + t3 - t4 - t5.
	^f1 * f2]

{ #category : #estimators }
BetaBinomialDistribution >> mean [
	^N * p mean]

{ #category : #'random sampling' }
BetaBinomialDistribution >> next [
	| binomial |
	binomial := BinomialDistribution events: N probability: p next.
	^binomial next]

{ #category : #printing }
BetaBinomialDistribution >> parameterArray [
	^{N. alpha. beta} , p parameterArray]

{ #category : #estimators }
BetaBinomialDistribution >> skewness [
	| s |
	s := alpha + beta.
	^2 * N + s * (beta - alpha) / (s + 2)
		* (1 + s / (N + s * N * alpha * beta)) sqrt]

{ #category : #'distribution protocol' }
BetaBinomialDistribution >> uniform: aRandom [
	super uniform: aRandom.
	p uniform: aRandom]

{ #category : #estimators }
BetaBinomialDistribution >> variance [
	| sum |
	sum := alpha + beta + N.
	^p variance * N * sum]

