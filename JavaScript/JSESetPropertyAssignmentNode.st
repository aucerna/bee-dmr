"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSESetPropertyAssignmentNode,
	#superclass : #JSEPropertyFunctionAssignmentNode,
	#instVars : [
		'parameter'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSESetPropertyAssignmentNode >> acceptVisitor: aVisitor [
	^aVisitor acceptSetPropertyAssignment: self]

{ #category : #accessing }
JSESetPropertyAssignmentNode >> parameter [
	^parameter]

{ #category : #accessing }
JSESetPropertyAssignmentNode >> parameter: anObject [
	parameter := anObject]

