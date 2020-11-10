"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GasDensityUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #accessing }
GasDensityUnit class >> constantsUnit [
	^self named: 'g/M scf']

{ #category : #accessing }
GasDensityUnit class >> conversions [
	^#(
		'g' 'M scf'
		'lb' 'M scf'
		'kg' 'm3'
		'tonne' 'm3'
		'short ton' 'M scf'
		'short ton' 'MM scf'
		'short ton' 'B scf'
		'long ton' 'M scf'
		'long ton' 'MM scf' 
		'long ton' 'B scf')]

{ #category : #defaults }
GasDensityUnit class >> defaultMetricUnitName [
	^'kg/m3']

{ #category : #accessing }
GasDensityUnit class >> denominatorUnitType [
	^GasVolumeUnit]

{ #category : #testing }
GasDensityUnit class >> isQualifier [
	^true]

{ #category : #accessing }
GasDensityUnit class >> numeratorUnitType [
	^WeightUnit]

{ #category : #accessing }
GasDensityUnit class >> typeName [
	^'Gas Density']

