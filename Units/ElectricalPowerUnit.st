"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ElectricalPowerUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #accessing }
ElectricalPowerUnit class >> constantsUnit [
	^self named: 'kW']

{ #category : #accessing }
ElectricalPowerUnit class >> conversions [
	^#(
		'kW.h' 'hour'
		'mW.h' 'hour'
		'gW.h' 'hour'
		'BTU' 'hour'
		'100MM BTU' 'year'
		'J' 's'
		'hp.h' 'hour')]

{ #category : #defaults }
ElectricalPowerUnit class >> defaultDecimalPlaces [
	^3]

{ #category : #accessing }
ElectricalPowerUnit class >> denominatorUnitType [
	^TimeUnit]

{ #category : #accessing }
ElectricalPowerUnit class >> gW [
	^units at: 'gW']

{ #category : #accessing }
ElectricalPowerUnit class >> hp [
	^units at: 'hp']

{ #category : #accessing }
ElectricalPowerUnit class >> kW [
	^units at: 'kW']

{ #category : #accessing }
ElectricalPowerUnit class >> mW [
	^units at: 'mW']

{ #category : #accessing }
ElectricalPowerUnit class >> numeratorUnitType [
	^EnergyUnit]

{ #category : #accessing }
ElectricalPowerUnit class >> typeName [
	^'Electrical Power']

{ #category : #private }
ElectricalPowerUnit class >> validCode: aString [
	| code |
	code := super validCode: aString.
	code := code replaceAll: 'kw' with: 'kW'.
	code := code replaceAll: 'mw' with: 'mW'.
	^code]

{ #category : #private }
ElectricalPowerUnit >> defaultName [
	(left isNil or: [right isNil]) ifTrue: [^super defaultName].
	^left explicitTime = right
		ifTrue: [left name upTo: $.]
		ifFalse: [left name , '/' , (right name replaceAll: 'hour' with: 'h')]]

{ #category : #testing }
ElectricalPowerUnit >> hasExplicitTime [
	^name includes: $/]

{ #category : #testing }
ElectricalPowerUnit >> matchesLeft: aUnit right: anotherUnit [
	^(super matchesLeft: aUnit right: anotherUnit) or: [
		self hasExplicitTime not
			and: [aUnit type == EnergyUnit] 
			and: [aUnit explicitTime = anotherUnit]
			and: [self = aUnit powerUnit]]]

