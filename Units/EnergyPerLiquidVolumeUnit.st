"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #EnergyPerLiquidVolumeUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #accessing }
EnergyPerLiquidVolumeUnit class >> conversions [
	^#(
		'kW.day' 'bbl'
		'kW.day' 'm3'
		'kW.h' 'bbl'
		'kW.h' 'm3'
		'mW.h' 'bbl'
		'BTU' 'm3'
		'BTU' 'bbl'
		'M BTU' 'm3'
		'M BTU' 'bbl'
		'MM BTU' 'M m3'
		'MM BTU' 'M bbl')]

{ #category : #defaults }
EnergyPerLiquidVolumeUnit class >> defaultMetricUnitName [
	^'kW.h/m3']

{ #category : #accessing }
EnergyPerLiquidVolumeUnit class >> denominatorUnitType [
	^LiquidVolumeUnit]

{ #category : #accessing }
EnergyPerLiquidVolumeUnit class >> numeratorUnitType [
	^EnergyUnit]

{ #category : #accessing }
EnergyPerLiquidVolumeUnit class >> typeName [
	^'Energy per Liquid Volume']

