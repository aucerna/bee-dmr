"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpRequestFailed,
	#superclass : #HttpRequestError,
	#category : #'HTTP\Client'
}

{ #category : #accessing }
HttpRequestFailed >> defaultDescription [
	^'The request could not be processed. Check your Internet connection.']

