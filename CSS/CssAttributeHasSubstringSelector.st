"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssAttributeHasSubstringSelector,
	#superclass : #CssAttributeSelector,
	#category : #CSS
}

{ #category : #testing }
CssAttributeHasSubstringSelector >> isCSS3 [
	^true]

{ #category : #testing }
CssAttributeHasSubstringSelector >> matches: anHtmlElement [
	| v |
	v := self attributeValueInNode: anHtmlElement.
	^v notNil and: [v includesString: value unquoted]]

