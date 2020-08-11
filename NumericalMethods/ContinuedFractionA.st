"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ContinuedFractionA,
	#superclass : #ContinuedFraction,
	#category : #NumericalMethods
}

{ #category : #evaluation }
ContinuedFractionA >> value [
	self reset; advance.
	^an / super value]

