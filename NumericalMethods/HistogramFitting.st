"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HistogramFitting,
	#superclass : #Object,
	#instVars : [
		'x0',
		'y0',
		'histogram',
		'points',
		'slopes',
		'line',
		'adjustable'
	],
	#category : #NumericalMethods
}

{ #category : #examples }
HistogramFitting class >> example1 [
	"
	HistogramFitting example1 chart open
	"
	^self new histogram: {100 @ 1000. 200 @ 900. 300 @ 200. 400 @ 100}]

{ #category : #examples }
HistogramFitting class >> example2 [
	"
	HistogramFitting example2 chart open
	"
	^self new histogram: {100 @ 1000. 200 @ 900. 300 @ 200}]

{ #category : #'instance creation' }
HistogramFitting class >> new [
	^super new initialize]

{ #category : #validation }
HistogramFitting class >> validatorClass [
	^HistogramFittingValidator]

{ #category : #'instance creation' }
HistogramFitting class >> x0: aNumber histogram: aCollection [
	^self new histogram: aCollection; x0: aNumber]

{ #category : #inquiries }
HistogramFitting >> adjustableBins [
	^adjustable]

{ #category : #services }
HistogramFitting >> adjustBins [
	| problem solver |
	problem := HistogramFittingProblem new.
	problem fitting: self.
	solver := AnnealingHistogramFittingSolver forProblem: problem.
	^solver solve; current]

{ #category : #private }
HistogramFitting >> areaPreservingLineAtBin: index [
	| h left right m b |
	h := self histogramAt: index.
	left := self pointAtBin: index - 1.
	right := self pointAtBin: index.
	m := right y - left y / (right x - left x).
	b := left y * left x - (right y * right x) / (right x - left x) + (2 * h y).
	^LinearFunction slope: m ordinate: b]

{ #category : #inquiries }
HistogramFitting >> at: x [
	| p |
	p := points detect: [:q | q notNil and: [q x = x]].
	^p y]

{ #category : #private }
HistogramFitting >> atBin: i putDeviatedPoint: p [
	points at: i * 2 put: p]

{ #category : #private }
HistogramFitting >> atBin: i putPoint: p [
	points at: i * 2 + 1 put: p]

{ #category : #private }
HistogramFitting >> atBin: i putPoint: p slope: s [
	self atBin: i putPoint: p.
	slopes at: i * 2 + 1 put: s]

{ #category : #private }
HistogramFitting >> calculateSlopeVariation [
	| variation negative penalty |
	variation := 0.0.
	self slopes withNextDo: [:s1 :s2 | variation := variation + (s1 - s2) abs].
	penalty := self penalty.
	negative := points
		select: [:p | p notNil and: [p y < 0.0]]
		thenSum: [:p | p y abs * penalty].
	^negative + variation]

{ #category : #testing }
HistogramFitting >> canFit [
	^self passesValidation]

{ #category : #private }
HistogramFitting >> deviateBin: index [
	| left right |
	left := self pointAtBin: index - 1.
	right := self histogramAt: index.
	(left y > 0 and: [right y = 0])
		ifTrue: [self deviateZeroBin: index]
		ifFalse: [self deviatePositiveBin: index]]

{ #category : #services }
HistogramFitting >> deviateBin: index at: x [
	| right y l |
	right := self pointAtBin: index.
	y := right y > 0.0
		ifTrue: [
			l := self areaPreservingLineAtBin: index.
			l at: x]
		ifFalse: [0.0].
	self deviateBin: index thru: x @ y]

{ #category : #services }
HistogramFitting >> deviateBin: index thru: aPoint [
	| left right |
	left := self pointAtBin: index - 1.
	right := self pointAtBin: index.
	self atBin: index putDeviatedPoint: aPoint.
	line through: left and: aPoint.
	slopes at: index * 2 put: line slope.
	line through: aPoint and: right.
	self slopeAtBin: index put: line slope]

{ #category : #inquiries }
HistogramFitting >> deviatedBins [
	^(1 to: histogram size) select: [:i | (self deviatedPointAtBin: i) notNil]]

{ #category : #inquiries }
HistogramFitting >> deviatedPointAtBin: i [
	^points at: i * 2]

{ #category : #inquiries }
HistogramFitting >> deviatedPoints [
	^(1 to: histogram size)
		collect: [:i | self deviatedPointAtBin: i]
		thenSelect: #notNil]

{ #category : #private }
HistogramFitting >> deviatePositiveBin: index [
	| h next right deviate |
	h := self histogramAt: index.
	next := self histogramAt: index + 1.
	next isNil ifTrue: [next := h x @ 0].
	right := h x @ (h y + next y / 2.0).
	self atBin: index putPoint: right.
	deviate := self pointToDeviateBin: index.
	deviate isNil
		ifTrue: [self divideHistogramAt: index; deviateBin: index]
		ifFalse: [self deviateBin: index thru: deviate]]

{ #category : #private }
HistogramFitting >> deviateZeroBin: index [
	| left right d w y x |
	left := self pointAtBin: index - 1.
	right := self histogramAt: index.
	d := self minBinWidth min: right x - left x / 2.0.
	w := left x - (self pointBeforeBin: index - 1) x.
	y := left y * w / (d + w).
	left y: y.
	x := left x + d.
	self
		atBin: index putPoint: right;
		deviateBin: index thru: x @ 0.0]

{ #category : #private }
HistogramFitting >> divideHistogramAt: index [
	| left right width |
	left := self histogramAt: index - 1.
	right := self histogramAt: index.
	width := right x - left x.
	histogram := Array streamContents: [:strm | 
		histogram from: 1 to: index - 1 do: [:p | strm nextPut: p].
		strm
			nextPut: width / 3 + left x @ (5 / 4 * right y);
			nextPut: width * 2 / 3 + left x @ (1 / 2 * right y);
			nextPut: width + left x @ (5 / 4 * right y).
		histogram from: index + 1 do: [:p | strm nextPut: p]].
	points := points , #(nil nil nil nil).
	slopes := slopes , #(nil nil nil nil)]

{ #category : #private }
HistogramFitting >> fit [
	"
	HistogramFitting example1 fit
	"
	| i |
	self reset.
	i := 1.
	[i <= histogram size] whileTrue: [
		self fitBin: i.
		i := i + 1]]

{ #category : #private }
HistogramFitting >> fitBin: index [
	| h next left middle y min max |
	h := self histogramAt: index.
	left := self pointAtBin: index - 1.
	left y ~ 0.0 ifTrue: [
		left := left x @ (self initialYForBin: index).
		self atBin: index - 1 putPoint: left].
	middle := h x + left x / 2.0 @ h y.
	line through: left and: middle.
	y := line at: h x.
	next := self histogramAt: index + 1.
	min := next isNil ifTrue: [0.0] ifFalse: [h y min: next y].
	max := next isNil ifTrue: [Number infinity] ifFalse: [h y max: next y].
	(y between: min and: max)
		ifTrue: [self atBin: index putPoint: h x @ y slope: line slope]
		ifFalse: [self deviateBin: index]]

{ #category : #testing }
HistogramFitting >> hasAdjustableBins [
	^adjustable notEmpty]

{ #category : #accessing }
HistogramFitting >> histogram [
	^histogram]

{ #category : #accessing }
HistogramFitting >> histogram: aCollection [
	histogram := aCollection]

{ #category : #private }
HistogramFitting >> histogramAt: index [
	^index = 0 ifTrue: [x0 @ y0] ifFalse: [histogram at: index ifAbsent: nil]]

{ #category : #initialization }
HistogramFitting >> initialize [
	super initialize.
	x0 := 0.0.
	line := LinearFunction new]

{ #category : #initialization }
HistogramFitting >> initializeAdjustable [
	adjustable := OrderedCollection new]

{ #category : #initialization }
HistogramFitting >> initializeFirstBin [
	| p0 |
	p0 := x0 @ y0.
	histogram first = p0 ifTrue: [histogram := histogram allButFirst].
	self atBin: 0 putPoint: p0]

{ #category : #initialization }
HistogramFitting >> initializePoints [
	points := Array new: histogram size * 2 + 1]

{ #category : #initialization }
HistogramFitting >> initializeSlopes [
	slopes := Array new: histogram size * 2 + 1]

{ #category : #initialization }
HistogramFitting >> initializeY0 [
	y0 notNil ifTrue: [^self].
	y0 := histogram first x = x0
		ifTrue: [histogram first y]
		ifFalse: [self initialYForBin: 1]]

{ #category : #private }
HistogramFitting >> initialYForBin: index [
	| h next prev x1 y1 x2 y2 xm ym y min |
	h := self histogramAt: index.
	next := self histogramAt: index + 1.
	prev := self histogramAt: index - 1.
	x1 := prev x.
	y1 := h y.
	x2 := h x.
	y2 := next notNil ifTrue: [next y] ifFalse: [0.0].
	xm := x1 + x2 / 2.0.
	ym := y1 + y2 / 2.0.
	line through: xm @ y1 and: x2 @ ym.
	y := line at: x1.
	min := y1 * 0.1.
	y isUndefinedValue ifTrue: [^y1].
	^y >~ min ifTrue: [y] ifFalse: [min]]

{ #category : #private }
HistogramFitting >> minBinWidth [
	^1]

{ #category : #private }
HistogramFitting >> penalty [
	^9999999]

{ #category : #private }
HistogramFitting >> pointAtBin: i [
	^points at: i * 2 + 1]

{ #category : #inquiries }
HistogramFitting >> pointBeforeBin: i [
	| p |
	p := self deviatedPointAtBin: i.
	^p ifNil: [self pointAtBin: i - 1]]

{ #category : #accessing }
HistogramFitting >> points [
	points isNil ifTrue: [self fit].
	^points copyWithout: nil]

{ #category : #enumerating }
HistogramFitting >> pointsDo: aBlock [
	points select: #notNil thenDo: [:p | aBlock value: p]]

{ #category : #private }
HistogramFitting >> pointToDeviateBin: index [
	| left h next right t |
	left := self pointAtBin: index - 1.
	h := self histogramAt: index.
	next := self histogramAt: index + 1.
	next isNil ifTrue: [next := h x @ 0].
	right := h x @ (h y + next y / 2.0).
	self atBin: index putPoint: right.
	line := self areaPreservingLineAtBin: index.
	((line at: left x) <= 0 and: [(line at: right x) <= 0]) ifTrue: [^nil].
	t := self xInLineForBin: index from: left to: right.
	^t @ (line at: t)]

{ #category : #copying }
HistogramFitting >> postCopy [
	super postCopy.
	histogram := histogram copy.
	points := points copy.
	slopes := slopes copy.
	line := line copy]

{ #category : #inquiries }
HistogramFitting >> rangeOfBin: index [
	| left right |
	left := self histogramAt: index - 1.
	right := self histogramAt: index.
	^Range from: left x to: right x]

{ #category : #private }
HistogramFitting >> reset [
	self
		initializeAdjustable;
		initializePoints;
		initializeSlopes;
		initializeY0;
		initializeFirstBin]

{ #category : #inquiries }
HistogramFitting >> scatterPoints [
	| prev |
	^OrderedCollection streamContents: [:strm | 
		self points do: [:p | 
			(prev notNil and: [prev y ~ 0.0]) ifTrue: [strm nextPut: p x @ 0].
			strm nextPut: p.
			prev := p]]]

{ #category : #private }
HistogramFitting >> slopeAtBin: index put: s [
	slopes at: index * 2 + 1 put: s]

{ #category : #accessing }
HistogramFitting >> slopes [
	slopes isNil ifTrue: [self fit].
	^slopes copyWithout: nil]

{ #category : #services }
HistogramFitting >> slopeVariation [
	^self calculateSlopeVariation]

{ #category : #inquiries }
HistogramFitting >> slopeVariationAtBin: index [
	| i0 u s0 s v |
	i0 := index * 2.
	u := (slopes at: i0 - 1) ifNil: 0.0.
	s0 := slopes at: i0.
	s := slopes at: i0 + 1.
	v := (slopes at: i0 + 2 ifAbsent: s) ifNil: [s].
	^(s0 - u) abs + (s - s0) abs + (v - s) abs]

{ #category : #inquiries }
HistogramFitting >> variationIncrementAtBin: index for: deviation [
	| i0 s0 s d0 v0 v d |
	i0 := index * 2.
	s0 := slopes at: i0.
	s := slopes at: i0 + 1.
	d0 := points at: i0.
	v0 := self slopeVariationAtBin: index.
	d0 y < 0 ifTrue: [v0 := v0 + (d0 y abs * self penalty)].
	self deviateBin: index at: deviation.
	v := self slopeVariationAtBin: index.
	d := points at: i0.
	d y < 0 ifTrue: [v := v + (d y abs * self penalty)].
	slopes
		at: i0 put: s0;
		at: i0 + 1 put: s.
	points at: i0 put: d0.
	^v - v0]

{ #category : #inquiries }
HistogramFitting >> widthOfBin: index [
	| left right |
	left := self histogramAt: index - 1.
	right := self histogramAt: index.
	^right x - left x]

{ #category : #accessing }
HistogramFitting >> x0 [
	^x0]

{ #category : #accessing }
HistogramFitting >> x0: aNumber [
	aNumber = x0 ifTrue: [^self].
	x0 := aNumber.
	self reset]

{ #category : #private }
HistogramFitting >> xInLineForBin: index from: left to: right [
	| h x xl yl xr slope epsilon nearLeft factor |
	h := self histogramAt: index.
	x := line inverseAt: h y.
	epsilon := right x - left x min: 1.0.
	(x notNil and: [x - epsilon > left x] and: [x + epsilon < right x])
		ifTrue: [^x].
	xl := left x.
	(yl := line at: xl) < 0.0 ifTrue: [
		xl := line root.
		yl := 0.0].
	xr := right x.
	(line at: xr) < 0.0 ifTrue: [xr := line root].
	slope := line slope.
	slope ~ 0.0 ifTrue: [^xl + xr / 2].
	nearLeft := slope > 0.0
		ifTrue: [yl >= left y or: [yl >= right y]]
		ifFalse: [yl <= left y or: [yl <= right y]].
	factor := nearLeft ifTrue: [1 / 4] ifFalse: [3 / 4].
	^xl + (factor * (xr - xl))]

{ #category : #accessing }
HistogramFitting >> y0 [
	y0 isNil ifTrue: [self initializeY0].
	^y0]

{ #category : #accessing }
HistogramFitting >> y0: aNumber [
	aNumber = y0 ifTrue: [^self].
	y0 := aNumber.
	self reset]

