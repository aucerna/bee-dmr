"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEOperatorNode,
	#superclass : #JSEParseNode,
	#instVars : [
		'operator'
	],
	#category : #JavaScript
}

{ #category : #accessing }
JSEOperatorNode >> operator [
	^operator]

{ #category : #accessing }
JSEOperatorNode >> operator: aSymbol [
	operator := aSymbol]

