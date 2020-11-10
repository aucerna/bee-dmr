"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #ArrayedCollection }

{ #category : '*Units' }
ArrayedCollection >> inUnit: aUnit [
	"
	Assumes self is in base unit
	"
	^self collect: [:each | aUnit convert: each]]

{ #category : '*Units' }
ArrayedCollection >> unitsOf: aUnit [
	^self collect: [:each | aUnit baseValueOf: each]]

