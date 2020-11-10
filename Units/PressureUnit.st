"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PressureUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #accessing }
PressureUnit class >> atm [
	^self named: 'atm']

{ #category : #accessing }
PressureUnit class >> bar [
	^self named: 'bar']

{ #category : #accessing }
PressureUnit class >> constantsUnit [
	^self named: 'psi']

{ #category : #accessing }
PressureUnit class >> conversions [
	^#(
		'lbf' 'in2'
		'N' 'm2'
		'kN' 'm2'
		'MN' 'm2'
		'Mdyn' 'cm2')]

{ #category : #defaults }
PressureUnit class >> defaultDecimalPlaces [
	^1]

{ #category : #defaults }
PressureUnit class >> defaultMetricUnitName [
	^'kPA']

{ #category : #defaults }
PressureUnit class >> defaultStandardPressure [
	^14.6 unitsOf: self psi
	"^1 unitsOf: self atm"]

{ #category : #accessing }
PressureUnit class >> denominatorUnitType [
	^AreaUnit ]

{ #category : #initialization }
PressureUnit class >> initializeUnits [
	| atm v |
	super initializeUnits.
	v := 101325.01 unitsOf: (self named: 'Pa').
	atm := self new name: 'atm'; conversion: v reciprocal.
	self add: atm]

{ #category : #testing }
PressureUnit class >> isQualifier [
	^true]

{ #category : #accessing }
PressureUnit class >> kPA [
	^self named: 'kPA']

{ #category : #accessing }
PressureUnit class >> MPA [
	^self named: 'MPA']

{ #category : #accessing }
PressureUnit class >> numeratorUnitType [
	^ForceUnit ]

{ #category : #accessing }
PressureUnit class >> pascal [
	^self named: 'Pa']

{ #category : #accessing }
PressureUnit class >> psi [
	^self units at: 'psi']

{ #category : #accessing }
PressureUnit class >> typeName [
	^'Pressure']

{ #category : #private }
PressureUnit class >> validCode: aString [
	| code |
	code := super validCode: aString.
	code := code replaceAll: 'PA' with: 'Pa'.
	^code]

{ #category : #private }
PressureUnit >> defaultName [
	(left isNil or: [right isNil]) ifTrue: [^super defaultName].
	(left name = 'N' and: [right name = 'm2']) ifTrue: [^'Pa'].
	(left name = 'kN' and: [right name = 'm2']) ifTrue: [^'kPa'].
	(left name = 'MN' and: [right name = 'm2']) ifTrue: [^'MPa'].
	(left name = 'lbf' and: [right name = 'in2']) ifTrue: [^'psi'].
	(left name = 'Mdyn' and: [right name = 'cm2']) ifTrue: [^'bar'].
	^super defaultName]

{ #category : #testing }
PressureUnit >> isSystemUnit [
	^name = 'atm' or: [super isSystemUnit]]

