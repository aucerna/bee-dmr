"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CostPerPowerUnit,
	#superclass : #CostUnit,
	#category : #Units
}

{ #category : #accessing }
CostPerPowerUnit class >> constantsUnit [
	^self named: '$/kW']

{ #category : #accessing }
CostPerPowerUnit class >> conversions [
	^#(
		'$' 'kW' 
		'$' 'mW'
		'$' 'BTU/h' 
		'$MM' 'kW'
		'$MM' 'mW'
		'$MM' 'BTU/h'
		'eu' 'kW'
		'eu' 'mW'
		'eu' 'BTU/h'
		'euMM' 'kW'
		'euMM' 'mW'
		'euMM' 'BTU/h')]

{ #category : #defaults }
CostPerPowerUnit class >> defaultMetricUnitName [
	^'$/kW']

{ #category : #accessing }
CostPerPowerUnit class >> denominatorUnitType [
	^ElectricalPowerUnit]

{ #category : #accessing }
CostPerPowerUnit class >> typeName [
	^'Money per Power']

{ #category : #private }
CostPerPowerUnit class >> validCode: aString [
	| code |
	code := super validCode: aString.
	code := code replaceAll: '/BTU/h' with: '/(BTU/h)'.
	^code]

