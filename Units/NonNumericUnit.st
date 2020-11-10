"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #NonNumericUnit,
	#superclass : #Unit,
	#category : #Units
}

{ #category : #accessing }
NonNumericUnit class >> add: aUnit [
	self ASSERT: units isEmpty.
	^super add: aUnit]

{ #category : #accessing }
NonNumericUnit class >> baseUnit [
	^units anyone]

{ #category : #accessing }
NonNumericUnit class >> conversions [
	^#()]

{ #category : #initialization }
NonNumericUnit class >> initializeUnits [
	| base |
	units := Dictionary new.
	base := self new name: self typeName.
	self baseUnit: base.
	self add: baseUnit]

{ #category : #testing }
NonNumericUnit class >> isAbstract [
	^self == NonNumericUnit]

{ #category : #testing }
NonNumericUnit class >> isNumeric [
	^false]

{ #category : #'instance creation' }
NonNumericUnit class >> newNamed: aString conversion: aNumber [
	^self defaultInstance]

{ #category : #testing }
NonNumericUnit class >> publishesDefaultUnit [
	^false]

{ #category : #accessing }
NonNumericUnit class >> unitConversions [
	^nil]

{ #category : #testing }
NonNumericUnit >> allowsMagicConstants [
	^true]

{ #category : #testing }
NonNumericUnit >> canChangeFormat [
	^false]

{ #category : #accessing }
NonNumericUnit >> displayName [
	^'']

{ #category : #initialization }
NonNumericUnit >> initializeConversion [
	"
	do nothing
	"
	]

{ #category : #testing }
NonNumericUnit >> isBaseUnit [
	^true]

{ #category : #testing }
NonNumericUnit >> isSystemUnit [
	^true]

{ #category : #'filein/out' }
NonNumericUnit >> needsConversionMigrationTo: u [
	^false]

