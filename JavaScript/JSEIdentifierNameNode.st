"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEIdentifierNameNode,
	#superclass : #JSEParseNode,
	#instVars : [
		'name'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSEIdentifierNameNode >> acceptVisitor: aVisitor [
	^aVisitor acceptIdentifierName: self]

{ #category : #accessing }
JSEIdentifierNameNode >> fromToken: aToken [
	super fromToken: aToken.
	name := aToken literalValue]

{ #category : #accessing }
JSEIdentifierNameNode >> identifier [
	^name]

{ #category : #testing }
JSEIdentifierNameNode >> isIdentifier [
	^true]

{ #category : #accessing }
JSEIdentifierNameNode >> name [
	^name]

{ #category : #accessing }
JSEIdentifierNameNode >> name: aString [
	name := aString]

{ #category : #accessing }
JSEIdentifierNameNode >> symbol [
	^name notNil ifTrue: [name asSymbol]]

