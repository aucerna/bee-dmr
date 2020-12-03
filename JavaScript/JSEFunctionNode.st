"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEFunctionNode,
	#superclass : #JSEParseNode,
	#instVars : [
		'identifier',
		'parameters',
		'body'
	],
	#category : #JavaScript
}

{ #category : #accessing }
JSEFunctionNode >> formalParameters [
	^parameters]

{ #category : #accessing }
JSEFunctionNode >> formalParameters: aCollection [
	parameters := aCollection.
	(position isNil and: [parameters notEmpty])
		ifTrue: [position := parameters first position - 'function(' size]]

{ #category : #accessing }
JSEFunctionNode >> functionBody [
	^body]

{ #category : #accessing }
JSEFunctionNode >> functionBody: aJSEParseNode [
	body := aJSEParseNode.
	body position notNil ifTrue: [
		position isNil ifTrue: [position := body position - 'function()' size].
		end := body end]]

{ #category : #accessing }
JSEFunctionNode >> identifier [
	^identifier]

{ #category : #accessing }
JSEFunctionNode >> identifier: aJSEIdentifierNameNode [
	identifier := aJSEIdentifierNameNode.
	identifier notNil ifTrue: [position := identifier position]]

