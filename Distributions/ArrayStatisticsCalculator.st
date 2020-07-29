"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ArrayStatisticsCalculator,
	#superclass : #StatisticsCalculator,
	#instVars : [
		'periods'
	],
	#category : #Distributions
}

{ #category : #initialization }
ArrayStatisticsCalculator >> adapt: value [
	^value isArrayValued
		ifTrue: [value asFloatArray]
		ifFalse: [FloatArray new: periods withAll: value]]

{ #category : #adding }
ArrayStatisticsCalculator >> addValue: value [
	value isArrayValued
		ifTrue: [values with: value do: [:period :x | period add: x]]
		ifFalse: [values do: [:period | period add: value]]]

{ #category : #calculation }
ArrayStatisticsCalculator >> calculateHistogram [
	| m histograms |
	statistic hasData ifFalse: [^self].
	statistic propertyAt: #valueFrequencies ifAbsentPut: [self values].
	m := statistic percentileCount.
	histograms := statistic histograms.
	frequencies := histograms collect: #frequencies.
	percentiles := histograms collect: [:h | h percentiles: m].
	statistic removeProperty: #periodStatistics ifAbsent: nil]

{ #category : #adding }
ArrayStatisticsCalculator >> convert: array [
	| result |
	result := Array new: array size.
	array withIndexDo: [:v :i | | w |
		w := v isUndefinedValue ifTrue: [v asFmlValue] ifFalse: [v].
		result at: i put: w].
	^result]

{ #category : #initialization }
ArrayStatisticsCalculator >> initializeWith: value [
	sum := value copy.
	min := value copy.
	max := value copy.
	values := Array new: periods.
	1 to: values size do: [:i | values at: i put: Bag new]]

{ #category : #testing }
ArrayStatisticsCalculator >> isArrayCalculator [
	^true]

{ #category : #adding }
ArrayStatisticsCalculator >> kurtosis [
	^self convert: super kurtosis]

{ #category : #adding }
ArrayStatisticsCalculator >> max [
	^self convert: super max]

{ #category : #adding }
ArrayStatisticsCalculator >> mean [
	^self convert: super mean]

{ #category : #adding }
ArrayStatisticsCalculator >> min [
	^self convert: super min]

{ #category : #accessing }
ArrayStatisticsCalculator >> on: aSampleStatistic [
	periods := aSampleStatistic arraySize.
	^super on: aSampleStatistic]

{ #category : #accessing }
ArrayStatisticsCalculator >> periods: anInteger [
	periods := anInteger]

{ #category : #testing }
ArrayStatisticsCalculator >> shouldInvalidateValues [
	^values first elements size > self maxValues]

{ #category : #adding }
ArrayStatisticsCalculator >> skewness [
	^self convert: super skewness]

{ #category : #adding }
ArrayStatisticsCalculator >> updateWith: x [
	sum += x.
	min fmlMin: x.
	max fmlMax: x]

{ #category : #adding }
ArrayStatisticsCalculator >> variance [
	^self convert: super variance]

