"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #DateUnit,
	#superclass : #NonNumericUnit,
	#category : #Units
}

{ #category : #accessing }
DateUnit class >> baseClass [
	^Date]

{ #category : #defaults }
DateUnit class >> defaultRange [
	| years |
	years := Range forSupportedYears.
	^Range
		close: (Date newDay: 1 monthIndex: 1 year: years lowerBound)
		close: (Date newDay: 31 monthIndex: 12 year: years upperBound)]

{ #category : #defaults }
DateUnit class >> defaultValue [
	^Date today]

{ #category : #accessing }
DateUnit class >> typeName [
	^'Date']

{ #category : #operations }
DateUnit >> - aUnit [
	aUnit baseClass = Date ifTrue: [^TimeUnit days].
	aUnit type = TimeUnit ifTrue: [^self].
	aUnit type = NumberUnit ifTrue: [^self].
	^super - aUnit]

{ #category : #inquiries }
DateUnit >> + aUnit [
	aUnit type = NumberUnit ifTrue: [^self].
	aUnit type = TimeUnit ifTrue: [^self].
	^super + aUnit]

{ #category : #accessing }
DateUnit >> adaptType: value [
	value isDate ifTrue: [^value].
	value isTimestamp ifTrue: [^value date].
	value isString ifTrue: [^self undefinedValue].
	value isBoolean ifTrue: [^self undefinedValue].
	value isNumber ifTrue: [^self undefinedValue].
	value isUndefinedValue ifTrue: [^value].
	value isArrayValued
		ifTrue: [^value asArray collect: [:each | self adaptType: each]].
	self ASSERT: false.
	^value]

{ #category : #conversion }
DateUnit >> baseValueOf: quantity [
	^quantity isNil ifFalse: [[quantity asDate] on: Error do: []]]

{ #category : #converting }
DateUnit >> convert: aDate [
	^aDate value]

{ #category : #'gui support' }
DateUnit >> displayString: aDate [
	^(self convert: aDate) displayString]

{ #category : #conversion }
DateUnit >> fromNLString: aString [
	^self fromString: aString]

{ #category : #conversion }
DateUnit >> fromString: aString [
	"
	DateUnit defaultUnit fromString: '1-Mar-2012'
	"
	| date |
	date := [Date fromString: aString format: self dateFormat]
		on: Error
		do: [nil].
	date isNil ifTrue: [date := [aString asDate] on: Error do: [nil]].
	date isNil ifTrue: [^nil].
	^self baseValueOf: date]

{ #category : #testing }
DateUnit >> isDateUnit [
	^true]

{ #category : #conversion }
DateUnit >> maxRepresentableValue [
	^Date newDay: 1 monthIndex: 1 year: 4096]

{ #category : #conversion }
DateUnit >> minRepresentableValue [
	^Date newDay: 1 monthIndex: 1 year: 0]

{ #category : #conversion }
DateUnit >> valueFromDisplay: aString [
	^self fromString: aString]

{ #category : #conversion }
DateUnit >> valueFromString: aString [
	^[Date fromString: aString format: self dateFormat]
		on: Error
		do: [Date iso8601: aString]]

