"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Float }

{ #category : '*NumericalMethods' }
Float class >> defaultPrecision [
	"
	Float defaultPrecision
	"
	^FloatPrecision current defaultPrecision]

{ #category : '*NumericalMethods' }
Float class >> largest [
	"
	Float largest
	"
	^FloatPrecision current largestFloat]

{ #category : '*NumericalMethods' }
Float class >> negativePrecision [
	"
	Float negativePrecision
	"
	^FloatPrecision current negativePrecision]

{ #category : '*NumericalMethods' }
Float class >> positivePrecision [
	"
	Float positivePrecision
	"
	^FloatPrecision current positivePrecision]

{ #category : '*NumericalMethods' }
Float class >> radix [
	| r |
	r := FloatPrecision current radix.
	^r == 2 ifTrue: [2.0]]

{ #category : '*NumericalMethods' }
Float class >> small [
	"
	Float small
	"
	^FloatPrecision current smallFloat]

{ #category : '*NumericalMethods' }
Float class >> smallest [
	"
	Float smallest
	"
	^FloatPrecision current smallestFloat]

{ #category : '*NumericalMethods' }
Float >> arcHaversine [
	^self sqrt arcSin * 2.0]

{ #category : '*NumericalMethods' }
Float >> arcTan2: y [
	| atan |
	y = 0.0 ifTrue: [^self > 0.0 ifTrue: [0.0] ifFalse: [Pi]].
	atan := (y / self) arcTan.
	self >= 0.0 ifTrue: [^atan].
	y > 0.0 ifTrue: [^atan + Pi].
	^atan - Pi]

{ #category : '*NumericalMethods' }
Float >> haversine [
	^(self / 2.0) sin squared]

