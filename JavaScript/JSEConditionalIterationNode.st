"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEConditionalIterationNode,
	#superclass : #JSEIterationNode,
	#instVars : [
		'condition'
	],
	#category : #JavaScript
}

{ #category : #accessing }
JSEConditionalIterationNode >> condition [
	^condition]

{ #category : #accessing }
JSEConditionalIterationNode >> condition: aJSEParseNode [
	condition := aJSEParseNode]

