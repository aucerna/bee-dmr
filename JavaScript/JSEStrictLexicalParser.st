"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEStrictLexicalParser,
	#superclass : #JSELexicalParser,
	#category : #JavaScript
}

{ #category : #constants }
JSEStrictLexicalParser class >> futureReservedWords [
	^#(
		'implements'
		'private'
		'public'
		'interface'
		'package'
		'protected'
		'static'
		'yield'
	)]

