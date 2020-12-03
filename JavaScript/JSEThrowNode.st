"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEThrowNode,
	#superclass : #JSEParseNode,
	#instVars : [
		'expression'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSEThrowNode >> acceptVisitor: aVisitor [
	^aVisitor acceptThrow: self]

{ #category : #accessing }
JSEThrowNode >> throwExpression [
	^expression]

{ #category : #accessing }
JSEThrowNode >> throwExpression: aThrowExpression [
	expression := aThrowExpression]

