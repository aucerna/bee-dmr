"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssAttributeEqualsSelector,
	#superclass : #CssAttributeSelector,
	#category : #CSS
}

{ #category : #testing }
CssAttributeEqualsSelector >> matches: anHtmlElement [
	| v |
	v := self attributeValueInNode: anHtmlElement.
	^v notNil and: [v unquoted = value unquoted]]

{ #category : #printing }
CssAttributeEqualsSelector >> printOn: aStream [
	aStream
		nextPut: $[;
		nextPutAll: self attribute;
		nextPutAll: '="';
		nextPutAll: self value;
		nextPutAll: '"]']

