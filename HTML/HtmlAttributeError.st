"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlAttributeError,
	#superclass : #HtmlError,
	#instVars : [
		'attribute'
	],
	#category : #HTML
}

{ #category : #accessing }
HtmlAttributeError >> attribute [
	^attribute]

{ #category : #accessing }
HtmlAttributeError >> attribute: anObject [
	attribute := anObject]

{ #category : #testing }
HtmlAttributeError >> isAttributeError [
	^true]

{ #category : #accessing }
HtmlAttributeError >> position [
	^self parent start + (self parent prefix findString: self attribute)]

{ #category : #printing }
HtmlAttributeError >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' Attribute: '.
	self attribute printOn: aStream.
	aStream space.
	self parent prefix printOn: aStream.
	aStream nextPut: $.]

