"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEPrimitiveLiteralNode,
	#superclass : #JSELiteralNode,
	#instVars : [
		'value'
	],
	#category : #JavaScript
}

{ #category : #accessing }
JSEPrimitiveLiteralNode >> fromToken: aToken [
	super fromToken: aToken.
	self literalValue: aToken literalValue]

{ #category : #accessing }
JSEPrimitiveLiteralNode >> literalValue [
	^value]

{ #category : #accessing }
JSEPrimitiveLiteralNode >> literalValue: anObject [
	value := anObject]

