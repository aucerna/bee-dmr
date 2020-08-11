"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FloatPrecision,
	#superclass : #Object,
	#instVars : [
		'radix',
		'positivePrecision',
		'negativePrecision',
		'defaultPrecision',
		'smallestFloat',
		'largestFloat',
		'smallFloat',
		'integerIntervalUpperBound',
		'integerIntervalLowerBound'
	],
	#category : #NumericalMethods
}

{ #category : #'accessing instances' }
FloatPrecision class >> current [
	"
	FloatPrecision current
	"
	current isNil ifTrue: [current := self new initialize].
	^current]

{ #category : #accessing }
FloatPrecision >> defaultPrecision [
	^defaultPrecision]

{ #category : #initialization }
FloatPrecision >> initialize [
	self
		initializeRadix;
		initializePositivePrecision;
		initializeNegativePrecision;
		initializeDefaultPrecision;
		initializeSmallestFloat;
		initializeLargestFloat;
		initializeSmallFloat]

{ #category : #initialization }
FloatPrecision >> initializeDefaultPrecision [
	defaultPrecision := positivePrecision sqrt]

{ #category : #initialization }
FloatPrecision >> initializeIntegerIntervalLowerBound [
	"
	FloatPrecision new initializeIntegerIntervalLowerBound; integerIntervalLowerBound
	"
	| exponent candidate |
	exponent := 1.
	[
		candidate := (2 raisedToInteger: exponent) negated.
		(candidate + 10000 to: candidate by: -1)
			conform: [:integer | integer asFloat asInteger = integer]]
		whileTrue: [
			integerIntervalLowerBound := candidate + 1.
			exponent := exponent + 1]]

{ #category : #initialization }
FloatPrecision >> initializeIntegerIntervalUpperBound [
	"
	FloatPrecision new initializeIntegerIntervalUpperBound; integerIntervalUpperBound
	"
	| exponent candidate |
	exponent := 1.
	[
		candidate := 2 raisedToInteger: exponent.
		(candidate - 10000 to: candidate)
			conform: [:integer | integer asFloat asInteger = integer]]
		whileTrue: [
			integerIntervalUpperBound := candidate - 1.
			exponent := exponent + 1]]

{ #category : #initialization }
FloatPrecision >> initializeLargestFloat [
	| r fm |
	r := radix asFloat.
	fm := 1.0 - (r * negativePrecision).
	largestFloat := fm.
	[
		[true] whileTrue: [
			fm := fm * r.
			largestFloat := fm]]
		on: Error
		do: [:ex | Float clearStatusFlags]]

{ #category : #initialization }
FloatPrecision >> initializeNegativePrecision [
	| s |
	s := 1.0 / radix asFloat.
	negativePrecision := 1.0.
	[1.0 - negativePrecision = 1.0]
		whileFalse: [negativePrecision := negativePrecision * s]]

{ #category : #initialization }
FloatPrecision >> initializePositivePrecision [
	| s |
	s := 1.0 / radix asFloat.
	positivePrecision := 1.0.
	[1.0 + positivePrecision = 1.0]
		whileFalse: [positivePrecision := positivePrecision * s]]

{ #category : #initialization }
FloatPrecision >> initializeRadix [
	"
	FloatPrecision new initializeRadix
	"
	| a x b |
	a := 1.0.
	[
		a := a + a.
		a + 1.0 = a] whileFalse.
	b := 1.0.
	[
		b := b + b.
		x := a + b.
		radix := (x - a) truncated.
		radix = 0.0] whileTrue]

{ #category : #initialization }
FloatPrecision >> initializeSmallestFloat [
	| r s fm |
	r := radix asFloat.
	fm := 1.0 - (r * negativePrecision).
	smallestFloat := fm.
	s := 1.0 / r.
	[
		[true] whileTrue: [
			fm := fm * s.
			smallestFloat := fm]]
		on: Error
		do: [Float clearStatusFlags]]

{ #category : #initialization }
FloatPrecision >> initializeSmallFloat [
	smallFloat := smallestFloat sqrt]

{ #category : #accessing }
FloatPrecision >> integerIntervalLowerBound [
	^integerIntervalLowerBound]

{ #category : #accessing }
FloatPrecision >> integerIntervalUpperBound [
	^integerIntervalUpperBound]

{ #category : #accessing }
FloatPrecision >> largestFloat [
	^largestFloat]

{ #category : #accessing }
FloatPrecision >> negativePrecision [
	^negativePrecision]

{ #category : #accessing }
FloatPrecision >> positivePrecision [
	^positivePrecision]

{ #category : #accessing }
FloatPrecision >> radix [
	^radix]

{ #category : #accessing }
FloatPrecision >> smallestFloat [
	^smallestFloat]

{ #category : #accessing }
FloatPrecision >> smallFloat [
	^smallFloat]

