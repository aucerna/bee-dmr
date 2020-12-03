"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEForWithInitializerNode,
	#superclass : #JSEConditionalForNode,
	#instVars : [
		'initializer'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSEForWithInitializerNode >> acceptVisitor: aVisitor [
	^aVisitor acceptForWithInitializer: self]

{ #category : #accessing }
JSEForWithInitializerNode >> initializer [
	^initializer]

{ #category : #accessing }
JSEForWithInitializerNode >> initializer: aJSEParseNode [
	initializer := aJSEParseNode]

