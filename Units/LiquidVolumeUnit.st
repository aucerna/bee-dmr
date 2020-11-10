"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #LiquidVolumeUnit,
	#superclass : #VolumeUnit,
	#category : #Units
}

{ #category : #'instance accessing' }
LiquidVolumeUnit class >> acreFt [
	^self named: 'acre.ft']

{ #category : #private }
LiquidVolumeUnit class >> adaptToBase: aUnit [
	| id base |
	aUnit isLengthUnit ifFalse: [^self].
	id := aUnit name = 'cm' ifTrue: ['cc'] ifFalse: [aUnit name , '3'].
	base := self named: id ifAbsent: [| length c conversion |
		length := self baseUnit lengthUnit.
		length isNil ifTrue: [self error: 'Unsupported change of volume unit'].
		c := 1.0 unitOf: length in: aUnit.
		conversion := c raisedToInteger: 3.
		self newNamed: id conversion: conversion].
	base beBaseUnitAndNormalize]

{ #category : #'instance accessing' }
LiquidVolumeUnit class >> bbl [
	^self units at: 'bbl']

{ #category : #'instance accessing' }
LiquidVolumeUnit class >> cc [
	^self units at: 'cc']

{ #category : #private }
LiquidVolumeUnit class >> componentTypes [
	^{AreaUnit. LengthUnit}]

{ #category : #accessing }
LiquidVolumeUnit class >> constantsUnit [
	^self named: 'bbl']

{ #category : #accessing }
LiquidVolumeUnit class >> conversions [
	| bbl ft ft3 acreInM2 |
	bbl := 6.28981077080553.
	ft := LengthUnit ft conversion.
	ft3 := ft raisedTo: 3.
	acreInM2 := Unit areaUnit m2 convert: Unit areaUnit acre conversion.
	^Dictionary new
		at: 'm3' put: 1.0;
		at: 'M m3' put: 1.0 / 1000.0;
		at: 'MM m3' put: 1.0 / 1000000.0;
		at: 'cc' put: 1000000.0;
		at: 'liters' put: 1000.0;
		at: 'bbl' put: bbl;
		at: 'M bbl' put: bbl / 1000.0;
		at: 'MM bbl' put: bbl / 1000000.0;
		at: 'ft3' put: ft3;
		at: 'M ft3' put: ft3 / 1000.0;
		at: 'MM ft3' put: ft3 / 1000000.0;
		at: 'acre.ft' put: acreInM2 * ft;
		at: 'hectare.m' put: 1.0 / 10000.0;
		at: 'gal US' put: 42.0 * bbl;
		at: 'gal UK' put: 34.972 * bbl;
		yourself]

{ #category : #defaults }
LiquidVolumeUnit class >> defaultMetricUnitName [
	^'m3']

{ #category : #converting }
LiquidVolumeUnit class >> fromString: aString [
	| string |
	string := aString asLowercase.
	(string includesString: 'bbl') ifTrue: [
		(string includesString: 'mm') ifTrue: [^self units at: 'MM bbl'].
		(string includesString: 'm') ifTrue: [^self units at: 'M bbl'].
		^self defaultInstance].
	(string includesString: 'm3') ifTrue: [^self units at: 'm3'].
	^self new]

{ #category : #'instance accessing' }
LiquidVolumeUnit class >> ft3 [
	^self units at: 'ft3']

{ #category : #services }
LiquidVolumeUnit class >> lengthCompatibleUnit [
	^LengthUnit baseUnit cubic]

{ #category : #'instance accessing' }
LiquidVolumeUnit class >> liter [
	^self named: 'liters']

{ #category : #'instance accessing' }
LiquidVolumeUnit class >> m [
	^self units at: 'M bbl']

{ #category : #'instance accessing' }
LiquidVolumeUnit class >> m3 [
	^self units at: 'm3']

{ #category : #'instance accessing' }
LiquidVolumeUnit class >> mBbl [
	^self units at: 'M bbl']

{ #category : #'instance accessing' }
LiquidVolumeUnit class >> mbbl [
	^self units at: 'M bbl']

{ #category : #'instance accessing' }
LiquidVolumeUnit class >> mm [
	^self units at: 'MM bbl']

{ #category : #'instance accessing' }
LiquidVolumeUnit class >> mm3 [
	^self units at: 'M m3']

{ #category : #'instance accessing' }
LiquidVolumeUnit class >> mmBbl [
	^self units at: 'MM bbl']

{ #category : #accessing }
LiquidVolumeUnit class >> typeName [
	^'Liquid Volume']

{ #category : #private }
LiquidVolumeUnit class >> validCode: aString [
	aString = 'cm3' ifTrue: [^'cc'].
	^super validCode: aString]

{ #category : #accessing }
LiquidVolumeUnit >> allNumerators [
	| names numerators |
	(name includes: $.) ifTrue: [
		names := $. split: name.
		numerators := names
			collect: [:n | (LengthUnit named: n) ifNil: [AreaUnit named: n]].
		(numerators conform: [:u | u notNil])
			ifTrue: [^numerators asOrderedCollection]].
	^super allNumerators]

{ #category : #testing }
LiquidVolumeUnit >> isLiquidUnit [
	^true]

{ #category : #testing }
LiquidVolumeUnit >> isSystemUnit [
	^self type class >> #conversions includes: name]

{ #category : #accessing }
LiquidVolumeUnit >> lengthUnitFrom: aString [
	| i |
	aString = 'cc' ifTrue: [^LengthUnit cm].
	i := aString indexOfLastChar: $..
	^i > 0
		ifTrue: [LengthUnit named: (aString allButFirst: i)]
		ifFalse: [super lengthUnitFrom: aString]]

{ #category : #'filein/out' }
LiquidVolumeUnit >> needsConversionMigrationTo: u [
	(name = 'acre.ft' and: [conversion = 43560.0]) ifTrue: [^false].
	(name = 'hectare.m' and: [conversion truncated = 56145]) ifTrue: [^false].
	(name = 'hectare.m' and: [conversion truncated = 353146]) ifTrue: [^false].
	^super needsConversionMigrationTo: u]

{ #category : #accessing }
LiquidVolumeUnit >> numerators [
	| names numerators |
	(name includes: $.) ifTrue: [
		names := $. split: name.
		numerators := names
			collect: [:n | (LengthUnit named: n) ifNil: [AreaUnit named: n]].
		(numerators conform: [:u | u notNil])
			ifTrue: [^numerators asOrderedCollection]].
	^super numerators]

