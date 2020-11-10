"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GasVolumeUnit,
	#superclass : #VolumeUnit,
	#category : #Units
}

{ #category : #private }
GasVolumeUnit class >> adaptToBase: aUnit [
	| id base |
	aUnit isLengthUnit ifFalse: [^self].
	id := aUnit name = 'cm' ifTrue: ['cc'] ifFalse: [aUnit name , '3'].
	base := self named: id ifAbsent: [| length c conversion |
		length := self baseUnit lengthUnit.
		length isNil ifTrue: [self error: 'Unsupported change of area unit'].
		c := 1.0 unitOf: length in: aUnit.
		conversion := c raisedToInteger: 3.
		self newNamed: id conversion: conversion].
	base beBaseUnitAndNormalize]

{ #category : #'instance accessing' }
GasVolumeUnit class >> bcf [
	^self units at: 'B scf']

{ #category : #constants }
GasVolumeUnit class >> co2weightPerBaseUnit [
	"
	standard CO2 density: 1.977 g/l 
	ShellDLL current openWebPage: 'http://en.wikipedia.org/wiki/Carbon_dioxide'

	GasVolumeUnit co2weightPerBaseUnit 0.69817095102431e-4 (when using Mscf)
	GasVolumeUnit co2weightPerBaseUnit 1.977  (when using m3)
	previous value: 0.17978696568866e-4, using 509.1 kg/l
	"
	| m3 liter g |
	m3 := 1 unitOf: self m3.
	liter := m3 / 1000.0.
	g := 1 unitOf: WeightUnit g.
	^1.977 / liter * g]

{ #category : #private }
GasVolumeUnit class >> componentTypes [
	^{AreaUnit. LengthUnit}]

{ #category : #accessing }
GasVolumeUnit class >> constantsUnit [
	^self named: 'M scf']

{ #category : #accessing }
GasVolumeUnit class >> conversions [
	| scf |
	scf := LengthUnit ft conversion raisedTo: 3.
	^Dictionary new
		at: 'm3' put: 1.0;
		at: 'M m3' put: 1.0 / 1000.0;
		at: 'MM m3' put: 1.0 / 1000000.0;
		at: 'B m3' put: 1.0 / 1000000000.0;
		at: 'T m3' put: 1.0 / 1000000000000.0;
		at: 'scf' put: scf;
		at: 'M scf' put: scf / 1000.0;
		at: 'MM scf' put: scf / 1000000.0;
		at: 'B scf' put: scf / 1000000000.0;
		at: 'T scf' put: scf / 1000000000000.0;
		yourself]

{ #category : #constants }
GasVolumeUnit class >> defaultBoeConversion [
	^5.8 * LiquidVolumeUnit bbl conversion / GasVolumeUnit mscf conversion]

{ #category : #defaults }
GasVolumeUnit class >> defaultMetricUnitName [
	^'M m3']

{ #category : #'instance creation' }
GasVolumeUnit class >> fromString: aString [
	| lower |
	lower := aString asLowercase.
	(lower includesString: 'cf') ifTrue: [
		(lower includesString: 'b') ifTrue: [^self units at: 'B scf'].
		(lower includesString: 'mm') ifTrue: [^self units at: 'MM scf'].
		(lower includesString: 't') ifTrue: [^self units at: 'T scf']].
	(lower includesString: 'm3') ifTrue: [
		(lower includesString: 'b') ifTrue: [^self units at: 'B m3'].
		(lower includesString: 'mm') ifTrue: [^self units at: 'MM m3'].
		(lower includesString: 't') ifTrue: [^self units at: 'T m3']].
	^self new]

{ #category : #services }
GasVolumeUnit class >> lengthCompatibleUnit [
	^self named: LengthUnit baseUnit name , '3']

{ #category : #'instance accessing' }
GasVolumeUnit class >> m3 [
	^self units at: 'm3']

{ #category : #'instance accessing' }
GasVolumeUnit class >> mm3 [
	^self units at: 'M m3']

{ #category : #'instance accessing' }
GasVolumeUnit class >> mmm3 [
	^self units at: 'MM m3']

{ #category : #'instance accessing' }
GasVolumeUnit class >> mmscf [
	^self units at: 'MM scf']

{ #category : #'instance accessing' }
GasVolumeUnit class >> mscf [
	^self units at: 'M scf']

{ #category : #accessing }
GasVolumeUnit class >> normalization [
	| u bl |
	u := self baseUnit lengthUnit.
	^u notNil ifTrue: [1.0 / (u conversion squared * u conversion)] ifFalse: [
		self baseUnit = self mscf ifTrue: [1000.0] ifFalse: [
			bl := LengthUnit baseUnit.
			1.0 unitsOf: self baseUnit in: bl * bl * bl]]]

{ #category : #bibliography }
GasVolumeUnit class >> references [
	"
	ShellDLL current openWebPage: CsrUGasVolume references
	"
	^'http://en.wikipedia.org/wiki/Standard_cubic_foot']

{ #category : #'instance accessing' }
GasVolumeUnit class >> scf [
	^self units at: 'scf']

{ #category : #accessing }
GasVolumeUnit class >> typeName [
	^'Gas Volume']

{ #category : #private }
GasVolumeUnit class >> validCode: aString [
	| code |
	code := super validCode: aString.
	code := code replaceAll: 'Mcf' with: 'M scf'.
	code := code replaceAll: 'Mm3' with: 'M m3'.
	code := code replaceAll: 'ft3' with: 'scf'.
	^code]

{ #category : #services }
GasVolumeUnit >> co2weightOf: aNumber [
	| co2 |
	co2 := self baseValueOf: aNumber.
	^co2 * self type co2weightPerBaseUnit]

{ #category : #testing }
GasVolumeUnit >> isGasVolumeUnit [
	^true]

{ #category : #accessing }
GasVolumeUnit >> lengthUnitFrom: aString [
	aString = 'scf' ifTrue: [^LengthUnit ft].
	^super lengthUnitFrom: aString]

