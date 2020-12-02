"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlTagMustBeEmptyError,
	#superclass : #HtmlTagStructureError,
	#category : #HTML
}

{ #category : #printing }
HtmlTagMustBeEmptyError >> printOn: aStream [
	self parent tag printOn: aStream.
	aStream nextPutAll: ' must be empty.']

