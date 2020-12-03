"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSESwitchNode,
	#superclass : #JSEParseNode,
	#instVars : [
		'switch',
		'clauses'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSESwitchNode >> acceptVisitor: aVisitor [
	^aVisitor acceptSwitch: self]

{ #category : #accessing }
JSESwitchNode >> clauses [
	^clauses]

{ #category : #accessing }
JSESwitchNode >> clauses: aCollection [
	clauses := aCollection]

{ #category : #accessing }
JSESwitchNode >> switch [
	^switch]

{ #category : #accessing }
JSESwitchNode >> switch: aJSEParseNode [
	switch := aJSEParseNode]

