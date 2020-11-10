"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlDate,
	#superclass : #FmlValue,
	#instVars : [
		'date'
	],
	#category : #FML
}

{ #category : #testing }
FmlDate class >> isSummable [
	^true]

{ #category : #constants }
FmlDate class >> typeName [
	^'Date']

{ #category : #arithmetic }
FmlDate >> - anFmlValue [
	anFmlValue isSummable
		ifTrue: [^anFmlValue performOperation: #'-' receiverValue: date].
	^super - anFmlValue]

{ #category : #arithmetic }
FmlDate >> / anFmlValue [
	| base |
	anFmlValue isNumeric ifFalse: [^super / anFmlValue].
	base := Date fmlBase.
	^(base
		addDays: (anFmlValue
			performOperation: #'/'
			receiverValue: (date daysSince: base) asFmlValue) value)
		asFmlValue]

{ #category : #arithmetic }
FmlDate >> + anFmlValue [
	| base left right result |
	anFmlValue isNumeric
		ifTrue: [^anFmlValue performOperation: #'+' receiverValue: date].
	anFmlValue hasDates ifTrue: [
		base := Date fmlBase.
		left := (anFmlValue - base asFmlValue) asFmlValue.
		right := date daysSince: base.
		result := (left performOperation: #'+' receiverValue: right) asFmlValue.
		^(result performOperation: #'+' receiverValue: base) asFmlValue].
	^super + anFmlValue]

{ #category : #comparing }
FmlDate >> < aFmlValue [
	"
	1 asFmlValue < 3 asFmlValue 
	1 asFmlValue < 3.0 asFmlValue 
	1 asFmlValue < #(1 2 3) asFmlValue
	"
	(aFmlValue isUndefinedValue or: [aFmlValue hasDates])
		ifFalse: [^self argumentIn: #'<' shouldBe: FmlDate].
	^aFmlValue performOperation: #'<' receiverValue: date]

{ #category : #comparing }
FmlDate >> <= anFmlValue [
	(anFmlValue isUndefinedValue or: [anFmlValue hasDates])
		ifFalse: [^self argumentIn: #'<=' shouldBe: FmlDate].
	^anFmlValue performOperation: #'<=' receiverValue: date]

{ #category : #comparing }
FmlDate >> > anFmlValue [
	(anFmlValue isUndefinedValue or: [anFmlValue hasDates])
		ifFalse: [^self argumentIn: #'>' shouldBe: FmlDate].
	^anFmlValue performOperation: #'>' receiverValue: date]

{ #category : #comparing }
FmlDate >> >= anFmlValue [
	(anFmlValue isUndefinedValue or: [anFmlValue hasDates])
		ifFalse: [^self argumentIn: #'>=' shouldBe: FmlDate].
	^anFmlValue performOperation: #'>=' receiverValue: date]

{ #category : #visiting }
FmlDate >> acceptVisitor: fmlVisitor [
	fmlVisitor visitFmlDate: self]

{ #category : #converting }
FmlDate >> asDate [
	^date]

{ #category : #functions }
FmlDate >> average: anArray [
	| array invalid mu |
	array := anArray isArray ifTrue: [anArray] ifFalse: [{anArray}].
	invalid := array findFirst: [:x | x isDateValued not] ifAbsent: nil.
	invalid isNil ifFalse: [
		^self
			argument: 'value' , (invalid + 1) printString
			in: 'average'
			shouldBe: FmlDate].
	array := array collect: [:d | d value subtractDate: date].
	mu := 0.0 asFmlValue average: array.
	^(date addDays: mu) asFmlValue]

{ #category : #arithmetic }
FmlDate >> ceiling [
	^self asInteger]

{ #category : #accessing }
FmlDate >> date [
	^date]

{ #category : #functions }
FmlDate >> date: month day: day [
	| answer |
	[
		answer := Date
			newDay: day value asInteger
			monthIndex: month value asInteger
			year: self year value asInteger]
		on: Error
		do: [:e | e return: FmlUndefinedValue new].
	^answer asFmlValue]

{ #category : #functions }
FmlDate >> day [
	^date dayOfMonth asFmlValue]

{ #category : #functions }
FmlDate >> dayOfYear [
	^date dayOfYear asFmlValue]

{ #category : #functions }
FmlDate >> daysInYear [
	^date daysInYear asFmlValue]

{ #category : #comparing }
FmlDate >> equals: anFmlValue [
	^anFmlValue performOperation: #'=' receiverValue: date]

{ #category : #accessing }
FmlDate >> inferredUnit [
	^DateUnit defaultInstance]

{ #category : #testing }
FmlDate >> isDate [
	^true]

{ #category : #testing }
FmlDate >> isDateValued [
	^true]

{ #category : #testing }
FmlDate >> isSummable [
	^true]

{ #category : #functions }
FmlDate >> max: anFmlValue [
	(anFmlValue isUndefinedValue or: [anFmlValue hasDates])
		ifFalse: [^self argumentIn: #max shouldBe: FmlDate].
	^super max: anFmlValue]

{ #category : #comparing }
FmlDate >> min: anFmlValue [
	(anFmlValue isUndefinedValue or: [anFmlValue hasDates])
		ifFalse: [^self argumentIn: #min shouldBe: FmlDate].
	^super min: anFmlValue]

{ #category : #functions }
FmlDate >> month [
	^date monthIndex asFmlValue]

{ #category : #functions }
FmlDate >> periodXNPV: aFmlArray dates: fmlDateArray [
	^self cannotEvaluate: #periodXNPV]

{ #category : #arithmetic }
FmlDate >> squaredDifference: anFmlDate [
	^(date squaredDifference: anFmlDate value) asFmlValue]

{ #category : #accessing }
FmlDate >> value [
	^date]

{ #category : #accessing }
FmlDate >> value: aDate [
	date := aDate]

{ #category : #functions }
FmlDate >> year [
	^date year asFmlValue]

