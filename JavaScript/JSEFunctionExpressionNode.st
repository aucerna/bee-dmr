"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEFunctionExpressionNode,
	#superclass : #JSEFunctionNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSEFunctionExpressionNode >> acceptVisitor: aVisitor [
	^aVisitor acceptFunctionExpression: self]

