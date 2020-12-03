"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEAssignmentNode,
	#superclass : #JSEParseNode,
	#instVars : [
		'assignee',
		'operator',
		'expression'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSEAssignmentNode >> acceptVisitor: aVisitor [
	^aVisitor acceptAssignment: self]

{ #category : #accessing }
JSEAssignmentNode >> assignee [
	^assignee]

{ #category : #accessing }
JSEAssignmentNode >> assignee: aLeftHandSide [
	assignee := aLeftHandSide.
	position := assignee position]

{ #category : #accessing }
JSEAssignmentNode >> expression [
	^expression]

{ #category : #accessing }
JSEAssignmentNode >> expression: anAssignedExpression [
	expression := anAssignedExpression.
	end := expression end]

{ #category : #accessing }
JSEAssignmentNode >> operator [
	^operator]

{ #category : #accessing }
JSEAssignmentNode >> operator: aSymbol [
	operator := aSymbol]

