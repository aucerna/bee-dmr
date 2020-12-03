"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEWithNode,
	#superclass : #JSEParseNode,
	#instVars : [
		'expression',
		'statement'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSEWithNode >> acceptVisitor: aVisitor [
	^aVisitor acceptWith: self]

{ #category : #accessing }
JSEWithNode >> statement [
	^statement]

{ #category : #accessing }
JSEWithNode >> statement: aJSEParseNode [
	statement := aJSEParseNode]

{ #category : #accessing }
JSEWithNode >> withExpression [
	^expression]

{ #category : #accessing }
JSEWithNode >> withExpression: aJSEParseNode [
	expression := aJSEParseNode]

