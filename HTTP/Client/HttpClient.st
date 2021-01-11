"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpClient,
	#superclass : #Object,
	#instVars : [
		'configuration',
		'authenticator',
		'format',
		'agent',
		'connection'
	],
	#category : #'HTTP\Client'
}

{ #category : #initialization }
HttpClient class >> availableEvents [
	^super availableEvents add: #percentSent:; yourself]

{ #category : #'instance creation' }
HttpClient class >> for: url [
	^self to: url]

{ #category : #'instance creation' }
HttpClient class >> fromConfiguration: anHttpConfiguration [
	^self basicNew configuration: anHttpConfiguration]

{ #category : #'instance creation' }
HttpClient class >> new [
	^super new initialize]

{ #category : #'instance creation' }
HttpClient class >> to: anURL [
	| configuration |
	configuration := HttpClientConfiguration url: anURL.
	^self fromConfiguration: configuration]

{ #category : #accessing }
HttpClient >> agent [
	^agent]

{ #category : #accessing }
HttpClient >> agent: aString [
	agent := aString]

{ #category : #accessing }
HttpClient >> authenticator [
	^authenticator]

{ #category : #accessing }
HttpClient >> authenticator: anHttpRequestAuthenticator [
	authenticator := anHttpRequestAuthenticator]

{ #category : #configuration }
HttpClient >> baseUri: aString [
	configuration baseUri: aString]

{ #category : #configuration }
HttpClient >> bePersistent [
	configuration bePersistent]

{ #category : #accessing }
HttpClient >> configuration [
	^configuration]

{ #category : #accessing }
HttpClient >> configuration: anHttpClientConfiguration [
	configuration := anHttpClientConfiguration.
	self updateAuthenticator]

{ #category : #private }
HttpClient >> connect [
	connection := self connectionClass
		to: configuration hostname
		port: configuration port
		secure: configuration isSecure.
	connection redirectAutomatically: self redirectsAutomatically.
	[connection connect]
		on: connection errorClass
		do: [:e | self handleConnectionError: e]]

{ #category : #private }
HttpClient >> connection [
	^connection]

{ #category : #private }
HttpClient >> connectionClass [
	^self propertyAt: #connectionClass ifAbsent: [HTTPConnection]]

{ #category : #private }
HttpClient >> connectionClass: aClass [
	self propertyAt: #connectionClass put: aClass]

{ #category : #headers }
HttpClient >> cookie [
	^self propertyAt: #cookie ifAbsent: nil]

{ #category : #configuration }
HttpClient >> credentials [
	^configuration credentials]

{ #category : #private }
HttpClient >> defaultPort [
	^configuration defaultPort]

{ #category : #requests }
HttpClient >> DELETE: uri [
	| request |
	request := self newRequestTo: uri.
	request beDelete; acceptFormat: format.
	^self sendRequest: request]

{ #category : #services }
HttpClient >> delete: uri [
	| response |
	response := self DELETE: uri.
	^response data]

{ #category : #private }
HttpClient >> disconnect [
	connection disconnect]

{ #category : #services }
HttpClient >> download: url [
	| credentials memory answer |
	memory := self requiresAuthorization
		ifTrue: [configuration password base64EncodingAFor: configuration username].
	credentials := memory bytes.
	memory clear: memory length; free.
	answer := InternetSession asynchronous
		openUrl: url
		credentials: credentials
		format: format.
	credentials atAllPut: 0.
	^answer]

{ #category : #private }
HttpClient >> errorClass [
	^WinInetError]

{ #category : #requests }
HttpClient >> GET: uri [
	^self GET: uri headers: nil]

{ #category : #services }
HttpClient >> get: uri [
	^self get: uri headers: nil]

{ #category : #services }
HttpClient >> get: uri format: aSymbol [
	^self get: uri format: aSymbol headers: nil]

{ #category : #requests }
HttpClient >> GET: uri format: aSymbol [
	^self GET: uri format: aSymbol headers: #()]

{ #category : #requests }
HttpClient >> GET: uri format: aSymbol headers: aDictionary [
	| request accept |
	accept := aSymbol ifNil: [format].
	request := self newRequestTo: uri.
	request beGet; acceptFormat: accept; addHeaders: aDictionary.
	^self sendRequest: request]

{ #category : #services }
HttpClient >> get: uri format: aSymbol headers: aDictionary [
	| response |
	response := self GET: uri format: aSymbol headers: aDictionary.
	^response isNotFound ifFalse: [response data]]

{ #category : #requests }
HttpClient >> GET: uri headers: aDictionary [
	^self GET: uri format: nil headers: aDictionary]

{ #category : #services }
HttpClient >> get: uri headers: aDictionary [
	^self get: uri format: nil headers: aDictionary]

{ #category : #errors }
HttpClient >> handleConnectionError: error [
	^HttpConnectionError new
		server: configuration hostname;
		port: configuration port;
		description: error description;
		signal]

{ #category : #errors }
HttpClient >> handleError: error fromRequest: anHttpRequest [
	(error isKindOf: HttpRequestCancelled)
		ifTrue: [error request: anHttpRequest; pass].
	((error isKindOf: WinInetError) and: [error isTimeout])
		ifTrue: [HttpRequestTimeout signal: error description for: anHttpRequest].
	HttpRequestFailed signal: error description for: anHttpRequest]

{ #category : #errors }
HttpClient >> handleResponseError: anHttpResponse [
	^HttpResponseError signalForResponse: anHttpResponse]

{ #category : #testing }
HttpClient >> hasCookie [
	^self cookie notNil]

{ #category : #requests }
HttpClient >> HEAD: uri [
	^self HEAD: uri headers: nil]

{ #category : #services }
HttpClient >> head: uri [
	^self head: uri headers: nil]

{ #category : #requests }
HttpClient >> HEAD: uri headers: aDictionary [
	| request |
	request := self newRequestTo: uri.
	request beHead; addHeaders: aDictionary.
	^self sendRequest: request]

{ #category : #services }
HttpClient >> head: uri headers: aDictionary [
	| response |
	response := self HEAD: uri headers: aDictionary.
	^response isOk]

{ #category : #configuration }
HttpClient >> hostname [
	^configuration hostname]

{ #category : #configuration }
HttpClient >> hostname: aString [
	configuration hostname: aString]

{ #category : #initialization }
HttpClient >> initialize [
	super initialize.
	configuration := HttpClientConfiguration new.
	format := #text.
	agent := 'Bee Smalltalk']

{ #category : #testing }
HttpClient >> isSecure [
	^configuration isSecure]

{ #category : #private }
HttpClient >> log: anHttpMessage [
	| ts stream |
	configuration usesLog ifFalse: [^self].
	ts := Timestamp now.
	stream := configuration logFilename asFilename asFile appendStream
		lineDelimiter: String crlf.
	[| json |
		stream position = 0
			ifTrue: [stream nextPut: $[]
			ifFalse: [stream skip: -3; nextPut: $,].
		stream crtab.
		json := anHttpMessage asJson.
		json at: 'Timestamp' put: ts.
		json printOn: stream indent: 2.
		stream cr; nextPut: $]]
		ensure: [stream close]]

{ #category : #configuration }
HttpClient >> logFilename: aFilename [
	configuration logFilename: aFilename]

{ #category : #private }
HttpClient >> newRequest [
	| request |
	request := HttpRequest new.
	self requiresAuthorization
		ifTrue: [authenticator authenticate: request using: configuration].
	agent notNil ifTrue: [request userAgent: agent].
	request headers host: self hostname.
	self usesSingleSignOn ifTrue: [request keepAlive].
	^request]

{ #category : #private }
HttpClient >> newRequestTo: uri [
	| request url encoded |
	request := self newRequest.
	uri isEmpty ifTrue: [url := configuration url] ifFalse: [
		encoded := WininetDLL current encodeUrl: uri.
		url := encoded asURL.
		url isRelative ifTrue: [url := configuration url / url]].
	request url: url.
	^request]

{ #category : #requests }
HttpClient >> OPTIONS: uri headers: aDictionary [
	| request |
	request := self newRequestTo: uri.
	request beOptions; addHeaders: aDictionary.
	^self sendRequest: request]

{ #category : #configuration }
HttpClient >> password: aString [
	configuration password: aString.
	self updateAuthenticator]

{ #category : #private }
HttpClient >> percentSent: anInteger [
	^self triggerEvent: #percentSent: with: anInteger defaultHandler: true]

{ #category : #configuration }
HttpClient >> persistent: aBoolean [
	configuration persistent: aBoolean]

{ #category : #configuration }
HttpClient >> port [
	^configuration port]

{ #category : #configuration }
HttpClient >> port: anInteger [
	configuration port: anInteger]

{ #category : #requests }
HttpClient >> POST: uri [
	^self POST: uri with: '' headers: nil]

{ #category : #services }
HttpClient >> post: uri [
	^self post: uri with: '']

{ #category : #requests }
HttpClient >> POST: uri with: data [
	^self POST: uri with: data headers: nil]

{ #category : #services }
HttpClient >> post: uri with: data [
	^self post: uri with: data headers: nil]

{ #category : #requests }
HttpClient >> POST: uri
with: data
format: aSymbol
headers: aDictionary [
	| request |
	request := self newRequestTo: uri.
	request
		when: #percentSent: send: #percentSent: to: self;
		bePost;
		acceptFormat: format;
		addHeaders: aDictionary;
		data: data format: aSymbol.
	^self sendRequest: request]

{ #category : #services }
HttpClient >> post: uri
with: data
format: aSymbol
headers: aDictionary [
	| response |
	response := self POST: uri with: data format: aSymbol headers: aDictionary.
	^response data]

{ #category : #services }
HttpClient >> post: uri with: data headers: aDictionary [
	^self post: uri with: data format: format headers: aDictionary]

{ #category : #requests }
HttpClient >> POST: uri with: data headers: aDictionary [
	^self POST: uri with: data format: format headers: aDictionary]

{ #category : #services }
HttpClient >> post: uri withBinary: data [
	^self post: uri with: data format: #binary headers: nil]

{ #category : #services }
HttpClient >> post: uri withForm: data [
	^self post: uri with: data format: #form headers: nil]

{ #category : #requests }
HttpClient >> POST: uri withForm: data [
	^self POST: uri with: data format: #form headers: nil]

{ #category : #services }
HttpClient >> post: uri withJson: aJsonObject [
	^self post: uri with: aJsonObject asString format: #json headers: nil]

{ #category : #printing }
HttpClient >> printOn: aStream [
	aStream nextPutAll: self class name , ' to ' , self url asString]

{ #category : #services }
HttpClient >> put: uri with: data [
	^self put: uri with: data format: format headers: nil]

{ #category : #services }
HttpClient >> put: uri
with: data
format: aSymbol
headers: aDictionary [
	| response |
	response := self PUT: uri with: data format: aSymbol headers: aDictionary.
	^response data]

{ #category : #requests }
HttpClient >> PUT: uri
with: data
format: aSymbol
headers: aDictionary [
	| request |
	request := self newRequestTo: uri.
	request
		when: #percentSent: send: #percentSent: to: self;
		bePut;
		acceptFormat: format;
		addHeaders: aDictionary;
		data: data format: aSymbol.
	^self sendRequest: request]

{ #category : #requests }
HttpClient >> PUT: uri withBinary: data [
	^self PUT: uri with: data format: #binary headers: nil]

{ #category : #services }
HttpClient >> put: uri withBinary: data [
	^self put: uri with: data format: #binary headers: nil]

{ #category : #services }
HttpClient >> put: uri withJson: aJsonObject [
	^self put: uri with: aJsonObject asString format: #json headers: nil]

{ #category : #configuration }
HttpClient >> redirectAutomatically: aBoolean [
	self propertyAt: #redirectsAutomatically put: aBoolean]

{ #category : #testing }
HttpClient >> redirectsAutomatically [
	^self propertyAt: #redirectsAutomatically ifAbsent: true]

{ #category : #configuration }
HttpClient >> requiresAuthorization [
	^authenticator notNil]

{ #category : #headers }
HttpClient >> resetCookie [
	self propertyAt: #cookie put: nil]

{ #category : #configuration }
HttpClient >> secure: aBoolean [
	configuration secure: aBoolean]

{ #category : #requests }
HttpClient >> sendFile: aFile to: uri [
	^self PUT: uri with: aFile format: #binary headers: nil]

{ #category : #private }
HttpClient >> sendRequest: anHttpRequest [
	^[| response |
		self shouldConnect ifTrue: [self connect].
		self cookie ifNotNil: [:cookie | anHttpRequest cookie: cookie].
		self log: anHttpRequest.
		response := self sendRequest: anHttpRequest timeout: self timeout.
		response hasError ifTrue: [self handleResponseError: response].
		response setCookie ifNotNil: [:cookie | self setCookie: cookie].
		self log: response.
		response]
		ensure: [self shouldDisconnect ifTrue: [self disconnect]]]

{ #category : #private }
HttpClient >> sendRequest: anHttpRequest timeout: timeout [
	^[connection sendRequest: anHttpRequest timeout: timeout]
		on: connection errorClass , HttpRequestCancelled
		do: [:e | self handleError: e fromRequest: anHttpRequest]]

{ #category : #headers }
HttpClient >> setCookie: anHttpCookie [
	| cookie |
	cookie := HttpCookie new
		name: anHttpCookie name;
		value: anHttpCookie value.
	self propertyAt: #cookie put: cookie]

{ #category : #testing }
HttpClient >> shouldConnect [
	^connection isNil or: [connection isConnected not]]

{ #category : #testing }
HttpClient >> shouldDisconnect [
	^configuration isPersistent not]

{ #category : #configuration }
HttpClient >> timeout [
	^configuration timeout]

{ #category : #configuration }
HttpClient >> timeout: seconds [
	configuration timeout: seconds]

{ #category : #private }
HttpClient >> updateAuthenticator [
	authenticator := configuration requiresAuthorization
		ifTrue: [configuration newAuthenticator]]

{ #category : #configuration }
HttpClient >> url [
	^configuration url]

{ #category : #configuration }
HttpClient >> url: anURL [
	configuration url: anURL]

{ #category : #accessing }
HttpClient >> useBinaryFormat [
	format := #binary]

{ #category : #configuration }
HttpClient >> useCredentials: credentials while: aBlock [
	| current parts temporary cookie |
	current := configuration.
	parts := $: split: credentials.
	temporary := configuration copy
		vaultName: nil;
		username: parts first;
		password: parts second.
	cookie := self cookie.
	self configuration: temporary; resetCookie.
	^aBlock ensure: [
		self configuration: current.
		cookie notNil ifTrue: [self setCookie: cookie]]]

{ #category : #accessing }
HttpClient >> useHtmlFormat [
	format := #html]

{ #category : #accessing }
HttpClient >> useJsonFormat [
	format := #json]

{ #category : #configuration }
HttpClient >> username: aString [
	configuration username: aString.
	self updateAuthenticator]

{ #category : #services }
HttpClient >> useSingleSignOn: aBoolean [
	configuration useSingleSignOn: aBoolean.
	self updateAuthenticator]

{ #category : #configuration }
HttpClient >> useSocketConnection [
	self connectionClass: HttpConnection]

{ #category : #services }
HttpClient >> usesSingleSignOn [
	^configuration usesSingleSignOn]

{ #category : #accessing }
HttpClient >> useTextFormat [
	format := #text]

{ #category : #services }
HttpClient >> useTimeout: seconds while: aBlock [
	| current |
	current := self timeout.
	self timeout: seconds.
	aBlock ensure: [self timeout: current]]

{ #category : #services }
HttpClient >> useVaultNamed: aString [
	configuration vaultName: aString.
	self updateAuthenticator]

{ #category : #services }
HttpClient >> useWindowsCredentials [
	^configuration useSingleSignOn: true]

