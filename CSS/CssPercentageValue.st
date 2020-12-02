"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssPercentageValue,
	#superclass : #CssUnitizedNumberValue,
	#category : #CSS
}

{ #category : #accessing }
CssPercentageValue >> allowableUnits [
	^#('%')]

{ #category : #testing }
CssPercentageValue >> isValid [
	^super isValid and: [string asNumber >= 0]]

