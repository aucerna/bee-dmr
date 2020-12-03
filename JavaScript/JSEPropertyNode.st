"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEPropertyNode,
	#superclass : #JSEParseNode,
	#instVars : [
		'name'
	],
	#category : #JavaScript
}

{ #category : #accessing }
JSEPropertyNode >> propertyName [
	^name]

{ #category : #accessing }
JSEPropertyNode >> propertyName: aString [
	name := aString.
	position := name position.
	end := name end]

