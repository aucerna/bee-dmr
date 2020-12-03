"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEFunctionBodyNode,
	#superclass : #JSESourceElementListNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSEFunctionBodyNode >> acceptVisitor: aVisitor [
	^aVisitor acceptFunctionBody: self]

