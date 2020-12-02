"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssFrequencyValue,
	#superclass : #CssUnitizedNumberValue,
	#category : #CSS
}

{ #category : #accessing }
CssFrequencyValue >> allowableUnits [
	^#('hz' 'khz')]

{ #category : #testing }
CssFrequencyValue >> isValid [
	^super isValid and: [string asNumber >= 0]]

