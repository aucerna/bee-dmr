"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #AccelerationUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #accessing }
AccelerationUnit class >> conversions [
	^#('ft' 'day2'
		'ft' 's2'
		'cm' 's2'
		'm' 's2'
		'm' 'day2')]

{ #category : #accessing }
AccelerationUnit class >> denominatorUnitType [
	^TimeUnit squared]

{ #category : #accessing }
AccelerationUnit class >> gn [
	^self named: 'gn']

{ #category : #initialization }
AccelerationUnit class >> initializeUnits [
	| gn newton |
	super initializeUnits.
	gn := self new name: 'gn'.
	newton := 9.80665 unitsOf: (self named: 'm/s2').
	gn conversion: newton reciprocal.
	self add: gn]

{ #category : #testing }
AccelerationUnit class >> isPrivate [
	^true]

{ #category : #accessing }
AccelerationUnit class >> numeratorUnitType [
	^LengthUnit]

{ #category : #accessing }
AccelerationUnit class >> typeName [
	^'Acceleration']

{ #category : #testing }
AccelerationUnit >> isSystemUnit [
	^name = 'gn' or: [super isSystemUnit]]

