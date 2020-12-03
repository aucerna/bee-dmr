"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSERegularExpressionNode,
	#superclass : #JSEParseNode,
	#instVars : [
		'expression',
		'flags'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSERegularExpressionNode >> acceptVisitor: aVisitor [
	^aVisitor acceptRegularExpression: self]

{ #category : #accessing }
JSERegularExpressionNode >> flags [
	^flags]

{ #category : #accessing }
JSERegularExpressionNode >> flags: aString [
	flags := aString]

{ #category : #accessing }
JSERegularExpressionNode >> fromToken: aToken [
	super fromToken: aToken.
	self regularExpression: aToken literalValue]

{ #category : #accessing }
JSERegularExpressionNode >> regularExpression [
	^expression]

{ #category : #accessing }
JSERegularExpressionNode >> regularExpression: aString [
	expression := aString]

