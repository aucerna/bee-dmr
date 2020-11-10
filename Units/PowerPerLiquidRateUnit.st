"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PowerPerLiquidRateUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #accessing }
PowerPerLiquidRateUnit class >> conversions [
	^#(
		'kW' 'bpd'
		'kW' 'm3d'
		'hp' 'm3d'
		'hp' 'bpd')]

{ #category : #defaults }
PowerPerLiquidRateUnit class >> defaultMetricUnitName [
	^'kW/m3d']

{ #category : #accessing }
PowerPerLiquidRateUnit class >> denominatorUnitType [
	^LiquidRateUnit]

{ #category : #accessing }
PowerPerLiquidRateUnit class >> kWbpd [
	^self named: 'kW/bpd']

{ #category : #accessing }
PowerPerLiquidRateUnit class >> numeratorUnitType [
	^ElectricalPowerUnit]

{ #category : #accessing }
PowerPerLiquidRateUnit class >> typeName [
	^'Power per Liquid Rate']

