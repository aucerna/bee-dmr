"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FDistribution,
	#superclass : #ContinuousProbabilityDistribution,
	#instVars : [
		'beta',
		'nu'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
FDistribution class >> sampleInstance [
	^self with: 6 with: 7]

{ #category : #'instance creation' }
FDistribution class >> with: a with: b [
	| validation |
	validation := self runValidation: #validateFWith:with: with: a with: b.
	^validation hasPassed ifTrue: [self new with: a with: b]]

{ #category : #accessing }
FDistribution >> a [
	^beta a * 2]

{ #category : #validation }
FDistribution >> addValidationSelectorsTo: aCollection [
	super addValidationSelectorsTo: aCollection.
	aCollection add: #fValidation]

{ #category : #accessing }
FDistribution >> asJson [
	^super asJson
		at: 'A' put: self a;
		at: 'B' put: self b;
		yourself]

{ #category : #accessing }
FDistribution >> b [
	^beta b * 2]

{ #category : #accessing }
FDistribution >> fromJson: aJsonObject [
	self with: aJsonObject A with: aJsonObject B]

{ #category : #inquiries }
FDistribution >> isLike: aProbabilityDistribution [
	^(super isLike: aProbabilityDistribution)
		and: [self a = aProbabilityDistribution a]
		and: [self b = aProbabilityDistribution b]]

{ #category : #estimators }
FDistribution >> mean [
	| b |
	b := self b.
	self ASSERT: b > 2.0.
	^b / (b - 2.0)]

{ #category : #'random sampling' }
FDistribution >> next [
	| b |
	b := beta next.
	^nu * b / (1 - b)]

{ #category : #printing }
FDistribution >> parameterArray [
	^{self a. self b}]

{ #category : #copying }
FDistribution >> postCopy [
	super postCopy.
	beta := beta copy]

{ #category : #printing }
FDistribution >> storeString [
	^self class name , ' with: ' , self a storeString , ' with: '
		, self b storeString]

{ #category : #accessing }
FDistribution >> uniform: aRandom [
	super uniform: aRandom.
	beta uniform: aRandom]

{ #category : #estimators }
FDistribution >> variance [
	| b a |
	b := self b.
	self ASSERT: b > 4.0.
	a := self a.
	^a + b - 2.0 * b squared * 2 / ((b - 2.0) squared * (b - 4.0) * a)]

{ #category : #private }
FDistribution >> with: a with: b [
	beta := BetaDistribution a: a / 2 b: b / 2.
	beta uniform: uniform.
	nu := b / a]

