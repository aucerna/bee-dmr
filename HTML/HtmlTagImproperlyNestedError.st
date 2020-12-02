"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlTagImproperlyNestedError,
	#superclass : #HtmlTagStructureError,
	#instVars : [
		'wrongTag'
	],
	#category : #HTML
}

{ #category : #printing }
HtmlTagImproperlyNestedError >> printOn: aStream [
	| rule |
	self parent tag printOn: aStream.
	aStream nextPutAll: ' found within tag: '.
	self parent parent tag printOn: aStream.
	rule := self parent dtd elementForTag: self parent parent dtdTag.
	rule notNil ifTrue: [
		aStream nextPutAll: '. Tag Rule: '.
		rule contentRule printOn: aStream]]

{ #category : #accessing }
HtmlTagImproperlyNestedError >> wrongTag [
	^wrongTag]

{ #category : #accessing }
HtmlTagImproperlyNestedError >> wrongTag: anObject [
	wrongTag := anObject]

