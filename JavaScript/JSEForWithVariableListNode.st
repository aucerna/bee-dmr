"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEForWithVariableListNode,
	#superclass : #JSEConditionalForNode,
	#instVars : [
		'variables'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSEForWithVariableListNode >> acceptVisitor: aVisitor [
	^aVisitor acceptForWithVariableList: self]

{ #category : #accessing }
JSEForWithVariableListNode >> variableDeclarations [
	^variables]

{ #category : #accessing }
JSEForWithVariableListNode >> variableDeclarations: aCollection [
	variables := aCollection]

