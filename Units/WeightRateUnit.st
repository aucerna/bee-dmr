"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #WeightRateUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #accessing }
WeightRateUnit class >> constantsUnit [
	^self named: 'g/day']

{ #category : #accessing }
WeightRateUnit class >> conversions [
	^#(
		'g' 'day'
		'kg' 'day'
		'lb' 'day'
		'tonne' 'day'
		'M tonne' 'day'
		'MM tonne' 'day'
		'short ton' 'day'
		'long ton' 'day')]

{ #category : #defaults }
WeightRateUnit class >> defaultMetricUnitName [
	^'tonne/day']

{ #category : #accessing }
WeightRateUnit class >> denominatorUnitType [
	^TimeUnit]

{ #category : #accessing }
WeightRateUnit class >> numeratorUnitType [
	^WeightUnit]

{ #category : #accessing }
WeightRateUnit class >> typeName [
	^'Weight Rate']

