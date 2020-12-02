"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssValueTypeOR,
	#superclass : #CssValueTypeRelation,
	#category : #CSS
}

{ #category : #accessing }
CssValueTypeOR >> addValues: aCollection fromStream: in [
	| pos |
	pos := in position.
	self types do: [:ea | 
		(ea addValues: aCollection fromStream: in) ifTrue: [^true].
		in position: pos].
	^false]

{ #category : #testing }
CssValueTypeOR >> isTypeOR [
	^true]

{ #category : #testing }
CssValueTypeOR >> isValueValid: anObject [
	^(self types detect: [:ea | ea isValueValid: anObject] ifNone: [nil]) notNil]

{ #category : #testing }
CssValueTypeOR >> operator [
	^'|']

{ #category : #printing }
CssValueTypeOR >> printOn: aStream [
	aStream nextPut: $[.
	self types do: [:ea | 
		ea printOn: aStream.
		ea == types last ifFalse: [aStream nextPutAll: ' | ']].
	aStream nextPut: $]]

