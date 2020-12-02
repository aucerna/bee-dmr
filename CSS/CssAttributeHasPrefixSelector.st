"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssAttributeHasPrefixSelector,
	#superclass : #CssAttributeSelector,
	#category : #CSS
}

{ #category : #testing }
CssAttributeHasPrefixSelector >> isCSS3 [
	^true]

{ #category : #testing }
CssAttributeHasPrefixSelector >> matches: anHtmlElement [
	| v |
	v := self attributeValueInNode: anHtmlElement.
	^v notNil and: [v beginsWith: value unquoted]]

