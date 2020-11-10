"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MoneyPerGasCalorificValueUnit,
	#superclass : #CostUnit,
	#category : #Units
}

{ #category : #accessing }
MoneyPerGasCalorificValueUnit class >> constantsUnit [
	^self named: '$/(kW.day/M scf)']

{ #category : #accessing }
MoneyPerGasCalorificValueUnit class >> conversions [
	^#(
		'$' 'kW.day/M scf'
		'$' 'BTU/scf'
		'$' 'BTU/M scf'
		'$' 'J/m3'
		'$M' 'BTU/scf'
		'$MM' 'BTU/scf'
		'eu' 'BTU/scf'
		'eu' 'BTU/M scf'
		'eu' 'kW.day/M scf'
		'euMM' 'BTU/scf')]

{ #category : #accessing }
MoneyPerGasCalorificValueUnit class >> defaultMetricUnitName [
	^'$/(J/m3)']

{ #category : #accessing }
MoneyPerGasCalorificValueUnit class >> denominatorUnitType [
	^Unit gasCalorificValueUnit ]

{ #category : #accessing }
MoneyPerGasCalorificValueUnit class >> typeName [
	^'Money per Gas Calorific Value']

