"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEIterationNode,
	#superclass : #JSEParseNode,
	#instVars : [
		'statement'
	],
	#category : #JavaScript
}

{ #category : #accessing }
JSEIterationNode >> statement [
	^statement]

{ #category : #accessing }
JSEIterationNode >> statement: aJSEParseNode [
	statement := aJSEParseNode]

