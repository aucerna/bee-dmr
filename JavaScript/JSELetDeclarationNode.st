"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSELetDeclarationNode,
	#superclass : #JSEVariableDeclarationNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSELetDeclarationNode >> acceptVisitor: aVisitor [
	^aVisitor acceptLetDeclaration: self]

