"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MoneyPerOilGravityUnit,
	#superclass : #CostUnit,
	#category : #Units
}

{ #category : #accessing }
MoneyPerOilGravityUnit class >> constantsUnit [
	^self named: '$/API']

{ #category : #accessing }
MoneyPerOilGravityUnit class >> conversions [
	^#(
		'$' 'API'
		'$M' 'API'
		'$MM' 'API'
		'eu' 'API'
		'euMM' 'API')]

{ #category : #accessing }
MoneyPerOilGravityUnit class >> denominatorUnitType [
	^OilGravityUnit]

{ #category : #accessing }
MoneyPerOilGravityUnit class >> typeName [
	^'Money per Oil Gravity']

