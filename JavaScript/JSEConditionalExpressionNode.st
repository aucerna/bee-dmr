"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEConditionalExpressionNode,
	#superclass : #JSEConditionalNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSEConditionalExpressionNode >> acceptVisitor: aVisitor [
	^aVisitor acceptConditionalExpression: self]

