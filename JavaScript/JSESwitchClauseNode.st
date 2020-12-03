"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSESwitchClauseNode,
	#superclass : #JSEParseNode,
	#instVars : [
		'statements'
	],
	#category : #JavaScript
}

{ #category : #accessing }
JSESwitchClauseNode >> statements [
	^statements]

{ #category : #accessing }
JSESwitchClauseNode >> statements: aStatements [
	statements := aStatements]

