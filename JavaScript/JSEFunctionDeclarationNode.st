"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEFunctionDeclarationNode,
	#superclass : #JSEFunctionNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSEFunctionDeclarationNode >> acceptVisitor: aVisitor [
	^aVisitor acceptFunctionDeclaration: self]

