"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSELetStatementNode,
	#superclass : #JSEVariableStatementNode,
	#category : #JavaScript
}

{ #category : #accessing }
JSELetStatementNode >> acceptVisitor: aVisitor [
	^aVisitor acceptLetStatement: self]

