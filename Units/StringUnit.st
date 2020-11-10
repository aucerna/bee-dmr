"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #StringUnit,
	#superclass : #NonNumericUnit,
	#category : #Units
}

{ #category : #accessing }
StringUnit class >> baseClass [
	^String]

{ #category : #defaults }
StringUnit class >> defaultValue [
	^'']

{ #category : #accessing }
StringUnit class >> typeName [
	^'Text']

{ #category : #private }
StringUnit class >> validCode: aString [
	| code |
	code := super validCode: aString.
	^code capitalized]

{ #category : #converting }
StringUnit >> adaptType: value [
	value isUndefinedValue ifTrue: [^value].
	value isArrayValued
		ifTrue: [^value asArray collect: [:each | self adaptType: each]].
	^value asString]

{ #category : #converting }
StringUnit >> baseValueOf: quantity [
	^quantity]

{ #category : #converting }
StringUnit >> convert: aString [
	^aString value]

{ #category : #accessing }
StringUnit >> fromNLString: aString [
	^aString asString]

{ #category : #converting }
StringUnit >> fromString: aString [
	^aString]

{ #category : #testing }
StringUnit >> isStringUnit [
	^true]

{ #category : #services }
StringUnit >> maxRepresentableRange [
	^nil]

{ #category : #converting }
StringUnit >> minRepresentableValue [
	^'']

{ #category : #printing }
StringUnit >> printOn: aStream [
	aStream nextPutAll: self type name]

{ #category : #printing }
StringUnit >> printTextOn: rtf [
	rtf nextPutAll: self type name]

{ #category : #'gui support' }
StringUnit >> valueFromDisplay: aString [
	^aString]

{ #category : #converting }
StringUnit >> valueFromString: aString [
	^aString]

