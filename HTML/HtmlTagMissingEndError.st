"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlTagMissingEndError,
	#superclass : #HtmlTagStructureError,
	#category : #HTML
}

{ #category : #testing }
HtmlTagMissingEndError >> isStructuralError [
	^true]

{ #category : #printing }
HtmlTagMissingEndError >> printOn: aStream [
	aStream nextPutAll: 'No closing tag found for tag: '.
	self parent tag printOn: aStream]

{ #category : #testing }
HtmlTagMissingEndError >> uniqueId [
	^self parent uniqueId , '-end-missing']

