"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PercentUnit,
	#superclass : #Unit,
	#category : #Units
}

{ #category : #accessing }
PercentUnit class >> conversions [
	^Dictionary new
		at: 'fraction' put: 1.0;
		at: '%' put: 100.0;
		yourself]

{ #category : #defaults }
PercentUnit class >> defaultMetricUnitName [
	^'%']

{ #category : #accessing }
PercentUnit class >> fraction [
	^self units at: 'fraction']

{ #category : #testing }
PercentUnit class >> isCompatibleWith: unitType [
	^NumberUnit isCompatibleWith: unitType]

{ #category : #testing }
PercentUnit class >> isDimensionless [
	^true]

{ #category : #testing }
PercentUnit class >> isPercentUnit [
	^true]

{ #category : #accessing }
PercentUnit class >> percent [
	^self units at: '%']

{ #category : #accessing }
PercentUnit class >> typeName [
	^'Percent']

{ #category : #testing }
PercentUnit >> allowsMagicConstants [
	^true]

{ #category : #accessing }
PercentUnit >> defaultDecimalPlaces [
	^name = '%' ifTrue: [1] ifFalse: [3]]

{ #category : #accessing }
PercentUnit >> displayName [
	^self isBaseUnit ifTrue: [''] ifFalse: [super displayName] ]

{ #category : #testing }
PercentUnit >> isMultiplicativeIdentity [
	^true]

{ #category : #testing }
PercentUnit >> isPercent [
	^true]

{ #category : #arithmetic }
PercentUnit >> raisedTo: aUnit [
	^aUnit isNumberUnit ifTrue: [self]]

