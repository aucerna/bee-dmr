"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEWhileNode,
	#superclass : #JSEConditionalIterationNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSEWhileNode >> acceptVisitor: aVisitor [
	^aVisitor acceptWhile: self]

