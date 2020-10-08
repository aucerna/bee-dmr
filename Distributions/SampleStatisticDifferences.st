"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SampleStatisticDifferences,
	#superclass : #Object,
	#instVars : [
		'sample',
		'referent',
		'diff',
		'coherent'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
SampleStatisticDifferences class >> between: aSampleStatistic and: baseSampleStatistic [
	^self new between: aSampleStatistic and: baseSampleStatistic]

{ #category : #services }
SampleStatisticDifferences >> atPeriod: anInteger [
	^diff atPeriod: anInteger]

{ #category : #accessing }
SampleStatisticDifferences >> between: aSampleStatistics and: anotherSampleStatistics [
	sample := aSampleStatistics.
	referent := anotherSampleStatistics.
	diff := sample copy]

{ #category : #accessing }
SampleStatisticDifferences >> coherentSamples: aBoolean [
	coherent := aBoolean.
	self updateData]

{ #category : #calculations }
SampleStatisticDifferences >> correlationCoefficient: aSampleStatistics [
	^diff correlationCoefficient: aSampleStatistics]

{ #category : #calculations }
SampleStatisticDifferences >> correlationCoefficientWith: aSampleStatistics [
	^diff correlationCoefficientWith: aSampleStatistics]

{ #category : #calculations }
SampleStatisticDifferences >> covariance: aSampleStatistics [
	^sample covariance: aSampleStatistics]

{ #category : #accessing }
SampleStatisticDifferences >> data [
	^diff data]

{ #category : #accessing }
SampleStatisticDifferences >> data: aCollection [
	sample data: aCollection.
	diff data: aCollection.
	self updateData]

{ #category : #accessing }
SampleStatisticDifferences >> dataAt: i [
	^diff dataAt: i]

{ #category : #testing }
SampleStatisticDifferences >> hasData [
	^sample hasData]

{ #category : #testing }
SampleStatisticDifferences >> hasDensityData [
	^sample hasDensityData]

{ #category : #testing }
SampleStatisticDifferences >> hasUndefinedValues [
	^sample hasUndefinedValues]

{ #category : #testing }
SampleStatisticDifferences >> histogram [
	^diff histogram]

{ #category : #testing }
SampleStatisticDifferences >> isArrayValued [
	^sample isArrayValued]

{ #category : #testing }
SampleStatisticDifferences >> isBooleanValued [
	^sample isBooleanValued]

{ #category : #testing }
SampleStatisticDifferences >> isConstant [
	^sample isConstant]

{ #category : #testing }
SampleStatisticDifferences >> isDateValued [
	^sample isDateValued]

{ #category : #testing }
SampleStatisticDifferences >> isDifferences [
	^true]

{ #category : #testing }
SampleStatisticDifferences >> isIntegerValued [
	^sample isIntegerValued]

{ #category : #testing }
SampleStatisticDifferences >> isNumberValued [
	^sample isNumberValued]

{ #category : #testing }
SampleStatisticDifferences >> isSingleValued [
	^sample isSingleValued]

{ #category : #testing }
SampleStatisticDifferences >> isStringValued [
	^sample isStringValued]

{ #category : #testing }
SampleStatisticDifferences >> isTableValued [
	^sample isTableValued]

{ #category : #services }
SampleStatisticDifferences >> kernelDensityWithBandwidth: smoothing [
	^diff kernelDensityWithBandwidth: smoothing]

{ #category : #estimators }
SampleStatisticDifferences >> kurtosis [
	^sample kurtosis - referent kurtosis]

{ #category : #estimators }
SampleStatisticDifferences >> max [
	^sample max - referent max]

{ #category : #estimators }
SampleStatisticDifferences >> mean [
	^sample mean - referent mean]

{ #category : #estimators }
SampleStatisticDifferences >> min [
	^sample min - referent min]

{ #category : #estimators }
SampleStatisticDifferences >> numData [
	^sample numData]

{ #category : #percentiles }
SampleStatisticDifferences >> percentile: percent [
	| index |
	index := sample indexOfPercentile: percent.
	index > 0 ifFalse: [^nil].
	self isSingleValued ifTrue: [^self percentiles at: index].
	^self percentiles collect: [:array | 
		array size = 1
			ifTrue: [array isUndefinedValue ifTrue: [array] ifFalse: [array anyone]]
			ifFalse: [array at: index]]]

{ #category : #estimators }
SampleStatisticDifferences >> percentiles [
	^sample percentiles with: referent percentiles collect: [:v :b | v - b]]

{ #category : #percentiles }
SampleStatisticDifferences >> percentileSize [
	^sample percentileSize]

{ #category : #estimators }
SampleStatisticDifferences >> populationSD [
	^sample populationSD - referent populationSD]

{ #category : #estimators }
SampleStatisticDifferences >> populationVariance [
	^sample populationVariance - referent populationVariance]

{ #category : #estimators }
SampleStatisticDifferences >> sampleVariance [
	^sample sampleVariance - referent sampleVariance]

{ #category : #estimators }
SampleStatisticDifferences >> sd [
	^sample sd - referent sd]

{ #category : #estimators }
SampleStatisticDifferences >> skewness [
	^sample skewness - referent skewness]

{ #category : #estimators }
SampleStatisticDifferences >> standardError [
	^sample standardError - referent standardError]

{ #category : #estimators }
SampleStatisticDifferences >> sum [
	^sample sum - referent sum]

{ #category : #accessing }
SampleStatisticDifferences >> undefinedCount [
	^sample undefinedCount]

{ #category : #updating }
SampleStatisticDifferences >> updateData [
	diff hasData ifFalse: [^self].
	diff setSamplesDifferencesWith: referent coherent: coherent; update]

{ #category : #estimators }
SampleStatisticDifferences >> variance [
	^sample variance - referent variance]

