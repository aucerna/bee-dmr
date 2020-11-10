"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MissingUnit,
	#superclass : #Error,
	#instVars : [
		'unit'
	],
	#category : #Units
}

{ #category : #signaling }
MissingUnit class >> unit: aUnit signal: messageText [
	^self new unit: aUnit; description: messageText; signal]

{ #category : #testing }
MissingUnit >> isResumable [
	^true]

{ #category : #accessing }
MissingUnit >> unit [
	^unit]

{ #category : #accessing }
MissingUnit >> unit: aUnit [
	unit := aUnit]

