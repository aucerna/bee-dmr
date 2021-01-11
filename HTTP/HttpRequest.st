"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpRequest,
	#superclass : #HttpMessage,
	#instVars : [
		'verb',
		'url',
		'info'
	],
	#category : #HTTP
}

{ #category : #initialization }
HttpRequest class >> availableEvents [
	^super availableEvents add: #percentSent:; yourself]

{ #category : #'instance creation' }
HttpRequest class >> from: anHTTP_REQUEST [
	^self new from: anHTTP_REQUEST]

{ #category : #headers }
HttpRequest >> accept: aMediaType [
	headers accept: aMediaType]

{ #category : #headers }
HttpRequest >> acceptCharset: aString [
	headers acceptCharset: aString]

{ #category : #inquiries }
HttpRequest >> acceptedType [
	^self accept ifNotNil: [:h | MediaType fromString: h]]

{ #category : #headers }
HttpRequest >> acceptFormat: aSymbol [
	| type |
	type := self typeFromFormat: aSymbol.
	type notNil ifTrue: [self accept: type] ifFalse: [self acceptUTF8]]

{ #category : #headers }
HttpRequest >> acceptUTF8 [
	self acceptCharset: 'utf-8']

{ #category : #headers }
HttpRequest >> accessControlRequestHeaders [
	^headers accessControlRequestHeaders]

{ #category : #headers }
HttpRequest >> accessControlRequestMethod [
	^headers accessControlRequestMethod]

{ #category : #headers }
HttpRequest >> authorization: aString [
	headers authorization: aString]

{ #category : #inquiries }
HttpRequest >> baseUri [
	^url baseUri]

{ #category : #accessing }
HttpRequest >> baseUrl [
	^url baseUrl]

{ #category : #accessing }
HttpRequest >> beDelete [
	verb := 'DELETE']

{ #category : #accessing }
HttpRequest >> beGet [
	verb := 'GET']

{ #category : #accessing }
HttpRequest >> beHead [
	verb := 'HEAD']

{ #category : #accessing }
HttpRequest >> beOptions [
	verb := 'OPTIONS']

{ #category : #accessing }
HttpRequest >> bePatch [
	verb := 'PATCH']

{ #category : #accessing }
HttpRequest >> bePost [
	verb := 'POST']

{ #category : #accessing }
HttpRequest >> bePut [
	verb := 'PUT']

{ #category : #accessing }
HttpRequest >> clientIP [
	^info valueAt: 'clientIP']

{ #category : #accessing }
HttpRequest >> clientIP: aString [
	info at: 'clientIP' put: aString]

{ #category : #headers }
HttpRequest >> cookie: anHttpCookie [
	headers cookie: anHttpCookie asString]

{ #category : #headers }
HttpRequest >> cookies [
	^self propertyAt: #cookies ifAbsentPut: [| cookies |
		cookies := Dictionary new.
		headers cookie ifNotNil: [:c | | raw |
			raw := $; split: c.
			raw
				collect: [:s | HttpCookie fromString: s]
				thenDo: [:cookie | cookies at: cookie name put: cookie]].
		cookies]]

{ #category : #private }
HttpRequest >> from: anHTTP_REQUEST [
	id := anHTTP_REQUEST id.
	verb := anHTTP_REQUEST verbName.
	self headers: anHTTP_REQUEST headers.
	url := anHTTP_REQUEST CookedUrl asURL.
	anHTTP_REQUEST Address isValid ifFalse: [^self].
	self
		port: anHTTP_REQUEST Address localAddress port;
		serverIP: anHTTP_REQUEST serverIP;
		clientIP: anHTTP_REQUEST clientIP]

{ #category : #testing }
HttpRequest >> hasPendingData [
	^body isNil and: [self contentLength asInteger > 0]]

{ #category : #testing }
HttpRequest >> hasQuery [
	^url hasQuery]

{ #category : #testing }
HttpRequest >> hasWebSocketKey [
	^headers webSocketKey notNil]

{ #category : #accessing }
HttpRequest >> host [
	^url host]

{ #category : #accessing }
HttpRequest >> host: aString [
	url host: aString]

{ #category : #initialization }
HttpRequest >> initialize [
	super initialize.
	url := URL new.
	info := Dictionary new]

{ #category : #testing }
HttpRequest >> isDelete [
	^verb = 'DELETE']

{ #category : #testing }
HttpRequest >> isGet [
	^verb = 'GET']

{ #category : #testing }
HttpRequest >> isHead [
	^verb = 'HEAD']

{ #category : #testing }
HttpRequest >> isOptions [
	^verb = 'OPTIONS']

{ #category : #testing }
HttpRequest >> isPatch [
	^verb = 'PATCH']

{ #category : #testing }
HttpRequest >> isPost [
	^verb = 'POST']

{ #category : #testing }
HttpRequest >> isPreflight [
	^self isOptions and: [self origin notNil]]

{ #category : #testing }
HttpRequest >> isPut [
	^verb = 'PUT']

{ #category : #testing }
HttpRequest >> isValidWebSocketRequest [
	^self isGet
		and: [self isWebSocketRequest]
		and: [self upgradesConnection]
		and: [self webSocketVersion = HttpHeaders webSocketVersion asString]
		and: [self hasWebSocketKey]]

{ #category : #testing }
HttpRequest >> isWebSocketRequest [
	^headers upgradesToWebSocket]

{ #category : #headers }
HttpRequest >> keepAlive [
	self headers keepAlive]

{ #category : #accessing }
HttpRequest >> method [
	^verb]

{ #category : #headers }
HttpRequest >> origin [
	^headers origin]

{ #category : #private }
HttpRequest >> percentSent: anInteger [
	^self triggerEvent: #percentSent: with: anInteger defaultHandler: true]

{ #category : #accessing }
HttpRequest >> port [
	^info valueAt: 'port']

{ #category : #accessing }
HttpRequest >> port: anInteger [
	info at: 'port' put: anInteger]

{ #category : #printing }
HttpRequest >> printTextOn: rtf [
	rtf
		useColor: Color darkGreen while: [rtf bold: verb asString];
		space;
		useColor: Color darkBlue while: [rtf nextPutAll: url asString];
		space;
		useColor: Color darkGray while: [rtf nextPutAll: self version asString];
		cr.
	headers printTextOn: rtf]

{ #category : #accessing }
HttpRequest >> queryAt: name [
	^url queryAt: name]

{ #category : #accessing }
HttpRequest >> queryAt: name put: value [
	url queryAt: name put: value]

{ #category : #accessing }
HttpRequest >> queryString [
	^url queryString]

{ #category : #reading }
HttpRequest >> readFrom: aStream [
	| line |
	line := aStream nextLine readStream.
	verb := line upTo: Character space.
	url := (line upTo: Character space) asURL.
	super readFrom: aStream]

{ #category : #headers }
HttpRequest >> referer [
	^headers referer]

{ #category : #inquiries }
HttpRequest >> relativeUri [
	^url relativeUri]

{ #category : #inquiries }
HttpRequest >> response [
	^HttpResponse forRequest: self]

{ #category : #accessing }
HttpRequest >> serverIP [
	^info valueAt: 'serverIP']

{ #category : #accessing }
HttpRequest >> serverIP: aString [
	info at: 'serverIP' put: aString]

{ #category : #accessing }
HttpRequest >> serviceName [
	^info valueAt: 'serviceName']

{ #category : #accessing }
HttpRequest >> serviceName: aString [
	info at: 'serviceName' put: aString]

{ #category : #testing }
HttpRequest >> upgradesConnection [
	^headers upgradesConnection]

{ #category : #accessing }
HttpRequest >> uri [
	^url path]

{ #category : #accessing }
HttpRequest >> uri: aString [
	url path: aString]

{ #category : #accessing }
HttpRequest >> url [
	^url]

{ #category : #accessing }
HttpRequest >> url: anURL [
	url := anURL]

{ #category : #headers }
HttpRequest >> userAgent [
	^headers userAgent]

{ #category : #headers }
HttpRequest >> userAgent: aString [
	headers userAgent: aString]

{ #category : #accessing }
HttpRequest >> username [
	^info valueAt: 'username']

{ #category : #accessing }
HttpRequest >> username: aString [
	info at: 'username' put: aString]

{ #category : #accessing }
HttpRequest >> verb [
	^verb]

{ #category : #accessing }
HttpRequest >> verb: aString [
	verb := aString]

{ #category : #websockets }
HttpRequest >> webSocketKey [
	^headers webSocketKey]

{ #category : #websockets }
HttpRequest >> webSocketVersion [
	^headers webSocketVersion]

{ #category : #writing }
HttpRequest >> writeOn: aStream [
	aStream
		nextPutAll: verb;
		space;
		nextPutAll: self uri asString;
		space;
		nextPutAll: self version;
		crlf.
	super writeOn: aStream]

