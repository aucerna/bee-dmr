"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SteamUnit,
	#superclass : #VolumeUnit,
	#instVars : [
		'quality',
		'temperature'
	],
	#category : #Units
}

{ #category : #private }
SteamUnit class >> adaptToBase: aUnit [
	| id base |
	aUnit isLengthUnit ifFalse: [^self].
	id := 'CWE ' , aUnit name , '3'.
	base := self named: id ifAbsent: [| length c conversion |
		length := self baseUnit lengthUnit.
		length isNil ifTrue: [self error: 'Unsupported change of steam unit'].
		c := 1.0 unitOf: length in: aUnit.
		conversion := c raisedToInteger: 3.
		self newNamed: id conversion: conversion].
	base beBaseUnitAndNormalize]

{ #category : #'instance accessing' }
SteamUnit class >> bbl [
	^self named: 'CWE bbl']

{ #category : #accessing }
SteamUnit class >> componentTypes [
	^{LiquidVolumeUnit}]

{ #category : #accessing }
SteamUnit class >> constantsUnit [
	^self named: 'CWE bbl']

{ #category : #accessing }
SteamUnit class >> conversions [
	| ft3 bbl m3 |
	ft3 := LiquidVolumeUnit ft3 conversion.
	bbl := LiquidVolumeUnit bbl conversion.
	m3 := LiquidVolumeUnit m3 conversion.
	^Dictionary new
		at: 'CWE m3' put: m3;
		at: 'CWE M m3' put: m3 / 1000.0;
		at: 'CWE MM m3' put: m3 / 1000000.0;
		at: 'CWE bbl' put: bbl;
		at: 'CWE M bbl' put: bbl / 1000.0;
		at: 'CWE MM bbl' put: bbl / 1000000.0;
		at: 'CWE ft3' put: ft3;
		at: 'CWE M ft3' put: ft3 / 1000.0;
		at: 'CWE MM ft3' put: ft3 / 1000000.0;
		yourself]

{ #category : #defaults }
SteamUnit class >> defaultMetricUnitName [
	^'CWE m3']

{ #category : #accessing }
SteamUnit class >> lengthCompatibleUnit [
	^self named: 'CWE ', LengthUnit baseUnit name , '3']

{ #category : #'instance accessing' }
SteamUnit class >> m3 [
	^self named: 'CWE m3']

{ #category : #accessing }
SteamUnit class >> typeName [
	^'Steam Volume']

{ #category : #accessing }
SteamUnit >> lengthUnitFrom: aString [
	| n |
	n := aString.
	(aString beginsWith: 'CWE ') ifTrue: [n := n allButFirst: 'CWE ' size].
	n := (n endsWith: '3')
		ifTrue: [n allButLast trimBlanks]
		ifFalse: [n = 'cc' ifTrue: ['cm']].
	^LengthUnit named: n]

{ #category : #accessing }
SteamUnit >> quality [
	^quality]

{ #category : #accessing }
SteamUnit >> quality: aNumber [
	quality := aNumber]

{ #category : #accessing }
SteamUnit >> temperature [
	^temperature]

{ #category : #accessing }
SteamUnit >> temperature: aNumber [
	temperature := aNumber]

