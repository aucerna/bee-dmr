"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlTagUnknownError,
	#superclass : #HtmlTagError,
	#category : #HTML
}

{ #category : #printing }
HtmlTagUnknownError >> printOn: aStream [
	self parent tag printOn: aStream.
	aStream
		nextPutAll: ' is not valid within this doctype.  It can probably be replaced with a span and CSS style.']

