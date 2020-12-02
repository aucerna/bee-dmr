"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssPaddingWidthValue,
	#superclass : #CssLengthValue,
	#category : #CSS
}

{ #category : #accessing }
CssPaddingWidthValue >> allowableUnits [
	^super allowableUnits copyWith: '%']

