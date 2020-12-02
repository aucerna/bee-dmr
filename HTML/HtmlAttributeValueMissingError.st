"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlAttributeValueMissingError,
	#superclass : #HtmlAttributeError,
	#category : #HTML
}

{ #category : #printing }
HtmlAttributeValueMissingError >> printOn: aStream [
	aStream nextPutAll: 'Value missing for: '.
	self attribute printOn: aStream.
	aStream nextPutAll: ' in '.
	self parent prefix printOn: aStream.
	aStream nextPutAll: '.']

