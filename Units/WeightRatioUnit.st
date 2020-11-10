"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #WeightRatioUnit,
	#superclass : #DimensionlessUnit,
	#category : #Units
}

{ #category : #accessing }
WeightRatioUnit class >> conversions [
	^#('g' 'g'
		'kg' 'tonne'
		'lb' 'short ton'
		'lb' 'long ton')]

{ #category : #defaults }
WeightRatioUnit class >> defaultMetricUnitName [
	^'kg/tonne']

{ #category : #accessing }
WeightRatioUnit class >> denominatorUnitType [
	^WeightUnit]

{ #category : #testing }
WeightRatioUnit class >> isPrivate [
	^true]

{ #category : #accessing }
WeightRatioUnit class >> numeratorUnitType [
	^WeightUnit]

{ #category : #accessing }
WeightRatioUnit class >> typeName [
	^'Weight Ratio']

