"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlAttributeValueNotValidError,
	#superclass : #HtmlAttributeError,
	#category : #HTML
}

{ #category : #printing }
HtmlAttributeValueNotValidError >> printOn: aStream [
	| attrList attr |
	"super printOn: aStream."
	self attribute printOn: aStream.
	aStream nextPutAll: ' in '.
	self parent prefix printOn: aStream.
	aStream nextPutAll: ' must be one of: '.
	attrList := self parent dtd attrListForTag: self parent dtdTag.
	attr := attrList attributeNamed: self attribute.
	attr type asString printOn: aStream]

{ #category : #accessing }
HtmlAttributeValueNotValidError >> validTypeExpression [
	| p attList attr |
	p := self parent.
	attList := p dtd attrListForTag: p dtdTag.
	attr := attList attributeNamed: self attribute.
	^attr type expression asString]

