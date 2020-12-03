"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEForWithLetListNode,
	#superclass : #JSEForWithVariableListNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSEForWithLetListNode >> acceptVisitor: aVisitor [
	^aVisitor acceptForWithLetList: self]

