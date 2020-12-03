"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEExpressionStatementNode,
	#superclass : #JSEParseNode,
	#instVars : [
		'expression'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSEExpressionStatementNode >> acceptVisitor: aVisitor [
	^aVisitor acceptExpressionStatement: self]

{ #category : #accessing }
JSEExpressionStatementNode >> expression [
	^expression]

{ #category : #accessing }
JSEExpressionStatementNode >> expression: aJSEParseNode [
	expression := aJSEParseNode.
	position := expression position.
	end := expression end]

