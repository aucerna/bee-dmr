"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GasVolumeRatioUnit,
	#superclass : #DimensionlessUnit,
	#category : #Units
}

{ #category : #accessing }
GasVolumeRatioUnit class >> conversions [
	^#('m3' 'm3'
 		'm3' 'M m3'
		'M m3' 'm3'
		'scf' 'scf'
		'M scf' 'M scf'
		'M scf' 'MM scf')]

{ #category : #defaults }
GasVolumeRatioUnit class >> defaultMetricUnitName [
	^'m3/M m3']

{ #category : #accessing }
GasVolumeRatioUnit class >> denominatorUnitType [
	^GasVolumeUnit]

{ #category : #accessing }
GasVolumeRatioUnit class >> numeratorUnitType [
	^GasVolumeUnit]

{ #category : #accessing }
GasVolumeRatioUnit class >> typeName [
	^'Gas Volume Ratio']

