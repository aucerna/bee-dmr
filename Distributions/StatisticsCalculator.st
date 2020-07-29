"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #StatisticsCalculator,
	#superclass : #Object,
	#instVars : [
		'sum',
		'min',
		'max',
		'n',
		'm1',
		'm2',
		'm3',
		'm4',
		'undefined',
		'values',
		'statistic',
		'outliers',
		'bounds',
		'frequencies',
		'percentiles'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
StatisticsCalculator class >> new [
	^super new initialize]

{ #category : #'instance creation' }
StatisticsCalculator class >> on: aSampleStatistic [
	^self new on: aSampleStatistic]

{ #category : #adding }
StatisticsCalculator >> adapt: value [
	^value]

{ #category : #adding }
StatisticsCalculator >> addValue: value [
	values add: value]

{ #category : #adding }
StatisticsCalculator >> append: value [
	| d n2 n3 d2 d3 d4 x |
	x := self adapt: value.
	n = 0.0 ifTrue: [self initializeWith: x] ifFalse: [self updateWith: x].
	self updateValuesWith: x.
	n := n + 1.0.
	d := x - m1.
	m1 := m1 + (d / n).
	n2 := n squared asFloat.
	n3 := n2 * n asFloat.
	d2 := d squared.
	d3 := d2 * d.
	d4 := d2 * d2.
	m4 := d4 * (n - 1.0) * (n2 - (3.0 * n) + 3.0) / n3 + m4 + (d2 * 6.0 * m2
		/ n2)
		- (d * 4.0 * m3 / n).
	m3 := d3 * (n - 1.0) * (n - 2.0) / n2 + m3 - (3 * d * m2 / n).
	m2 := d2 * (n - 1.0) / n + m2]

{ #category : #calculation }
StatisticsCalculator >> calculate [
	statistic hasData ifFalse: [^self].
	statistic data do: [:x | self append: x value]]

{ #category : #calculation }
StatisticsCalculator >> calculateHistogram [
	| m histogram |
	statistic hasData ifFalse: [^self].
	statistic propertyAt: #valueFrequencies put: self values.
	m := statistic percentileCount.
	histogram := statistic histogram.
	frequencies := histogram frequencies.
	percentiles := histogram percentiles: m]

{ #category : #calculation }
StatisticsCalculator >> calculateOutliers [
	| hi low regular |
	low := statistic lowOutlierLimit.
	low isUndefinedValue ifTrue: [^self].
	hi := statistic hiOutlierLimit.
	hi isUndefinedValue ifTrue: [^self].
	outliers := OrderedCollection new.
	regular := OrderedCollection new.
	statistic data reject: [:v | v isUndefinedValue] thenDo: [:v | 
		(v value between: low and: hi)
			ifTrue: [regular add: v]
			ifFalse: [outliers add: v]].
	bounds := {regular min. regular max}]

{ #category : #testing }
StatisticsCalculator >> calculatesPercentiles [
	^false]

{ #category : #testing }
StatisticsCalculator >> canRetryOn: anError [
	^false]

{ #category : #accessing }
StatisticsCalculator >> device [
	^nil]

{ #category : #accessing }
StatisticsCalculator >> frequencies [
	frequencies isNil ifTrue: [self calculateHistogram].
	^frequencies]

{ #category : #testing }
StatisticsCalculator >> hasUndefinedValues [
	^undefined > 0]

{ #category : #initialization }
StatisticsCalculator >> initialize [
	super initialize.
	n := m1 := m2 := m3 := m4 := undefined := 0.0.
	values := Bag new]

{ #category : #initialization }
StatisticsCalculator >> initializeWith: value [
	sum := value.
	min := value.
	max := value.
	value isUndefinedValue ifTrue: [undefined := 1]]

{ #category : #testing }
StatisticsCalculator >> isArrayCalculator [
	^false]

{ #category : #estimators }
StatisticsCalculator >> kurtosis [
	m2 isUndefinedValue ifTrue: [^m2].
	n <= 3.0 ifTrue: [^m1 zero].
	m2 isZero ifTrue: [^m2 value].
	^m4 * (n - 1.0 * n * (n + 1.0) / (n - 2.0 * (n - 3.0))) / m2 squared
		- (3.0 * (n - 1.0) squared / (n - 2.0 * (n - 3.0)))]

{ #category : #estimators }
StatisticsCalculator >> max [
	^max]

{ #category : #accessing }
StatisticsCalculator >> maxBound [
	^bounds notNil ifTrue: [bounds last]]

{ #category : #accessing }
StatisticsCalculator >> maxValues [
	^60]

{ #category : #estimators }
StatisticsCalculator >> mean [
	^m1]

{ #category : #estimators }
StatisticsCalculator >> min [
	^min]

{ #category : #accessing }
StatisticsCalculator >> minBound [
	^bounds notNil ifTrue: [bounds first]]

{ #category : #accessing }
StatisticsCalculator >> on: aSampleStatistic [
	statistic := aSampleStatistic]

{ #category : #accessing }
StatisticsCalculator >> outliers [
	^outliers]

{ #category : #accessing }
StatisticsCalculator >> percentiles [
	percentiles isNil ifTrue: [self calculateHistogram].
	^percentiles]

{ #category : #testing }
StatisticsCalculator >> shouldInvalidateValues [
	^values elements size > self maxValues]

{ #category : #accessing }
StatisticsCalculator >> size [
	^n]

{ #category : #estimators }
StatisticsCalculator >> skewness [
	n <= 2.0 ifTrue: [^m2 zero].
	m2 isZero ifTrue: [^m2 value].
	m2 isUndefinedValue ifTrue: [^m2].
	^m3 * (n * (n - 1.0) sqrt / (n - 2.0)) / (m2 raisedTo: 1.5)]

{ #category : #estimators }
StatisticsCalculator >> sum [
	^sum]

{ #category : #accessing }
StatisticsCalculator >> undefinedCount [
	^undefined]

{ #category : #adding }
StatisticsCalculator >> updateValuesWith: value [
	values isNil ifTrue: [^self].
	self addValue: value.
	self shouldInvalidateValues ifTrue: [values := nil]]

{ #category : #adding }
StatisticsCalculator >> updateWith: x [
	sum := sum + x.
	min := x isUndefinedValue ifTrue: [min] ifFalse: [min min: x].
	max := x isUndefinedValue ifTrue: [max] ifFalse: [max max: x].
	x isUndefinedValue ifTrue: [undefined := undefined + 1]]

{ #category : #accessing }
StatisticsCalculator >> values [
	^values]

{ #category : #estimators }
StatisticsCalculator >> variance [
	n = 0.0 ifTrue: [^m2 zero].
	^m2 / n]

