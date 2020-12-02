"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssValueTypeAND,
	#superclass : #CssValueTypeRelation,
	#category : #CSS
}

{ #category : #accessing }
CssValueTypeAND >> addValues: aCollection fromStream: in [
	| pos sz |
	pos := in position.
	sz := aCollection size.
	self types do: [:ea | 
		(ea addValues: aCollection fromStream: in) ifFalse: [
			in position: pos.
			[aCollection size > sz] whileTrue: [aCollection removeLast].
			^false]].
	^true]

{ #category : #testing }
CssValueTypeAND >> isTypeAND [
	^true]

{ #category : #testing }
CssValueTypeAND >> operator [
	^' ']

{ #category : #printing }
CssValueTypeAND >> printOn: aStream [
	aStream nextPut: $[.
	self types do: [:ea | 
		ea printOn: aStream.
		ea == types last ifFalse: [aStream nextPutAll: ' ']].
	aStream nextPut: $]]

