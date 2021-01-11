"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTPConnection,
	#superclass : #InternetConnection,
	#category : #'HTTP\Client'
}

{ #category : #'instance creation' }
HTTPConnection class >> to: host port: port secure: aBoolean [
	| class |
	class := aBoolean ifTrue: [HTTPSConnection] ifFalse: [HTTPConnection].
	^class new server: host; port: port]

{ #category : #configuration }
HTTPConnection >> addFlagDontCache [
	self addFlag: INTERNET_FLAG_NO_CACHE_WRITE]

{ #category : #configuration }
HTTPConnection >> addFlagExistingConnect [
	self addFlag: INTERNET_FLAG_EXISTING_CONNECT]

{ #category : #configuration }
HTTPConnection >> addFlagInternetReload [
	self addFlag: INTERNET_FLAG_RELOAD]

{ #category : #configuration }
HTTPConnection >> addFlagKeepConnection [
	self addFlag: INTERNET_FLAG_KEEP_CONNECTION]

{ #category : #configuration }
HTTPConnection >> addFlagNoAuthorization [
	self addFlag: INTERNET_FLAG_NO_AUTH]

{ #category : #configuration }
HTTPConnection >> addFlagRawData [
	self addFlag: INTERNET_FLAG_RAW_DATA]

{ #category : #configuration }
HTTPConnection >> addFlagReload [
	self addFlag: INTERNET_FLAG_RELOAD]

{ #category : #configuration }
HTTPConnection >> addFlagSecure [
	self addFlag: INTERNET_FLAG_SECURE]

{ #category : #accessing }
HTTPConnection >> address [
	^self server]

{ #category : #accessing }
HTTPConnection >> address: url [
	self server: url]

{ #category : #actions }
HTTPConnection >> connect [
	| s |
	self isValid ifTrue: [^self].
	s := session ifNil: [InternetSession asynchronous].
	s connect: self to: server port: port.
	self isValid ifFalse: [self open]]

{ #category : #services }
HTTPConnection >> defaultTimeout [
	^50]

{ #category : #actions }
HTTPConnection >> disconnect [
	self release.
	session := nil]

{ #category : #accessing }
HTTPConnection >> errorClass [
	^WinInetError]

{ #category : #configuration }
HTTPConnection >> hasFlagKeepConnection [
	^flags & INTERNET_FLAG_KEEP_CONNECTION = INTERNET_FLAG_KEEP_CONNECTION]

{ #category : #initialization }
HTTPConnection >> initializeFlags [
	flags := INTERNET_FLAG_NO_CACHE_WRITE | INTERNET_FLAG_KEEP_CONNECTION]

{ #category : #initialization }
HTTPConnection >> initializePort [
	port := INTERNET_DEFAULT_HTTP_PORT]

{ #category : #testing }
HTTPConnection >> isConnected [
	^self isValid]

{ #category : #private }
HTTPConnection >> newRequest [
	| request index struct |
	request := self requestClass new.
	index := requests findFirst: #isNil ifAbsent: [requests add: nil; size].
	requests at: index put: request.
	struct := HTTP_REQUEST_TOKEN new
		connectionId: token connectionId;
		requestId: index.
	request
		session: session;
		connection: self;
		token: struct;
		addFlag: INTERNET_FLAG_NO_CACHE_WRITE.
	self hasFlagKeepConnection ifTrue: [request addFlagKeepConnection].
	self redirectsAutomatically ifFalse: [request addFlagNoAutoRedirect].
	^request]

{ #category : #private }
HTTPConnection >> optionalBodyLimit [
	^16 kbytes]

{ #category : #configuration }
HTTPConnection >> redirectAutomatically: aBoolean [
	self propertyAt: #redirectsAutomatically put: aBoolean]

{ #category : #testing }
HTTPConnection >> redirectsAutomatically [
	^self propertyAt: #redirectsAutomatically ifAbsent: true]

{ #category : #services }
HTTPConnection >> request: verb objectName: uri [
	^self newRequest
		openRequest: verb
		objectName: uri
		version: 'HTTP/1.1'
		referrer: nil
		acceptTypes: nil]

{ #category : #accessing }
HTTPConnection >> requestClass [
	^HTTPRequest]

{ #category : #services }
HTTPConnection >> sendRequest: anHttpRequest timeout: seconds [
	| request |
	request := self
		request: anHttpRequest verb
		objectName: anHttpRequest url pathAndQuery.
	^[| body headers |
		request receiveTimeout: seconds; sendTimeout: seconds.
		body := anHttpRequest body.
		headers := anHttpRequest headerString.
		(body isExternalMemory not
			and: [anHttpRequest contentLength <= self optionalBodyLimit])
			ifTrue: [request send: body headers: headers]
			ifFalse: [
				request
					when: #percentSent: send: #percentSent: to: anHttpRequest;
					sendChunked: body headers: headers].
		request statusCode asInteger = HTTP_STATUS_DENIED
			ifTrue: [request send: body headers: headers].
		request response]
		ensure: [request release]]

