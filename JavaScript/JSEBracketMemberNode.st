"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEBracketMemberNode,
	#superclass : #JSEMemberNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSEBracketMemberNode >> acceptVisitor: aVisitor [
	^aVisitor acceptBracketMember: self]

