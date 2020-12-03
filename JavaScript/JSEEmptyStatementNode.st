"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEEmptyStatementNode,
	#superclass : #JSEParseNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSEEmptyStatementNode >> acceptVisitor: aVisitor [
	^aVisitor acceptEmptyStatement: self]

{ #category : #testing }
JSEEmptyStatementNode >> isEmptyNode [
	^true]

