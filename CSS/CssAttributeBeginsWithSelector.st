"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssAttributeBeginsWithSelector,
	#superclass : #CssAttributeSelector,
	#category : #CSS
}

{ #category : #testing }
CssAttributeBeginsWithSelector >> matches: anHtmlElement [
	| v |
	v := self attributeValueInNode: anHtmlElement.
	^v notNil and: [($- split: v) first = value unquoted]]

