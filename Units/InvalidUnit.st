"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #InvalidUnit,
	#superclass : #Unit,
	#category : #Units
}

{ #category : #accessing }
InvalidUnit class >> conversions [
	^Dictionary with: '<invalid>' -> 1.0]

{ #category : #testing }
InvalidUnit class >> isPrivate [
	^true]

{ #category : #accessing }
InvalidUnit class >> typeName [
	^'Invalid Unit']

{ #category : #private }
InvalidUnit class >> validCode: aString [
	| code |
	code := super validCode: aString.
	code := code replaceAll: 'undefined' with: 'invalid'.
	^code]

{ #category : #arithmetic }
InvalidUnit >> - aUnit [
	^self]

{ #category : #arithmetic }
InvalidUnit >> * aUnit [
	^self]

{ #category : #arithmetic }
InvalidUnit >> / aUnit [
	^self]

{ #category : #arithmetic }
InvalidUnit >> // aUnit [
	^self]

{ #category : #arithmetic }
InvalidUnit >> + aUnit [
	^self]

{ #category : #converting }
InvalidUnit >> baseValueOf: quantity [
	^quantity]

{ #category : #converting }
InvalidUnit >> convert: aNumber [
	^aNumber]

{ #category : #testing }
InvalidUnit >> isInvalidUnit [
	^true]

