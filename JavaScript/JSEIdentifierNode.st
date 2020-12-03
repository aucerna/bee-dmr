"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEIdentifierNode,
	#superclass : #JSEIdentifierNameNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSEIdentifierNode >> acceptVisitor: aVisitor [
	^aVisitor acceptIdentifier: self]

