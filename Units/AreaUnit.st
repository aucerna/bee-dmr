"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #AreaUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #'instance accessing' }
AreaUnit class >> acre [
	^self named: 'acre']

{ #category : #private }
AreaUnit class >> adaptToBase: aUnit [
	| base length |
	aUnit isLengthUnit ifFalse: [^self].
	base := self unitForLeft: aUnit right: aUnit.
	base isNil ifTrue: [
		length := self baseUnit lengthUnit.
		length isNil ifTrue: [self error: 'Unsupported change of area unit'].
		base := self newForLeft: aUnit right: aUnit].
	base beBaseUnitAndNormalize]

{ #category : #private }
AreaUnit class >> componentTypes [
	^{LengthUnit}]

{ #category : #accessing }
AreaUnit class >> constantsUnit [
	^self named: 'acre']

{ #category : #accessing }
AreaUnit class >> conversions [
	^#('ft' 'ft'
		'cm' 'cm'
		'm' 'm'
		'in' 'in'
		'km' 'km'
		'mile' 'mile'
		'hm' 'hm')]

{ #category : #defaults }
AreaUnit class >> defaultDecimalPlaces [
	^1]

{ #category : #defaults }
AreaUnit class >> defaultMetricUnitName [
	^'km2']

{ #category : #'instance accessing' }
AreaUnit class >> ft2 [
	^self named: 'ft2']

{ #category : #'instance accessing' }
AreaUnit class >> hectare [
	^self named: 'hectares']

{ #category : #initialization }
AreaUnit class >> initializeUnits [
	| acre |
	super initializeUnits.
	acre := self new
		name: 'acre';
		conversion: (43560.0 unitsOf: self ft2) reciprocal.
	self add: acre]

{ #category : #testing }
AreaUnit class >> isQuantifier [
	^true]

{ #category : #'instance accessing' }
AreaUnit class >> km2 [
	^self named: 'km2']

{ #category : #accessing }
AreaUnit class >> leftUnitType [
	^LengthUnit]

{ #category : #accessing }
AreaUnit class >> lengthCompatibleUnit [
	^LengthUnit baseUnit squared]

{ #category : #'instance accessing' }
AreaUnit class >> m2 [
	^self named: 'm2']

{ #category : #'instance accessing' }
AreaUnit class >> mile2 [
	^self named: 'mile2']

{ #category : #accessing }
AreaUnit class >> normalization [
	^LengthUnit baseUnit squared conversion]

{ #category : #accessing }
AreaUnit class >> operator [
	^#*
	]

{ #category : #accessing }
AreaUnit class >> rightUnitType [
	^LengthUnit]

{ #category : #accessing }
AreaUnit class >> typeName [
	^'Area']

{ #category : #private }
AreaUnit class >> validCode: aString [
	| code |
	code := super validCode: aString.
	code := code replaceAll: 'hectares' with: 'hectare'.
	code := code replaceAll: 'hm2' with: 'hectare'.
	^code]

{ #category : #arithmetic }
AreaUnit >> * aUnit [
	aUnit isLengthUnit ifFalse: [^super * aUnit].
	^LiquidVolumeUnit named: self name , '.' , aUnit name ifAbsent: [
		LiquidVolumeUnit
			named: aUnit name , '3'
			ifAbsent: [LiquidVolumeUnit baseUnit]]]

{ #category : #arithmetic }
AreaUnit >> / aUnit [
	aUnit isLengthUnit ifFalse: [^super / aUnit].
	^aUnit]

{ #category : #private }
AreaUnit >> defaultName [
	left isNil ifTrue: [^super defaultName].
	^left name = 'hm' ifTrue: ['hectare'] ifFalse: [super defaultName]]

{ #category : #testing }
AreaUnit >> isAreaUnit [
	^true]

{ #category : #testing }
AreaUnit >> isSystemUnit [
	^name = 'acre' or: [super isSystemUnit]]

{ #category : #accessing }
AreaUnit >> lengthUnit [
	^left]

