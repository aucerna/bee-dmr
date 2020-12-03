"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEUnaryOperatorNode,
	#superclass : #JSEOperatorNode,
	#instVars : [
		'expression'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSEUnaryOperatorNode >> acceptVisitor: aVisitor [
	^aVisitor acceptUnaryOperator: self]

{ #category : #accessing }
JSEUnaryOperatorNode >> expression [
	^expression]

{ #category : #accessing }
JSEUnaryOperatorNode >> expression: aJSEParseNode [
	expression := aJSEParseNode.
	position := expression position - operator size.
	end := expression end]

