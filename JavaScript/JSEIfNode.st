"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEIfNode,
	#superclass : #JSEConditionalNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSEIfNode >> acceptVisitor: aVisitor [
	^aVisitor acceptIf: self]

