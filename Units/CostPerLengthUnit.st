"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CostPerLengthUnit,
	#superclass : #CostUnit,
	#category : #Units
}

{ #category : #accessing }
CostPerLengthUnit class >> constantsUnit [
	^self named: '$MM/mile']

{ #category : #accessing }
CostPerLengthUnit class >> conversions [
	^#(
		'$' 'ft'
		'$MM' 'mile'
		'$MM' 'km'
		'euMM' 'mile'
		'euMM' 'km' 
		'eu' 'ft')]

{ #category : #defaults }
CostPerLengthUnit class >> defaultDecimalPlaces [
	^3]

{ #category : #defaults }
CostPerLengthUnit class >> defaultMetricUnitName [
	^'$MM/km']

{ #category : #accessing }
CostPerLengthUnit class >> denominatorUnitType [
	^LengthUnit]

{ #category : #accessing }
CostPerLengthUnit class >> typeName [
	^'Cost Per Length']

