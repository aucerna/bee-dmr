"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlUnclosedXmlCDataSectionError,
	#superclass : #HtmlSyntaxError,
	#category : #HTML
}

{ #category : #testing }
HtmlUnclosedXmlCDataSectionError >> isStructuralError [
	^true]

{ #category : #printing }
HtmlUnclosedXmlCDataSectionError >> printOn: aStream [
	aStream nextPutAll: 'CDATA section not properly terminated.']

