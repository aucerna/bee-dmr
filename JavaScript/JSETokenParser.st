"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSETokenParser,
	#superclass : #PPTokenParser,
	#instVars : [
		'type'
	],
	#category : #JavaScript
}

{ #category : #private }
JSETokenParser >> defaultTokenClass [
	^ JSEToken]

{ #category : #parsing }
JSETokenParser >> parseOn: aStream [
	| start element stop token |
	start := aStream position.
	element := parser parseOn: aStream.
	element isPetitFailure ifTrue: [
		aStream position: start.
		^element].
	stop := aStream position.
	token := self create: aStream collection start: start + 1 stop: stop.
	token type: self type.
	token parsedValue: element.
	^token]

{ #category : #accessing }
JSETokenParser >> type [

	^ type]

{ #category : #accessing }
JSETokenParser >> type: aType [

	type := aType.]

