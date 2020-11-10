"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #EnergyDensityUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #accessing }
EnergyDensityUnit class >> constantsUnit [
	^self named: 'kW.day/ft']

{ #category : #accessing }
EnergyDensityUnit class >> conversions [
	^#(
		'kW.day' 'ft' 
		'kW.h' 'ft' 
		'kW.h' 'm' 
		'BTU' 'ft' 
		'100MM BTU' 'ft' )]

{ #category : #accessing }
EnergyDensityUnit class >> denominatorUnitType [
	^LengthUnit]

{ #category : #testing }
EnergyDensityUnit class >> isQualifier [
	^true]

{ #category : #accessing }
EnergyDensityUnit class >> numeratorUnitType [
	^EnergyUnit]

{ #category : #accessing }
EnergyDensityUnit class >> typeName [
	^'Energy Density' ]

