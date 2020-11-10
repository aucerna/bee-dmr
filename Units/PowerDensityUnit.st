"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PowerDensityUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #accessing }
PowerDensityUnit class >> constantsUnit [
	^self named: 'kW/ft']

{ #category : #accessing }
PowerDensityUnit class >> conversions [
	^#(
		'kW' 'ft'
		'kW' 'm'
		'BTU/h' 'ft'
		'100MM BTU/year' 'ft')]

{ #category : #accessing }
PowerDensityUnit class >> denominatorUnitType [
	^LengthUnit]

{ #category : #testing }
PowerDensityUnit class >> isPrivate [
	^true]

{ #category : #testing }
PowerDensityUnit class >> isQualifier [
	^true]

{ #category : #accessing }
PowerDensityUnit class >> numeratorUnitType [
	^ElectricalPowerUnit]

{ #category : #accessing }
PowerDensityUnit class >> typeName [
	^'Power Density']

{ #category : #private }
PowerDensityUnit >> oldDefaultName [
	left isNil | right isNil ifTrue: [^self defaultName].
	left name = 'BTU/h' ifTrue: [^'BTU/h-' , right name].
	left name = '100MM BTU/year' ifTrue: [^'100MM BTU/' , right name , '/year'].
	^self defaultName]

