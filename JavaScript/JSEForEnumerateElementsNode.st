"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEForEnumerateElementsNode,
	#superclass : #JSEEnumeratingForNode,
	#instVars : [
		'enumerable'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSEForEnumerateElementsNode >> acceptVisitor: aVisitor [
	^aVisitor acceptForEnumerateElements: self]

{ #category : #accessing }
JSEForEnumerateElementsNode >> enumerable [
	^enumerable]

{ #category : #accessing }
JSEForEnumerateElementsNode >> enumerable: aJSEParseNode [
	enumerable := aJSEParseNode]

