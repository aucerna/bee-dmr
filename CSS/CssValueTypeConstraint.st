"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssValueTypeConstraint,
	#superclass : #CssValueType,
	#instVars : [
		'type'
	],
	#category : #CSS
}

{ #category : #accessing }
CssValueTypeConstraint class >> allTypes [

	^self subclasses collect:[:ea | ea type]]

{ #category : #'instance creation' }
CssValueTypeConstraint class >> forType: aCharacter [

	^self subclasses detect: [:ea | ea type = aCharacter] 
		ifNone: [self error: ('Type not found ', (aCharacter asString))].
	]

{ #category : #accessing }
CssValueTypeConstraint class >> isSimple [

	^true]

{ #category : #'instance creation' }
CssValueTypeConstraint class >> readFrom: in [
	| cls |
	cls := self forType: in peek.
	^cls isSimple
		ifTrue: [
			in next.
			cls new]
		ifFalse: [cls readFrom: in]]

{ #category : #printing }
CssValueTypeConstraint >> printOn: aStream [
	self type printOn: aStream.
	aStream nextPut: self class type]

{ #category : #accessing }
CssValueTypeConstraint >> type [
	^type]

{ #category : #accessing }
CssValueTypeConstraint >> type: anObject [
	type := anObject]

