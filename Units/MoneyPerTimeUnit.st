"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MoneyPerTimeUnit,
	#superclass : #CostUnit,
	#category : #Units
}

{ #category : #accessing }
MoneyPerTimeUnit class >> constantsUnit [
	^self named: '$/year']

{ #category : #accessing }
MoneyPerTimeUnit class >> conversions [
	^#(
		'$' 'day'
		'$M' 'day'
		'$MM' 'day' 
		'$' 'year'
		'$MM' 'year'
		'$' 'month'
		'$MM' 'month'
		'eu' 'year'
		'eu' 'day'
		'euM' 'day'
		'euMM' 'day' 
		'eu' 'month' 
		'euMM' 'year' 
		'euMM' 'month')]

{ #category : #defaults }
MoneyPerTimeUnit class >> defaultDecimalPlaces [
	^2]

{ #category : #defaults }
MoneyPerTimeUnit class >> defaultMetricUnitName [
	^'$MM/year']

{ #category : #accessing }
MoneyPerTimeUnit class >> denominatorUnitType [
	^TimeUnit]

{ #category : #'instance accessing' }
MoneyPerTimeUnit class >> dollarDay [
	^self units at: '$/day']

{ #category : #'instance accessing' }
MoneyPerTimeUnit class >> dollarYear [
	^self units at: '$/year']

{ #category : #'instance accessing' }
MoneyPerTimeUnit class >> mmYear [
	^self named: '$MM/year']

{ #category : #accessing }
MoneyPerTimeUnit class >> typeName [
	^'Money per Time']

{ #category : #converting }
MoneyPerTimeUnit >> convertValue: aNumber toUnit: aUnit in: context [
	| n u |
	aUnit type = MoneyUnit
		ifTrue: [
			n := aNumber * context duration value.
			u := self numerator]
		ifFalse: [
			n := aNumber.
			u := self].
	^aUnit convert: (u baseValueOf: n)]

{ #category : #converting }
MoneyPerTimeUnit >> displayValue: aNumber withUnit: aUnit in: context [
	| n |
	n := aUnit type == MoneyUnit
		ifTrue: [aNumber * context duration value]
		ifFalse: [aNumber].
	^aUnit convert: n]

