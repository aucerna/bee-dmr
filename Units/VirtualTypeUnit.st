"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #VirtualTypeUnit,
	#superclass : #CompositeUnit,
	#instVars : [
		'type'
	],
	#category : #Units
}

{ #category : #initialization }
VirtualTypeUnit class >> initializeUnits [
	^self]

{ #category : #testing }
VirtualTypeUnit class >> isAbstract [
	^true]

{ #category : #'instance creation' }
VirtualTypeUnit class >> newForLeft: lUnit right: rUnit type: aCompositeUnitType [
	^self new
		type: aCompositeUnitType;
		leftUnit: lUnit;
		rightUnit: rUnit;
		update]

{ #category : #converting }
VirtualTypeUnit >> asJson [
	^JsonObject new
		at: 'Type' put: self type asJson;
		at: 'Name' put: self name;
		at: 'Left' put: left asJson;
		at: 'Right' put: right asJson;
		yourself]

{ #category : #accessing }
VirtualTypeUnit >> currency [
	| money |
	self ASSERT: self type hasCurrency.
	money := self numerators detect: [:u | u isMoneyUnit] ifNone: [^nil].
	^money currency]

{ #category : #'file in/out' }
VirtualTypeUnit >> fileOutSurrogate [
	^self clone instVarNamed: 'type' put: type operator; yourself]

{ #category : #testing }
VirtualTypeUnit >> hasSystemUnitType [
	^false]

{ #category : #testing }
VirtualTypeUnit >> isSystemUnit [
	Unit allUnitsDo: [:u | 
		(u hasSystemUnitType and: [u isSystemUnit] and: [u dependsOn: self])
			ifTrue: [^true]].
	^false]

{ #category : #testing }
VirtualTypeUnit >> isUserDefined [
	^false]

{ #category : #accessing }
VirtualTypeUnit >> type [
	^type]

{ #category : #accessing }
VirtualTypeUnit >> type: unitType [
	self ASSERT: unitType isPrivate.
	type := unitType]

{ #category : #accessing }
VirtualTypeUnit >> updateFrom: aUnit [
	self ASSERT: type == aUnit type.
	super updateFrom: aUnit]

