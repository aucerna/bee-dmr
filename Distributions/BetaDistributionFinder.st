"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BetaDistributionFinder,
	#superclass : #Algorithm,
	#instVars : [
		'x1',
		'p1',
		'x2',
		'p2',
		'interval',
		'step',
		'beta'
	],
	#category : #Distributions
}

{ #category : #examples }
BetaDistributionFinder class >> sampleInstance [
	^self
		x: 0.2
		p: 0.1
		x: 0.8
		p: 0.9]

{ #category : #'instance creation' }
BetaDistributionFinder class >> x: x1
p: p1
x: x2
p: p2 [
	self ASSERT: p1 != p2.
	^p1 < p2
		ifTrue: [
			self new
				x: x1
				p: p1
				x: x2
				p: p2]
		ifFalse: [
			self new
				x: x2
				p: p2
				x: x1
				p: p1]]

{ #category : #computing }
BetaDistributionFinder >> basicRun [
	| guess ms prob kappa delta |
	guess := 1.0 - p1.
	ms := interval collect: [:k | 
		self wasCancelled ifTrue: [^self].
		step := step + 1.
		step \\ 10 = 0 ifTrue: [self triggerEvent: #changed: with: self].
		guess := self
			bisect: k
			for: p1
			on: x1
			guess: guess].
	prob := interval with: ms collect: [:k :m | 
		beta
			a: k * m b: k * (1.0 - m);
			distribution: x2].
	kappa := self linearInterpolate: interval with: prob on: p2.
	delta := self bisect: kappa for: p1 on: x1.
	beta a: kappa * delta b: kappa * (1.0 - delta)]

{ #category : #computing }
BetaDistributionFinder >> bisect: k for: p on: x [
	^self
		bisect: k
		for: p
		on: x
		guess: 1.0 - p]

{ #category : #computing }
BetaDistributionFinder >> bisect: k
for: p
on: x
guess: guess [
	| mid inf low sup high aux count |
	mid := guess.
	low := inf := 0.0.
	high := sup := 1.0.
	aux := BetaDistribution a: k * mid b: k * (1.0 - mid).
	aux isNil ifTrue: [^mid].
	count := 1.
	[| p0 error |
		p0 := aux distribution: x.
		p0 < p
			ifTrue: [
				high := mid.
				inf := p0.
				error := p - p0]
			ifFalse: [
				low := mid.
				sup := p0.
				error := p0 - p].
		self haltWhen: (inf ~ sup or: [low ~ high]).
		error < 0.0001 or: [self wasCancelled]]
		whileFalse: [
			mid := p - inf * low + (sup - p * high) / (sup - inf).
			aux a: k * mid b: k * (1.0 - mid).
			count := count + 1.
			count \\ 1000 = 0 ifTrue: [self triggerEvent: #changed: with: self]].
	^mid]

{ #category : #services }
BetaDistributionFinder >> find [
	self run.
	^beta]

{ #category : #computing }
BetaDistributionFinder >> linearInterpolate: samples with: probabilities on: p [
	| d2 d1 i1 i2 q1 q2 s1 s2 slope kappa |
	d1 := d2 := 4.0.
	1 to: samples size do: [:i | | pi d |
		pi := probabilities at: i.
		d := (pi - p) abs.
		d < d1
			ifTrue: [
				d1 := d.
				i1 := i]
			ifFalse: [
				d < d2 ifTrue: [
					d2 := d.
					i2 := i]]].
	q1 := probabilities at: i1.
	q2 := probabilities at: i2.
	s1 := (samples at: i1) ln.
	s2 := (samples at: i2) ln.
	^q1 < q2
		ifTrue: [
			slope := s2 - s1 / (q2 - q1).
			kappa := slope * (p - q1) + s1.
			kappa exp]
		ifFalse: [s1 exp]]

{ #category : #inquiries }
BetaDistributionFinder >> progress [
	^step * 100 / interval size]

{ #category : #computing }
BetaDistributionFinder >> startUp [
	super startUp.
	interval := 1.0e-3 to: 1.0e8 logarithmicSize: 100.
	step := 0.
	beta := BetaDistribution new]

{ #category : #accessing }
BetaDistributionFinder >> x: percentile1
p: probability1
x: percentile2
p: probability2 [
	percentile1 < percentile2 ifFalse: [^nil].
	x1 := percentile1.
	p1 := probability1.
	x2 := percentile2.
	p2 := probability2]

