"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #TDistribution,
	#superclass : #ContinuousProbabilityDistribution,
	#instVars : [
		'normal',
		'chiSquare',
		'nu'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
TDistribution class >> around: aNumber [
	^self degree: aNumber]

{ #category : #'instance creation' }
TDistribution class >> degree: nu [
	| validation |
	validation := self runValidation: #validateTDegree: with: nu.
	^validation hasPassed ifTrue: [self new degree: nu]]

{ #category : #'instance creation' }
TDistribution class >> sampleInstance [
	^self around: 5.0]

{ #category : #validation }
TDistribution >> addValidationSelectorsTo: aCollection [
	super addValidationSelectorsTo: aCollection.
	aCollection add: #tValidation]

{ #category : #private }
TDistribution >> asJson [
	^super asJson at: 'Nu' put: self degree; yourself]

{ #category : #accessing }
TDistribution >> degree [
	^nu squared]

{ #category : #private }
TDistribution >> degree: a [
	nu := a sqrt.
	normal := NormalDistribution mean: 0 deviation: 1.
	normal uniform: uniform.
	chiSquare := ChiSquareDistribution degree: a.
	chiSquare uniform: uniform]

{ #category : #private }
TDistribution >> fromJson: aJsonObject [
	self degree: aJsonObject Nu]

{ #category : #inquiries }
TDistribution >> isLike: aProbabilityDistribution [
	^(super isLike: aProbabilityDistribution)
		and: [self degree = aProbabilityDistribution degree]]

{ #category : #estimators }
TDistribution >> kurtosis [
	"http://mathworld.wolfram.com/Kurtosis.html"
	^6 / ( nu - 4)]

{ #category : #estimators }
TDistribution >> mean [
	self ASSERT: nu > 1.0.
	^0]

{ #category : #'random sampling' }
TDistribution >> next [
	^normal next / chiSquare next sqrt * nu]

{ #category : #printing }
TDistribution >> parameterArray [
	^{self degree}]

{ #category : #copying }
TDistribution >> postCopy [
	super postCopy.
	normal := normal copy.
	chiSquare := chiSquare copy]

{ #category : #estimators }
TDistribution >> skewness [
	"http://mathworld.wolfram.com/Skewness.html"
	^0.0]

{ #category : #printing }
TDistribution >> storeString [
	^self class name , ' degree: ' , self degree storeString]

{ #category : #accessing }
TDistribution >> uniform: aRandom [
	super uniform: aRandom.
	chiSquare uniform: uniform.
	normal uniform: uniform]

{ #category : #estimators }
TDistribution >> variance [
	self ASSERT: nu > 2.0.
	^nu / (nu - 2.0)]

