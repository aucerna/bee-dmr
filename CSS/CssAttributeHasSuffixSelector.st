"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssAttributeHasSuffixSelector,
	#superclass : #CssAttributeSelector,
	#category : #CSS
}

{ #category : #testing }
CssAttributeHasSuffixSelector >> isCSS3 [
	^true]

{ #category : #testing }
CssAttributeHasSuffixSelector >> matches: anHtmlElement [
	| v |
	v := self attributeValueInNode: anHtmlElement.
	^v notNil and: [v endsWith: value unquoted]]

