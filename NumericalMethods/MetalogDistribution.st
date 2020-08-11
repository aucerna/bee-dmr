"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MetalogDistribution,
	#superclass : #Object,
	#instVars : [
		'coefficients',
		'cdf'
	],
	#category : #NumericalMethods
}

{ #category : #'instance creation' }
MetalogDistribution class >> new [
	^super new initialize]

{ #category : #'instance creation' }
MetalogDistribution class >> on: aSampleSpace [
	^self new on: aSampleSpace]

{ #category : #examples }
MetalogDistribution class >> t3Example [
	"
	Returns an approximation to the Student-t distribution with 3 degrees of freedom.
	"
	| coefficients metalog |
	coefficients := #(-9.49755175e-05  7.34321124e-01  1.20637568e-02 -4.19076009e-02 2.32502148 -1.27148263e1 -2.82356999e-02).
	metalog := MetalogDistribution new
		instVarNamed: 'coefficients'
		put: coefficients.
	self
		ASSERT: ((metalog quantile: 0.99) - 4.54) abs < 0.1;
		ASSERT: ((metalog quantile: 0.75) - 0.764) abs < 0.1;
		ASSERT: ((metalog quantile: 0.3) - -0.584) abs < 0.1 ^ metalog]

{ #category : #percentiles }
MetalogDistribution >> computeCoefficients: n [
	| x y t |
	self ASSERT: cdf size >= n.
	x := FloatMatrix
		fromBlock: [:i :j | (cdf at: i) key]
		numRows: cdf size
		columns: 1.
	y := self Y: n.
	t := y transposed.
	coefficients := (t * y) inverse * t * x column: 1]

{ #category : #percentiles }
MetalogDistribution >> delta2At: j for: y [
	| centered |
	j = 1 ifTrue: [^1].
	j = 2 ifTrue: [^(y / (1 - y)) ln].
	centered := y - 0.5 raisedTo: j // 2.
	^j odd ifTrue: [(y / (1 - y)) ln * centered] ifFalse: [centered]]

{ #category : #percentiles }
MetalogDistribution >> deltaAt: j for: y [
	| centered |
	j = 1 ifTrue: [^1.0].
	j = 2 ifTrue: [^(y / (1.0 - y)) ln].
	centered := y - 0.5 raisedToInteger: j - 1 // 2.
	j = 3 ifTrue: [^centered * (y / (1.0 - y)) ln].
	j = 4 ifTrue: [^centered].
	^j odd ifTrue: [centered] ifFalse: [(y / (1.0 - y)) ln * centered]]

{ #category : #pdf }
MetalogDistribution >> deltaAtCum: y order: n [
	n = 2 ifTrue: [^1.0 / (1.0 - y * y)].
	n = 3 ifTrue: [^y - 0.5 / (1.0 - y * y) + (y / (1.0 - y)) ln].
	n = 4 ifTrue: [^1.0].
	n odd ifTrue: [^n - 1 // 2 * (y - 0.5 raisedToInteger: n - 3 // 2)].
	^(y - 0.5 raisedToInteger: n // 2 - 1) / (1.0 - y * y)
		+ (n // 2 - 1 * (y - 0.5 raisedToInteger: n // 2 - 2) * (y / (1.0 - y)) ln)]

{ #category : #pdf }
MetalogDistribution >> densityAtCum: y [
	| g |
	g := 0.0.
	2 to: coefficients size do: [:i | | ai delta |
		ai := coefficients at: i.
		delta := self deltaAtCum: y order: i.
		g := ai * delta + g].
	^g reciprocal]

{ #category : #percentiles }
MetalogDistribution >> inverseDistribution: y [
	^self quantile: y]

{ #category : #accessing }
MetalogDistribution >> on: aSampleSpace [
	| min max |
	cdf := aSampleSpace cdf.
	min := cdf
		findFirst: [:assoc | (assoc value ~ 0.0) not]
		ifAbsent: [cdf size + 1].
	max := cdf findLast: [:assoc | (assoc value ~ 1.0) not] ifAbsent: 0.
	(min = 1 and: [max = cdf size]) ifTrue: [^self].
	cdf := cdf copyFrom: min to: max]

{ #category : #percentiles }
MetalogDistribution >> quantile: y [
	| q |
	q := 0.0.
	coefficients withIndexDo: [:ai :i | | delta |
		delta := self deltaAt: i for: y.
		q := delta * ai + q].
	^q]

{ #category : #percentiles }
MetalogDistribution >> Y: n [
	| rows |
	rows := cdf collect: [:assoc | self Y: n for: assoc value].
	^FloatMatrix fromRowCollection: rows]

{ #category : #percentiles }
MetalogDistribution >> Y: n for: y [
	^(1 to: n) collect: [:i | self deltaAt: i for: y]]

