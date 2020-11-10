"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #EnergySteamRatioUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #accessing }
EnergySteamRatioUnit class >> constantsUnit [
	^self named: 'kW.day/CWE bbl']

{ #category : #accessing }
EnergySteamRatioUnit class >> conversions [
	^Array streamContents: [:strm | 
		strm nextPut: 'kW.day'; nextPut: 'CWE bbl'.
		strm nextPut: 'kW.day'; nextPut: 'CWE ft3'.
		#('kW.h' 'BTU' 'J')
			do: [:energy | SteamUnit units
				do: [:steam | strm nextPut: energy; nextPut: steam name]]]]

{ #category : #defaults }
EnergySteamRatioUnit class >> defaultMetricUnitName [
	^'J/CWE m3']

{ #category : #accessing }
EnergySteamRatioUnit class >> denominatorUnitType [
	^SteamUnit]

{ #category : #accessing }
EnergySteamRatioUnit class >> numeratorUnitType [
	^EnergyUnit]

{ #category : #accessing }
EnergySteamRatioUnit class >> typeName [
	^'Energy / Steam']

