"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpConnectionError,
	#superclass : #HttpClientError,
	#instVars : [
		'server',
		'port'
	],
	#category : #'HTTP\Client'
}

{ #category : #accessing }
HttpConnectionError >> defaultDescription [
	^'Could not connect to the server ' , server asString , ' on port '
		, port asString]

{ #category : #accessing }
HttpConnectionError >> port [
	^port]

{ #category : #accessing }
HttpConnectionError >> port: aNumber [
	port := aNumber]

{ #category : #accessing }
HttpConnectionError >> server [
	^server]

{ #category : #accessing }
HttpConnectionError >> server: aString [
	server := aString]

