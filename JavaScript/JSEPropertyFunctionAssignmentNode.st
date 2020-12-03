"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEPropertyFunctionAssignmentNode,
	#superclass : #JSEPropertyNode,
	#instVars : [
		'body'
	],
	#category : #JavaScript
}

{ #category : #accessing }
JSEPropertyFunctionAssignmentNode >> functionBody [
	^body]

{ #category : #accessing }
JSEPropertyFunctionAssignmentNode >> functionBody: aFunctionBody [
	body := aFunctionBody.
	end := body end]

