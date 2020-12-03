"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSESourceElementListNode,
	#superclass : #JSEParseNode,
	#instVars : [
		'elements'
	],
	#category : #JavaScript
}

{ #category : #accessing }
JSESourceElementListNode >> sourceElements [
	^elements]

{ #category : #accessing }
JSESourceElementListNode >> sourceElements: aCollection [
	elements := aCollection.
	elements size > 0 ifTrue: [
		position := elements first position.
		end := elements last end]]

