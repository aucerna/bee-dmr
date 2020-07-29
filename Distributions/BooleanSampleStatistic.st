"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BooleanSampleStatistic,
	#superclass : #SampleStatistic,
	#category : #Distributions
}

{ #category : #adding }
BooleanSampleStatistic >> addData: value [
	| x |
	x := value isCollection
		ifTrue: [self convertAll: value]
		ifFalse: [self convert: value].
	^super addData: x]

{ #category : #converting }
BooleanSampleStatistic >> convert: aBoolean [
	^aBoolean isBoolean ifTrue: [aBoolean asParameter] ifFalse: [aBoolean]]

{ #category : #converting }
BooleanSampleStatistic >> convertAll: aCollection [
	^aCollection value collect: [:x | self convert: x value]]

{ #category : #accessing }
BooleanSampleStatistic >> data: aCollection [
	| values |
	values := (aCollection notEmpty
		and: [aCollection anyone isString not]
		and: [aCollection anyone isCollection])
		ifTrue: [aCollection collect: [:period | self convertAll: period]]
		ifFalse: [self convertAll: aCollection].
	super data: values]

{ #category : #histogram }
BooleanSampleStatistic >> histogramClass [
	^DiscreteHistogram]

{ #category : #histogram }
BooleanSampleStatistic >> histogramDomain [
	^#(0 1)]

{ #category : #testing }
BooleanSampleStatistic >> isBooleanValued [
	^true]

