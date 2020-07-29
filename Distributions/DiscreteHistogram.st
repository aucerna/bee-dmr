"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #DiscreteHistogram,
	#superclass : #Histogram,
	#category : #Distributions
}

{ #category : #examples }
DiscreteHistogram class >> example [
	"
	DiscreteHistogram example chart open
	"
	| sample |
	sample := SampleStatistic on: #('a' 'a' 'b' 'c' 'c').
	^Histogram on: sample]

{ #category : #'instance creation' }
DiscreteHistogram class >> on: sample domain: domain [
	^self new sample: sample; bins: domain]

{ #category : #'instance creation' }
DiscreteHistogram class >> on: sample domain: domain frequencies: frequencies [
	^self new
		sample: sample;
		bins: domain;
		frequencies: frequencies]

{ #category : #'instance creation' }
DiscreteHistogram class >> on: sample domain: interval numberOfBins: anInteger [
	^self on: sample domain: interval]

{ #category : #testing }
DiscreteHistogram >> bin: bin includes: x [
	^bin = x]

{ #category : #private }
DiscreteHistogram >> calculate [
	self validate hasPassed ifFalse: [^self].
	self calculateBins; calculateFrequencies]

{ #category : #private }
DiscreteHistogram >> calculateBins [
	bins notNil ifTrue: [^self].
	bins := self values asSet asArray sort]

{ #category : #testing }
DiscreteHistogram >> isDiscreteHistogram [
	^true]

{ #category : #services }
DiscreteHistogram >> percentiles: count [
	| values distribution m |
	m := count min: self numberOfBins.
	values := sample data collect: #value.
	distribution := SampleSpace on: values.
	sample valueFrequencies notNil
		ifTrue: [distribution frequencies: sample valueFrequencies elements].
	^distribution percentiles: m]

