"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #TruncatedNormalSolver,
	#superclass : #Object,
	#instVars : [
		'min',
		'max',
		'x1',
		'p1',
		'x2',
		'p2',
		'delta',
		'xi',
		'xi1',
		'xi2',
		'n',
		'error'
	],
	#category : #Distributions
}

{ #category : #'instance creation' }
TruncatedNormalSolver class >> x1: x1
p1: p1
x2: x2
p2: p2
min: min
max: max
steps: n [
	^self new
		x1: x1
		p1: p1
		x2: x2
		p2: p2
		min: min
		max: max
		steps: n]

{ #category : #outputs }
TruncatedNormalSolver >> answer [
	^self truncated]

{ #category : #running }
TruncatedNormalSolver >> basicRun [
	| counter h1 h2 h |
	counter := 0.
	h1 := self h: xi1.
	h2 := self h: xi2.
	[
		h1 sign = h2 sign
			ifTrue: [self error: 'Error in algorithm. Cannot compute'].
		xi := xi1 + xi2 / 2.0.
		h := self h: xi.
		h1 sign ~= h sign
			ifTrue: [
				xi2 := xi.
				h2 := h]
			ifFalse: [
				xi1 := xi.
				h1 := h].
		error := h.
		error abs < 0.1e-50]
		whileFalse: [
			counter := counter + 1.
			counter > n ifTrue: [^self halt]].
	self halt]

{ #category : #inputs }
TruncatedNormalSolver >> delta: aNumber [
	delta := aNumber]

{ #category : #outputs }
TruncatedNormalSolver >> error [
	| truncated q1 q2 |
	truncated := self truncated.
	q1 := truncated distribution: x1.
	q2 := truncated distribution: x2.
	^((q1 - p1) squared + (q2 - p2) squared) sqrt]

{ #category : #outputs }
TruncatedNormalSolver >> errorX [
	| truncated r1 r2 |
	truncated := self truncated.
	r1 := truncated percentile: p1.
	r2 := truncated percentile: p2.
	^((r1 - x1) squared + (r2 - x2) squared) sqrt]

{ #category : #private }
TruncatedNormalSolver >> h: zetha [
	| s q2 q1 x |
	s := NormalDistribution standard.
	q2 := p2 * delta + zetha.
	q2 ~ 1.0 ifTrue: [^zetha negated].
	delta ~ 0.0 ifTrue: [^0.0].
	q1 := p1 * delta + zetha.
	x := x2 - min * (s percentile: q1) - (x1 - min * (s percentile: q2)) / (x2
		- x1).
	^(s distribution: x) - zetha]

{ #category : #private }
TruncatedNormalSolver >> h2: zetha [
	| s |
	s := NormalDistribution standard.
	^x2 - x1 * (s percentile: zetha)
		- (x2 - min * (s percentile: p1 * delta * zetha))
		+ (x1 - min * (s percentile: p2 * delta * zetha))]

{ #category : #private }
TruncatedNormalSolver >> h3: zetha [
	| s |
	s := NormalDistribution standard.
	^(s
		distribution: x2 - min / (x2 - x1) * (s percentile: p1 * delta + zetha)
			- (x1 - min / (x2 - x1) * (s percentile: p2 * delta + zetha))) - zetha]

{ #category : #outputs }
TruncatedNormalSolver >> mu [
	| sigma s mu |
	s := NormalDistribution standard.
	sigma := self sigma.
	mu := x1 - ((s percentile: p1 * delta + xi) * sigma).
	self ASSERT: x2 - ((s percentile: p2 * delta + xi) * sigma) = mu.
	^mu]

{ #category : #outputs }
TruncatedNormalSolver >> mu1 [
	| sigma s mu |
	s := NormalDistribution standard.
	sigma := self sigma.
	mu := x1 - ((s percentile: p1 * delta + xi) * sigma).
	^mu]

{ #category : #outputs }
TruncatedNormalSolver >> mu2 [
	| sigma s mu r1 r2 |
	s := NormalDistribution standard.
	sigma := self sigma.
	r1 := s percentile: p1 * delta + xi.
	r2 := s percentile: p2 * delta + xi.
	mu := x1 + x2 - (r1 + r2 * sigma) / 2.0.
	^mu]

{ #category : #outputs }
TruncatedNormalSolver >> muSigma [
	| f1 f2 |
	f1 := NormalDistribution
		withPercentiles: xi
		valued: min
		and: delta + xi
		valued: max.
	f2 := NormalDistribution
		withPercentiles: p1 * delta + xi
		valued: x1
		and: p2 * delta + xi
		valued: x2.
	^{f1 mean + f2 mean / 2.0. (f1 deviation * f2 deviation) sqrt}]

{ #category : #running }
TruncatedNormalSolver >> run [
	| err e minDelta minXi |
	err := 1000.0.
	0.1 to: 0.90 by: 0.1 do: [:d | 
		delta := d.
		e := self startUp; basicRun; error.
		Transcript cr; show: delta printString; tab; show: xi printString; tab; show: e printString.
		e < err ifTrue: [
			minDelta := delta.
			minXi := xi.
			err := e]].
	delta := minDelta.
	xi := minXi]

{ #category : #outputs }
TruncatedNormalSolver >> sigma [
	| s |
	s := NormalDistribution standard.
	^x2 - x1
		/ ((s percentile: p2 * delta + xi) - (s percentile: p1 * delta + xi))]

{ #category : #running }
TruncatedNormalSolver >> startUp [
	delta isNil ifTrue: [delta := p2 - p1].
	xi1 := 0.0.
	xi2 := 1.0 - (delta * p2)]

{ #category : #inputs }
TruncatedNormalSolver >> steps: anInteger [
	n := anInteger]

{ #category : #outputs }
TruncatedNormalSolver >> truncated [
	| normal |
	normal := NormalDistribution
		withPercentiles: xi
		valued: min
		and: delta + xi
		valued: max.
	^normal truncateFrom: min to: max]

{ #category : #inputs }
TruncatedNormalSolver >> x1: y1
p1: q1
x2: y2
p2: q2
min: minValue
max: maxValue
steps: anInteger [
	x1 := y1.
	p1 := q1.
	x2 := y2.
	p2 := q2.
	min := minValue.
	max := maxValue.
	self steps: anInteger]

