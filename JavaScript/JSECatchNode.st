"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSECatchNode,
	#superclass : #JSEExceptionHandlerNode,
	#instVars : [
		'identifier'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSECatchNode >> acceptVisitor: aVisitor [
	^aVisitor acceptCatch: self]

{ #category : #accessing }
JSECatchNode >> identifier [
	^identifier]

{ #category : #accessing }
JSECatchNode >> identifier: aJSEIdentifierNameNode [
	identifier := aJSEIdentifierNameNode]

