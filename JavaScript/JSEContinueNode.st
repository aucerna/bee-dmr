"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEContinueNode,
	#superclass : #JSEControlStatementNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSEContinueNode >> acceptVisitor: aVisitor [
	^aVisitor acceptContinue: self]

