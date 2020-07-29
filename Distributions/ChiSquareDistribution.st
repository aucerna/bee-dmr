"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ChiSquareDistribution,
	#superclass : #ContinuousProbabilityDistribution,
	#instVars : [
		'gamma'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
ChiSquareDistribution class >> degree: nu [
	| validation |
	validation := self runValidation: #validateChiSquareDegree: with: nu.
	^validation hasPassed ifTrue: [self new degree: nu]]

{ #category : #examples }
ChiSquareDistribution class >> sampleInstance [
	^self degree: 10]

{ #category : #validation }
ChiSquareDistribution >> addValidationSelectorsTo: aCollection [
	super addValidationSelectorsTo: aCollection.
	aCollection add: #chiSquareValidation]

{ #category : #accessing }
ChiSquareDistribution >> degree [
	^gamma order * 2]

{ #category : #accessing }
ChiSquareDistribution >> degree: nu [
	gamma := GammaDistribution order: nu / 2]

{ #category : #printing }
ChiSquareDistribution >> explain [
	^'Chi-square distribution with ' , self degree printString , ' degrees of freedom']

{ #category : #inquiries }
ChiSquareDistribution >> isLike: aProbabilityDistribution [
	^self class == aProbabilityDistribution class
		and: [self degree = aProbabilityDistribution degree]]

{ #category : #estimators }
ChiSquareDistribution >> kurtosis [
	"http://mathworld.wolfram.com/Kurtosis.html"
	^12 / self degree]

{ #category : #estimators }
ChiSquareDistribution >> mean [
	^self degree]

{ #category : #'random sampling' }
ChiSquareDistribution >> next [
	^2 * gamma next]

{ #category : #printing }
ChiSquareDistribution >> parameterArray [
	^{self degree}]

{ #category : #copying }
ChiSquareDistribution >> postCopy [
	super postCopy.
	gamma := gamma copy]

{ #category : #printing }
ChiSquareDistribution >> printOn: aStream [
	^aStream
		nextPutAll: self class name;
		nextPutAll: '(';
		print: self degree;
		nextPut: $)]

{ #category : #estimators }
ChiSquareDistribution >> skewness [
	"http://mathworld.wolfram.com/Skewness.html"
	^2 * (2 / self degree) sqrt]

{ #category : #printing }
ChiSquareDistribution >> storeString [
	^self class name , ' degree: ' , self degree storeString]

{ #category : #accessing }
ChiSquareDistribution >> uniform: aRandom [
	super uniform: aRandom.
	gamma uniform: aRandom]

{ #category : #estimators }
ChiSquareDistribution >> variance [
	^2 * self degree]

