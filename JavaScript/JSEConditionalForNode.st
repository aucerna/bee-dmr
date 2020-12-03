"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEConditionalForNode,
	#superclass : #JSEForIterationNode,
	#instVars : [
		'condition',
		'expression'
	],
	#category : #JavaScript
}

{ #category : #accessing }
JSEConditionalForNode >> condition [
	^condition]

{ #category : #accessing }
JSEConditionalForNode >> condition: aJSEParseNode [
	condition := aJSEParseNode]

{ #category : #accessing }
JSEConditionalForNode >> updateExpression [
	^expression]

{ #category : #accessing }
JSEConditionalForNode >> updateExpression: aJSEParseNode [
	expression := aJSEParseNode]

