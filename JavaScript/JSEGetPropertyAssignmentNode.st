"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEGetPropertyAssignmentNode,
	#superclass : #JSEPropertyFunctionAssignmentNode,
	#category : #JavaScript
}

{ #category : #visitor }
JSEGetPropertyAssignmentNode >> acceptVisitor: aVisitor [
	^aVisitor acceptGetPropertyAssignment: self]

