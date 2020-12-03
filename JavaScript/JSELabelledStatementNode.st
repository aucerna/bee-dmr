"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSELabelledStatementNode,
	#superclass : #JSEParseNode,
	#instVars : [
		'label',
		'statement'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSELabelledStatementNode >> acceptVisitor: aVisitor [
	^aVisitor acceptLabelledStatement: self]

{ #category : #accessing }
JSELabelledStatementNode >> label [
	^label]

{ #category : #accessing }
JSELabelledStatementNode >> label: aString [
	label := aString]

{ #category : #accessing }
JSELabelledStatementNode >> statement [
	^statement]

{ #category : #accessing }
JSELabelledStatementNode >> statement: aJSEParseNode [
	statement := aJSEParseNode]

