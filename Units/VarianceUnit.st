"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #VarianceUnit,
	#superclass : #Unit,
	#instVars : [
		'unit'
	],
	#category : #Units
}

{ #category : #accessing }
VarianceUnit class >> add: aUnit [
	self shouldNotImplement]

{ #category : #accessing }
VarianceUnit class >> conversions [
	^Dictionary new]

{ #category : #testing }
VarianceUnit class >> isPrivate [
	^true]

{ #category : #'instance creation' }
VarianceUnit class >> on: aUnit [
	^self new unit: aUnit]

{ #category : #accessing }
VarianceUnit class >> typeName [
	^'Variance']

{ #category : #converting }
VarianceUnit >> baseValueOf: aNumber [
	^(unit baseValueOfSd: aNumber sqrt) squared]

{ #category : #converting }
VarianceUnit >> convert: aNumber [
	aNumber isUndefinedValue ifTrue: [^aNumber].
	^unit isNumeric
		ifTrue: [(unit convertSd: aNumber abs sqrt) squared * aNumber sign]]

{ #category : #converting }
VarianceUnit >> convertMomentum: aNumber [
	aNumber isUndefinedValue ifTrue: [^aNumber].
	^(unit convertMomentum: aNumber abs sqrt) squared * aNumber sign]

{ #category : #'gui support' }
VarianceUnit >> displayName [
	| n |
	n := unit displayName.
	unit type = NumberUnit ifTrue: [^n].
	((n includes: $/) or: [n includes: $*]) ifTrue: [n := '(' , n , ')'].
	^n , '²']

{ #category : #testing }
VarianceUnit >> isIntegerUnit [
	^false]

{ #category : #accessing }
VarianceUnit >> unit: aUnit [
	unit := aUnit]

