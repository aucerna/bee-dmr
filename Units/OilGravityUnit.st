"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #OilGravityUnit,
	#superclass : #Unit,
	#category : #Units
}

{ #category : #accessing }
OilGravityUnit class >> api [
	^self named: 'API']

{ #category : #accessing }
OilGravityUnit class >> constantsUnit [
	^self named: 'API']

{ #category : #accessing }
OilGravityUnit class >> conversions [
	^Dictionary new
		at: 'API' put: 1.0;
		at: 'sg' put: nil;
		yourself]

{ #category : #constants }
OilGravityUnit class >> convertAPIToSG: aNumber [
	aNumber = -131.5 ifTrue: [^Float plusInfinity].
	^141.5 / (131.5 + aNumber)]

{ #category : #constants }
OilGravityUnit class >> convertSGToAPI: aNumber [
	aNumber = 0.0 ifTrue: [^Float plusInfinity].
	^141.5 / aNumber - 131.5]

{ #category : #defaults }
OilGravityUnit class >> defaultDecimalPlaces [
	^1]

{ #category : #defaults }
OilGravityUnit class >> defaultMetricUnitName [
	^'sg']

{ #category : #accessing }
OilGravityUnit class >> defaultRange [
	^Range open: -131 open: 120]

{ #category : #testing }
OilGravityUnit class >> hasLinearConversion [
	^false]

{ #category : #testing }
OilGravityUnit class >> isDimensionless [
	^true]

{ #category : #testing }
OilGravityUnit class >> isQualifier [
	^true]

{ #category : #accessing }
OilGravityUnit class >> sg [
	^self named: 'sg']

{ #category : #accessing }
OilGravityUnit class >> typeName [
	^'Oil Gravity']

{ #category : #private }
OilGravityUnit class >> validCode: aString [
	| code |
	code := super validCode: aString.
	code := code replaceAll: 'gm/cc' with: 'sg'.
	^code]

{ #category : #services }
OilGravityUnit >> addConversionTo: aString [
	^name = 'sg'
		ifTrue: ['(141.5 / (131.5 + ' , aString , '))']
		ifFalse: [super addConversionTo: aString]]

{ #category : #converting }
OilGravityUnit >> baseValueOf: quantity [
	quantity isNumber ifFalse: [^super baseValueOf: quantity].
	self isBaseUnit ifTrue: [^quantity asFloat].
	name = 'sg' ifTrue: [^self type convertSGToAPI: quantity].
	name = 'API' ifTrue: [^self type convertAPIToSG: quantity].
	self ASSERT: false]

{ #category : #converting }
OilGravityUnit >> conversionString [
	^self addConversionTo: 'x']

{ #category : #converting }
OilGravityUnit >> convert: quantity [
	| number |
	number := quantity value.
	self isBaseUnit ifTrue: [^number].
	number isNumber ifFalse: [^number].
	name = 'sg' ifTrue: [^self type convertAPIToSG: number].
	name = 'API' ifTrue: [^self type convertSGToAPI: number].
	self ASSERT: false]

{ #category : #converting }
OilGravityUnit >> convertRange: aRange [
	| lower upper range |
	self isBaseUnit ifTrue: [^aRange].
	lower := aRange lowerBound ifNotNil: [:b | self safeConvert: b].
	upper := aRange upperBound ifNil: [Float plusInfinity].
	upper := self safeConvert: upper.
	range := aRange shallowCopy.
	range lowerBound: lower; upperBound: upper.
	(lower notNil and: [upper notNil] and: [lower > upper]) ifTrue: [range swap].
	^range]

{ #category : #converting }
OilGravityUnit >> maxRepresentableValue [
	name = 'sg' ifTrue: [^Float maxValue / 10.0].
	name = 'API' ifTrue: [^Float maxValue / 10.0].
	self ASSERT: false]

{ #category : #converting }
OilGravityUnit >> minRepresentableValue [
	| max |
	max := Float maxValue / 10.0.
	name = 'sg' ifTrue: [^141.5 / (131.5 + max)].
	name = 'API' ifTrue: [^-131.49].
	self ASSERT: false]

