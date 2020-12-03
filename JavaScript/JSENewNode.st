"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSENewNode,
	#superclass : #JSECallNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSENewNode >> acceptVisitor: aVisitor [
	^aVisitor acceptNew: self]

