"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BoxCoxDistribution,
	#superclass : #ContinuousProbabilityDistribution,
	#instVars : [
		'lambda',
		'offset',
		'deviate',
		'transformation',
		'mu',
		'sigma'
	],
	#category : #Distributions
}

{ #category : #accessing }
BoxCoxDistribution class >> displayString [
	^'Box Cox']

{ #category : #'instance creation' }
BoxCoxDistribution class >> fromTransformation: aBoxCoxTransformation [
	^self new transformation: aBoxCoxTransformation]

{ #category : #'instance creation' }
BoxCoxDistribution class >> mean: mu deviation: sigma lambda: lambda [
	^self
		mean: mu
		deviation: sigma
		lambda: lambda
		offset: 0.0]

{ #category : #'instance creation' }
BoxCoxDistribution class >> mean: mu
deviation: sigma
lambda: lambda
offset: delta [
	^self new
		mean: mu
		deviation: sigma
		lambda: lambda
		offset: delta]

{ #category : #examples }
BoxCoxDistribution class >> sampleInstance [
	| lognormal sample boxcox |
	lognormal := LogNormalDistribution sampleInstance.
	sample := lognormal sample: 100.
	boxcox := BoxCoxTransformation on: sample.
	^boxcox compute; distribution]

{ #category : #'probability functions' }
BoxCoxDistribution >> density: x [
	| y f g |
	y := self lambdaAt: x.
	f := deviate density: y.
	g := x + offset raisedTo: lambda - 1.0.
	^f * g]

{ #category : #'probability functions' }
BoxCoxDistribution >> distribution: x [
	| y |
	y := self lambdaAt: x.
	^deviate distribution: y]

{ #category : #'probability functions' }
BoxCoxDistribution >> inverseDistribution: u [
	| y |
	y := deviate inverseDistribution: u.
	^self inverseLambda: y]

{ #category : #private }
BoxCoxDistribution >> inverseLambda: y [
	| x |
	x := lambda ~ 0.0
		ifTrue: [y exp]
		ifFalse: [y * lambda + 1.0 raisedTo: 1.0 / lambda].
	^x - offset]

{ #category : #private }
BoxCoxDistribution >> lambdaAt: aNumber [
	| x y |
	x := aNumber + offset.
	^lambda ~ 0.0 ifTrue: [x ln] ifFalse: [
		y := x raisedTo: lambda.
		y - 1.0 / lambda]]

{ #category : #private }
BoxCoxDistribution >> lambdaDerivative: aNumber [
	| x a b |
	x := aNumber + offset.
	^lambda ~ 0.0 ifTrue: [1.0 / x] ifFalse: [
		a := x raisedTo: lambda - 1.0.
		b := self lambdaAt: x.
		a - (b / lambda)]]

{ #category : #estimators }
BoxCoxDistribution >> mean [
	^transformation data sum / transformation data size asFloat]

{ #category : #accessing }
BoxCoxDistribution >> mean: aNumber deviation: anotherNumber [
	mu := aNumber.
	sigma := anotherNumber]

{ #category : #accessing }
BoxCoxDistribution >> mean: mean
deviation: std
lambda: aNumber
offset: anotherNumber [
	lambda := aNumber asFloat.
	offset := anotherNumber asFloat.
	deviate := ProbabilityDistribution normalMean: mean deviation: std]

{ #category : #printing }
BoxCoxDistribution >> parameterArray [
	^{lambda. offset. mu. sigma}]

{ #category : #estimators }
BoxCoxDistribution >> sd [
	^sigma]

{ #category : #printing }
BoxCoxDistribution >> storeString [
	^self class name , ' mean: ' , deviate mean storeString , ' deviate: '
		, deviate deviation storeString
		, ' lambda: '
		, lambda storeString]

{ #category : #private }
BoxCoxDistribution >> transformation: aBoxCoxTransformation [
	transformation := aBoxCoxTransformation.
	self updateFromTransformation]

{ #category : #accessing }
BoxCoxDistribution >> uniform: aRandom [
	super uniform: aRandom.
	deviate uniform: aRandom]

{ #category : #private }
BoxCoxDistribution >> updateFromTransformation [
	| sample |
	self
		mean: transformation transform mean
		deviation: transformation transform deviation
		lambda: transformation power
		offset: transformation offset.
	sample := SampleSpace on: transformation data.
	mu := sample mean.
	sigma := sample deviation]

