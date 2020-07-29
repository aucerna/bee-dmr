"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #UniformDistribution,
	#superclass : #ContinuousProbabilityDistribution,
	#instVars : [
		'start',
		'stop'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
UniformDistribution class >> around: aNumber [
	| value start stop |
	value := aNumber asFloat.
	value = 0.0
		ifTrue: [
			start := -0.75.
			stop := 1.25]
		ifFalse: [
			start := value * 0.75.
			stop := value * 1.25].
	^self from: (start min: stop) to: (start max: stop).
"
	UniformDistribution around: -1
"]

{ #category : #'instance creation' }
UniformDistribution class >> between: n and: m [
	^self from: n to: m]

{ #category : #'instance creation' }
UniformDistribution class >> default [
	^self from: 0 to: 1]

{ #category : #'instance creation' }
UniformDistribution class >> from: start to: stop [
	| validation |
	validation := self
		runValidation: #validateUniformFrom:to:
		with: start
		with: stop.
	^validation hasPassed ifTrue: [self new start: start stop: stop]]

{ #category : #examples }
UniformDistribution class >> sampleInstance [
	^self around: 100.0]

{ #category : #examples }
UniformDistribution class >> sampleSize [
	^1200]

{ #category : #validation }
UniformDistribution >> addValidationSelectorsTo: aCollection [
	super addValidationSelectorsTo: aCollection.
	aCollection add: #uniformValidation]

{ #category : #converting }
UniformDistribution >> asJson [
	^super asJson
		at: 'Min' put: start;
		at: 'Max' put: stop;
		yourself]

{ #category : #services }
UniformDistribution >> convertValuesWith: aNumber [
	self start: start * aNumber stop: stop * aNumber]

{ #category : #'probability functions' }
UniformDistribution >> density: x [
	^(x between: start and: stop)
		ifTrue: [(stop - start) reciprocal]
		ifFalse: [0.0]]

{ #category : #'probability functions' }
UniformDistribution >> distribution: x [
	x < start ifTrue: [^0.0].
	stop < x ifTrue: [^1.0].
	^x - start / (stop - start)]

{ #category : #printing }
UniformDistribution >> explain [
	^'Number of times that each integer value between '
		, start rounded printString
		, ' and '
		, stop rounded printString
		, ' has been randomly choosen']

{ #category : #converting }
UniformDistribution >> fromJson: aJsonObject [
	self start: aJsonObject Min stop: aJsonObject Max]

{ #category : #services }
UniformDistribution >> gaps: n [
	"
	[10000 timesRepeat: [UniformDistribution new gaps: 5000]] timeToRun
	"
	| u |
	u := Array new: n + 1.
	u
		at: 1 put: 0.0;
		at: n + 1 put: 1.0.
	2 to: n do: [:i | u at: i put: self next].
	^u sort increments]

{ #category : #services }
UniformDistribution >> gapsOn: aCollection [
	"
	| a |
	a := Array new: 3001.
	[1000 timesRepeat: [UniformDistribution new gapsOn: a]] timeToRun
	"
	| n u0 |
	n := aCollection size.
	aCollection
		at: 1 put: 0.0;
		at: n put: 1.0.
	2 to: n - 1 do: [:i | aCollection at: i put: self next].
	aCollection sort.
	u0 := 0.0.
	2 to: n do: [:i | | ui |
		ui := aCollection at: i.
		aCollection at: i - 1 put: ui - u0.
		u0 := ui]]

{ #category : #initialization }
UniformDistribution >> initialize [
	super initialize.
	start := 0.0.
	stop := 1.0]

{ #category : #'probability functions' }
UniformDistribution >> inverseDistribution: u [
	self ASSERT: (u between: 0 and: 1).
	^stop - start * u + start]

{ #category : #inquiries }
UniformDistribution >> isConsistentWith: deterministicValue [
	^deterministicValue isNumber
		and: [self isConsistentWithBounds: deterministicValue]]

{ #category : #inquiries }
UniformDistribution >> isLike: aProbabilityDistribution [
	^(super isLike: aProbabilityDistribution)
		and: [self min = aProbabilityDistribution min]
		and: [self max = aProbabilityDistribution max]]

{ #category : #testing }
UniformDistribution >> isUniform [
	^true]

{ #category : #estimators }
UniformDistribution >> kurtosis [
	"http://mathworld.wolfram.com/Kurtosis.html"
	^-1.2]

{ #category : #estimators }
UniformDistribution >> max [
	^stop]

{ #category : #private }
UniformDistribution >> max: aNumber [
	self start: start stop: aNumber]

{ #category : #estimators }
UniformDistribution >> mean [
	^start + stop / 2]

{ #category : #estimators }
UniformDistribution >> median [
	^self mean]

{ #category : #estimators }
UniformDistribution >> min [
	^start]

{ #category : #private }
UniformDistribution >> min: aNumber [
	self start: aNumber stop: stop]

{ #category : #printing }
UniformDistribution >> parameterArray [
	^{self min. self max}]

{ #category : #accessing }
UniformDistribution >> parameters [
	| answer |
	answer := Dictionary new.
	answer
		at: 'Min' put: self min;
		at: 'Max' put: self max.
	^answer]

{ #category : #printing }
UniformDistribution >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		nextPutAll: '(';
		print: start;
		nextPut: $,;
		print: stop;
		nextPut: $)]

{ #category : #estimators }
UniformDistribution >> skewness [
	"http://mathworld.wolfram.com/Skewness.html"
	^0.0]

{ #category : #private }
UniformDistribution >> start: here stop: there [
	start := here.
	stop := there]

{ #category : #printing }
UniformDistribution >> storeString [
	^self class name , ' from: ' , start storeString , ' to: '
		, stop storeString]

{ #category : #operations }
UniformDistribution >> translateBy: delta [
	self start: self min + delta stop: self max + delta]

{ #category : #validation }
UniformDistribution >> validateMax: max [
	^self runValidation: #validateUniformMax: max]

{ #category : #validation }
UniformDistribution >> validateMin: min [
	^self runValidation: #validateUniformMin: min]

{ #category : #estimators }
UniformDistribution >> variance [
	^(stop - start) squared / 12]

