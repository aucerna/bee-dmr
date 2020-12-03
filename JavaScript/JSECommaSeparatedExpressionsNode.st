"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSECommaSeparatedExpressionsNode,
	#superclass : #JSEParseNode,
	#instVars : [
		'left',
		'right'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSECommaSeparatedExpressionsNode >> acceptVisitor: aVisitor [

	^ aVisitor acceptCommaSeparatedExpressions: self]

{ #category : #accessing }
JSECommaSeparatedExpressionsNode >> leftExpression [
	^left]

{ #category : #accessing }
JSECommaSeparatedExpressionsNode >> leftExpression: aJSEParseNode [
	left := aJSEParseNode]

{ #category : #accessing }
JSECommaSeparatedExpressionsNode >> rightExpression [
	^right]

{ #category : #accessing }
JSECommaSeparatedExpressionsNode >> rightExpression: aJSEParseNode [
	right := aJSEParseNode]

