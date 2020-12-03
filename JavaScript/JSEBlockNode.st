"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEBlockNode,
	#superclass : #JSEParseNode,
	#instVars : [
		'statements'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSEBlockNode >> acceptVisitor: aVisitor [
	^aVisitor acceptBlock: self]

{ #category : #accessing }
JSEBlockNode >> statements [
	^statements]

{ #category : #accessing }
JSEBlockNode >> statements: aCollection [
	statements := aCollection]

