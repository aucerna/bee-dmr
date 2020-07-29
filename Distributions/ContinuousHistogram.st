"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ContinuousHistogram,
	#superclass : #Histogram,
	#instVars : [
		'min',
		'max',
		'k',
		'h'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
ContinuousHistogram class >> from: min to: max frequencies: frequencies [
	"
	ContinuousHistogram from: 1 to: 10 frequencies: #(0.5 0.3 0.2 0.0).
	ContinuousHistogram from: 1 to: 10 frequencies: #(0.5).
	"
	^self new from: min to: max frequencies: frequencies]

{ #category : #'instance creation' }
ContinuousHistogram class >> on: sample binWidth: aNumber [
	| histogram |
	histogram := self on: sample.
	^histogram binWidth: aNumber]

{ #category : #'instance creation' }
ContinuousHistogram class >> on: sample domain: interval frequencies: frequencies [
	"
	ContinuousHistogram on: nil domain: (1 to: 10) frequencies: #(0.5 0.3 0.2 0.0).
	ContinuousHistogram on: domain: (1 to: 10) frequencies: #(0.5).
	"
	^self new
		sample: sample;
		from: interval first to: interval last frequencies: frequencies]

{ #category : #'instance creation' }
ContinuousHistogram class >> on: sample domain: interval numberOfBins: anInteger [
	^self on: sample numberOfBins: anInteger]

{ #category : #converting }
ContinuousHistogram >> asDiscreteHistogram [
	^DiscreteHistogram new
		sample: sample;
		bins: (self bins collect: #last);
		frequencies: frequencies copy]

{ #category : #testing }
ContinuousHistogram >> bin: bin includes: x [
	^bin first <~ x and: [bin last = max orNot: [bin last <~ x]]]

{ #category : #private }
ContinuousHistogram >> binFrom: a to: b [
	^{a. b}]

{ #category : #accessing }
ContinuousHistogram >> binWidth [
	^h]

{ #category : #accessing }
ContinuousHistogram >> binWidth: anInteger [
	h := anInteger.
	k := nil.
	self invalidate]

{ #category : #private }
ContinuousHistogram >> calculate [
	| valid |
	valid := self
		passesValidation: [:v | v
			validateSample;
			validateNumberOfBins;
			validateBinWidth].
	valid ifFalse: [^self].
	k notNil ifTrue: [self calculateH] ifFalse: [self calculateK].
	h = 0 ifTrue: [^self calculateSingle].
	self calculateBins; calculateFrequencies]

{ #category : #private }
ContinuousHistogram >> calculateBins [
	| left bin |
	bins := Array new: k.
	left := min.
	(1 to: k - 1) do: [:i | | right |
		right := i * h + min.
		bin := self binFrom: left to: right.
		bins at: i put: bin.
		left := right].
	bin := self binFrom: left to: max.
	bins at: k put: bin]

{ #category : #private }
ContinuousHistogram >> calculateH [
	h := max - min / k asFloat]

{ #category : #private }
ContinuousHistogram >> calculateK [
	k := (max - min / h) asInteger]

{ #category : #private }
ContinuousHistogram >> calculateSingle [
	| x |
	x := sample min value.
	bins := {self binFrom: x to: x}.
	frequencies := #(1.0)]

{ #category : #accessing }
ContinuousHistogram >> from: x1 to: xn frequencies: aCollection [
	| data |
	self min: x1; max: xn.
	frequencies := aCollection.
	k := frequencies size.
	self calculateH; calculateBins.
	data := (bins collect: #first) copyWith: bins last last.
	sample notNil
		ifTrue: [sample hasData ifFalse: [sample data: data]]
		ifFalse: [sample := SampleStatistic on: data]]

{ #category : #initialization }
ContinuousHistogram >> initialize [
	super initialize.
	k := 10]

{ #category : #private }
ContinuousHistogram >> interpolatedPercentile: p from: values [
	| n i0 i1 v0 v1 c0 c1 |
	n := values size.
	i0 := (n * p) truncated.
	i0 < 1 ifTrue: [^values at: 1].
	i0 = n ifTrue: [^values at: n].
	i1 := i0 + 1.
	[i0 > 1 and: [(values at: i0) ~ (values at: i0 + 1)]]
		whileTrue: [i0 := i0 - 1].
	[i1 < n and: [(values at: i1) ~ (values at: i1 + 1)]]
		whileTrue: [i1 := i1 + 1].
	v0 := values at: i0.
	v0 isUndefinedValue ifTrue: [^self percentile: p from: values].
	v1 := values at: i1.
	v1 isUndefinedValue ifTrue: [^self percentile: p from: values].
	c0 := i0 asFloat / n asFloat.
	c0 >~ p ifTrue: [^v0].
	c1 := i1 asFloat / n asFloat.
	^(v1 - v0 / (c1 - c0) * (p - c0)) asFloat + v0]

{ #category : #accessing }
ContinuousHistogram >> max [
	^max]

{ #category : #accessing }
ContinuousHistogram >> max: aMagnitude [
	max := aMagnitude]

{ #category : #accessing }
ContinuousHistogram >> min [
	^min]

{ #category : #accessing }
ContinuousHistogram >> min: aMagnitude [
	min := aMagnitude]

{ #category : #accessing }
ContinuousHistogram >> numberOfBins [
	^k]

{ #category : #accessing }
ContinuousHistogram >> numberOfBins: anInteger [
	k := anInteger.
	h := nil.
	self invalidate]

{ #category : #private }
ContinuousHistogram >> percentile: p from: values [
	| i j |
	p = 0.0 ifTrue: [^nil].
	p = 1.0 ifTrue: [^values last].
	i := p * values size.
	j := i truncated max: 1.
	i != j ifTrue: [j := i ceiling].
	^values at: j]

{ #category : #services }
ContinuousHistogram >> percentiles: count [
	| percents values step distribution |
	count = 0 ifTrue: [^#()].
	values := sample data collect: [:x | | v | v := x value].
	^sample valueFrequencies isNil
		ifTrue: [
			step := 1.0 / count.
			percents := step to: 1 by: step.
			values := self sort: values.
			percents collect: [:p | self interpolatedPercentile: p from: values]]
		ifFalse: [
			distribution := SampleSpace on: values.
			distribution
				frequencies: sample valueFrequencies elements;
				interpolatedPercentiles: count]]

{ #category : #accessing }
ContinuousHistogram >> sample: aSampleStatistic [
	super sample: aSampleStatistic.
	sample isNil
		ifTrue: [self min: nil; max: nil]
		ifFalse: [self min: sample min value; max: sample max value]]

{ #category : #formulas }
ContinuousHistogram >> scottBinWidth [
	| sigma n |
	sigma := sample sd value.
	n := sample size.
	h := 3.5 * sigma / (n raisedTo: 1 / 3)]

{ #category : #private }
ContinuousHistogram >> sort: aCollection [
	| all undefined |
	all := OrderedCollection new.
	undefined := OrderedCollection new.
	aCollection
		do: [:x | x isUndefinedValue
			ifTrue: [undefined add: x]
			ifFalse: [all add: x]].
	all sort addAllFirst: undefined.
	^all]

{ #category : #formulas }
ContinuousHistogram >> squareRootNumberOfBins [
	| n |
	n := sample size.
	k := n sqrt]

{ #category : #formulas }
ContinuousHistogram >> sturgesNumberOfBins [
	| n |
	n := sample size.
	k := ((n log: 2) + 1) ceiling]

