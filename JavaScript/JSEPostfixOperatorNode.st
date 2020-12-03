"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEPostfixOperatorNode,
	#superclass : #JSEUnaryOperatorNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSEPostfixOperatorNode >> acceptVisitor: aVisitor [
	^aVisitor acceptPostfixOperator: self]

