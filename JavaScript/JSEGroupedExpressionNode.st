"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEGroupedExpressionNode,
	#superclass : #JSEParseNode,
	#instVars : [
		'expression'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSEGroupedExpressionNode >> acceptVisitor: aVisitor [
	^aVisitor acceptGroupedExpression: self]

{ #category : #accessing }
JSEGroupedExpressionNode >> expression [
	^expression]

{ #category : #accessing }
JSEGroupedExpressionNode >> expression: aJSEParseNode [
	expression := aJSEParseNode.
	position := expression position.
	end := expression end]

