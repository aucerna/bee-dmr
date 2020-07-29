"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #DateStatisticsCalculator,
	#superclass : #NoNumericStatisticsCalculator,
	#category : #Distributions
}

{ #category : #adding }
DateStatisticsCalculator >> adapt: x [
	^x value isArray
		ifTrue: [(x value
			collect: [:xi | xi isUndefinedValue ifFalse: [xi value - Date baseDate]])
			asFloatArray]
		ifFalse: [x isUndefinedValue ifFalse: [x value - Date baseDate]]]

{ #category : #estimators }
DateStatisticsCalculator >> convert: x [
	| y |
	y := x value.
	^y isArray
		ifTrue: [
			y
				collect: [:xi | xi isUndefinedValue
					ifFalse: [Date baseDate + xi asInteger]]]
		ifFalse: [y isUndefinedValue ifFalse: [Date baseDate + y]]]

