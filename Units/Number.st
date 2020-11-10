"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Number }

{ #category : '*Units' }
Number >> inUnit: aUnit [
	"
	Assumes self is in base unit
	"
	^aUnit convert: self]

{ #category : '*Units' }
Number >> unitOf: aUnit [
	self ASSERT: self = 1.
	^self unitsOf: aUnit]

{ #category : '*Units' }
Number >> unitOf: aUnit in: anotherUnit [
	self ASSERT: self = 1.
	^self unitsOf: aUnit in: anotherUnit]

{ #category : '*Units' }
Number >> unitsOf: aUnit [
	^aUnit baseValueOf: self]

{ #category : '*Units' }
Number >> unitsOf: aUnit in: anotherUnit [
	| x |
	x := self unitsOf: aUnit.
	^anotherUnit convert: x]

