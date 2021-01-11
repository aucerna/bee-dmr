"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpConnection,
	#superclass : #Object,
	#instVars : [
		'port',
		'socket',
		'secure',
		'upgraded'
	],
	#category : #HTTP
}

{ #category : #'instance creation' }
HttpConnection class >> new [
	^super new initialize]

{ #category : #'instance creation' }
HttpConnection class >> on: aSocket [
	^self new on: aSocket]

{ #category : #'instance creation' }
HttpConnection class >> to: host port: port secure: aBoolean [
	| socket |
	socket := Socket new host: host; port: port.
	^self on: socket]

{ #category : #accessing }
HttpConnection >> beUpgraded [
	upgraded := true]

{ #category : #actions }
HttpConnection >> connect [
	| delay |
	socket
		open;
		nonBlocking;
		respondToExternalEvents: #(#readyToRead #readyToWrite #shuttingDown #connectionCompleted);
		connect.
	delay := Delay forMilliseconds: 1000.
	socket when: #connectionCompleted do: [delay resume].
	delay wait]

{ #category : #actions }
HttpConnection >> disconnect [
	socket notNil ifTrue: [socket close]]

{ #category : #accessing }
HttpConnection >> errorClass [
	^SocketError]

{ #category : #initialization }
HttpConnection >> initialize [
	super initialize.
	upgraded := false]

{ #category : #testing }
HttpConnection >> isConnected [
	^socket notNil and: [socket isOpen]]

{ #category : #testing }
HttpConnection >> isUpgraded [
	^upgraded]

{ #category : #private }
HttpConnection >> on: aSocket [
	socket := aSocket]

{ #category : #accessing }
HttpConnection >> port [
	^port]

{ #category : #accessing }
HttpConnection >> port: anInteger [
	port := anInteger]

{ #category : #printing }
HttpConnection >> printOn: aStream [
	aStream nextPutAll: self class name; nextPutAll: ' on '.
	socket printOn: aStream]

{ #category : #actions }
HttpConnection >> receiveRequest [
	| reader request |
	reader := socket readStream.
	reader lineDelimiter: String crlf; waitForData.
	request := HttpRequest fromStream: reader.
	request url beHttp; host: socket host; port: port.
	^request]

{ #category : #actions }
HttpConnection >> receiveResponse [
	socket readStream lineDelimiter: String crlf.
	^HttpResponse fromStream: socket readStream]

{ #category : #accessing }
HttpConnection >> redirectAutomatically: aBoolean [
	self propertyAt: #redirectsAutomatically put: aBoolean]

{ #category : #testing }
HttpConnection >> redirectsAutomatically [
	^self propertyAt: #redirectsAutomatically ifAbsent: true]

{ #category : #actions }
HttpConnection >> sendRequest: anHttpRequest [
	| writer |
	writer := socket writeStream.
	anHttpRequest writeOn: writer.
	writer flush]

{ #category : #actions }
HttpConnection >> sendRequest: anHttpRequest timeout: seconds [
	self sendRequest: anHttpRequest.
	socket readStream timeout: seconds.
	^self receiveResponse]

{ #category : #actions }
HttpConnection >> sendResponse: anHttpResponse [
	| writer |
	writer := socket writeStream.
	anHttpResponse writeOn: writer.
	writer flush]

{ #category : #actions }
HttpConnection >> shutdown [
	socket shutdown]

{ #category : #accessing }
HttpConnection >> socket [
	^socket]

