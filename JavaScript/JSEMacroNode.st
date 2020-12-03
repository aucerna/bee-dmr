"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEMacroNode,
	#superclass : #JSEIdentifierNameNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSEMacroNode >> acceptVisitor: aVisitor [
	^aVisitor acceptMacro: self]

{ #category : #testing }
JSEMacroNode >> isMacroNode [
	^true]

