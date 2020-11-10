"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CostPerEnergyUnit,
	#superclass : #CostUnit,
	#category : #Units
}

{ #category : #accessing }
CostPerEnergyUnit class >> constantsUnit [
	^self named: '$/kW.day']

{ #category : #accessing }
CostPerEnergyUnit class >> conversions [
	^#(
		'$' 'kW.day' 
		'$' 'kW.h' 
		'$' 'mW.h' 
		'$' 'BTU' 
		'$' 'MM BTU' 
		'$M' 'mW.h'
		'$M' 'BTU' 
		'$MM' 'kW.day' 
		'$MM' 'kW.h' 
		'$MM' 'mW.h'
		'$MM' 'BTU' 
		'eu' 'kW.day'
		'eu' 'kW.h' 
		'eu' 'mW.h'
		'eu' 'BTU' 
		'euMM' 'kW.day' 
		'euMM' 'kW.h' 
		'euMM' 'mW.h'
		'euMM' 'BTU' )]

{ #category : #defaults }
CostPerEnergyUnit class >> defaultMetricUnitName [
	^'$/kW.h']

{ #category : #accessing }
CostPerEnergyUnit class >> denominatorUnitType [
	^EnergyUnit]

{ #category : #accessing }
CostPerEnergyUnit class >> typeName [
	^'Money per Energy']

