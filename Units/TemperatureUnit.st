"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #TemperatureUnit,
	#superclass : #Unit,
	#category : #Units
}

{ #category : #'instance accessing' }
TemperatureUnit class >> celsius [
	^self named: 'C']

{ #category : #accessing }
TemperatureUnit class >> constantsUnit [
	^self named: 'F']

{ #category : #accessing }
TemperatureUnit class >> conversions [
	^Dictionary new
		at: 'F' put: 1.0;
		at: 'C' put: nil;
		at: 'R' put: nil;
		at: 'K' put: nil;
		yourself]

{ #category : #defaults }
TemperatureUnit class >> defaultDecimalPlaces [
	^0]

{ #category : #defaults }
TemperatureUnit class >> defaultMetricUnitName [
	^'C']

{ #category : #'instance accessing' }
TemperatureUnit class >> fahrenheit [
	^self named: 'F']

{ #category : #testing }
TemperatureUnit class >> hasLinearConversion [
	^false]

{ #category : #testing }
TemperatureUnit class >> isQualifier [
	^true]

{ #category : #'instance accessing' }
TemperatureUnit class >> kelvin [
	^self named: 'K']

{ #category : #'instance accessing' }
TemperatureUnit class >> rankine [
	^self named: 'R']

{ #category : #accessing }
TemperatureUnit class >> typeName [
	^'Temperature']

{ #category : #private }
TemperatureUnit class >> validCode: aString [
	| code |
	code := super validCode: aString.
	^code asUppercase]

{ #category : #services }
TemperatureUnit >> addConversionTo: aString [
	name = 'F' ifTrue: [^aString].
	name = 'C' ifTrue: [^'(5.0 * (' , aString , ' - 32.0) / 9.0)'].
	name = 'R' ifTrue: [^aString , ' + 460.0'].
	name = 'K' ifTrue: [^'((5.0 * (' , aString , ' - 32.0) / 9.0) + 273.15)'].
	self ASSERT: false.
	^aString]

{ #category : #converting }
TemperatureUnit >> baseValueOf: aNumber [
	aNumber isNumber ifFalse: [^super baseValueOf: aNumber].
	name = 'F' ifTrue: [^aNumber asFloat].
	name = 'R' ifTrue: [^aNumber - 460.0].
	name = 'C' ifTrue: [^32.0 + (9.0 * aNumber / 5.0)].
	name = 'K' ifTrue: [^32.0 + (9.0 * (aNumber - 273.15) / 5.0)].
	self error: 'Unknown unit of temperature ' , name storeString]

{ #category : #converting }
TemperatureUnit >> c: aNumber [
	^5.0 * (aNumber - 32.0) / 9.0]

{ #category : #converting }
TemperatureUnit >> conversionString [
	name isNil ifTrue: [name := 'F'].
	^self addConversionTo: 'x']

{ #category : #converting }
TemperatureUnit >> convert: aNumber [
	| number |
	number := aNumber value.
	number isNumber ifFalse: [^number].
	name isNil ifTrue: [name := 'F'].
	name = 'F' ifTrue: [^self f: number].
	name = 'C' ifTrue: [^self c: number].
	name = 'R' ifTrue: [^self r: number].
	name = 'K' ifTrue: [^self k: number].
	self ASSERT: false]

{ #category : #'gui support' }
TemperatureUnit >> displayName [
	^'º' , super displayName]

{ #category : #converting }
TemperatureUnit >> f: aNumber [
	^aNumber]

{ #category : #converting }
TemperatureUnit >> k: aNumber [
	^(self c: aNumber) + 273.15]

{ #category : #converting }
TemperatureUnit >> maxRepresentableValue [
	| max |
	max := Float maxValue / 10.0.
	name = 'F' ifTrue: [^max].
	name = 'R' ifTrue: [^max - 460.0].
	name = 'C' ifTrue: [^32.0 + (9.0 / 5.0 * max)].
	name = 'K' ifTrue: [^32.0 + (9.0 / 5.0 * (max - 273.15))].
	self error: 'Unknown unit of temperature ' , name storeString]

{ #category : #converting }
TemperatureUnit >> minRepresentableValue [
	| min |
	min := Float minValue / 10.0.
	name = 'F' ifTrue: [^min].
	name = 'R' ifTrue: [^min - 460.0].
	name = 'C' ifTrue: [^32.0 + (9.0 / 5.0 * min)].
	name = 'K' ifTrue: [^32.0 + (9.0 / 5.0 * (min - 273.15))].
	self error: 'Unknown unit of temperature ' , name storeString]

{ #category : #'filein/out' }
TemperatureUnit >> needsConversionMigrationTo: u [
	^false]

{ #category : #converting }
TemperatureUnit >> r: aNumber [
	^aNumber + 460.0]

