"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlTagError,
	#superclass : #HtmlError,
	#category : #HTML
}

{ #category : #testing }
HtmlTagError >> isTagError [

	^true]

{ #category : #printing }
HtmlTagError >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' Tag: ' , self tag]

