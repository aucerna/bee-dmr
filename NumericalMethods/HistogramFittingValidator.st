"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HistogramFittingValidator,
	#superclass : #DomainValidator,
	#category : #NumericalMethods
}

{ #category : #services }
HistogramFittingValidator >> histogramValidation [
	| domain histogram x0 repeated n |
	self aspect: #histogram; valueIsNotEmpty.
	histogram := self value.
	domain := histogram collect: #x.
	self aspect: #histogramDomain; areIncreasing: domain.
	n := domain size.
	repeated := (1 to: n)
		detect: [:i | i < n and: [(domain at: i) ~ (domain at: i + 1)]]
		ifNone: nil.
	repeated notNil ifTrue: [
		self
			failBecause: self prettyPrint , ' has repeated X values at row '
				, repeated printString].
	x0 := object x0.
	(x0 notNil and: [histogram first x ~ x0] and: [histogram size = 1]) ifTrue: [
		self
			aspect: #histogram;
			failBecause: ' has only one point and it has the same X value as X0']]

{ #category : #all }
HistogramFittingValidator >> validate [
	self histogramValidation; x0Validation; y0Validation]

{ #category : #services }
HistogramFittingValidator >> x0Validation [
	| histogram |
	self aspect: #x0; valueIsDefined.
	histogram := object histogram.
	self value <= histogram first x ifFalse: [
		self
			failBecause: self prettyPrint
				, ' is greater than the first histogram X value']]

{ #category : #services }
HistogramFittingValidator >> y0Validation [
	| y0 histogram h1 x0 y1 |
	self aspect: #y0.
	y0 := self value.
	y0 isNil ifTrue: [^self].
	histogram := object histogram.
	h1 := histogram first.
	x0 := object x0.
	(x0 = h1 x and: [y0 ~= h1 y]) ifTrue: [
		self
			failBecause: self prettyPrint
				, ' differs from the first histogram Y value'].
	y1 := x0 < h1 x
		ifTrue: [h1 y]
		ifFalse: [histogram size > 1 ifTrue: [histogram second y]].
	(y1 notNil and: [y0 > 0] and: [y1 = 0.0]) ifTrue: [
		self
			failBecause: self prettyPrint
				, ' is greater than zero and it is followed by a zero Y (a bin that cannot be fitted)']]

