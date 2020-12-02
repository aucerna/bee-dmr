"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssLengthValue,
	#superclass : #CssUnitizedNumberValue,
	#category : #CSS
}

{ #category : #accessing }
CssLengthValue >> allowableUnits [
	^#('em' 'ex' 'px' 'in' 'cm' 'mm' 'pt' 'pc')]

{ #category : #testing }
CssLengthValue >> isRelative [
	^#('em' 'ex' 'px') includes: units]

{ #category : #testing }
CssLengthValue >> isValid [
	^super isValid and: [units notNil or: [string asNumber = 0]]]

