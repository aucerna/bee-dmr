"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEBreakNode,
	#superclass : #JSEControlStatementNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSEBreakNode >> acceptVisitor: aVisitor [
	^aVisitor acceptBreak: self]

