"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpRequestError,
	#superclass : #HttpClientError,
	#instVars : [
		'request'
	],
	#category : #'HTTP\Client'
}

{ #category : #private }
HttpRequestError class >> signal: aString for: anHttpRequest [
	^self new request: anHttpRequest; description: aString; signal]

{ #category : #accessing }
HttpRequestError >> request [
	^request]

{ #category : #accessing }
HttpRequestError >> request: anHttpRequest [
	request := anHttpRequest]

