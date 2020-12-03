"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEThisNode,
	#superclass : #JSEParseNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSEThisNode >> acceptVisitor: aVisitor [
	^aVisitor acceptThis: self]

