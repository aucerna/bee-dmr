"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CostPerVolumeUnit,
	#superclass : #CostUnit,
	#category : #Units
}

{ #category : #accessing }
CostPerVolumeUnit class >> constantsUnit [
	^self named: '$/bbl']

{ #category : #accessing }
CostPerVolumeUnit class >> conversions [
	^#('$' 'bbl' 
		'$' 'm3'
		'eu' 'bbl'
		'eu' 'm3')]

{ #category : #defaults }
CostPerVolumeUnit class >> defaultDecimalPlaces [
	^1]

{ #category : #defaults }
CostPerVolumeUnit class >> defaultMetricUnitName [
	^'$/m3']

{ #category : #accessing }
CostPerVolumeUnit class >> denominatorUnitType [
	^LiquidVolumeUnit]

{ #category : #accessing }
CostPerVolumeUnit class >> typeName [
	^'Money per Liquid Volume']

