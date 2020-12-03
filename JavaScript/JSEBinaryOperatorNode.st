"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEBinaryOperatorNode,
	#superclass : #JSEOperatorNode,
	#instVars : [
		'left',
		'right'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSEBinaryOperatorNode >> acceptVisitor: aVisitor [
	^aVisitor acceptBinaryOperator: self]

{ #category : #accessing }
JSEBinaryOperatorNode >> leftExpression [
	^left]

{ #category : #accessing }
JSEBinaryOperatorNode >> leftExpression: aJSEParseNode [
	left := aJSEParseNode.
	position := left position]

{ #category : #accessing }
JSEBinaryOperatorNode >> rightExpression [
	^right]

{ #category : #accessing }
JSEBinaryOperatorNode >> rightExpression: aJSEParseNode [
	right := aJSEParseNode.
	end := right end]

