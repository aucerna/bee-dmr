"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ForceUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #accessing }
ForceUnit class >> conversions [
	^#('g' 'ft/day2'
		'kg' 'm/day2'
		'kg' 'm/s2'
		'tonne' 'm/s2'
		'lb' 'gn'
		'g' 'cm/s2'
		'tonne' 'cm/s2' )]

{ #category : #initialization }
ForceUnit class >> initializeUnits [
	| meganewton |
	super initializeUnits.
	meganewton := self new
		name: 'MN';
		conversion: (1000 unitsOf: (self named: 'kN')) reciprocal.
	self add: meganewton]

{ #category : #testing }
ForceUnit class >> isPrivate [
	^true]

{ #category : #accessing }
ForceUnit class >> kiloNewton [
	^self named: 'kN']

{ #category : #accessing }
ForceUnit class >> lbf [
	^self named: 'lbf']

{ #category : #accessing }
ForceUnit class >> leftUnitType [
	^WeightUnit]

{ #category : #accessing }
ForceUnit class >> megaNewton [
	^self named: 'MN']

{ #category : #accessing }
ForceUnit class >> newton [
	^self named: 'N']

{ #category : #accessing }
ForceUnit class >> operator [
	^#*]

{ #category : #accessing }
ForceUnit class >> rightUnitType [
	^AccelerationUnit]

{ #category : #accessing }
ForceUnit class >> typeName [
	^'Force']

{ #category : #private }
ForceUnit >> defaultName [
	(left isNil or: [right isNil]) ifTrue: [^super defaultName].
	(left name = 'kg' and: [right name = 'm/s2']) ifTrue: [^'N'].
	(left name = 'lb' and: [right name = 'gn']) ifTrue: [^'lbf'].
	(left name = 'tonne' and: [right name = 'm/s2']) ifTrue: [^'kN'].
	(left name = 'g' and: [right name = 'cm/s2']) ifTrue: [^'dyn'].
	(left name = 'tonne' and: [right name = 'cm/s2']) ifTrue: [^'Mdyn'].
	^super defaultName]

{ #category : #testing }
ForceUnit >> isSystemUnit [
	^name = 'MN' or: [super isSystemUnit]]

