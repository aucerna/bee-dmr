"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #DirectHttpClient,
	#superclass : #HttpClient,
	#instVars : [
		'server'
	],
	#category : #'HTTP\Client'
}

{ #category : #'instance creation' }
DirectHttpClient class >> on: anHttpServer [
	^self new server: anHttpServer]

{ #category : #private }
DirectHttpClient >> sendRequest: anHttpRequest [
	| response location request |
	response := super sendRequest: anHttpRequest.
	(response isRedirect and: [self redirectsAutomatically]) ifTrue: [
		location := response location trimPrefix: configuration baseUri.
		location isEmpty ifTrue: [location := '/'].
		request := self newRequestTo: location.
		self
			ASSERT: request url host = configuration hostname;
			ASSERT: request url port = configuration port.
		request beGet; headers: anHttpRequest headers.
		^self sendRequest: request].
	^response]

{ #category : #private }
DirectHttpClient >> sendRequest: anHttpRequest timeout: timeout [
	anHttpRequest data isFile
		ifTrue: [anHttpRequest binaryData: anHttpRequest data binaryContents].
	^server responseFor: anHttpRequest]

{ #category : #accessing }
DirectHttpClient >> server: anHttpServer [
	server := anHttpServer]

{ #category : #testing }
DirectHttpClient >> shouldConnect [
	^false]

{ #category : #testing }
DirectHttpClient >> shouldDisconnect [
	^false]

