"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEConstStatementNode,
	#superclass : #JSEVariableStatementNode,
	#category : #JavaScript
}

{ #category : #accessing }
JSEConstStatementNode >> acceptVisitor: aVisitor [
	^aVisitor acceptConstStatement: self]

