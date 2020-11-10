"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #WeightUnit,
	#superclass : #Unit,
	#category : #Units
}

{ #category : #accessing }
WeightUnit class >> constantsUnit [
	^self named: 'g']

{ #category : #accessing }
WeightUnit class >> conversionRange [
	^Range from: 0.1e-15 to: 0.1e15]

{ #category : #accessing }
WeightUnit class >> conversions [
	^Dictionary new
		at: 'kg' put: 1.0;
		at: 'g' put: 1000.0;
		at: 'lb' put: 2.204622621849;
		"metric ton"
		at: 'tonne' put: 1000.0 reciprocal;
		at: 'M tonne' put: 1000000.0 reciprocal;
		at: 'MM tonne' put: 1000000000.0 reciprocal;
		"US ton"
		at: 'short ton' put: 0.1102311310924e-2;
		"UK ton"
		at: 'long ton' put: 0.9842065276111e-3;
		yourself]

{ #category : #defaults }
WeightUnit class >> defaultMetricUnitName [
	^'kg']

{ #category : #'instance accessing' }
WeightUnit class >> g [
	^self named: 'g']

{ #category : #testing }
WeightUnit class >> isQuantifier [
	^true]

{ #category : #'instance accessing' }
WeightUnit class >> kg [
	^self named: 'kg']

{ #category : #'instance accessing' }
WeightUnit class >> lb [
	^self named: 'lb']

{ #category : #'instance accessing' }
WeightUnit class >> metricTon [
	^self named: 'tonne']

{ #category : #accessing }
WeightUnit class >> typeName [
	^'Weight']

{ #category : #'instance accessing' }
WeightUnit class >> ukTon [
	^self named: 'long ton']

{ #category : #'instance accessing' }
WeightUnit class >> usTon [
	^self named: 'short ton']

