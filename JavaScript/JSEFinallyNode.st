"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEFinallyNode,
	#superclass : #JSEExceptionHandlerNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSEFinallyNode >> acceptVisitor: aVisitor [
	^aVisitor acceptFinally: self]

