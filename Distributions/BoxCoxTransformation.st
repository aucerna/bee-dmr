"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BoxCoxTransformation,
	#superclass : #Object,
	#instVars : [
		'offset',
		'data',
		'power',
		'transform',
		'distribution',
		'lognormal',
		'uniform'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
BoxCoxTransformation class >> new [
	^super new initialize]

{ #category : #'instance creation' }
BoxCoxTransformation class >> on: data [
	^self new on: data]

{ #category : #bibliography }
BoxCoxTransformation class >> references [
	'http://www.itl.nist.gov/div898/handbook/pmc/section5/pmc52.htm' asURL browse]

{ #category : #computing }
BoxCoxTransformation >> compute [
	self
		computePower;
		computeTransform;
		computeDistribution;
		computeLognormal]

{ #category : #computing }
BoxCoxTransformation >> computeDistribution [
	distribution := BoxCoxDistribution fromTransformation: self.
	distribution uniform: uniform]

{ #category : #computing }
BoxCoxTransformation >> computeLognormal [
	| t sample |
	t := data collect: [:xi | self x: xi lambda: 0.0].
	sample := SampleSpace on: t.
	lognormal := BoxCoxDistribution
		mean: sample mean
		deviation: sample deviation
		lambda: 0.0
		offset: offset.
	sample := SampleSpace on: data.
	lognormal
		mean: sample mean deviation: sample deviation;
		uniform: uniform]

{ #category : #computing }
BoxCoxTransformation >> computePower [
	| method |
	method := IntervalHalving
		maxOf: self
		from: -4
		to: 4
		precision: 0.01.
	method compute.
	power := method max]

{ #category : #computing }
BoxCoxTransformation >> computeTransform [
	| t |
	t := data collect: [:xi | self x: xi lambda: power].
	transform := SampleSpace on: t]

{ #category : #accessing }
BoxCoxTransformation >> data [
	^data]

{ #category : #accessing }
BoxCoxTransformation >> deviation [
	^(SampleSpace on: data) deviation]

{ #category : #outputs }
BoxCoxTransformation >> distribution [
	^distribution]

{ #category : #outputs }
BoxCoxTransformation >> evaluateWith: lambda [
	^self logLikelihoodAt: lambda]

{ #category : #initialization }
BoxCoxTransformation >> initialize [
	uniform := Random current]

{ #category : #outputs }
BoxCoxTransformation >> logLikelihoodAt: lambda [
	| n mu s sigma ln |
	n := data size asFloat.
	mu := self mu: lambda.
	s := data sum: [:xi | | yi |
		yi := self x: xi lambda: lambda.
		(yi - mu) squared].
	sigma := s / n.
	ln := data sum: [:xi | (xi + offset) ln].
	^lambda - 1.0 * ln - (sigma ln * n / 2.0)]

{ #category : #outputs }
BoxCoxTransformation >> lognormal [
	^lognormal]

{ #category : #accessing }
BoxCoxTransformation >> mean [
	^(SampleSpace on: data) mean]

{ #category : #private }
BoxCoxTransformation >> mu: lambda [
	| sum |
	sum := data sum: [:xi | self x: xi lambda: lambda].
	^sum / data size asFloat]

{ #category : #accessing }
BoxCoxTransformation >> offset [
	^offset]

{ #category : #inputs }
BoxCoxTransformation >> on: aCollection [
	| min |
	data := aCollection.
	min := data min.
	offset := min <= 0.0 ifTrue: [min negated + 1.0] ifFalse: [0.0]]

{ #category : #outputs }
BoxCoxTransformation >> power [
	^power]

{ #category : #outputs }
BoxCoxTransformation >> transform [
	^transform]

{ #category : #accessing }
BoxCoxTransformation >> uniform: random [
	uniform := random.
	distribution notNil ifTrue: [
		distribution uniform: random.
		lognormal uniform: random]]

{ #category : #private }
BoxCoxTransformation >> x: xi lambda: lambda [
	^lambda = 0.0
		ifTrue: [(xi + offset) ln]
		ifFalse: [(xi + offset raisedTo: lambda) - 1.0 / lambda]]

