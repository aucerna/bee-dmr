"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SampleSpace,
	#superclass : #DiscreteProbabilityDistribution,
	#instVars : [
		'data',
		'sorted',
		'table',
		'frequencies'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
SampleSpace class >> around: aNumber [
	| value delta x |
	value := aNumber asFloat.
	value = 0.0
		ifTrue: [
			delta := 0.25.
			x := -0.5]
		ifFalse: [
			delta := value abs * 0.25.
			x := value - (delta * 2)].
	^self on: (Array streamContents: [:stream | 
		5 timesRepeat: [
			stream nextPut: x.
			x := x + delta]])
"
	SampleSpace around: -100
"]

{ #category : #'instance creation' }
SampleSpace class >> between: n and: m [
	^self between: n and: m steps: 5
"
	SampleSpace between: -30 and: 30
"]

{ #category : #'instance creation' }
SampleSpace class >> between: n and: m steps: steps [
	^self on: (n to: m by: m - n / (steps - 1))
"
	SampleSpace between: -30 and: 30 steps: 5
"]

{ #category : #'GUI support' }
SampleSpace class >> displayString [
	^self name prettyPrint]

{ #category : #examples }
SampleSpace class >> example [
	"
	self example
	"
	| instance |
	instance := self
		on: #(60 60 60 62 62 64 64 64 64 66 66 66 68 68 68 68 68 70 70 70 ).
	^{instance. instance density: 64.
		instance distributionOver: (60 to: 64 by: 2)}]

{ #category : #'gs support' }
SampleSpace class >> instVarMap [
	^super instVarMap, #(
	#(table nil) #(nil table) 
	)]

{ #category : #'instance creation' }
SampleSpace class >> on: dataCollection [
	| valid |
	valid := self
		passesValidation: [:v | v validateSampleSpaceOn: dataCollection].
	^valid ifTrue: [self new data: dataCollection]]

{ #category : #examples }
SampleSpace class >> sampleInstance [
	^self on: #(60 60 60 62 62 64 64 64 64 66 66 66 68 68 68 68 68 70 70 70)]

{ #category : #validation }
SampleSpace >> addValidationSelectorsTo: aCollection [
	super addValidationSelectorsTo: aCollection.
	aCollection add: #sampleSpaceValidation]

{ #category : #'Box-Cox' }
SampleSpace >> boxCoxDistribution [
	^self boxCoxTransformation distribution]

{ #category : #'Box-Cox' }
SampleSpace >> boxCoxTransformation [
	| boxcox |
	boxcox := BoxCoxTransformation on: data.
	boxcox compute.
	^boxcox]

{ #category : #'probability functions' }
SampleSpace >> cdf [
	^self table collect: [:vpc | vpc first -> vpc third]]

{ #category : #'file in/out' }
SampleSpace >> clearSurrogate [
	self invalidate]

{ #category : #services }
SampleSpace >> convertValuesWith: aNumber [
	data := data collect: [:v | v * aNumber].
	table := nil]

{ #category : #private }
SampleSpace >> data: aCollection [
	data := aCollection.
	self invalidate]

{ #category : #'probability functions' }
SampleSpace >> density: x [
	^(data occurrencesOf: x) / data size]

{ #category : #'probability functions' }
SampleSpace >> distribution: x [
	| c |
	c := 0.0.
	self table do: [:vpc | 
		x < vpc first ifTrue: [^c].
		c := vpc third].
	^1.0]

{ #category : #'probability functions' }
SampleSpace >> distributionLeft: x [
	^(super distributionLeft: x) - (self density: x)]

{ #category : #'file in/out' }
SampleSpace >> fileOutSurrogate [
	^self shallowCopy clearSurrogate]

{ #category : #accessing }
SampleSpace >> frequencies: aDictionary [
	frequencies := aDictionary]

{ #category : #testing }
SampleSpace >> hasBooleanValues [
	^data anySatisfy: [:v | v isBoolean]]

{ #category : #testing }
SampleSpace >> hasTable [
	^true]

{ #category : #initialization }
SampleSpace >> initializeSorted [
	| array copy |
	sorted notNil ifTrue: [^self].
	array := data asArray.
	copy := self hasBooleanValues
		ifTrue: [array collect: #asParameter]
		ifFalse: [array copy].
	sorted := self sort: copy]

{ #category : #initialization }
SampleSpace >> initializeTable [
	| n |
	n := data size asFloat.
	frequencies isNil ifTrue: [frequencies := data asBag frequencies].
	table := Array streamContents: [:stream | | c |
		c := 0.0.
		(self sort: frequencies keys asArray) do: [:x | | p |
			p := (frequencies at: x) asFloat / n.
			c := c + p.
			stream nextPut: {x. p. c}]]]

{ #category : #'probability functions' }
SampleSpace >> interpolatedPercentile: p [
	| i vpc0 v0 c0 vpc1 v1 c1 |
	p ~ 0.0 ifTrue: [^nil].
	i := self table findLast: [:vpc | vpc third <~ p] ifAbsent: 1.
	vpc0 := table at: i.
	v0 := vpc0 first.
	v0 isUndefinedValue ifTrue: [^self percentile: p].
	c0 := vpc0 third.
	c0 >~ p ifTrue: [^v0].
	i = table size ifTrue: [^nil].
	vpc1 := table at: i + 1.
	v1 := vpc1 first.
	c1 := vpc1 third.
	^v1 - v0 / (c1 - c0) * (p - c0) + v0]

{ #category : #estimators }
SampleSpace >> interpolatedPercentiles: anInteger [
	| interval |
	anInteger = 0 ifTrue: [^#()].
	interval := 0 to: 1 by: 1.0 / anInteger.
	^interval
		collect: [:p | self interpolatedPercentile: p]
		thenSelect: #notNil]

{ #category : #private }
SampleSpace >> invalidate [
	sorted := nil.
	table := nil]

{ #category : #'probability functions' }
SampleSpace >> inverseDistribution: u [
	| i v |
	u = 0.0 ifTrue: [^nil].
	self initializeSorted.
	u = 1.0 ifTrue: [^sorted last].
	v := u * sorted size.
	i := v truncated max: 1.
	v = i ifFalse: [i := (v + 0.5) rounded].
	^sorted at: i]

{ #category : #testing }
SampleSpace >> isFinite [
	^true]

{ #category : #inquiries }
SampleSpace >> isLike: aProbabilityDistribution [
	^(super isLike: aProbabilityDistribution)
		and: [self table = aProbabilityDistribution table]]

{ #category : #estimators }
SampleSpace >> kurtosis [
	| mu mu4 |
	mu := self mean.
	mu4 := self table
		sum: [:vpc | (vpc first - mu raisedToInteger: 4) * vpc second].
	^mu4 / self variance squared]

{ #category : #estimators }
SampleSpace >> max [
	^data max]

{ #category : #estimators }
SampleSpace >> mean [
	^self table sum: [:vpc | vpc first * vpc second]]

{ #category : #estimators }
SampleSpace >> min [
	^data min]

{ #category : #estimators }
SampleSpace >> mode [
	| max mode |
	max := 0.
	table do: [:vpc | | p |
		p := vpc second.
		p > max ifTrue: [
			mode := vpc first.
			max := p]].
	^mode]

{ #category : #printing }
SampleSpace >> parameterArray [
	^data asArray]

{ #category : #copying }
SampleSpace >> postCopy [
	super postCopy.
	data := data copy.
	table := table notNil ifTrue: [table collect: [:pair | pair copy]]]

{ #category : #printing }
SampleSpace >> prettyPrint [
	^self displayString]

{ #category : #'probability functions' }
SampleSpace >> reverseDistribution: x [
	^(super reverseDistribution: x) + (self density: x)]

{ #category : #estimators }
SampleSpace >> skewness [
	| mu mu3 |
	mu := self mean.
	mu3 := self table
		sum: [:vpc | (vpc first - mu raisedToInteger: 3) * vpc second].
	^mu3 / (self variance raisedTo: 1.5)]

{ #category : #private }
SampleSpace >> sort: values [
	| undefined defined |
	undefined := values select: [:x | x isUndefinedValue].
	defined := values reject: [:x | x isUndefinedValue].
	^undefined , defined sort]

{ #category : #printing }
SampleSpace >> storeString [
	data isNil ifTrue: [^self class name , ' new'].
	^self class name , ' on: ' , data asArray literalString]

{ #category : #'gui support' }
SampleSpace >> table [
	table isNil ifTrue: [self initializeTable].
	^table]

{ #category : #operations }
SampleSpace >> translateBy: delta [
	| translated |
	translated := data collect: [:v | v + delta].
	self data: translated]

{ #category : #accessing }
SampleSpace >> values [
	^data]

{ #category : #accessing }
SampleSpace >> valuesSize [
	^data asBag size]

{ #category : #estimators }
SampleSpace >> variance [
	| mu |
	mu := self mean.
	^self table sum: [:vpc | (vpc first - mu) squared * vpc second]]

