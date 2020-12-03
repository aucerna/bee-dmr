"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEVariableDeclarationNode,
	#superclass : #JSEParseNode,
	#instVars : [
		'identifier',
		'initializer'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSEVariableDeclarationNode >> acceptVisitor: aVisitor [
	^aVisitor acceptVariableDeclaration: self]

{ #category : #accessing }
JSEVariableDeclarationNode >> identifier [
	^identifier]

{ #category : #accessing }
JSEVariableDeclarationNode >> identifier: aJSEIdentifierNameNode [
	identifier := aJSEIdentifierNameNode.
	position := identifier position.
	end := identifier end]

{ #category : #accessing }
JSEVariableDeclarationNode >> initializer [
	^initializer]

{ #category : #accessing }
JSEVariableDeclarationNode >> initializer: aJSEParseNode [
	initializer := aJSEParseNode.
	initializer notNil ifTrue: [end := initializer end]]

{ #category : #testing }
JSEVariableDeclarationNode >> isVariable [
	^true]

