"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEObjectNode,
	#superclass : #JSELiteralNode,
	#instVars : [
		'assignments'
	],
	#category : #JavaScript
}

{ #category : #visitor }
JSEObjectNode >> acceptVisitor: aVisitor [
	^aVisitor acceptLiteralObject: self]

{ #category : #accessing }
JSEObjectNode >> literalValue [
	^self]

{ #category : #accessing }
JSEObjectNode >> propertyAssignments [
	^assignments]

{ #category : #accessing }
JSEObjectNode >> propertyAssignments: aCollection [
	assignments := aCollection.
	assignments notEmpty ifTrue: [
		position := assignments first position.
		end := assignments last end]]

