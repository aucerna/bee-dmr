"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEReturnNode,
	#superclass : #JSEParseNode,
	#instVars : [
		'return'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSEReturnNode >> acceptVisitor: aVisitor [
	^aVisitor acceptReturn: self]

{ #category : #accessing }
JSEReturnNode >> return [
	^return]

{ #category : #accessing }
JSEReturnNode >> return: aReturnExpression [
	return := aReturnExpression ifNil: [^self].
	position := return position - 'return ' size.
	end := return end]

