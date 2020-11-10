"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #DimensionlessUnit,
	#superclass : #CompositeUnit,
	#category : #Units
}

{ #category : #defaults }
DimensionlessUnit class >> defaultBaseUnitName [
	^'ratio']

{ #category : #defaults }
DimensionlessUnit class >> defaultPercentName [
	^'%']

{ #category : #initialization }
DimensionlessUnit class >> initializeUnitsFrom: anArray [
	| base percent |
	super initializeUnitsFrom: anArray.
	base := self baseUnit.
	percent := self newForLeft: base numerator right: base denominator.
	percent name: self defaultPercentName; conversion: 100.0.
	self add: percent]

{ #category : #testing }
DimensionlessUnit class >> isAbstract [
	^self == DimensionlessUnit]

{ #category : #testing }
DimensionlessUnit class >> isCompatibleWith: unitType [
	^unitType isDimensionless]

{ #category : #testing }
DimensionlessUnit class >> isDimensionless [
	^true]

{ #category : #'instance creation' }
DimensionlessUnit class >> newBaseUnitLeft: lUnit right: rUnit [
	super newBaseUnitLeft: lUnit right: rUnit.
	baseUnit name: self defaultBaseUnitName.
	^baseUnit]

{ #category : #'instance accessing' }
DimensionlessUnit class >> ratio [
	^self named: self defaultBaseUnitName]

{ #category : #converting }
DimensionlessUnit >> beBaseUnit [
	| prev |
	self isBaseUnit ifTrue: [^self].
	prev := self type baseUnit.
	super beBaseUnit.
	prev name: prev defaultName.
	self name: self defaultBaseUnitName]

{ #category : #private }
DimensionlessUnit >> defaultBaseUnitName [
	^self type defaultBaseUnitName]

{ #category : #accessing }
DimensionlessUnit >> denominator [
	^right ifNil: [self denominatorUnitType baseUnit]]

{ #category : #testing }
DimensionlessUnit >> isMultiplicativeIdentity [
	^self isBaseUnit]

{ #category : #testing }
DimensionlessUnit >> isSystemUnit [
	^name = self type defaultPercentName
		or: [name = self defaultBaseUnitName]
		or: [super isSystemUnit]]

{ #category : #accessing }
DimensionlessUnit >> numerator [
	^left ifNil: [self numeratorUnitType baseUnit]]

{ #category : #private }
DimensionlessUnit >> updateName [
	self isBaseUnit ifFalse: [super updateName]]

