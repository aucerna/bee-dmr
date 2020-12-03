"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEPropertyAssignmentNode,
	#superclass : #JSEPropertyNode,
	#instVars : [
		'expression'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSEPropertyAssignmentNode >> acceptVisitor: aVisitor [
	^aVisitor acceptPropertyAssignment: self]

{ #category : #accessing }
JSEPropertyAssignmentNode >> expression [
	^expression]

{ #category : #accessing }
JSEPropertyAssignmentNode >> expression: anAssignedExpression [
	expression := anAssignedExpression.
	expression end ifNotNil: [:e | end := e]]

