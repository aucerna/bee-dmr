"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #StringStatisticsCalculator,
	#superclass : #StatisticsCalculator,
	#category : #Distributions
}

{ #category : #accessing }
StringStatisticsCalculator >> append: string [
	min := min isNil ifTrue: [string] ifFalse: [string min: min].
	max := max isNil ifTrue: [string] ifFalse: [string max: max].
	self updateValuesWith: string]

{ #category : #calculation }
StringStatisticsCalculator >> calculate [
	super calculate.
	n := statistic data size.
	m1 := min = max ifTrue: [min] ifFalse: [nil asFmlValue].
	m2 := m3 := m4 := min = max ifTrue: [0] ifFalse: [nil asFmlValue]]

{ #category : #calculation }
StringStatisticsCalculator >> calculateHistogram [
	| calculator |
	statistic isArrayValued
		ifTrue: [
			calculator := ArrayStatisticsCalculator on: statistic.
			calculator calculateHistogram.
			percentiles := calculator percentiles.
			frequencies := calculator frequencies]
		ifFalse: [super calculateHistogram]]

{ #category : #accessing }
StringStatisticsCalculator >> kurtosis [
	^nil asFmlValue]

