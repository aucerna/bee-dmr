"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEForEnumerateVariableNode,
	#superclass : #JSEEnumeratingForNode,
	#instVars : [
		'variable'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSEForEnumerateVariableNode >> acceptVisitor: aVisitor [
	^aVisitor acceptForEnumerateVariable: self]

{ #category : #accessing }
JSEForEnumerateVariableNode >> variableDeclaration [
	^variable]

{ #category : #accessing }
JSEForEnumerateVariableNode >> variableDeclaration: aJSEParseNode [
	variable := aJSEParseNode]

