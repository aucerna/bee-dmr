"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpConfiguration,
	#superclass : #Object,
	#instVars : [
		'url',
		'timeout',
		'wsPort'
	],
	#category : #HTTP
}

{ #category : #'instance creation' }
HttpConfiguration class >> fromFile: aFilename [
	| json |
	json := JsonParser parse: aFilename asFilename asFile contents.
	^self fromJson: json]

{ #category : #'instance creation' }
HttpConfiguration class >> new [
	^super new initialize]

{ #category : #'instance creation' }
HttpConfiguration class >> port: anInteger uri: aString [
	^self new port: anInteger uri: aString]

{ #category : #'instance creation' }
HttpConfiguration class >> url: anURL [
	^self new url: anURL]

{ #category : #comparing }
HttpConfiguration >> = aHttpConfiguration [
	self class == aHttpConfiguration class ifFalse: [^false].
	self port = aHttpConfiguration port ifFalse: [^false].
	self isSecure = aHttpConfiguration isSecure ifFalse: [^false].
	self baseUri = aHttpConfiguration baseUri ifFalse: [^false].
	^true]

{ #category : #accessing }
HttpConfiguration >> address [
	^self hostname]

{ #category : #accessing }
HttpConfiguration >> address: aString [
	self hostname: aString]

{ #category : #accessing }
HttpConfiguration >> baseUri [
	^url path]

{ #category : #accessing }
HttpConfiguration >> baseUri: aString [
	url path: aString]

{ #category : #actions }
HttpConfiguration >> beSecure [
	self secure: true]

{ #category : #accessing }
HttpConfiguration >> credentials [
	^url credentials]

{ #category : #private }
HttpConfiguration >> defaultPort [
	^url defaultPort]

{ #category : #private }
HttpConfiguration >> defaultTimeout [
	^15]

{ #category : #private }
HttpConfiguration >> defaultUri [
	^'/']

{ #category : #testing }
HttpConfiguration >> hasBaseUri [
	^url hasPath andNot: [url isSlash]]

{ #category : #testing }
HttpConfiguration >> hasCredentials [
	^self username notNil and: [self password notNil]]

{ #category : #comparing }
HttpConfiguration >> hash [
	^self baseUri hashWith: self port with: self isSecure]

{ #category : #accessing }
HttpConfiguration >> hostname [
	^url host]

{ #category : #accessing }
HttpConfiguration >> hostname: aString [
	url host: aString]

{ #category : #initialization }
HttpConfiguration >> initialize [
	super initialize.
	url := URL new protocol: 'http'; host: 'localhost'.
	timeout := self defaultTimeout.
	wsPort := 0]

{ #category : #comparing }
HttpConfiguration >> isLike: aWebServiceConfiguration [
	^self hostname = aWebServiceConfiguration hostname
		and: [self port = aWebServiceConfiguration port]
		and: [self isSecure = aWebServiceConfiguration isSecure]]

{ #category : #testing }
HttpConfiguration >> isPersistent [
	^false]

{ #category : #testing }
HttpConfiguration >> isSecure [
	^url isSecure]

{ #category : #services }
HttpConfiguration >> newAuthenticator [
	^HttpBasicAuthenticator new]

{ #category : #accessing }
HttpConfiguration >> password [
	^url password]

{ #category : #accessing }
HttpConfiguration >> password: aString [
	url password: aString]

{ #category : #accessing }
HttpConfiguration >> port [
	^url port ifNil: [self defaultPort]]

{ #category : #accessing }
HttpConfiguration >> port: anInteger [
	url port: anInteger]

{ #category : #initialization }
HttpConfiguration >> port: anInteger uri: aString [
	url port: anInteger; path: aString]

{ #category : #copying }
HttpConfiguration >> postCopy [
	url := url copy]

{ #category : #printing }
HttpConfiguration >> printOn: aStream [
	super printOn: aStream.
	aStream space; nextPutAll: url asString]

{ #category : #printing }
HttpConfiguration >> printTextOn: rtf [
	rtf
		useBoldWhile: [rtf nextPutAll: self class name asPhrase];
		cr;
		cr;
		useBoldWhile: [rtf nextPutAll: 'URL: '].
	url printTextOn: rtf.
	rtf
		cr;
		useBoldWhile: [rtf nextPutAll: 'Timeout: '];
		nextPutAll: timeout asString;
		cr;
		useBoldWhile: [rtf nextPutAll: 'WS port: '];
		nextPutAll: wsPort asString]

{ #category : #inquiries }
HttpConfiguration >> protocol [
	^url protocol]

{ #category : #testing }
HttpConfiguration >> requiresAuthorization [
	^self username notNil and: [self password notNil]]

{ #category : #inquiries }
HttpConfiguration >> rootUri [
	^url path]

{ #category : #accessing }
HttpConfiguration >> secure: aBoolean [
	aBoolean ifTrue: [url beHttps] ifFalse: [url beHttp]]

{ #category : #accessing }
HttpConfiguration >> timeout [
	^timeout ifNil: [self defaultTimeout]]

{ #category : #accessing }
HttpConfiguration >> timeout: seconds [
	timeout := seconds]

{ #category : #accessing }
HttpConfiguration >> url [
	^url]

{ #category : #accessing }
HttpConfiguration >> url: aURL [
	url := aURL asURL]

{ #category : #accessing }
HttpConfiguration >> username [
	^url user]

{ #category : #accessing }
HttpConfiguration >> username: aString [
	url user: aString]

{ #category : #testing }
HttpConfiguration >> usesSingleSignOn [
	^false]

{ #category : #accessing }
HttpConfiguration >> wsPort [
	^wsPort]

{ #category : #accessing }
HttpConfiguration >> wsPort: anInteger [
	wsPort := anInteger]

{ #category : #inquiries }
HttpConfiguration >> wsURL [
	| ws |
	ws := url copy asWebSocketURL.
	wsPort != 0 ifTrue: [ws port: wsPort].
	^ws]

