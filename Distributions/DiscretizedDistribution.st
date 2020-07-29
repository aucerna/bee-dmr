"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #DiscretizedDistribution,
	#superclass : #ContinuousProbabilityDistribution,
	#instVars : [
		'values',
		'density',
		'distribution',
		'intervalSelector'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
DiscretizedDistribution class >> around: aNumber [
	| value distribution start stop |
	value := aNumber asFloat.
	distribution := (Array new: 5)
		at: 1 put: 0;
		at: 2 put: 0.25;
		at: 3 put: 0.5;
		at: 4 put: 0.75;
		at: 5 put: 1.0;
		yourself.
	value = 0.0
		ifTrue: [
			start := -50.0.
			stop := 50.0]
		ifFalse: [
			start := value * 0.5.
			stop := value * 1.5].
	^self distribution: distribution from: (start min: stop) to: (start max: stop)
"
	DiscretizedDistribution around: 0
"]

{ #category : #'instance creation' }
DiscretizedDistribution class >> around: aNumber
between: lowerBound
and: upperBound
steps: n [
	(lowerBound isNil and: [upperBound isNil]) ifTrue: [^self around: aNumber].
	^self between: lowerBound and: upperBound steps: n]

{ #category : #'instance creation' }
DiscretizedDistribution class >> between: n and: m [
	^self between: n and: m steps: 4]

{ #category : #'instance creation' }
DiscretizedDistribution class >> between: n and: m steps: steps [
	| distribution validation |
	validation := self
		runValidation: #validateDiscretizedBetween:and:steps:
		withArguments: {n. m. steps}.
	validation hasPassed ifFalse: [^nil].
	distribution := Array
		streamContents: [:stream | 0
			to: steps
			do: [:i | stream nextPut: i / steps asFloat]].
	^self
		distribution: distribution
		from: n
		to: m 
"
	DiscretizedDistribution between: -30 and: 30 steps: 5
"]

{ #category : #'instance creation' }
DiscretizedDistribution class >> density: pdfCollection from: left to: right [
	| step |
	step := right - left / (pdfCollection size - 1).
	step isFraction ifTrue: [step := step asFloat].
	^self density: pdfCollection values: (left to: right by: step)]

{ #category : #'instance creation' }
DiscretizedDistribution class >> density: pdfCollection values: values [
	| array validation |
	validation := self
		runValidation: #validateDiscretizedDensity:values:
		with: pdfCollection
		with: values.
	validation hasPassed ifFalse: [^nil].
	array := self cleanValues: values probabilities: pdfCollection.
	^self new density: array second values: array first]

{ #category : #'gui support' }
DiscretizedDistribution class >> displayString [
	^'Cumulative']

{ #category : #'instance creation' }
DiscretizedDistribution class >> distribution: cdfCollection from: left to: right [
	| step |
	step := right - left / (cdfCollection size - 1).
	step isFraction ifTrue: [step := step asFloat].
	^self distribution: cdfCollection values: (left to: right by: step)]

{ #category : #'instance creation' }
DiscretizedDistribution class >> distribution: cdfCollection values: values [
	| array validation |
	validation := self
		runValidation: #validateDiscretizedDistribution:values:
		with: cdfCollection
		with: values.
	validation hasPassed ifFalse: [^nil].
	array := self cleanValues: values probabilities: cdfCollection.
	^self new distribution: array second values: array first]

{ #category : #'gs support' }
DiscretizedDistribution class >> instVarMap [
	^super instVarMap, #(
	#(intervalSelector nil) #(nil intervalSelector) 
	)]

{ #category : #examples }
DiscretizedDistribution class >> sampleInstance [
	"
	DiscretizedDistribution sampleInstance
	"
	^self around: 100]

{ #category : #'instance creation' }
DiscretizedDistribution class >> values: aCollection [
	| cdf anyone n |
	n := aCollection size.
	cdf := Array new: n withAll: 1.0.
	n = 0 ifTrue: [^nil].
	cdf at: 1 put: 0.0.
	anyone := self distribution: cdf values: aCollection.
	anyone isNil ifTrue: [^nil].
	^anyone beUniform]

{ #category : #validation }
DiscretizedDistribution >> addValidationSelectorsTo: aCollection [
	super addValidationSelectorsTo: aCollection.
	aCollection add: #discretizedValidation]

{ #category : #private }
DiscretizedDistribution >> beUniform [
	| n pdf delta |
	n := values size.
	n = 0 ifTrue: [^self].
	delta := values last - values first.
	delta = 0 ifTrue: [^self].
	pdf := Array new: n withAll: 1.0 / delta.
	self density: pdf values: values]

{ #category : #'file in/out' }
DiscretizedDistribution >> clearSurrogate [
	intervalSelector := nil]

{ #category : #services }
DiscretizedDistribution >> convertValuesWith: aNumber [
	values := values collect: [:v | v * aNumber].
	self distribution: distribution values: values]

{ #category : #'probability functions' }
DiscretizedDistribution >> density: x [
	| index |
	index := values positionOf: x.
	(index <= 0 or: [index >= values size]) ifTrue: [^0.0].
	index = 1 ifTrue: [^density at: 1].
	^x = (values at: index)
		ifTrue: [density at: index - 1]
		ifFalse: [density at: index]]

{ #category : #private }
DiscretizedDistribution >> density: pdfCollection values: valueCollection [
	| n delta |
	values := valueCollection.
	density := pdfCollection.
	n := density size.
	distribution := Array new: n.
	distribution at: 1 put: 0.0.
	2 to: n - 1 do: [:i | 
		delta := (values at: i) - (values at: i - 1).
		distribution at: i put: (density at: i) * delta + (distribution at: i - 1)].
	distribution at: n put: 1.0.
	self initializeIntervalSelector]

{ #category : #accessing }
DiscretizedDistribution >> distribution [
	^distribution]

{ #category : #'probability functions' }
DiscretizedDistribution >> distribution: x [
	| index x0 x1 y0 y1 |
	index := values positionOf: x.
	index = 0 ifTrue: [^0.0].
	index = values size ifTrue: [^1.0].
	(values at: index) = x ifTrue: [^distribution at: index].
	x0 := values at: index.
	x1 := values at: index + 1.
	y0 := distribution at: index.
	y1 := distribution at: index + 1.
	^y1 - y0 / (x1 - x0) * (x - x0) + y0]

{ #category : #private }
DiscretizedDistribution >> distribution: cdfCollection values: valueCollection [
	| n delta |
	values := valueCollection.
	distribution := cdfCollection.
	n := distribution size.
	density := Array new: n.
	1 to: density size - 1 do: [:i | 
		delta := (values at: i + 1) - (values at: i).
		density at: i put: (distribution at: i + 1) - (distribution at: i) / delta].
	density at: density size put: 1.0 - (distribution at: n).
	self initializeIntervalSelector]

{ #category : #private }
DiscretizedDistribution >> distributionAt: x put: p [
	distribution markDirtyAt: x put: p]

{ #category : #'file in/out' }
DiscretizedDistribution >> fileInActivate [
	| fix d v |
	fix := false.
	d := distribution.
	v := values.
	d first = 0.0 ifFalse: [
		fix := true.
		d := d copyWithFirst: 0.0.
		v := v copyWithFirst: (v first - (v second - v first) max: 0.0)].
	d last = 1.0 ifFalse: [
		fix := true.
		d := d copyWith: 1.0.
		v := v copyWith: v last + (v last - v nextToLast)].
	fix ifTrue: [self distribution: d values: v].
	self initializeIntervalSelector]

{ #category : #'file in/out' }
DiscretizedDistribution >> fileOutSurrogate [
	^self shallowCopy clearSurrogate]

{ #category : #testing }
DiscretizedDistribution >> hasTable [
	^true]

{ #category : #initialization }
DiscretizedDistribution >> initializeIntervalSelector [
	| n indexes lengths validation |
	n := distribution size.
	indexes := (1 to: n - 1) asArray.
	lengths := Array new: n - 1.
	1
		to: n - 1
		do: [:i | lengths
			at: i
			put: (distribution at: i + 1) - (distribution at: i)].
	validation := self
		runValidation: #validateDiscreteValues:probabilities:
		with: indexes
		with: lengths.
	validation hasPassed ifTrue: [
		intervalSelector := DiscreteDistribution
			values: indexes
			probabilities: lengths.
		intervalSelector uniform: uniform]]

{ #category : #'probability functions' }
DiscretizedDistribution >> inverseDistribution: u [
	| index p1 p0 v1 v0 |
	index := distribution positionOf: u.
	index = 0 ifTrue: [^values first].
	index = distribution size ifTrue: [^values last].
	p0 := distribution at: index.
	v0 := values at: index.
	p1 := distribution at: index + 1.
	v1 := values at: index + 1.
	^v1 - v0 / (p1 - p0) * (u - p0) + v0]

{ #category : #inquiries }
DiscretizedDistribution >> isConsistentWith: deterministicValue [
	^deterministicValue isNumber
		and: [self isConsistentWithBounds: deterministicValue]]

{ #category : #testing }
DiscretizedDistribution >> isDiscretized [
	^true]

{ #category : #inquiries }
DiscretizedDistribution >> isLike: aProbabilityDistribution [
	^(super isLike: aProbabilityDistribution)
		and: [self table = aProbabilityDistribution table]]

{ #category : #estimators }
DiscretizedDistribution >> max [
	^values last]

{ #category : #estimators }
DiscretizedDistribution >> mean [
	| mean x0 x1 f0 |
	mean := 0.0.
	1 to: values size - 1 do: [:i | 
		x0 := values at: i.
		x1 := values at: i + 1.
		f0 := density at: i.
		mean := x1 squared - x0 squared / 2.0 * f0 + mean].
	^mean]

{ #category : #estimators }
DiscretizedDistribution >> min [
	^values first]

{ #category : #'random sampling' }
DiscretizedDistribution >> next [
	| index u a b |
	index := intervalSelector next.
	u := intervalSelector uniform next.
	a := values at: index.
	b := values at: index + 1.
	^b - a * u + a]

{ #category : #printing }
DiscretizedDistribution >> parameterArray [
	^Array streamContents: [:stream | 
		stream nextPut: values size.
		1 to: values size do: [:i | 
			stream
				nextPut: (values at: i);
				nextPut: (distribution at: i)]]]

{ #category : #printing }
DiscretizedDistribution >> parameterArrayForDateDistribution: aDateDistribution [
	^Array streamContents: [:stream | 
		stream nextPut: values size.
		1 to: values size do: [:i | | vi di pi |
			vi := values at: i.
			di := aDateDistribution dateFrom: vi.
			pi := distribution at: i.
			stream nextPut: di; nextPut: pi]]]

{ #category : #printing }
DiscretizedDistribution >> parameterArrayInUnit: unit [
	^Array streamContents: [:stream | 
		stream nextPut: values size.
		1 to: values size do: [:i | | v |
			v := unit convert: (values at: i).
			stream
				nextPut: v;
				nextPut: (distribution at: i)]]]

{ #category : #accessing }
DiscretizedDistribution >> parameters [
	| answer n |
	answer := Dictionary new.
	answer
		at: 'Min' put: self min;
		at: 'Max' put: self max.
	n := values size - 2.
	2 to: n + 1 do: [:i | 
		answer
			at: 'x' , (i - 1) asString put: (values at: i);
			at: 'p' , (i - 1) asString put: (distribution at: i)].
	^answer]

{ #category : #copying }
DiscretizedDistribution >> postCopy [
	super postCopy.
	values := values copy.
	density := density copy.
	distribution := distribution copy.
	self initializeIntervalSelector]

{ #category : #printing }
DiscretizedDistribution >> prettyPrint [
	^self displayString]

{ #category : #accessing }
DiscretizedDistribution >> probabilityAt: index ifAbsent: aBlock [
	^distribution at: index ifAbsent: aBlock]

{ #category : #accessing }
DiscretizedDistribution >> probabilityAt: index put: aNumber [
	self
		distribution: (distribution at: index put: aNumber; yourself)
		values: values]

{ #category : #printing }
DiscretizedDistribution >> storeString [
	^self class name , ' distribution: ' , distribution asArray literalString
		, ' values: '
		, values asArray literalString]

{ #category : #'gui support' }
DiscretizedDistribution >> table [
	^Array
		streamContents: [:stream | values
			with: distribution
			do: [:x :p | stream nextPut: {x. p}]]]

{ #category : #operations }
DiscretizedDistribution >> translateBy: delta [
	| translated |
	translated := self values collect: [:v | v + delta].
	self distribution: distribution values: translated]

{ #category : #accessing }
DiscretizedDistribution >> uniform: aRandom [
	super uniform: aRandom.
	intervalSelector notNil ifTrue: [intervalSelector uniform: aRandom]]

{ #category : #validation }
DiscretizedDistribution >> validateProbability: aNumber at: index [
	^self
		runValidation: #validateDiscretizedProbability:at:
		with: aNumber
		with: index]

{ #category : #validation }
DiscretizedDistribution >> validateValue: aNumber at: index [
	^self
		runValidation: #validateDiscretizedValue:at:
		with: aNumber
		with: index]

{ #category : #accessing }
DiscretizedDistribution >> valueAt: index ifAbsent: aBlock [
	^values at: index ifAbsent: aBlock]

{ #category : #accessing }
DiscretizedDistribution >> valueAt: index put: aNumber [
	self
		distribution: distribution
		values: (values at: index put: aNumber; yourself)]

{ #category : #accessing }
DiscretizedDistribution >> values [
	^values]

{ #category : #estimators }
DiscretizedDistribution >> variance [
	| mu v x0 x1 fi |
	mu := self mean.
	v := 0.0.
	1 to: values size - 1 do: [:i | 
		x0 := values at: i.
		x1 := values at: i + 1.
		fi := density at: i.
		v := (x1 - mu raisedToInteger: 3) - (x0 - mu raisedToInteger: 3) * fi + v].
	^v]

