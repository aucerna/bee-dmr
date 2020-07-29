"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PertDistribution,
	#superclass : #BetaDistribution,
	#instVars : [
		'min',
		'max',
		'mode',
		'lambda'
	],
	#category : #Distributions
}

{ #category : #private }
PertDistribution class >> a: alpha
b: beta
min: left
max: right
lambda: shape [
	^self new
		a: alpha
		b: beta
		min: left
		max: right
		lambda: shape]

{ #category : #'instance creation' }
PertDistribution class >> around: aNumber [
	| triangular |
	triangular := TriangularDistribution around: aNumber.
	^self min: triangular min max: triangular max mode: triangular mid]

{ #category : #'instance creation' }
PertDistribution class >> min: left max: right mode: c [
	^self
		min: left
		max: right
		mode: c
		lambda: 4.0]

{ #category : #'instance creation' }
PertDistribution class >> min: left
max: right
mode: c
lambda: shape [
	| validation |
	validation := self
		runValidation: #validatePertMin:max:mode:lambda:
		withArguments: {left. right. c. shape}.
	^validation hasPassed
		ifTrue: [self new min: left max: right mode: c lambda: shape]]

{ #category : #private }
PertDistribution class >> percentile: p1
valued: x1
and: p2
valued: x2 [
	| beta |
	beta := super
		percentile: p1
		valued: x1
		and: p2
		valued: x2.
	beta isNil ifTrue: [^nil].
	beta usePert: true.
	^beta]

{ #category : #'instance creation' }
PertDistribution class >> sampleInstance [
	| triangular |
	triangular := TriangularDistribution sampleInstance.
	^self min: triangular min max: triangular max mode: triangular mid]

{ #category : #accessing }
PertDistribution >> a: alpha
b: beta
min: left
max: right
lambda: shape [
	| mu |
	self a: alpha b: beta.
	lambda := shape.
	min := left.
	max := right.
	mu := a * max + (b * min) / (a + b).
	mode := mu * (shape + 2.0) - min - max / shape]

{ #category : #converting }
PertDistribution >> asJson [
	^super asJson
		at: 'Min' put: min;
		at: 'Mode' put: mode;
		at: 'Max' put: max;
		at: 'Lambda' put: lambda;
		yourself]

{ #category : #services }
PertDistribution >> convertValuesWith: aNumber [
	super convertValuesWith: aNumber.
	self usesPert ifFalse: [^self].
	min := min * aNumber.
	max := max * aNumber.
	mode := mode * aNumber]

{ #category : #'probability functions' }
PertDistribution >> density: x [
	| length f |
	length := max - min.
	f := super density: x - min / length.
	^f / length]

{ #category : #'probability functions' }
PertDistribution >> distribution: x [
	^super distribution: x - min / (max - min)]

{ #category : #converting }
PertDistribution >> fromJson: aJsonObject [
	self
		min: aJsonObject Min
		max: aJsonObject Max
		mode: aJsonObject Mode
		lambda: aJsonObject Lambda]

{ #category : #initialization }
PertDistribution >> initialize [
	super initialize.
	min := 0.0.
	max := 1.0.
	lambda := 4.0]

{ #category : #'probability functions' }
PertDistribution >> inverseDistribution: p [
	| u |
	u := super inverseDistribution: p.
	^u * (max - min) + min]

{ #category : #inquiries }
PertDistribution >> isConsistentWith: deterministicValue [
	(super isConsistentWith: deterministicValue) ifTrue: [^true].
	deterministicValue isNumber ifFalse: [^false].
	^self isConsistentWithMode: deterministicValue]

{ #category : #inquiries }
PertDistribution >> isConsistentWithMode: aNumber [
	| r sd |
	self usesPert ifFalse: [^false].
	r := 4.
	sd := self sd.
	^aNumber between: mode - (r * sd) and: mode + (r * sd)]

{ #category : #inquiries }
PertDistribution >> isLike: aProbabilityDistribution [
	^(super isLike: aProbabilityDistribution)
		and: [min = aProbabilityDistribution min]
		and: [max = aProbabilityDistribution max]
		and: [mode = aProbabilityDistribution mode]
		and: [lambda = aProbabilityDistribution lambda]]

{ #category : #estimators }
PertDistribution >> kurtosis [
	^super kurtosis * (max - min) squared]

{ #category : #accessing }
PertDistribution >> lambda [
	^lambda]

{ #category : #accessing }
PertDistribution >> max [
	^max]

{ #category : #accessing }
PertDistribution >> max: hi [
	max := hi]

{ #category : #estimators }
PertDistribution >> mean [
	^super mean * (max - min) + min]

{ #category : #accessing }
PertDistribution >> mean: mu deviation: sd [
	| length |
	length := max - min.
	^super mean: mu - min / length deviation: sd / length sqrt]

{ #category : #accessing }
PertDistribution >> min [
	^min]

{ #category : #accessing }
PertDistribution >> min: low [
	min := low]

{ #category : #accessing }
PertDistribution >> min: low max: hi mode: c [
	self
		min: low
		max: hi
		mode: c
		lambda: lambda]

{ #category : #accessing }
PertDistribution >> min: left
max: right
mode: c
lambda: shape [
	| length |
	left < right ifFalse: [^self].
	c notNil ifTrue: [
		left < c ifFalse: [^self].
		c < right ifFalse: [^self]].
	min := left.
	max := right.
	mode := c.
	lambda := shape.
	length := max - min.
	self
		a: mode - min / length * lambda + 1.0
		b: max - mode / length * lambda + 1.0]

{ #category : #accessing }
PertDistribution >> mode [
	^mode]

{ #category : #accessing }
PertDistribution >> mode: m [
	mode := m]

{ #category : #printing }
PertDistribution >> parameterArray [
	^mode isNil ifTrue: [super parameterArray] ifFalse: [{min. max. mode}]]

{ #category : #printing }
PertDistribution >> printOn: aStream [
	self usesPert
		ifTrue: [
			aStream
				nextPutAll: self class name;
				nextPutAll: ' min: ';
				nextPutAll: min printString;
				nextPutAll: ' max: ';
				nextPutAll: max printString;
				nextPutAll: ' mode: ';
				nextPutAll: mode printString]
		ifFalse: [super printOn: aStream]]

{ #category : #estimators }
PertDistribution >> skewness [
	^super skewness * (max - min raisedTo: 1.5)]

{ #category : #printing }
PertDistribution >> storeString [
	^mode isNil
		ifTrue: [self class name , ' a: ' , a storeString , ' b: ' , b storeString]
		ifFalse: [self class name , ' min: ' , min storeString , ' max: '
			, max storeString
			, ' mode: '
			, mode storeString]]

{ #category : #operations }
PertDistribution >> translateBy: delta [
	self usesPert
		ifTrue: [self min: min + delta max: max + delta mode: mode + delta]]

{ #category : #accessing }
PertDistribution >> type [
	^self usesPert ifTrue: [super type] ifFalse: [BetaDistribution]]

{ #category : #accessing }
PertDistribution >> usePert: aBoolean [
	aBoolean
		ifTrue: [mode isNil ifTrue: [mode := a - 1.0 / (a + b - 2.0)]]
		ifFalse: [
			min := 0.0.
			max := 1.0.
			mode := nil]]

{ #category : #testing }
PertDistribution >> usesPert [
	^mode notNil]

{ #category : #estimators }
PertDistribution >> variance [
	^super variance * (max - min)]

