"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #TriangularDistribution,
	#superclass : #ContinuousProbabilityDistribution,
	#instVars : [
		'a',
		'c',
		'b',
		'h'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
TriangularDistribution class >> around: aNumber [
	| mid left right |
	mid := aNumber asFloat.
	mid = 0.0
		ifTrue: [
			left := -0.75.
			right := 1.25]
		ifFalse: [
			left := mid * 0.75.
			right := mid * 1.25].
	^self left: (left min: right) mid: mid right: (left max: right)
"
	TriangularDistribution around: -1
"]

{ #category : #'instance creation' }
TriangularDistribution class >> around: aNumber inRange: aRange [
	| mid left right min max |
	mid := (aRange isNil ifTrue: [aNumber] ifFalse: [aRange closestTo: aNumber]) asFloat.
	mid = 0.0
		ifTrue: [
			left := -0.75.
			right := 1.25]
		ifFalse: [
			left := mid * 0.75.
			right := mid * 1.25].
	min := left min: right.
	max := left max: right.
	aRange isEmptyOrNil ifFalse: [
		min := min max: aRange min.
		max := max min: aRange max].
	mid := (mid = min or: [mid = max]) ifTrue: [min + max / 2] ifFalse: [mid].
	^self left: min mid: mid right: max]

{ #category : #'instance creation' }
TriangularDistribution class >> between: n and: m [
	^self left: n mid: n + m / 2 right: m]

{ #category : #'instance creation' }
TriangularDistribution class >> default [
	^self
		left: 0
		mid: 0.5
		right: 1]

{ #category : #'instance creation' }
TriangularDistribution class >> left: a mid: b right: c [
	| validation |
	validation := self
		runValidation: #validateTriangularLeft:mid:right:
		withArguments: {a asFloat. b asFloat. c asFloat}.
	^validation hasPassed ifTrue: [self new left: a mid: b right: c]]

{ #category : #examples }
TriangularDistribution class >> sampleInstance [
	^self around: 100.0]

{ #category : #'instance creation' }
TriangularDistribution class >> withPercentile: p
valued: x
left: a
right: b [
	| c triangular |
	(p = 0.0 or: [x < a] or: [p = 1.0] or: [x > b]) ifTrue: [^nil].
	b - a = 0.0 ifTrue: [^nil].
	c := (x - a) squared / (b - a * p) + a.
	(a < c and: [c < b]) ifTrue: [
		triangular := self left: a mid: c right: b.
		(triangular percentile: p) ~ x ifTrue: [^triangular]].
	c := (b - x) squared / (p - 1 * (b - a)) + b.
	^(a < c and: [c < b]) ifTrue: [
		triangular := self left: a mid: c right: b.
		(triangular percentile: p) ~ x ifTrue: [triangular]]]

{ #category : #validation }
TriangularDistribution >> addValidationSelectorsTo: aCollection [
	super addValidationSelectorsTo: aCollection.
	aCollection add: #triangularValidation]

{ #category : #converting }
TriangularDistribution >> asJson [
	^super asJson
		at: 'Min' put: a;
		at: 'Mid' put: c;
		at: 'Max' put: b;
		yourself]

{ #category : #services }
TriangularDistribution >> convertValuesWith: aNumber [
	self
		left: self left * aNumber
		mid: self mid * aNumber
		right: self right * aNumber]

{ #category : #'probability functions' }
TriangularDistribution >> density: x [
	(x < a or: [b < x]) ifTrue: [^0.0].
	^x < c
		ifTrue: [x - a * 2.0 / (b - a * (c - a))]
		ifFalse: [b - x * 2.0 / (b - a * (b - c))]]

{ #category : #'probability functions' }
TriangularDistribution >> distribution: x [
	x < a ifTrue: [^0.0].
	b < x ifTrue: [^1.0].
	^x < c
		ifTrue: [(x - a) squared / (b - a * (c - a))]
		ifFalse: [1.0 - ((b - x) squared / (b - a * (b - c)))]]

{ #category : #converting }
TriangularDistribution >> fromJson: aJsonObject [
	self left: aJsonObject Min mid: aJsonObject Mid right: aJsonObject Max]

{ #category : #'probability functions' }
TriangularDistribution >> inverseDistribution: u [
	^u < h
		ifTrue: [a + (u * (b - a) * (c - a)) sqrt]
		ifFalse: [b - (1 - u * (b - a) * (b - c)) sqrt]]

{ #category : #inquiries }
TriangularDistribution >> isConsistentWith: deterministicValue [
	^deterministicValue isNumber
		and: [self isConsistentWithBounds: deterministicValue]]

{ #category : #inquiries }
TriangularDistribution >> isLike: aProbabilityDistribution [
	^(super isLike: aProbabilityDistribution)
		and: [self left = aProbabilityDistribution left]
		and: [self mid = aProbabilityDistribution mid]
		and: [self right = aProbabilityDistribution right]]

{ #category : #testing }
TriangularDistribution >> isTriangular [
	^true]

{ #category : #estimators }
TriangularDistribution >> kurtosis [
	^-3.0/5.0]

{ #category : #accessing }
TriangularDistribution >> left [
	^a]

{ #category : #private }
TriangularDistribution >> left: left mid: mid right: right [
	a := left asFloat.
	b := right asFloat.
	c := mid asFloat.
	b - a = 0.0 ifFalse: [h := c - a / (b - a)]]

{ #category : #estimators }
TriangularDistribution >> max [
	^b]

{ #category : #private }
TriangularDistribution >> max: aNumber [
	self left: a mid: c right: aNumber]

{ #category : #estimators }
TriangularDistribution >> mean [
	^a + b + c / 3]

{ #category : #estimators }
TriangularDistribution >> mid [
	^c]

{ #category : #private }
TriangularDistribution >> mid: aNumber [
	self left: a mid: aNumber right: b]

{ #category : #estimators }
TriangularDistribution >> min [
	^a]

{ #category : #private }
TriangularDistribution >> min: aNumber [
	self left: aNumber mid: c right: b]

{ #category : #estimators }
TriangularDistribution >> mode [
	^self mid]

{ #category : #printing }
TriangularDistribution >> parameterArray [
	^{self min. self mid. self max}]

{ #category : #accessing }
TriangularDistribution >> parameters [
	| answer |
	answer := Dictionary new.
	answer
		at: 'Min' put: self min;
		at: 'Mid' put: self mid;
		at: 'Max' put: self max.
	^answer]

{ #category : #printing }
TriangularDistribution >> prettyPrint [
	^self displayString , ' (' , a printNLString , ', ' , c printNLString
		, ', '
		, b printNLString
		, ')']

{ #category : #accessing }
TriangularDistribution >> right [
	^b]

{ #category : #estimators }
TriangularDistribution >> skewness [
	| x y |
	x := a + b - (2 * c) * (2 * a - b - c) * (a - (2 * b) + c).
	y := a squared + b squared + c squared - (a * b) - (a * c) - (b * c)
		raisedTo: 1.5.
	^2.0 sqrt * x / (5 * y)]

{ #category : #printing }
TriangularDistribution >> storeString [
	^self class name , ' left: ' , a storeString , ' mid: ' , c storeString
		, ' right: '
		, b storeString]

{ #category : #operations }
TriangularDistribution >> translateBy: delta [
	self
		left: self left + delta
		mid: self mid + delta
		right: self right + delta]

{ #category : #validation }
TriangularDistribution >> validateMax: aNumber [
	^self runValidation: #validateTriangularMax: with: aNumber]

{ #category : #validation }
TriangularDistribution >> validateMid: aNumber [
	^self runValidation: #validateTriangularMid: with: aNumber]

{ #category : #validation }
TriangularDistribution >> validateMin: aNumber [
	^self runValidation: #validateTriangularMin: with: aNumber]

{ #category : #estimators }
TriangularDistribution >> variance [
	^a squared + b squared + c squared - (a * b) - (a * c) - (b * c) / 18]

