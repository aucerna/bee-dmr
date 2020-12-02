"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlAttributeNotLowerCaseError,
	#superclass : #HtmlAttributeError,
	#category : #HTML
}

{ #category : #testing }
HtmlAttributeNotLowerCaseError >> isCaseError [
]

{ #category : #printing }
HtmlAttributeNotLowerCaseError >> printOn: aStream [
	self attribute printOn: aStream.
	aStream nextPutAll: ' should be '.
	self attribute asLowercase printOn: aStream.
	aStream nextPutAll: ' in '.
	self parent prefix
		printOn: aStream
		" Valid attributes are: '.
	attrList := self parent dtd attrListForTag: self parent dtdTag.
	(attrList attributes collect:[:ea | ea attribute]) printOn: aStream."]

