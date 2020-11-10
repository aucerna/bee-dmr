"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GasDeliverabilityUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #accessing }
GasDeliverabilityUnit class >> constantsUnit [
	^self named: 'Mscfd/psi2']

{ #category : #accessing }
GasDeliverabilityUnit class >> conversions [
	^#('M scfd' 'psi2'
		'M m3d' 'kPa2')]

{ #category : #defaults }
GasDeliverabilityUnit class >> defaultMetricUnitName [
	^'M m3d/kPa2']

{ #category : #accessing }
GasDeliverabilityUnit class >> denominatorUnitType [
	^PressureUnit squared]

{ #category : #accessing }
GasDeliverabilityUnit class >> numeratorUnitType [
	^GasRateUnit]

{ #category : #accessing }
GasDeliverabilityUnit class >> typeName [
	^'Gas Deliverability']

{ #category : #private }
GasDeliverabilityUnit class >> validCode: aString [
	| code |
	code := super validCode: aString.
	code := code replaceAll: 'kpa' with: 'kPa'.
	code := code replaceAll: 'Mscfd' with: 'M scfd'.
	code := code replaceAll: 'Mm3d' with: 'M m3d'.
	^code]

