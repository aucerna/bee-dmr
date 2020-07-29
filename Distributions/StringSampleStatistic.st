"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #StringSampleStatistic,
	#superclass : #SampleStatistic,
	#category : #Distributions
}

{ #category : #samples }
StringSampleStatistic class >> sampleInstance [
	^self on: (StringDistribution sampleInstance sample: 10)]

{ #category : #testing }
StringSampleStatistic >> canComputeOutliers [
	^false]

{ #category : #calculations }
StringSampleStatistic >> correlationCoefficient: statistics [
	^0.0]

{ #category : #services }
StringSampleStatistic >> covariance: aSampleStatistic [
	^nil]

{ #category : #testing }
StringSampleStatistic >> hasDensityData [
	^false]

{ #category : #testing }
StringSampleStatistic >> hasUndefinedValues [
	data isNil ifTrue: [^super hasUndefinedValues].
	^self isArrayValued
		ifTrue: [data anySatisfy: [:v | v hasUndefinedValues]]
		ifFalse: [data hasUndefinedValues]]

{ #category : #estimators }
StringSampleStatistic >> hiOutlierLimit [
	^nil]

{ #category : #estimators }
StringSampleStatistic >> hiOutliers [
	^self outliers]

{ #category : #histogram }
StringSampleStatistic >> histogramClass [
	^DiscreteHistogram]

{ #category : #histogram }
StringSampleStatistic >> histogramDomain [
	^domain]

{ #category : #testing }
StringSampleStatistic >> isDateValued [
	^false]

{ #category : #testing }
StringSampleStatistic >> isSingleValued [
	^self isArrayValued not]

{ #category : #testing }
StringSampleStatistic >> isStringValued [
	^true]

{ #category : #services }
StringSampleStatistic >> kernelDensityWithBandwidth: smoothing [
	^nil]

{ #category : #estimators }
StringSampleStatistic >> lowOutlierLimit [
	^nil]

{ #category : #estimators }
StringSampleStatistic >> lowOutliers [
	^self outliers]

{ #category : #calculations }
StringSampleStatistic >> usedDevice [
	^nil]

