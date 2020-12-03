"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSECallNode,
	#superclass : #JSEParseNode,
	#instVars : [
		'member',
		'arguments'
	],
	#category : #JavaScript
}

{ #category : #accessing }
JSECallNode >> arguments [
	^arguments]

{ #category : #accessing }
JSECallNode >> arguments: aCollection [
	arguments := aCollection.
	end := arguments isEmpty
		ifTrue: [position + 2]
		ifFalse: [arguments last end ifNotNil: [:e | e + 1]]]

{ #category : #accessing }
JSECallNode >> member [
	^member]

{ #category : #accessing }
JSECallNode >> member: aJSEParseNode [
	member := aJSEParseNode.
	position := member position]

