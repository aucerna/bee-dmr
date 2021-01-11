"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpRequestCancelled,
	#superclass : #HttpRequestError,
	#category : #'HTTP\Client'
}

{ #category : #actions }
HttpRequestCancelled >> defaultAction [
	"
	do nothing
	"
	]

{ #category : #accessing }
HttpRequestCancelled >> defaultDescription [
	^'The request was cancelled.']

