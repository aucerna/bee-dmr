"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssAttributeExistsSelector,
	#superclass : #CssAttributeSelector,
	#category : #CSS
}

{ #category : #testing }
CssAttributeExistsSelector >> matches: anHtmlElement [
	^(self attributeKeyInNode: anHtmlElement) notNil]

{ #category : #printing }
CssAttributeExistsSelector >> printOn: aStream [
	aStream
		nextPut: $[;
		nextPutAll: self attribute;
		nextPut: $]]

