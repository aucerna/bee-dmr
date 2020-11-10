"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SteamLiquidVolumeRatioUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #'instance accessing' }
SteamLiquidVolumeRatioUnit class >> bbl [
	^self named: 'CWE bbl/bbl']

{ #category : #accessing }
SteamLiquidVolumeRatioUnit class >> conversions [
	^#('CWE m3' 'm3'
		'CWE bbl' 'bbl')]

{ #category : #defaults }
SteamLiquidVolumeRatioUnit class >> defaultMetricUnitName [
	^'CWE m3/m3']

{ #category : #accessing }
SteamLiquidVolumeRatioUnit class >> denominatorUnitType [
	^LiquidVolumeUnit]

{ #category : #'instance accessing' }
SteamLiquidVolumeRatioUnit class >> m3 [
	^self named: 'CWE m3/m3']

{ #category : #accessing }
SteamLiquidVolumeRatioUnit class >> numeratorUnitType [
	^SteamUnit]

{ #category : #accessing }
SteamLiquidVolumeRatioUnit class >> typeName [
	^'Steam to Oil Volume Ratio']

