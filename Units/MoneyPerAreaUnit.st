"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MoneyPerAreaUnit,
	#superclass : #CostUnit,
	#category : #Units
}

{ #category : #accessing }
MoneyPerAreaUnit class >> constantsUnit [
	^self named: '$/acre']

{ #category : #accessing }
MoneyPerAreaUnit class >> conversions [
	^#(
		'$' 'ft2'
		'$' 'acre'
		'$M' 'acre' 
		'$' 'hectare'
		'$M' 'hectare' 
		'$' 'km2'
		'$M' 'km2'
		'eu' 'acre'
		'euM' 'acre'
		'eu' 'hectare'
		'euM' 'hectare'
		'eu' 'ft2')]

{ #category : #accessing }
MoneyPerAreaUnit class >> defaultMetricUnitName [
	^'$M/km2']

{ #category : #accessing }
MoneyPerAreaUnit class >> denominatorUnitType [
	^Unit areaUnit ]

{ #category : #accessing }
MoneyPerAreaUnit class >> typeName [
	^'Money per Area']

