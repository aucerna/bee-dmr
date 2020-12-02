"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlUnclosedCommentError,
	#superclass : #HtmlSyntaxError,
	#category : #HTML
}

{ #category : #testing }
HtmlUnclosedCommentError >> isStructuralError [
	^true]

{ #category : #printing }
HtmlUnclosedCommentError >> printOn: aStream [
	aStream nextPutAll: 'Comment section not properly terminated.']

