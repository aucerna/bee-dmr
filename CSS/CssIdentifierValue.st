"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssIdentifierValue,
	#superclass : #CssValue,
	#category : #CSS
}

{ #category : #testing }
CssIdentifierValue >> isValid [
	string isEmpty ifTrue: [^false].
	string first isLetter ifFalse: [^false].
	^string conform: [:ch | ch isAlphanumeric or: ['_-' includes: ch]]]

