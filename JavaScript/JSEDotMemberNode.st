"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEDotMemberNode,
	#superclass : #JSEMemberNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSEDotMemberNode >> acceptVisitor: aVisitor [
	^aVisitor acceptDotMember: self]

