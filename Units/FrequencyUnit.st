"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FrequencyUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #defaults }
FrequencyUnit class >> defaultDecimalPlaces [
	^0]

{ #category : #accessing }
FrequencyUnit class >> denominatorUnitType [
	^TimeUnit]

{ #category : #'instance accessing' }
FrequencyUnit class >> existingUnitForLeft: lUnit right: rUnit [
	lUnit isNumberUnit ifFalse: [^nil].
	^units detect: [:u | u rightUnit = rUnit] ifNone: nil]

{ #category : #initialization }
FrequencyUnit class >> initializeUnits [
	| num base |
	units := Dictionary new.
	num := Unit number.
	base := self newBaseUnitLeft: num right: self denominatorUnitType baseUnit.
	self add: base.
	self denominatorUnitType units
		reject: [:den | den isBaseUnit]
		thenDo: [:den | | new |
			new := self newForLeft: num right: den.
			self add: new]]

{ #category : #accessing }
FrequencyUnit class >> numeratorUnitType [
	^NumberUnit]

{ #category : #accessing }
FrequencyUnit class >> typeName [
	^'Frequency']

{ #category : #'instance accessing' }
FrequencyUnit class >> unitsPerDay [
	^self baseUnit]

{ #category : #'instance accessing' }
FrequencyUnit class >> unitsPerMonth [
	^units at: 'units per month']

{ #category : #'instance accessing' }
FrequencyUnit class >> unitsPerYear [
	^units at: 'units per year']

{ #category : #private }
FrequencyUnit >> defaultName [
	| r |
	r := right isNil ifTrue: ['?'] ifFalse: [right name].
	^'units per ' , r]

{ #category : #testing }
FrequencyUnit >> isSystemUnit [
	^right notNil
		and: [right isSystemUnit]
		and: [left = Unit number]
		and: [name = self defaultName]]

