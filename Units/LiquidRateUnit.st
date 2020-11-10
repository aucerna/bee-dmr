"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #LiquidRateUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #accessing }
LiquidRateUnit class >> bpd [
	^self units at: 'bpd']

{ #category : #accessing }
LiquidRateUnit class >> constantsUnit [
	^self named: 'bpd']

{ #category : #defaults }
LiquidRateUnit class >> defaultDecimalPlaces [
	^1]

{ #category : #accessing }
LiquidRateUnit class >> denominatorUnitType [
	^TimeUnit]

{ #category : #accessing }
LiquidRateUnit class >> ft3d [
	^self units at: 'ft3d']

{ #category : #initialization }
LiquidRateUnit class >> initializeUnits [
	| day numType base |
	units := Dictionary new.
	day := TimeUnit days.
	numType := self numeratorUnitType.
	base := self newBaseUnitLeft: numType baseUnit right: day.
	self add: base.
	#('bbl' 'ft3' 'm3' 'M bbl' 'M ft3' 'M m3' 'MM bbl' 'MM ft3' 'MM m3')
		do: [:n | | new num |
			num := numType named: n.
			self ASSERT: num notNil.
			base leftUnit = num ifFalse: [
				new := self newForLeft: num right: day.
				new name: (num name replaceAll: 'bbl' with: 'bp') , 'd'.
				self add: new]]]

{ #category : #accessing }
LiquidRateUnit class >> m3d [
	^self units at: 'm3d']

{ #category : #accessing }
LiquidRateUnit class >> numeratorUnitType [
	^LiquidVolumeUnit]

{ #category : #accessing }
LiquidRateUnit class >> typeName [
	^'Liquid Rate']

{ #category : #private }
LiquidRateUnit >> defaultName [
	right = TimeUnit days
		ifTrue: [^(left name replaceAll: 'bbl' with: 'bp') , 'd'].
	^super defaultName]

{ #category : #testing }
LiquidRateUnit >> isLiquidUnit [
	^true]

{ #category : #testing }
LiquidRateUnit >> isOilRateUnit [
	^true]

{ #category : #testing }
LiquidRateUnit >> isSystemUnit [
	^left notNil
		and: [left isSystemUnit]
		and: [right = TimeUnit days]
		and: [name = self defaultName]]

