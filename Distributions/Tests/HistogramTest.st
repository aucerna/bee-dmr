"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HistogramTest,
	#superclass : #TestCase,
	#category : #'Distributions\Tests'
}

{ #category : #all }
HistogramTest >> testBasicHistogram [
	| distribution sample histogram |
	distribution := NormalDistribution mean: 0 deviation: 1.
	distribution uniform: self random.
	sample := SampleStatistic on: (distribution sample: 100).
	histogram := Histogram on: sample numberOfBins: 10.
	self
		assert: histogram bins size = 10;
		assert: histogram frequencies sum ~ 1.0]

{ #category : #all }
HistogramTest >> testBinWidthHistogram [
	| distribution sample min max histogram |
	distribution := NormalDistribution mean: 0 deviation: 1.
	distribution uniform: self random.
	sample := SampleStatistic on: (distribution sample: 100).
	min := sample min value.
	max := sample max value.
	histogram := ContinuousHistogram on: sample binWidth: max - min / 10.0.
	self
		assert: histogram bins size = 10;
		assert: histogram frequencies sum ~ 1.0]

{ #category : #all }
HistogramTest >> testDateHistogram [
	| distribution sample histogram |
	distribution := DateDistribution
		between: Date today
		and: (Date today addDays: 200).
	distribution uniform: self random.
	sample := SampleStatistic on: (distribution sample: 50).
	histogram := Histogram on: sample numberOfBins: 20.
	self
		assert: histogram bins size = 20;
		assert: histogram frequencies sum ~ 1.0]

{ #category : #dates }
HistogramTest >> testInvalidDateHistogram [
	| distribution sample histogram |
	distribution := DateDistribution
		between: Date today
		and: (Date today addDays: 10).
	distribution uniform: self random.
	sample := SampleStatistic on: (distribution sample: 100).
	histogram := Histogram on: sample numberOfBins: 20.
	self assert: histogram numberOfBins = 10]

{ #category : #all }
HistogramTest >> testPercentiles [
	| distribution data sample histogram percentiles n |
	distribution := NormalDistribution mean: 0 deviation: 1.
	distribution uniform: self random.
	n := 1000.
	data := distribution sample: n.
	sample := SampleStatistic on: data.
	histogram := Histogram on: sample numberOfBins: 5.
	#testTP26453.
	percentiles := histogram percentiles.
	percentiles withIndexDo: [:xi :i | | p count |
		p := i / 5.0.
		count := data count: [:xj | xj <= xi].
		self assert: (p between: count - 1 / n asFloat and: count + 1 / n asFloat)]]

{ #category : #all }
HistogramTest >> testSingleHistogram [
	| sample histogram validation |
	sample := SampleStatistic on: #(10 10 10 10 10 10 10 10 10 10).
	histogram := Histogram on: sample numberOfBins: 5.
	validation := histogram validate.
	self
		assert: validation hasValidationWarnings;
		assert: histogram percentiles notEmpty;
		assert: histogram percentiles asSet asArray = #(10)]

{ #category : #strings }
HistogramTest >> testStringHistogram [
	| sample histogram |
	sample := SampleStatistic
		on: #('e' 'e' 'aa' 'aa' 'bb' 'aa' 'bb' 'c' 'd' 'e').
	histogram := Histogram on: sample.
	self
		assert: histogram validate hasPassed;
		assert: histogram numberOfBins = 5;
		assert: histogram frequencies first ~ 0.3]

{ #category : #all }
HistogramTest >> testTP21981 [
	| sample histogram validation |
	sample := SampleStatistic on: #(10 10 10 10 10 10 10 10 10 10).
	sample releaseData.
	histogram := Histogram on: sample numberOfBins: 5.
	validation := histogram validate.
	self
		assert: validation hasValidationWarnings;
		assert: histogram frequencies = (Array with: 1.0)]

{ #category : #all }
HistogramTest >> testTP22286 [
	| s h |
	s := SampleStatistic on: #(0).
	h := Histogram on: s numberOfBins: 0.
	self
		assert: h numberOfBins = 1;
		assert: h percentiles size = 1]

{ #category : #strings }
HistogramTest >> testTP22575 [
	| sample histogram |
	sample := SampleStatistic on: #('a' 'b' 'c' 'd').
	histogram := Histogram on: sample.
	self
		assert: histogram numberOfBins = 4
		description: 'There should be as much bins as different strings in the sample']

{ #category : #integers }
HistogramTest >> testTP31111 [
	| sample histogram bins |
	sample := SampleStatistic on: (1 to: 27).
	histogram := Histogram on: sample numberOfBins: 20.
	self
		assert: histogram validate hasPassed;
		assert: histogram numberOfBins = 20.
	bins := histogram bins groupBy: [:bin | bin last - bin first].
	self assert: bins keys asArray sort = #(1 7)]

{ #category : #integers }
HistogramTest >> testTP31111b [
	| sample histogram |
	sample := SampleStatistic on: (0 to: 10).
	histogram := Histogram on: sample numberOfBins: 20.
	self assert: histogram numberOfBins = 10]

{ #category : #integers }
HistogramTest >> testTP31111c [
	| sample histogram1 histogram2 |
	sample := SampleStatistic on: (0 to: 100).
	histogram1 := Histogram on: sample numberOfBins: 20.
	self
		precondition: histogram1 bins size = 20;
		precondition: histogram1 frequencies sum ~ 1.0.
	histogram2 := histogram1 class
		from: 0
		to: 100
		frequencies: histogram1 frequencies.
	self assert: (histogram2 bins equalsTo: histogram1 bins)]

