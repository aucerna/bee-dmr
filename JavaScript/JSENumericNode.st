"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSENumericNode,
	#superclass : #JSEPrimitiveLiteralNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSENumericNode >> acceptVisitor: aVisitor [
	^aVisitor acceptLiteralNumeric: self]

