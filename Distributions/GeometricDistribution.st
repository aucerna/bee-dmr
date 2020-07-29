"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GeometricDistribution,
	#superclass : #BernoulliDistribution,
	#category : #Distributions
}

{ #category : #'instance creation' }
GeometricDistribution class >> around: aNumber [
	^self mean: aNumber]

{ #category : #examples }
GeometricDistribution class >> example1 [
	"
	GeometricDistribution example1
	"
	| instance |
	instance := self mean: 60 / 2.
	^{instance. instance density: 30. instance distributionOver: (30 to: 40)}]

{ #category : #'instance creation' }
GeometricDistribution class >> mean: m [
	| validation |
	validation := self runValidation: #validateGeometricMean: with: m.
	^validation hasPassed ifTrue: [self new parameter: 1 / m]]

{ #category : #examples }
GeometricDistribution class >> sampleInstance [
	^self around: 2]

{ #category : #examples }
GeometricDistribution class >> sampleSize [
	^250]

{ #category : #'probability functions' }
GeometricDistribution >> density: x [
	^x > 0
		ifTrue: [p * (1.0 - p raisedTo: x - 1)]
		ifFalse: [0.0]]

{ #category : #printing }
GeometricDistribution >> explain [
	^'Number of trials needed to obtain the first success when the probability of success is '
		, p printString]

{ #category : #'probability functions' }
GeometricDistribution >> inverseDistribution: x [
	^(x ln / (1.0 - p) ln) ceiling]

{ #category : #testing }
GeometricDistribution >> isBernoulliDistribution [
	^false]

{ #category : #inquiries }
GeometricDistribution >> isConsistentWith: deterministicValue [
	^deterministicValue isNumber and: [
		self min <~ deterministicValue
			and: [self isConsistentWithMean: deterministicValue]]]

{ #category : #testing }
GeometricDistribution >> isFinite [
	^false]

{ #category : #estimators }
GeometricDistribution >> kurtosis [
	"http://mathworld.wolfram.com/Kurtosis.html"
	^5 - p + (1 - p) reciprocal]

{ #category : #estimators }
GeometricDistribution >> max [
	^nil]

{ #category : #estimators }
GeometricDistribution >> mean [
	^1.0 / p]

{ #category : #estimators }
GeometricDistribution >> min [
	^1]

{ #category : #printing }
GeometricDistribution >> parameterArray [
	^{self mean}]

{ #category : #printing }
GeometricDistribution >> printOn: aStream [
	aStream
		nextPutAll: 'Geometric(';
		print: p;
		nextPut: $)]

{ #category : #estimators }
GeometricDistribution >> skewness [
	"http://mathworld.wolfram.com/Skewness.html"
	^2 - p / (1 - p) sqrt]

{ #category : #printing }
GeometricDistribution >> storeString [
	^self class name , ' mean: ' , self mean storeString]

{ #category : #estimators }
GeometricDistribution >> variance [
	^1.0 - p / p squared]

