"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #Histogram,
	#superclass : #Object,
	#instVars : [
		'sample',
		'bins',
		'frequencies'
	],
	#category : #Distributions
}

{ #category : #private }
Histogram class >> classFor: sample [
	| values |
	self == Histogram ifFalse: [^self].
	sample isStringValued ifTrue: [^DiscreteHistogram].
	sample hasData ifFalse: [^ContinuousHistogram].
	values := sample data.
	(values conform: [:x | x value isInteger]) ifTrue: [^IntegerHistogram].
	(values conform: [:x | x value isDate]) ifTrue: [^IntegerHistogram].
	^ContinuousHistogram]

{ #category : #'instance creation' }
Histogram class >> domain: interval frequencies: frequencies [
	^self on: nil domain: interval frequencies: frequencies]

{ #category : #examples }
Histogram class >> example [
	"
	ContinuousHistogram example chart open
	"
	| data sample |
	data := (1 to: 20) collect: #atRandom.
	sample := SampleStatistic on: data.
	^Histogram on: sample]

{ #category : #'instance creation' }
Histogram class >> new [
	^super new initialize]

{ #category : #'instance creation' }
Histogram class >> on: sample [
	| class |
	class := self classFor: sample.
	^class new sample: sample]

{ #category : #'instance creation' }
Histogram class >> on: sample numberOfBins: aNumber [
	| histogram |
	histogram := self on: sample.
	^histogram numberOfBins: aNumber]

{ #category : #bibliography }
Histogram class >> references [
	ShellDLL current openWebPage: 'http://en.wikipedia.org/wiki/Histogram']

{ #category : #validation }
Histogram class >> validatorClass [
	^HistogramValidator]

{ #category : #private }
Histogram >> add: x withOccurrences: anInteger [
	x isUndefinedValue ifTrue: [^self].
	bins
		withIndexDo: [:bin :i | (self bin: bin includes: x value)
			ifTrue: [frequencies at: i sum: anInteger]]]

{ #category : #accessing }
Histogram >> bins [
	bins isNil ifTrue: [self calculate].
	^bins]

{ #category : #private }
Histogram >> bins: aCollection [
	bins := aCollection]

{ #category : #private }
Histogram >> calculate [
	self subclassResponsibility]

{ #category : #private }
Histogram >> calculateBins [
	self subclassResponsibility]

{ #category : #private }
Histogram >> calculateFrequencies [
	| n values |
	frequencies := Array new: bins size withAll: 0.
	values := sample valueFrequencies.
	values isNil
		ifTrue: [sample data do: [:x | self add: x withOccurrences: 1]]
		ifFalse: [values
			withOccurrencesDo: [:x :count | self add: x withOccurrences: count]].
	n := sample size asFloat.
	frequencies := frequencies collect: [:count | count asFloat / n]]

{ #category : #accessing }
Histogram >> data [
	^sample data]

{ #category : #accessing }
Histogram >> frequencies [
	frequencies isNil ifTrue: [self calculate].
	^frequencies]

{ #category : #accessing }
Histogram >> frequencies: aCollection [
	frequencies := aCollection]

{ #category : #private }
Histogram >> invalidate [
	bins := frequencies := nil]

{ #category : #testing }
Histogram >> isDiscreteHistogram [
	^false]

{ #category : #testing }
Histogram >> isIntegerHistogram [
	^false]

{ #category : #accessing }
Histogram >> numberOfBins [
	^self bins size]

{ #category : #services }
Histogram >> percentiles [
	^self percentiles: self numberOfBins]

{ #category : #services }
Histogram >> percentiles: count [
	self subclassResponsibility]

{ #category : #accessing }
Histogram >> sample [
	^sample]

{ #category : #accessing }
Histogram >> sample: aSampleStatistic [
	sample := aSampleStatistic.
	self invalidate]

{ #category : #accessing }
Histogram >> values [
	^sample data
		collect: [:d | d value]
		thenSelect: [:v | v isUndefinedValue not]]

