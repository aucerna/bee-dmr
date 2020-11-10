"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #VolumeUnit,
	#superclass : #Unit,
	#category : #Units
}

{ #category : #accessing }
VolumeUnit class >> allNumerators [
	^OrderedCollection with: LengthUnit with: LengthUnit with: LengthUnit]

{ #category : #accessing }
VolumeUnit class >> conversionRange [
	^Range from: 0.1e-20 to: 0.1e20]

{ #category : #defaults }
VolumeUnit class >> defaultDecimalPlaces [
	^1]

{ #category : #testing }
VolumeUnit class >> hasConsistentBaseUnit [
	^self lengthCompatibleUnit = self baseUnit]

{ #category : #testing }
VolumeUnit class >> isAbstract [
	^self == VolumeUnit]

{ #category : #testing }
VolumeUnit class >> isQuantifier [
	^true]

{ #category : #testing }
VolumeUnit class >> isVolumeUnit [
	^true]

{ #category : #accessing }
VolumeUnit class >> normalization [
	| u bl |
	u := self baseUnit lengthUnit.
	^u notNil ifTrue: [1.0 / (u conversion squared * u conversion)] ifFalse: [
		bl := LengthUnit baseUnit.
		1.0 unitsOf: self baseUnit in: bl * bl * bl]]

{ #category : #services }
VolumeUnit class >> normalize [
	self lengthCompatibleUnit beBaseUnit]

{ #category : #accessing }
VolumeUnit class >> numerators [
	^{self}]

{ #category : #arithmetic }
VolumeUnit >> / aUnit [
	| length |
	length := self relatedLengthUnit.
	length isNil ifTrue: [length := LengthUnit defaultUnit].
	aUnit isLengthUnit ifTrue: [^length squared].
	aUnit isAreaUnit ifTrue: [^length].
	^super / aUnit]

{ #category : #accessing }
VolumeUnit >> allNumerators [
	| length |
	length := self lengthUnit.
	^length isNil
		ifTrue: [super numerators]
		ifFalse: [OrderedCollection with: length with: length with: length]]

{ #category : #accessing }
VolumeUnit >> lengthUnit [
	^self lengthUnitFrom: name]

{ #category : #accessing }
VolumeUnit >> lengthUnitFrom: aString [
	| n |
	aString = 'scf' ifTrue: [^LengthUnit ft].
	n := (aString endsWith: '3')
		ifTrue: [aString allButLast trimBlanks]
		ifFalse: [aString].
	^LengthUnit named: n]

{ #category : #accessing }
VolumeUnit >> relatedLengthUnit [
	| u n |
	u := self lengthUnit.
	u notNil ifTrue: [^u].
	n := name replaceAll: '.' with: ' '.
	^self lengthUnitFrom: n substrings last]

