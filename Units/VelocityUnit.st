"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #VelocityUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #accessing }
VelocityUnit class >> constantsUnit [
	^self named: 'ft/day']

{ #category : #accessing }
VelocityUnit class >> conversions [
	^#(
		'ft' 'day'
		'm' 'day'
		'mile' 'hour')]

{ #category : #accessing }
VelocityUnit class >> denominatorUnitType [
	^TimeUnit]

{ #category : #accessing }
VelocityUnit class >> numeratorUnitType [
	^LengthUnit]

{ #category : #accessing }
VelocityUnit class >> typeName [
	^'Velocity']

{ #category : #private }
VelocityUnit >> defaultName [
	(left isNil or: [right isNil]) ifTrue: [^super defaultName].
	^(left name = 'mile' and: [right name = 'hour'])
		ifTrue: ['mph']
		ifFalse: [super defaultName]]

