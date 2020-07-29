"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #NoNumericStatisticsCalculator,
	#superclass : #StatisticsCalculator,
	#instVars : [
		'calculator'
	],
	#category : #Distributions
}

{ #category : #adding }
NoNumericStatisticsCalculator >> append: x [
	| y |
	y := self adapt: x.
	calculator append: y]

{ #category : #calculation }
NoNumericStatisticsCalculator >> calculate [
	super calculate.
	n := calculator size.
	sum := self convert: calculator sum.
	max := self convert: calculator max.
	min := self convert: calculator min.
	self convertValues]

{ #category : #calculation }
NoNumericStatisticsCalculator >> calculateHistogram [
	statistic isArrayValued
		ifTrue: [
			statistic propertyAt: #valueFrequencies put: self values.
			calculator calculateHistogram.
			percentiles := calculator percentiles.
			frequencies := calculator frequencies]
		ifFalse: [super calculateHistogram]]

{ #category : #private }
NoNumericStatisticsCalculator >> convertValues [
	values := calculator values.
	values isNil ifTrue: [^self].
	calculator isArrayCalculator
		ifTrue: [values := values collect: [:period | self convertValues: period]]
		ifFalse: [values := self convertValues: values]]

{ #category : #private }
NoNumericStatisticsCalculator >> convertValues: aCollection [
	| converted |
	converted := Bag new: aCollection size.
	aCollection withOccurrencesDo: [:x :count | | y |
		y := self convert: x.
		converted add: y withOccurrences: count].
	^converted]

{ #category : #accessing }
NoNumericStatisticsCalculator >> initializeCalculatorWith: aSampleStatistic [
	calculator := aSampleStatistic isArrayValued
		ifTrue: [ArrayStatisticsCalculator on: aSampleStatistic]
		ifFalse: [StatisticsCalculator on: aSampleStatistic]]

{ #category : #estimators }
NoNumericStatisticsCalculator >> kurtosis [
	^calculator kurtosis]

{ #category : #estimators }
NoNumericStatisticsCalculator >> mean [
	^self convert: calculator mean]

{ #category : #accessing }
NoNumericStatisticsCalculator >> on: aSampleStatistic [
	self initializeCalculatorWith: aSampleStatistic.
	super on: aSampleStatistic]

{ #category : #accessing }
NoNumericStatisticsCalculator >> size [
	^calculator size]

{ #category : #estimators }
NoNumericStatisticsCalculator >> skewness [
	^calculator skewness]

{ #category : #estimators }
NoNumericStatisticsCalculator >> variance [
	^calculator variance]

