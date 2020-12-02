"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssAngleValue,
	#superclass : #CssUnitizedNumberValue,
	#category : #CSS
}

{ #category : #accessing }
CssAngleValue >> allowableUnits [
	^#('deg' 'grad' 'rad')]

