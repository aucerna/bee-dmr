"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #VolumeRatioUnit,
	#superclass : #DimensionlessUnit,
	#category : #Units
}

{ #category : #accessing }
VolumeRatioUnit class >> conversions [
	^#('bbl' 'bbl'
		'bbl' 'acre.ft'
		'm3' 'hectare.m'
		'bbl' 'ft3'
		'bbl' 'm3'
		'm3' 'bbl')]

{ #category : #defaults }
VolumeRatioUnit class >> defaultMetricUnitName [
	^'m3/hectare.m']

{ #category : #accessing }
VolumeRatioUnit class >> denominatorUnitType [
	^LiquidVolumeUnit]

{ #category : #testing }
VolumeRatioUnit class >> isLiquidUnit [
	^true]

{ #category : #accessing }
VolumeRatioUnit class >> numeratorUnitType [
	^LiquidVolumeUnit]

{ #category : #accessing }
VolumeRatioUnit class >> typeName [
	^'Volume Ratio']

{ #category : #'gui support' }
VolumeRatioUnit >> displayName [
	name = 'factor' ifTrue: [^''].
	^super displayName]

{ #category : #'filein/out' }
VolumeRatioUnit >> needsConversionMigrationTo: u [
	(name = 'bbl/acre.ft' and: [conversion ~= 0.40887758947493e-5])
		ifTrue: [^false].
	(name = 'm3/hectare.m' and: [conversion ~= 0.28316846592e-5])
		ifTrue: [^false].
	^super needsConversionMigrationTo: u]

