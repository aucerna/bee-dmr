"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSELiteralNode,
	#superclass : #JSEParseNode,
	#category : #JavaScript
}

{ #category : #testing }
JSELiteralNode >> isLiteral [
	^true]

{ #category : #testing }
JSELiteralNode >> isRGBColor [
	^false]

