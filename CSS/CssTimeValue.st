"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssTimeValue,
	#superclass : #CssUnitizedNumberValue,
	#category : #CSS
}

{ #category : #accessing }
CssTimeValue >> allowableUnits [
	^#('s' 'ms')]

{ #category : #testing }
CssTimeValue >> isValid [
	^super isValid and: [string asNumber >= 0]]

