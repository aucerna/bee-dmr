"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssValueTypeZeroOrOneOf,
	#superclass : #CssValueTypeConstraint,
	#category : #CSS
}

{ #category : #accessing }
CssValueTypeZeroOrOneOf class >> type [

	^$?]

{ #category : #accessing }
CssValueTypeZeroOrOneOf >> addValues: aCollection fromStream: in [
	| pos |
	pos := in position.
	(type addValues: aCollection fromStream: in) ifFalse: [in position: pos].
	^true]

