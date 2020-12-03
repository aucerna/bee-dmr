"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEConditionalNode,
	#superclass : #JSEParseNode,
	#instVars : [
		'condition',
		'trueExpression',
		'falseExpression'
	],
	#category : #JavaScript
}

{ #category : #accessing }
JSEConditionalNode >> condition [
	^condition]

{ #category : #accessing }
JSEConditionalNode >> condition: aCondition [
	condition := aCondition.
	position := condition position]

{ #category : #accessing }
JSEConditionalNode >> falseExpression [
	^falseExpression]

{ #category : #accessing }
JSEConditionalNode >> falseExpression: aFalseExpression [
	falseExpression := aFalseExpression.
	falseExpression notNil ifTrue: [end := falseExpression end]]

{ #category : #accessing }
JSEConditionalNode >> trueExpression [
	^trueExpression]

{ #category : #accessing }
JSEConditionalNode >> trueExpression: aTrueExpression [
	trueExpression := aTrueExpression.
	trueExpression notNil ifTrue: [end := trueExpression end]]

