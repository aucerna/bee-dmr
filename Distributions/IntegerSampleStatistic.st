"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #IntegerSampleStatistic,
	#superclass : #SampleStatistic,
	#category : #Distributions
}

{ #category : #histogram }
IntegerSampleStatistic >> histogramClass [
	^domain notNil ifTrue: [DiscreteHistogram] ifFalse: [IntegerHistogram]]

{ #category : #testing }
IntegerSampleStatistic >> isIntegerValued [
	^true]

