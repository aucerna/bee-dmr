"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #TimeUnit,
	#superclass : #Unit,
	#category : #Units
}

{ #category : #accessing }
TimeUnit class >> baseUnit: aUnit [
	aUnit name = 'day' ifFalse: [self error: 'Invalid base unit'].
	super baseUnit: aUnit]

{ #category : #accessing }
TimeUnit class >> conversionRange [
	^Range from: 0.1e-15 to: 0.1e15]

{ #category : #accessing }
TimeUnit class >> conversions [
	^Dictionary new
		at: 'day' put: 1.0;
		at: 's' put: 24 * 60 * 60;
		at: 'week' put: 1.0 / 7.0;
		at: 'hour' put: 24.0;
		at: 'month' put: 12.0 / 365.0;
		at: 'year' put: 1.0 / 365.0;
		yourself]

{ #category : #'instance accessing' }
TimeUnit class >> day [
	^units at: 'day']

{ #category : #'instance accessing' }
TimeUnit class >> days [
	^self day]

{ #category : #defaults }
TimeUnit class >> defaultDecimalPlaces [
	^0]

{ #category : #defaults }
TimeUnit class >> defaultMetricUnitName [
	^'day']

{ #category : #'instance accessing' }
TimeUnit class >> hr [
	^units at: 'hour']

{ #category : #testing }
TimeUnit class >> isTimeUnit [
	^true]

{ #category : #'instance accessing' }
TimeUnit class >> month [
	^units at: 'month']

{ #category : #'instance accessing' }
TimeUnit class >> s [
	^units at: 's']

{ #category : #'instance accessing' }
TimeUnit class >> seconds [
	^units at: 's']

{ #category : #accessing }
TimeUnit class >> typeName [
	^'Time']

{ #category : #private }
TimeUnit class >> validCode: aString [
	| code |
	aString = 'h' ifTrue: [^'hour'].
	(aString beginsWith: 'second') ifTrue: [^'s'].
	code := aString replaceAll: 'days' with: 'day'.
	code := code replaceAll: 'Day' with: 'day'.
	^code]

{ #category : #'instance accessing' }
TimeUnit class >> week [
	^units at: 'week']

{ #category : #'instance accessing' }
TimeUnit class >> year [
	^units at: 'year']

{ #category : #'instance accessing' }
TimeUnit class >> years [
	^self year]

{ #category : #arithmetic }
TimeUnit >> - aUnit [
	aUnit baseClass = Date ifTrue: [^InvalidUnit defaultInstance].
	^super - aUnit]

{ #category : #arithmetic }
TimeUnit >> + aUnit [
	aUnit baseClass = Date ifTrue: [^aUnit].
	^super + aUnit]

{ #category : #'gui support' }
TimeUnit >> displayName [
	name = 's' ifTrue: [^'second'].
	^super displayName]

{ #category : #testing }
TimeUnit >> isCompatibleWith: aUnit [
	(self == self class days and: [aUnit isIntegerUnit]) ifTrue: [^true].
	^super isCompatibleWith: aUnit]

