"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GasRateUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #accessing }
GasRateUnit class >> constantsUnit [
	^self named: 'M scfd']

{ #category : #defaults }
GasRateUnit class >> defaultDecimalPlaces [
	^1]

{ #category : #accessing }
GasRateUnit class >> denominatorUnitType [
	^TimeUnit]

{ #category : #initialization }
GasRateUnit class >> initializeUnits [
	| day numType base |
	units := Dictionary new.
	day := TimeUnit days.
	numType := self numeratorUnitType.
	base := self newBaseUnitLeft: numType baseUnit right: day.
	self add: base.
	numType units reject: [:num | num isBaseUnit] thenDo: [:num | | new |
		new := self newForLeft: num right: day.
		new name: num name , 'd'.
		self add: new]]

{ #category : #'instance accessing' }
GasRateUnit class >> m3d [
	^self units at: 'm3d']

{ #category : #'instance accessing' }
GasRateUnit class >> mmscfd [
	^self units at: 'MM scfd']

{ #category : #'instance accessing' }
GasRateUnit class >> mscfd [
	^self units at: 'M scfd']

{ #category : #accessing }
GasRateUnit class >> numeratorUnitType [
	^GasVolumeUnit]

{ #category : #'instance accessing' }
GasRateUnit class >> scfd [
	^self named: 'scfd']

{ #category : #accessing }
GasRateUnit class >> typeName [
	^'Gas Rate']

{ #category : #private }
GasRateUnit >> defaultName [
	right = TimeUnit days ifTrue: [^left name , 'd'].
	^super defaultName]

{ #category : #testing }
GasRateUnit >> isGasRateUnit [
	^true]

{ #category : #testing }
GasRateUnit >> isSystemUnit [
	^left notNil
		and: [left isSystemUnit]
		and: [right = TimeUnit days]
		and: [name = self defaultName]]

