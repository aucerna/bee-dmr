"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #EnergyWeightRatioUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #accessing }
EnergyWeightRatioUnit class >> constantsUnit [
	^self named: 'kW.day/g']

{ #category : #accessing }
EnergyWeightRatioUnit class >> conversions [
	^#(
		'kW.day' 'g'	
		'kW.day' 'kg'
		'kW.h' 'lb'
		'BTU' 'short ton' 
		'BTU' 'lb' 
		'100MM BTU' 'short ton' 
		'BTU' 'g' 
		'J' 'kg' 
		'kJ' 'kg')]

{ #category : #defaults }
EnergyWeightRatioUnit class >> defaultMetricUnitName [
	^'J/kg']

{ #category : #accessing }
EnergyWeightRatioUnit class >> denominatorUnitType [
	^WeightUnit]

{ #category : #accessing }
EnergyWeightRatioUnit class >> numeratorUnitType [
	^EnergyUnit]

{ #category : #accessing }
EnergyWeightRatioUnit class >> typeName [
	^'Energy / Weight']

