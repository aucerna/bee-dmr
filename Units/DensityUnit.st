"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #DensityUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #accessing }
DensityUnit class >> constantsUnit [
	^self named: 'g/cc']

{ #category : #accessing }
DensityUnit class >> conversions [
	^#(
		'g' 'bbl'
		'g' 'cc' 
		'g' 'm3'
		'kg' 'm3'
		'lb' 'ft3'
		'lb' 'gal US' 
		'lb' 'gal UK')]

{ #category : #defaults }
DensityUnit class >> defaultMetricUnitName [
	^'g/cc']

{ #category : #accessing }
DensityUnit class >> denominatorUnitType [
	^LiquidVolumeUnit]

{ #category : #testing }
DensityUnit class >> isQualifier [
	^true]

{ #category : #accessing }
DensityUnit class >> numeratorUnitType [
	^WeightUnit]

{ #category : #accessing }
DensityUnit class >> typeName [
	^'Density']

{ #category : #private }
DensityUnit class >> validCode: aString [
	| code |
	code := super validCode: aString.
	code := code replaceAll: 'gm' with: 'g'.
	^code]

