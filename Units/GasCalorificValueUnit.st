"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GasCalorificValueUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #accessing }
GasCalorificValueUnit class >> btuPerMscf [
	^self named: 'BTU/M scf']

{ #category : #accessing }
GasCalorificValueUnit class >> btuPerScf [
	^self named: 'BTU/scf']

{ #category : #accessing }
GasCalorificValueUnit class >> constantsUnit [
	^self named: 'BTU/scf']

{ #category : #accessing }
GasCalorificValueUnit class >> conversions [
	^#(		
		'kW.day' 'M scf'
		'BTU' 'scf'
		'BTU' 'M scf'
		'J' 'm3'
		'MJ' 'm3')]

{ #category : #defaults }
GasCalorificValueUnit class >> defaultMetricUnitName [
	^'J/m3']

{ #category : #accessing }
GasCalorificValueUnit class >> denominatorUnitType [
	^GasVolumeUnit]

{ #category : #testing }
GasCalorificValueUnit class >> isQualifier [
	^true]

{ #category : #accessing }
GasCalorificValueUnit class >> numeratorUnitType [
	^EnergyUnit]

{ #category : #accessing }
GasCalorificValueUnit class >> typeName [
	^'Gas Calorific Value']

{ #category : #'filein/out' }
GasCalorificValueUnit >> needsConversionMigrationTo: u [
	^(u name includesString: 'joule')
		ifTrue: [
			conversion notNil
				and: [self canOverrideConversion not]
				and: [(u conversion relativeDistanceTo: conversion) > 0.001]]
		ifFalse: [super needsConversionMigrationTo: u]]

