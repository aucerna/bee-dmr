"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BooleanUnit,
	#superclass : #NonNumericUnit,
	#category : #Units
}

{ #category : #accessing }
BooleanUnit class >> baseClass [
	^Boolean]

{ #category : #defaults }
BooleanUnit class >> defaultValue [
	^true]

{ #category : #accessing }
BooleanUnit class >> typeName [
	^'Boolean']

{ #category : #services }
BooleanUnit >> adaptType: value [
	value isBoolean ifTrue: [^value].
	value isString ifTrue: [^self undefinedValue].
	value isDate ifTrue: [^self undefinedValue].
	value isUndefinedValue ifTrue: [^self undefinedValue].
	value isNumber ifTrue: [^value asInteger asBoolean].
	value isArrayValued
		ifTrue: [^value asArray collect: [:each | self adaptType: each]].
	self ASSERT: false.
	^value]

{ #category : #converting }
BooleanUnit >> baseValueOf: quantity [
	^quantity notNil ifTrue: [self adaptType: quantity]]

{ #category : #converting }
BooleanUnit >> convert: aBoolean [
	| b |
	b := aBoolean value.
	b isNumber ifTrue: [^(b = 0.0) not].
	^b]

{ #category : #'gui support' }
BooleanUnit >> displayString: aBoolean [
	^aBoolean printString]

{ #category : #reading }
BooleanUnit >> fromString: aString [
	(aString equalsCaseInsensitive: 'true') ifTrue: [^self baseValueOf: true].
	(aString equalsCaseInsensitive: 'false') ifTrue: [^self baseValueOf: false].
	^nil]

{ #category : #testing }
BooleanUnit >> isBooleanUnit [
	^true]

{ #category : #services }
BooleanUnit >> maxRepresentableRange [
	^nil]

{ #category : #reading }
BooleanUnit >> valueFromString: aString [
	(aString equalsCaseInsensitive: 'true') ifTrue: [^true].
	(aString equalsCaseInsensitive: 'false') ifTrue: [^false].
	^nil]

