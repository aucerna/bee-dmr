"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssValueTypeZeroOrMoreOf,
	#superclass : #CssValueTypeConstraint,
	#category : #CSS
}

{ #category : #accessing }
CssValueTypeZeroOrMoreOf class >> type [

	^$*]

{ #category : #accessing }
CssValueTypeZeroOrMoreOf >> addValues: aCollection fromStream: in [
	| pos |
	[
		pos := in position.
		type addValues: aCollection fromStream: in]
		whileTrue: [].
	in position: pos.
	^true]

