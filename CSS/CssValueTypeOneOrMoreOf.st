"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssValueTypeOneOrMoreOf,
	#superclass : #CssValueTypeConstraint,
	#category : #CSS
}

{ #category : #accessing }
CssValueTypeOneOrMoreOf class >> type [

	^$+]

{ #category : #accessing }
CssValueTypeOneOrMoreOf >> addValues: aCollection fromStream: in [
	| one pos |
	one := false.
	[
		pos := in position.
		type addValues: aCollection fromStream: in]
		whileTrue: [one := true].
	in position: pos.
	^one]

