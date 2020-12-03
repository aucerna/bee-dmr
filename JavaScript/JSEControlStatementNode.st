"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEControlStatementNode,
	#superclass : #JSEParseNode,
	#instVars : [
		'identifier'
	],
	#category : #JavaScript
}

{ #category : #accessing }
JSEControlStatementNode >> identifier [
	^identifier]

{ #category : #accessing }
JSEControlStatementNode >> identifier: aJSEIdentifierNameNode [
	identifier := aJSEIdentifierNameNode]

