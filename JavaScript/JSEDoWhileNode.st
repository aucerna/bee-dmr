"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEDoWhileNode,
	#superclass : #JSEConditionalIterationNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSEDoWhileNode >> acceptVisitor: aVisitor [
	^aVisitor acceptDoWhile: self]

