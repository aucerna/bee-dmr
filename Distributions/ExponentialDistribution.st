"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ExponentialDistribution,
	#superclass : #ContinuousProbabilityDistribution,
	#instVars : [
		'lambda'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
ExponentialDistribution class >> around: aNumber [
	^self mean: aNumber]

{ #category : #'instance creation' }
ExponentialDistribution class >> default [
	^self mean: 1]

{ #category : #examples }
ExponentialDistribution class >> example [
	"
	self example
	"
	^self sampleInstance]

{ #category : #'instance creation' }
ExponentialDistribution class >> mean: mu [
	| validation |
	validation := self runValidation: #validateExponentialParameter: with: mu.
	^validation hasPassed ifTrue: [self new mean: mu]]

{ #category : #'instance creation' }
ExponentialDistribution class >> parameter: lambda [
	| validation |
	validation := self
		runValidation: #validateExponentialParameter:
		with: lambda.
	^validation hasPassed ifTrue: [self new parameter: lambda]]

{ #category : #examples }
ExponentialDistribution class >> sampleInstance [
	^self around: 3]

{ #category : #examples }
ExponentialDistribution class >> sampleSize [
	^500]

{ #category : #validation }
ExponentialDistribution >> addValidationSelectorsTo: aCollection [
	super addValidationSelectorsTo: aCollection.
	aCollection add: #exponentialValidation]

{ #category : #converting }
ExponentialDistribution >> asJson [
	^super asJson at: 'Lambda' put: lambda; yourself]

{ #category : #'probability functions' }
ExponentialDistribution >> density: x [
	^x > 0.0 ifTrue: [(x * lambda) negated exp * lambda] ifFalse: [0.0]]

{ #category : #'probability functions' }
ExponentialDistribution >> distribution: aNumber [
	aNumber <= 0.0 ifTrue: [^0.0].
	^1.0 - (aNumber * lambda) negated exp]

{ #category : #'probability functions' }
ExponentialDistribution >> distributionFrom: a to: b [
	^(self distribution: b) - (self distribution: a)]

{ #category : #printing }
ExponentialDistribution >> explain [
	^'Number of seconds for the next event when the average lapse is '
		, lambda printString
		, ' seconds']

{ #category : #converting }
ExponentialDistribution >> fromJson: aJsonObject [
	self parameter: aJsonObject Lambda]

{ #category : #services }
ExponentialDistribution >> gaps: n [
	| gaps s |
	gaps := Array new: n.
	s := 0.0.
	1 to: n do: [:i | | u |
		u := self next.
		s := s + u.
		gaps at: i put: u].
	gaps withIndexDo: [:gi :i | gaps at: i put: gi / s].
	^gaps]

{ #category : #'probability functions' }
ExponentialDistribution >> inverseDistribution: u [
	u = 0.0 ifTrue: [^1.0].
	^(1.0 - u) ln / lambda negated]

{ #category : #inquiries }
ExponentialDistribution >> isLike: aProbabilityDistribution [
	^(super isLike: aProbabilityDistribution)
		and: [self mean = aProbabilityDistribution mean]]

{ #category : #estimators }
ExponentialDistribution >> kurtosis [
	"
	http://mathworld.wolfram.com/Kurtosis.html
	"
	^6.0]

{ #category : #estimators }
ExponentialDistribution >> mean [
	^lambda reciprocal]

{ #category : #accessing }
ExponentialDistribution >> mean: aNumber [
	lambda := 1.0 / aNumber]

{ #category : #estimators }
ExponentialDistribution >> median [
	^lambda reciprocal * 2.0 ln]

{ #category : #private }
ExponentialDistribution >> parameter [
	^lambda]

{ #category : #private }
ExponentialDistribution >> parameter: aNumber [
	lambda := aNumber]

{ #category : #printing }
ExponentialDistribution >> parameterArray [
	^{lambda}]

{ #category : #printing }
ExponentialDistribution >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		nextPutAll: '(';
		print: lambda;
		nextPut: $)]

{ #category : #estimators }
ExponentialDistribution >> skewness [
	"
	http://mathworld.wolfram.com/Skewness.html
	"
	^2.0]

{ #category : #printing }
ExponentialDistribution >> storeString [
	^self class name , ' mean: ' , lambda storeString]

{ #category : #estimators }
ExponentialDistribution >> variance [
	^lambda reciprocal squared]

