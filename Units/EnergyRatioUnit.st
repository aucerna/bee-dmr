"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #EnergyRatioUnit,
	#superclass : #DimensionlessUnit,
	#category : #Units
}

{ #category : #accessing }
EnergyRatioUnit class >> conversions [
	^#('kW.day' 'kW.day'
		'BTU' 'kW.h' 
		'kW.h' 'BTU' 
		'MM BTU' 'mW.h' 
		'mW.h' 'MM BTU')]

{ #category : #accessing }
EnergyRatioUnit class >> defaultBaseUnitName [
	^'efficiency']

{ #category : #defaults }
EnergyRatioUnit class >> defaultDecimalPlaces [
	^1]

{ #category : #defaults }
EnergyRatioUnit class >> defaultMetricUnitName [
	^'efficiency %']

{ #category : #defaults }
EnergyRatioUnit class >> defaultPercentName [
	^'efficiency %']

{ #category : #accessing }
EnergyRatioUnit class >> denominatorUnitType [
	^EnergyUnit]

{ #category : #accessing }
EnergyRatioUnit class >> numeratorUnitType [
	^EnergyUnit]

{ #category : #accessing }
EnergyRatioUnit class >> typeName [
	^'Energy Ratio']

{ #category : #private }
EnergyRatioUnit class >> validCode: aString [
	aString = 'ratio' ifTrue: [^self defaultBaseUnitName].
	aString = '%' ifTrue: [^self defaultPercentName].
	^super validCode: aString]

