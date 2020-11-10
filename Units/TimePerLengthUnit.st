"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #TimePerLengthUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #accessing }
TimePerLengthUnit class >> constantsUnit [
	^self named: 'day/mile']

{ #category : #accessing }
TimePerLengthUnit class >> conversions [
	^#(
		'day' 'ft'
		'day' 'mile'
		'day' 'm'
		'day' 'km')]

{ #category : #defaults }
TimePerLengthUnit class >> defaultMetricUnitName [
	^'day/km']

{ #category : #accessing }
TimePerLengthUnit class >> denominatorUnitType [
	^LengthUnit]

{ #category : #accessing }
TimePerLengthUnit class >> numeratorUnitType [
	^TimeUnit]

{ #category : #accessing }
TimePerLengthUnit class >> typeName [
	^'Time per Length']

