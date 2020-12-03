"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEFunctionCallNode,
	#superclass : #JSECallNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSEFunctionCallNode >> acceptVisitor: aVisitor [
	^aVisitor acceptFunctionCall: self]

