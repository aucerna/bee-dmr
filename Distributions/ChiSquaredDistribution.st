"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ChiSquaredDistribution,
	#superclass : #ContinuousProbabilityDistribution,
	#instVars : [
		'deviate',
		'dof'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
ChiSquaredDistribution class >> dof: dof [
	^self new dof: dof]

{ #category : #'instance creation' }
ChiSquaredDistribution class >> new [
	^super new initialize]

{ #category : #'instance creation' }
ChiSquaredDistribution class >> sampleInstance [
	^self dof: 2]

{ #category : #converting }
ChiSquaredDistribution >> asJson [
	^super asJson at: 'DoF' put: dof; yourself]

{ #category : #'probability functions' }
ChiSquaredDistribution >> distribution: x [
	^deviate distribution: x]

{ #category : #accessing }
ChiSquaredDistribution >> dof [
	^dof]

{ #category : #accessing }
ChiSquaredDistribution >> dof: nu [
	dof := nu.
	deviate := nu = 2
		ifTrue: [ExponentialDistribution around: 2.0]
		ifFalse: [ScaledGammaDistribution shape: nu / 2.0 scale: 2.0]]

{ #category : #converting }
ChiSquaredDistribution >> fromJson: aJsonObject [
	self dof: aJsonObject DoF]

{ #category : #'probability functions' }
ChiSquaredDistribution >> inverseDistribution: u [
	^deviate inverseDistribution: u]

{ #category : #statistics }
ChiSquaredDistribution >> kurtosis [
	^deviate kurtosis]

{ #category : #statistics }
ChiSquaredDistribution >> mean [
	^deviate mean]

{ #category : #statistics }
ChiSquaredDistribution >> oneSidedInterval: alpha [
	^self inverseDistribution: 1.0 - alpha]

{ #category : #printing }
ChiSquaredDistribution >> parameterArray [
	^{dof}]

{ #category : #statistics }
ChiSquaredDistribution >> skewness [
	^deviate skewness]

{ #category : #statistics }
ChiSquaredDistribution >> twoSidedInterval: alpha [
	^{alpha / 2. 1 - (alpha / 2)} collect: [:p | self inverseDistribution: p]]

{ #category : #statistics }
ChiSquaredDistribution >> variance [
	^deviate variance]

