"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #LeastSquares,
	#superclass : #Object,
	#instVars : [
		'xValues',
		'yValues',
		'xMean',
		'yMean',
		'bounds',
		'c',
		'defined',
		'vertical',
		'horizontal'
	],
	#category : #CurvesFitting
}

{ #category : #'instance creation' }
LeastSquares class >> availableCalculators [
	"
	LeastSquares availableCalculators
	"
	| default classes |
	default := self defaultClass.
	classes := OrderedCollection with: default.
	self subclasses
		select: [:class | class ~= default]
		thenDo: [:class | classes add: class].
	^classes collect: [:class | class basicNew initialize]]

{ #category : #'instance creation' }
LeastSquares class >> defaultClass [
	^RayleighQuotientLeastSquares]

{ #category : #'instance creation' }
LeastSquares class >> new [
	| ls |
	ls := self == LeastSquares
		ifTrue: [self defaultClass new]
		ifFalse: [super new].
	ls initialize.
	^ls]

{ #category : #references }
LeastSquares class >> references [
	"
	ShellDLL current openWebPage: LeastSquares references
	"
	^'http://mathworld.wolfram.com/LeastSquaresFitting.html']

{ #category : #accessing }
LeastSquares >> bottomPoint [
	| y |
	self isHorizontal ifTrue: [^nil].
	y := bounds bottom.
	self isVertical ifTrue: [^xMean @ y].
	^(self inverseAt: y) @ y]

{ #category : #inputs }
LeastSquares >> bounds: aRectangle [
	bounds := aRectangle]

{ #category : #outputs }
LeastSquares >> c [
	^c]

{ #category : #calculations }
LeastSquares >> calculate [
	self subclassResponsibility]

{ #category : #calculations }
LeastSquares >> ensureBounds [
	bounds isNil
		ifTrue: [bounds := xValues min @ yValues min
			rightTop: xValues max @ yValues max]]

{ #category : #initialization }
LeastSquares >> initialize [
	super initialize.
	defined := true.
	vertical := false.
	horizontal := false]

{ #category : #outputs }
LeastSquares >> inverseAt: y [
	^1 / self slope * (y - self c)]

{ #category : #testing }
LeastSquares >> isDefined [
	^defined]

{ #category : #testing }
LeastSquares >> isHorizontal [
	^horizontal]

{ #category : #testing }
LeastSquares >> isVertical [
	^vertical]

{ #category : #accessing }
LeastSquares >> leftPoint [
	| x |
	self isVertical ifTrue: [^nil].
	x := bounds left.
	^x @ (self lineAt: x)]

{ #category : #outputs }
LeastSquares >> lineAt: x [
	^self slope * x + self c]

{ #category : #calculations }
LeastSquares >> mean: aCollection [
	^aCollection mean]

{ #category : #calculations }
LeastSquares >> points [
	| points first |
	self isDefined ifFalse: [^#()].
	self ensureBounds.
	points := OrderedCollection
		with: self leftPoint
		with: self topPoint
		with: self rightPoint
		with: self bottomPoint.
	points := points select: [:p | 
		p notNil
			and: [p x >~ bounds left]
			and: [p y <~ bounds top]
			and: [p x <~ bounds right]
			and: [p y >~ bounds bottom]].
	self ASSERT: points size >= 2.
	points isEmpty ifTrue: [^#()].
	first := points first.
	points sortBy: [:p1 :p2 | (p1 distanceTo: first) <= (p2 distanceTo: first)].
	^{points first. points last}]

{ #category : #accessing }
LeastSquares >> rightPoint [
	| x |
	self isVertical ifTrue: [^nil].
	x := bounds right.
	^x @ (self lineAt: x)]

{ #category : #accessing }
LeastSquares >> topPoint [
	| y |
	self isHorizontal ifTrue: [^nil].
	y := bounds top.
	self isVertical ifTrue: [^xMean @ y].
	^(self inverseAt: y) @ y]

{ #category : #outputs }
LeastSquares >> xMean [
	^xMean]

{ #category : #inputs }
LeastSquares >> xValues: aCollection [
	xValues := aCollection asFloatArray.
	xMean := self mean: aCollection.
	vertical := xValues min ~ xMean]

{ #category : #outputs }
LeastSquares >> yMean [
	^yMean]

{ #category : #inputs }
LeastSquares >> yValues: aCollection [
	yValues := aCollection asFloatArray.
	yMean := self mean: aCollection.
	horizontal := yValues min ~ yMean]

