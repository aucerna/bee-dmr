"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SampleStatisticTest,
	#superclass : #TestCase,
	#category : #'Distributions\Tests'
}

{ #category : #percentiles }
SampleStatisticTest >> test0Percentile [
	| sample |
	sample := SampleStatistic sampleInstance.
	self assert: (sample percentile: 0) isNil]

{ #category : #percentiles }
SampleStatisticTest >> testArrayPercentiles [
	| sample periods n |
	sample := SampleStatistic sampleArrayInstance.
	periods := sample percentiles.
	n := periods anyone size.
	periods withIndexDo: [:percentiles :period | 
		percentiles withIndexDo: [:p :i | | percent |
			percent := 100.0 / n * i.
			self assert: p ~ ((sample percentile: percent) at: period)]]]

{ #category : #percentiles }
SampleStatisticTest >> testDatePercentiles [
	| dates sample |
	dates := Array with: Date yesterday with: Date today with: Date tomorrow.
	sample := SampleStatistic on: dates.
	self assert: sample percentiles size = 20]

{ #category : #indicators }
SampleStatisticTest >> testKurtosis [
	| data statistics excel |
	data := #(9.3 10.7 9.4 10.4 10.6 9.8 10.0 10.1 9.6 10.0).
	statistics := SampleStatistic on: data.
	excel := -1.06329492.
	self assert: (statistics kurtosis - excel) abs < 0.000001]

{ #category : #indicators }
SampleStatisticTest >> testOutliers [
	| data statistics outliers hi lo |
	data := Array new: 50 withAll: 0.5.
	data
		at: 8 put: 1.0;
		at: 33 put: 0.9;
		at: 40 put: 0.2.
	statistics := SampleStatistic on: data.
	outliers := statistics outliers.
	self
		assert: outliers size = 3;
		assert: ((outliers collect: #value) equalsTo: #(1.0 0.9 0.2)).
	hi := statistics hiOutliers.
	self
		assert: hi size = 2;
		assert: ((hi collect: #value) equalsTo: #(1.0 0.9)).
	lo := statistics lowOutliers.
	self
		assert: lo size = 1;
		assert: lo anyone value = 0.2]

{ #category : #percentiles }
SampleStatisticTest >> testPercentiles [
	| sample percentiles n |
	sample := SampleStatistic sampleInstance.
	percentiles := sample percentiles.
	n := percentiles size.
	percentiles withIndexDo: [:p :i | | percent |
		percent := 100.0 / n * i.
		self assert: p ~ (sample percentile: percent)]]

{ #category : #indicators }
SampleStatisticTest >> testSkewness [
	| data statistics excel |
	data := #(9.3 10.7 9.4).
	statistics := SampleStatistic on: data.
	excel := 1.700161848.
	self assert: (statistics skewness - excel) abs < 0.000001.
	data := #(9.3 10.7 9.4 10.4 10.6 9.8 10.0 10.1 9.6 10.0).
	statistics := SampleStatistic on: data.
	excel := 0.069403994.
	self assert: (statistics skewness - excel) abs < 0.000001]

{ #category : #indicators }
SampleStatisticTest >> testStandardError [
	| data statistics |
	data := #(9.3 10.7 9.4 10.4 10.6 9.8 10.0 10.1 9.6 10.0).
	statistics := SampleStatistic on: data.
	self
		assert: statistics standardError = (statistics variance / data size) sqrt
		description: 'Standard Error of Mean should be calculated using the estimator of the true distribution variance'.
	self
		deny: statistics standardError
			= (statistics populationVariance / data size) sqrt
		description: 'Standard Error of Mean should be calculated using the estimator of the true distribution variance']

{ #category : #'arrayed samples' }
SampleStatisticTest >> testTP2060 [
	| statistic |
	statistic := SampleStatistic
		on: (Array
			with: #(0.0 0.0 0.0 0.0) asFmlValue
			with: #(0.0 0.0 0.0 0.0) asFmlValue
			with: #(0.0 0.0 0.0 0.0) asFmlValue).
	self assert: statistic skewness size = statistic mean size.
	self assert: statistic kurtosis size = statistic mean size]

{ #category : #percentiles }
SampleStatisticTest >> testTP38812 [
	| integer |
	integer := SampleStatistic on: #(1 1 2 3 4 4 4 4 5).
	self
		precondition: integer isIntegerValued;
		assert: integer histogram bins size = 4;
		assert: integer percentiles size = 20]

{ #category : #percentiles }
SampleStatisticTest >> testTP38812b [
	| integer |
	integer := SampleStatistic on: #(#(1 1) #(2 3) #(4 3)).
	self
		precondition: integer isIntegerValued;
		precondition: integer isArrayValued;
		assert: (integer histograms conform: [:h | h bins size = 2]);
		assert: (integer percentiles conform: [:array | array size = 20])]

{ #category : #'arrayed samples' }
SampleStatisticTest >> testTP6032 [
	| statistic data |
	data := Array
		with: #(0.0 0.0 0.0) asFmlValue
		with: #(0.0 0.0 0.0) asFmlValue.
	data first at: 3 put: Float nan.
	statistic := SampleStatistic on: data.
	self shouldnt: [statistic sum] raise: Error.
	self assert: statistic hasUndefinedValues]

{ #category : #indicators }
SampleStatisticTest >> testTP6968 [
	| n sample statistic mean variance variancePopulation sd sdPopulation skewness kurtosis |
	n := 30.
	sample := NormalDistribution sampleInstance sample: n.
	statistic := SampleStatistic on: sample.
	mean := statistic mean.
	variance := statistic variance.
	variancePopulation := statistic populationVariance.
	sd := statistic sd.
	sdPopulation := statistic populationSD.
	skewness := statistic skewness.
	kurtosis := statistic kurtosis.
	self assert: sample sum / sample size ~ mean.
	self
		assert: (sample collect: [:x | (x - mean) squared]) sum / (n - 1) ~ variance.
	self
		assert: (sample collect: [:x | (x - mean) squared]) sum / n
			~ variancePopulation.
	self assert: variance sqrt = sd.
	self assert: variancePopulation sqrt = sdPopulation.
	self
		assert: (sample collect: [:x | x - mean raisedTo: 3]) sum / (sd
			raisedTo: 3)
			* n
			/ (n - 1.0 * (n - 2.0))
			~ skewness.
	self
		assert: (sample collect: [:x | x - mean raisedTo: 4]) sum / variance squared
			* (n * (n + 1.0) / (n - 1.0 * (n - 2.0) * (n - 3.0)))
			- (3 * (n - 1.0) squared / (n - 2.0) / (n - 3.0))
			~ kurtosis]

{ #category : #indicators }
SampleStatisticTest >> testTP6968B [
	| sample statistic |
	sample := NormalDistribution sampleInstance sample: 30.
	statistic := SampleStatistic on: sample.
	statistic releaseData.
	self
		shouldnt: [
			statistic
				min;
				max;
				mean;
				sum;
				variance;
				sampleVariance;
				populationVariance;
				sd;
				sampleSD;
				populationSD;
				skewness;
				kurtosis;
				standardError]
		raise: Error]

