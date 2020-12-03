"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEDebuggerNode,
	#superclass : #JSEParseNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSEDebuggerNode >> acceptVisitor: aVisitor [
	^aVisitor acceptDebugger: self]

