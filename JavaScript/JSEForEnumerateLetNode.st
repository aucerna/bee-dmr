"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEForEnumerateLetNode,
	#superclass : #JSEForEnumerateVariableNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSEForEnumerateLetNode >> acceptVisitor: aVisitor [
	^aVisitor acceptForEnumerateLet: self]

