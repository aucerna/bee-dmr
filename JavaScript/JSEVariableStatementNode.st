"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEVariableStatementNode,
	#superclass : #JSEParseNode,
	#instVars : [
		'variables'
	],
	#category : #JavaScript
}

{ #category : #accessing }
JSEVariableStatementNode >> acceptVisitor: aVisitor [
	^aVisitor acceptVariableStatement: self]

{ #category : #accessing }
JSEVariableStatementNode >> variableDeclarations [
	^variables]

{ #category : #accessing }
JSEVariableStatementNode >> variableDeclarations: aCollection [
	variables := aCollection.
	position := variables first position.
	end := variables last end]

