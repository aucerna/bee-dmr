"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSELookaheadParser,
	#superclass : #PPDelegateParser,
	#category : #JavaScript
}

{ #category : #parsing }
JSELookaheadParser >> parseOn: aStream [

	| element position |
	position := aStream position.
	element := parser parseOn: aStream.
	aStream position: position.
	^ element]

