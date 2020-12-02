"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlTagNotLowerCaseError,
	#superclass : #HtmlError,
	#instVars : [
		'tag'
	],
	#category : #HTML
}

{ #category : #'instance creation' }
HtmlTagNotLowerCaseError class >> tag: aString [
	^self new tag: aString]

{ #category : #testing }
HtmlTagNotLowerCaseError >> isCaseError [
	^true]

{ #category : #printing }
HtmlTagNotLowerCaseError >> printOn: aStream [
	self parent rawTag printOn: aStream.
	aStream nextPutAll: ' should probably be '.
	self parent tag printOn: aStream]

{ #category : #accessing }
HtmlTagNotLowerCaseError >> tag [
	^tag]

{ #category : #accessing }
HtmlTagNotLowerCaseError >> tag: aString [
	tag := aString]

