"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CostPerGasVolumeUnit,
	#superclass : #CostUnit,
	#category : #Units
}

{ #category : #accessing }
CostPerGasVolumeUnit class >> constantsUnit [
	^self named: '$/M scf']

{ #category : #accessing }
CostPerGasVolumeUnit class >> conversions [
	^#(
		'$' 'M scf' 
		'$' 'M m3' 
		'eu' 'M scf' 
		'eu' 'M m3')]

{ #category : #defaults }
CostPerGasVolumeUnit class >> defaultDecimalPlaces [
	^1]

{ #category : #defaults }
CostPerGasVolumeUnit class >> defaultMetricUnitName [
	^'$/M m3']

{ #category : #accessing }
CostPerGasVolumeUnit class >> denominatorUnitType [
	^GasVolumeUnit]

{ #category : #accessing }
CostPerGasVolumeUnit class >> typeName [
	^'Money per Gas Volume']

