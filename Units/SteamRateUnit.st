"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SteamRateUnit,
	#superclass : #CompositeUnit,
	#instVars : [
		'quality',
		'temperature'
	],
	#category : #Units
}

{ #category : #'instance accessing' }
SteamRateUnit class >> bpd [
	^self named: 'CWE bpd']

{ #category : #accessing }
SteamRateUnit class >> constantsUnit [
	^self named: 'CWE bpd']

{ #category : #accessing }
SteamRateUnit class >> denominatorUnitType [
	^TimeUnit]

{ #category : #initialization }
SteamRateUnit class >> initializeUnits [
	| day numType base |
	units := Dictionary new.
	day := TimeUnit days.
	numType := self numeratorUnitType.
	base := self newBaseUnitLeft: numType baseUnit right: day.
	self add: base.
	numType units reject: [:num | num isBaseUnit] thenDo: [:num | | new |
		new := self newForLeft: num right: day.
		new name: (num name replaceAll: 'bbl' with: 'bp') , 'd'.
		self add: new]]

{ #category : #'instance accessing' }
SteamRateUnit class >> m3d [
	^self named: 'CWE m3d']

{ #category : #accessing }
SteamRateUnit class >> numeratorUnitType [
	^SteamUnit]

{ #category : #accessing }
SteamRateUnit class >> typeName [
	^'Steam Rate']

{ #category : #private }
SteamRateUnit >> defaultName [
	right = TimeUnit days ifTrue: [^(left name replaceAll: 'bbl' with: 'bp') , 'd'].
	^super defaultName]

{ #category : #testing }
SteamRateUnit >> isSystemUnit [
	^left notNil
		and: [left isSystemUnit]
		and: [right = TimeUnit days]
		and: [name = self defaultName]]

{ #category : #accessing }
SteamRateUnit >> quality [
	^quality]

{ #category : #accessing }
SteamRateUnit >> quality: aNumber [
	quality := aNumber]

{ #category : #accessing }
SteamRateUnit >> temperature [
	^temperature]

{ #category : #accessing }
SteamRateUnit >> temperature: aNumber [
	temperature := aNumber]

