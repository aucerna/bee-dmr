"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEExceptionHandlerNode,
	#superclass : #JSEParseNode,
	#instVars : [
		'block'
	],
	#category : #JavaScript
}

{ #category : #accessing }
JSEExceptionHandlerNode >> block [
	^block]

{ #category : #accessing }
JSEExceptionHandlerNode >> block: aBlock [
	block := aBlock]

