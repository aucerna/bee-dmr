"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #NumberUnit,
	#superclass : #Unit,
	#category : #Units
}

{ #category : #testing }
NumberUnit class >> canAddUnit [
	^false]

{ #category : #accessing }
NumberUnit class >> conversions [
	^Dictionary new
		at: '<none>' put: 1.0;
		at: 'integer number' put: 1.0;
		yourself]

{ #category : #defaults }
NumberUnit class >> defaultDecimalPlaces [
	^3]

{ #category : #initialization }
NumberUnit class >> initializeUnitsFrom: aDictionary [
	super initializeUnitsFrom: aDictionary.
	self baseUnit: (self named: '<none>')]

{ #category : #'instance accessing' }
NumberUnit class >> integer [
	^self units at: 'integer number']

{ #category : #testing }
NumberUnit class >> isCompatibleWith: unitType [
	^unitType isDimensionless and: [unitType hasLinearConversion]]

{ #category : #testing }
NumberUnit class >> isDimensionless [
	^true]

{ #category : #testing }
NumberUnit class >> isQuantifier [
	^true]

{ #category : #accessing }
NumberUnit class >> numerator: aUnit denominator: anotherUnit [
	self ASSERT: aUnit type == anotherUnit type.
	^aUnit type == self ifTrue: [aUnit] ifFalse: [self defaultInstance]]

{ #category : #services }
NumberUnit class >> readUnitsFrom: aDictionary [
	^#()]

{ #category : #accessing }
NumberUnit class >> typeName [
	^'Number']

{ #category : #arithmetic }
NumberUnit >> - aUnit [
	aUnit baseClass = Date ifTrue: [^InvalidUnit defaultInstance].
	^super - aUnit]

{ #category : #arithmetic }
NumberUnit >> / aUnit [
	| type |
	aUnit isInvalidUnit ifTrue: [^super / aUnit].
	aUnit isCompositeUnit ifFalse: [^super / aUnit].
	aUnit numeratorUnitType = self type ifTrue: [^aUnit denominator].
	type := Unit
		typeForLeft: aUnit denominatorUnitType
		right: aUnit numeratorUnitType
		operator: #'/'.
	type isNil ifTrue: [
		type := aUnit hasSystemUnitType
			ifTrue: [CompositeUnitType
				left: self type
				operator: #'/'
				right: aUnit type]].
	^type isNil
		ifTrue: [aUnit denominator type = self type
			ifFalse: [aUnit denominator / aUnit numerator]]
		ifFalse: [(type unitForLeft: self right: aUnit) ifNil: [type defaultUnit]]]

{ #category : #arithmetic }
NumberUnit >> + aUnit [
	aUnit baseClass = Date ifTrue: [^aUnit].
	^super + aUnit]

{ #category : #testing }
NumberUnit >> allowsMagicConstants [
	^true]

{ #category : #testing }
NumberUnit >> canChangeFormat [
	^self isIntegerUnit not]

{ #category : #converting }
NumberUnit >> convert: aNumber [
	| number |
	number := aNumber value.
	number isNumber ifFalse: [^number].
	^self isIntegerUnit ifTrue: [number rounded asFloat] ifFalse: [number]]

{ #category : #converting }
NumberUnit >> convertRange: aRange [
	| range |
	range := super convertRange: aRange.
	self isIntegerUnit ifTrue: [
		range lowerBound ifNotNil: [:b | range lowerBound: b rounded].
		range upperBound ifNotNil: [:b | range upperBound: b rounded]].
	^range]

{ #category : #accessing }
NumberUnit >> defaultDecimalPlaces [
	^self isIntegerUnit ifTrue: [0] ifFalse: [super defaultDecimalPlaces]]

{ #category : #defaults }
NumberUnit >> defaultUnit [
	^self isIntegerUnit ifTrue: [self] ifFalse: [super defaultUnit]]

{ #category : #'gui support' }
NumberUnit >> displayName [
	^'']

{ #category : #testing }
NumberUnit >> isCompatibleWith: aUnit [
	(self isIntegerUnit and: [aUnit == TimeUnit days]) ifTrue: [^true].
	^super isCompatibleWith: aUnit]

{ #category : #testing }
NumberUnit >> isIntegerUnit [
	^self type integer == self]

{ #category : #testing }
NumberUnit >> isMultiplicativeIdentity [
	^self isBaseUnit]

{ #category : #testing }
NumberUnit >> isNumberUnit [
	^true]

{ #category : #testing }
NumberUnit >> isPercent [
	^name notNil and: [name first = $%]]

{ #category : #arithmetic }
NumberUnit >> raisedTo: aUnit [
	^aUnit type = self type ifTrue: [self]]

{ #category : #arithmetic }
NumberUnit >> sqrt [
	^self]

{ #category : #'gui support' }
NumberUnit >> visibleDisplayName [
	^self isIntegerUnit ifTrue: ['integer'] ifFalse: [super visibleDisplayName]]

