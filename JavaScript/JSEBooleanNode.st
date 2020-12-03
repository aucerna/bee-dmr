"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEBooleanNode,
	#superclass : #JSEPrimitiveLiteralNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSEBooleanNode >> acceptVisitor: aVisitor [
	^aVisitor acceptLiteralBoolean: self]

