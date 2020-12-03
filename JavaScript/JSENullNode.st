"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSENullNode,
	#superclass : #JSEPrimitiveLiteralNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSENullNode >> acceptVisitor: aVisitor [
	^aVisitor acceptLiteralNull: self]

