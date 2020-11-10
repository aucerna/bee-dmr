"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #InverseDensityUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #accessing }
InverseDensityUnit class >> constantsUnit [
	^self named: 'cc/g']

{ #category : #accessing }
InverseDensityUnit class >> conversions [
	^#(
		'bbl' 'g' 
		'cc' 'g'
		'm3' 'kg'
		'ft3' 'lb'
		'gal US' 'lb'
		'gal UK' 'lb'
		'gal US' 'short ton'
		'bbl' 'lb')]

{ #category : #defaults }
InverseDensityUnit class >> defaultMetricUnitName [
	^'cc/g']

{ #category : #accessing }
InverseDensityUnit class >> denominatorUnitType [
	^WeightUnit]

{ #category : #testing }
InverseDensityUnit class >> isQualifier [
	^true]

{ #category : #accessing }
InverseDensityUnit class >> numeratorUnitType [
	^LiquidVolumeUnit]

{ #category : #accessing }
InverseDensityUnit class >> typeName [
	^'Inverse density']

{ #category : #private }
InverseDensityUnit class >> validCode: aString [
	| code |
	code := super validCode: aString.
	code := code replaceAll: '/ton' with: '/short ton'.
	^code]

