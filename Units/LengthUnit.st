"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #LengthUnit,
	#superclass : #Unit,
	#category : #Units
}

{ #category : #'instance accessing' }
LengthUnit class >> cm [
	^self units at: 'cm']

{ #category : #accessing }
LengthUnit class >> constantsUnit [
	^self named: 'ft']

{ #category : #accessing }
LengthUnit class >> conversionRange [
	^Range from: 0.1e-15 to: 0.1e15]

{ #category : #accessing }
LengthUnit class >> conversions [
	"
	LengthUnit initializeUnits
	"
	| ft |
	ft := 1.0 / 0.3048.
	^Dictionary new
		at: 'm' put: 1.0;
		at: 'cm' put: 100.0;
		at: 'hm' put: 1.0 / 100.0;
		at: 'km' put: 1.0 / 1000.0;
		at: 'ft' put: ft;
		at: 'varas' put: 0.36 * ft;
		at: 'in' put: 12.0 * ft;
		at: 'mile' put: 0.00018939393939 * ft;
		yourself]

{ #category : #defaults }
LengthUnit class >> defaultDecimalPlaces [
	^1]

{ #category : #defaults }
LengthUnit class >> defaultMetricUnitName [
	^'m']

{ #category : #constants }
LengthUnit class >> earthDiameter [
	"
	CsrULength  earthDiameter
	"
	^12700000 unitsOf: self m]

{ #category : #'instance accessing' }
LengthUnit class >> ft [
	^self units at: 'ft']

{ #category : #'instance accessing' }
LengthUnit class >> hm [
	^self units at: 'hm']

{ #category : #'instance accessing' }
LengthUnit class >> inch [

	^self units at: 'in']

{ #category : #testing }
LengthUnit class >> isQuantifier [
	^true]

{ #category : #'instance accessing' }
LengthUnit class >> km [
	^self named: 'km']

{ #category : #'instance accessing' }
LengthUnit class >> m [
	^self units at: 'm']

{ #category : #'instance accessing' }
LengthUnit class >> mile [
	^self units at: 'mile']

{ #category : #accessing }
LengthUnit class >> typeName [
	^'Length']

{ #category : #private }
LengthUnit class >> validCode: aString [
	aString = 'miles' ifTrue: [^'mile'].
	^aString]

{ #category : #inquiries }
LengthUnit >> * aUnit [
	aUnit isLengthUnit
		ifTrue: [^AreaUnit named: self name , '2' ifAbsent: [AreaUnit baseUnit]].
	aUnit isAreaUnit ifTrue: [
		^LiquidVolumeUnit named: self name , '3' ifAbsent: [| u |
			u := aUnit lengthUnit notNil
				ifTrue: [LiquidVolumeUnit
					named: aUnit lengthUnit name , '3'
					ifAbsent: nil].
			u ifNil: [LiquidVolumeUnit baseUnit]]].
	^super * aUnit]

{ #category : #inquiries }
LengthUnit >> cubic [
	^self * self * self]

{ #category : #testing }
LengthUnit >> isLengthUnit [
	^true]

