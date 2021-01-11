"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #InternetSession,
	#superclass : #Win32InternetObject,
	#instVars : [
		'agent',
		'accessType',
		'proxy',
		'proxyBypass',
		'flags',
		'synchronous',
		'connections',
		'callback',
		'state'
	],
	#classVars : [
		'LOG'
	],
	#category : #'HTTP\Client'
}

{ #category : #'pm support' }
InternetSession class >> aboutToSaveLibraryOn: aCodeSegmentBuilder [
	aCodeSegmentBuilder
		map: synchronous to: nil;
		map: asynchronous to: nil.
	super aboutToSaveLibraryOn: aCodeSegmentBuilder]

{ #category : #accessing }
InternetSession class >> asynchronous [
	^(asynchronous notNil and: [asynchronous isValid])
		ifTrue: [asynchronous]
		ifFalse: [asynchronous := self new beAsynchronous open]]

{ #category : #events }
InternetSession class >> availableEvents [
	^super availableEvents
		add: #connectionOpened:;
		add: #requestCompleted:;
		add: #requestOpened:;
		add: #stateChanged:;
		yourself]

{ #category : #actions }
InternetSession class >> close [
	synchronous notNil ifTrue: [
		synchronous release.
		synchronous := nil].
	asynchronous notNil ifTrue: [
		asynchronous release.
		asynchronous := nil]]

{ #category : #accessing }
InternetSession class >> current [
	^self synchronous]

{ #category : #initialization }
InternetSession class >> initializeLog [
	"
	InternetSession initializeLog
	"
	LOG := OrderedCollection new]

{ #category : #accessing }
InternetSession class >> log [
	"
	InternetSession log
	"
	^LOG]

{ #category : #actions }
InternetSession class >> resetLog [
	"
	InternetSession resetLog
	"
	LOG notNil ifTrue: [LOG removeAll]]

{ #category : #accessing }
InternetSession class >> synchronous [
	^(synchronous notNil and: [synchronous isValid])
		ifTrue: [synchronous]
		ifFalse: [synchronous := self new open]]

{ #category : #configuration }
InternetSession >> beAsynchronous [
	synchronous := false]

{ #category : #configuration }
InternetSession >> beLocal [
	accessType := INTERNET_OPEN_TYPE_DIRECT]

{ #category : #system }
InternetSession >> bytesSent: token data: data [
	| connection request |
	connection := self connectionAt: token connectionId.
	request := connection requestAt: token requestId.
	self
		log: 'INTERNET_STATUS_REQUEST_SENT: ' , data asString;
		disableCode: [request bytesSent: data lowULong]]

{ #category : #'open/close' }
InternetSession >> close [
	super close ifFalse: [^false].
	connections select: #notNil thenDo: #close.
	callback free]

{ #category : #private }
InternetSession >> connect: anInternetConnection to: server port: port [
	| token |
	anInternetConnection
		session: self;
		server: server;
		port: port.
	connections add: anInternetConnection.
	token := HTTP_REQUEST_TOKEN new connectionId: connections size.
	^anInternetConnection token: token]

{ #category : #system }
InternetSession >> connectionAt: anInteger [
	^connections
		at: anInteger
		ifAbsent: [self error: 'unknown connection ' , anInteger printString]]

{ #category : #private }
InternetSession >> eventFor: status [
	status = INTERNET_STATUS_CLOSING_CONNECTION ifTrue: [^#closing].
	status = INTERNET_STATUS_CONNECTED_TO_SERVER ifTrue: [^#connected].
	status = INTERNET_STATUS_CONNECTING_TO_SERVER ifTrue: [^#connecting].
	status = status = INTERNET_STATUS_CONNECTION_CLOSED
		ifTrue: [^#connectionClosed].
	status = INTERNET_STATUS_COOKIE_HISTORY ifTrue: [^nil].
	status = INTERNET_STATUS_COOKIE_RECEIVED ifTrue: [^nil].
	status = INTERNET_STATUS_COOKIE_SENT ifTrue: [^nil].
	status = INTERNET_STATUS_CTL_RESPONSE_RECEIVED ifTrue: [^nil].
	status = INTERNET_STATUS_DETECTING_PROXY ifTrue: [^nil].
	status = INTERNET_STATUS_HANDLE_CLOSING ifTrue: [^nil].
	status = INTERNET_STATUS_HANDLE_CREATED ifTrue: [^nil].
	status = INTERNET_STATUS_INTERMEDIATE_RESPONSE ifTrue: [^nil].
	status = INTERNET_STATUS_NAME_RESOLVED ifTrue: [^#nameResolved].
	status = INTERNET_STATUS_P3P_HEADER ifTrue: [^nil].
	status = INTERNET_STATUS_P3P_POLICYREF ifTrue: [^nil].
	status = INTERNET_STATUS_PREFETCH ifTrue: [^nil].
	status = INTERNET_STATUS_PRIVACY_IMPACTED ifTrue: [^nil].
	status = INTERNET_STATUS_RECEIVING_RESPONSE ifTrue: [^nil].
	status = INTERNET_STATUS_REDIRECT ifTrue: [^nil].
	status = INTERNET_FLAG_NO_AUTO_REDIRECT ifTrue: [^nil].
	status = INTERNET_STATUS_REQUEST_COMPLETE ifTrue: [^nil].
	status = INTERNET_STATUS_REQUEST_SENT ifTrue: [^nil].
	status = INTERNET_STATUS_RESOLVING_NAME ifTrue: [^nil].
	status = INTERNET_STATUS_RESPONSE_RECEIVED ifTrue: [^nil].
	status = INTERNET_STATUS_SENDING_REQUEST ifTrue: [^nil].
	status = INTERNET_STATUS_STATE_CHANGE ifTrue: [^nil].
	^nil]

{ #category : #accessing }
InternetSession >> flags: anInteger [
	flags := anInteger]

{ #category : #'open/close' }
InternetSession >> forgetConnection: anInternetConnection [
	connections replace: anInternetConnection with: nil]

{ #category : #services }
InternetSession >> ftpConnectionTo: server port: port [
	^self connect: FTPConnection new to: server port: port]

{ #category : #'open/close' }
InternetSession >> getHandle [
	| name server bypass ulong |
	name := agent externalCopy.
	server := proxy externalCopy.
	bypass := proxyBypass externalCopy.
	ulong := WininetDLL current
		InternetOpen: name asParameter
		dwAccessType: accessType
		lpszProxyName: server asParameter
		lpszProxyBypass: bypass asParameter
		dwFlags: flags.
	ulong = 0 ifTrue: [self winError].
	name free.
	server free.
	bypass free.
	self handle: ulong asExternalHandle]

{ #category : #system }
InternetSession >> handleClosed: token data: data [
	| result connection request r object |
	connection := self connectionAt: token connectionId.
	r := token requestId.
	r > 0 ifTrue: [request := connection requestAt: r].
	object := request ifNil: [connection].
	result := INTERNET_ASYNC_RESULT usingBytes: data.
	result success
		ifTrue: [object closed]
		ifFalse: [object error: result error]]

{ #category : #system }
InternetSession >> handleCreated: token data: data [
	| result connection id request |
	result := INTERNET_ASYNC_RESULT usingBytes: data , #[0 0 0 0].
	connection := self connectionAt: token connectionId.
	id := token requestId.
	id = 0 ifTrue: [
		connection handle: result handle; signal.
		^self triggerEvent: #connectionOpened: with: connection].
	request := connection requestAt: id.
	request handle: result handle; signal.
	^self triggerEvent: #requestOpened: with: request]

{ #category : #system }
InternetSession >> hInternet: hInternet
dwContext: pContext
dwInternetStatus: status
lpvStatusInformation: info
dwStatusInformationLength: length [
	| token data s |
	token := HTTP_REQUEST_TOKEN fromMemory: pContext pointedMemory.
	data := info != 0
		ifTrue: [info pointedMemory copyFrom: 1 to: length lowULong].
	s := status lowULong.
	self
		log: (self statusFor: s);
		information: data status: s token: token]

{ #category : #services }
InternetSession >> httpConnectionTo: server port: port secure: aBoolean [
	| class |
	class := aBoolean ifTrue: [HTTPSConnection] ifFalse: [HTTPConnection].
	^self connect: class new to: server port: port]

{ #category : #system }
InternetSession >> information: data status: status token: token [
	| event |
	status = INTERNET_STATUS_STATE_CHANGE ifTrue: [^self stateChange: data].
	status = INTERNET_STATUS_HANDLE_CREATED
		ifTrue: [^self handleCreated: token data: data].
	status = INTERNET_STATUS_REQUEST_COMPLETE
		ifTrue: [^self requestComplete: token data: data].
	status = INTERNET_STATUS_HANDLE_CLOSING
		ifTrue: [^self handleClosed: token data: data].
	status = INTERNET_STATUS_REQUEST_SENT
		ifTrue: [^self bytesSent: token data: data].
	event := self eventFor: status.
	event notNil ifTrue: [self triggerEvent: event]]

{ #category : #initialization }
InternetSession >> initialize [
	super initialize.
	self useRegistry; initializeAgent; initializeFlags.
	synchronous := true.
	connections := OrderedCollection new]

{ #category : #initialization }
InternetSession >> initializeAgent [
	agent := 'Bee Smalltalk']

{ #category : #initialization }
InternetSession >> initializeCallback [
	synchronous ifTrue: [^self].
	callback := self
		asyncCallbackOn: #hInternet:dwContext:dwInternetStatus:lpvStatusInformation:dwStatusInformationLength:.
	WininetDLL current
		InternetSetStatusCallback: self asParameter
		lpfnInternetCallback: callback asParameter]

{ #category : #initialization }
InternetSession >> initializeFlags [
	flags := 0]

{ #category : #testing }
InternetSession >> isAsynchronous [
	^synchronous not]

{ #category : #testing }
InternetSession >> isOpen [
	^self isValid]

{ #category : #system }
InternetSession >> log: aString [
	| stream ts0 ts |
	LOG isNil ifTrue: [^self].
	LOG isOrderedCollection
		ifTrue: [
			ts0 := LOG isEmpty ifTrue: [0] ifFalse: [LOG last first].
			ts := Time millisecondClockValue.
			LOG add: {ts. ts - ts0. aString}]
		ifFalse: [
			stream := LOG asFilename asFile appendStream.
			stream
				nextPutAll: Time millisecondClockValue asString;
				space;
				nextPutAll: aString;
				cr;
				close]]

{ #category : #'open/close' }
InternetSession >> open [
	self isOpen ifTrue: [^self].
	synchronous ifFalse: [flags := flags | INTERNET_FLAG_ASYNC].
	self getHandle; initializeCallback]

{ #category : #services }
InternetSession >> openUrl: url [
	"
	[
	InternetSession asynchronous openUrl: 'http://www.google.com'
	] repeat
	InternetSession synchronous openUrl: 'http://www.google.com'
	"
	| file token |
	file := InternetFile new
		addFlagDontCache;
		addFlagInternetReload;
		session: self.
	connections add: file.
	token := HTTP_REQUEST_TOKEN new connectionId: connections size.
	file token: token; address: url.
	^[| response |
		response := file request.
		response isNotFound ifFalse: [response data]]
		ensure: [file close]]

{ #category : #services }
InternetSession >> openUrl: url credentials: aString format: format [
	| headers |
	headers := HttpHeaders new.
	aString notNil ifTrue: [headers authorization: 'Basic ' , aString].
	format = #binary ifTrue: [headers accept: 'application/octet-stream'].
	headers := String streamContents: [:strm | headers writeOn: strm].
	^self openUrl: url headers: headers format: format]

{ #category : #services }
InternetSession >> openUrl: url headers: headers format: format [
	| file token |
	file := InternetFile new
		addFlagDontCache;
		addFlagInternetReload;
		session: self.
	connections add: file.
	token := HTTP_REQUEST_TOKEN new connectionId: connections size.
	file token: token; address: url.
	^[| response |
		response := file requestWith: headers.
		response isNotFound
			ifFalse: [format = #binary
				ifTrue: [response body]
				ifFalse: [response data]]]
		ensure: [file close]]

{ #category : #accessing }
InternetSession >> proxy: aString [
	proxy := aString]

{ #category : #accessing }
InternetSession >> proxyBypass: aString [
	proxyBypass := aString]

{ #category : #system }
InternetSession >> requestComplete: token data: data [
	| result connection request index |
	connection := self connectionAt: token connectionId.
	index := token requestId.
	request := index > 0 ifTrue: [connection requestAt: index].
	result := INTERNET_ASYNC_RESULT usingBytes: data.
	result success
		ifTrue: [
			request notNil ifTrue: [request signal].
			self triggerEvent: #requestCompleted: with: request]
		ifFalse: [request error: result error]]

{ #category : #private }
InternetSession >> resetConnections [
	connections select: #notNil thenDo: #close; removeAll]

{ #category : #accessing }
InternetSession >> resetLog [
	"
	InternetSession resetLog
	"
	self class resetLog]

{ #category : #system }
InternetSession >> stateChange: data [
	| ulong |
	ulong := ExternalInt32 usingBytes: data.
	state := self stateFrom: ulong asInteger.
	self triggerEvent: #stateChanged: with: state]

{ #category : #private }
InternetSession >> stateFrom: ulong [
	ulong = INTERNET_STATE_CONNECTED ifTrue: [^#connected].
	ulong = INTERNET_STATE_DISCONNECTED ifTrue: [^#disconnected].
	ulong = INTERNET_STATE_DISCONNECTED_BY_USER ifTrue: [^#disconnectedByUser].
	ulong = INTERNET_STATE_IDLE ifTrue: [^#idle].
	ulong = INTERNET_STATE_BUSY ifTrue: [^#busy].
	ulong = INTERNET_STATUS_USER_INPUT_REQUIRED ifTrue: [^#waitingUserInput].
	^self error: 'invalid state']

{ #category : #private }
InternetSession >> statusFor: code [
	code = INTERNET_STATUS_DETECTING_PROXY
		ifTrue: [^'INTERNET_STATUS_DETECTING_PROXY'].
	code = INTERNET_STATUS_COOKIE_SENT
		ifTrue: [^'INTERNET_STATUS_COOKIE_SENT '].
	code = INTERNET_STATUS_COOKIE_RECEIVED
		ifTrue: [^'INTERNET_STATUS_COOKIE_RECEIVED'].
	code = INTERNET_STATUS_CLOSING_CONNECTION
		ifTrue: [^'INTERNET_STATUS_CLOSING_CONNECTION'].
	code = INTERNET_STATUS_CONNECTED_TO_SERVER
		ifTrue: [^'INTERNET_STATUS_CONNECTED_TO_SERVER'].
	code = INTERNET_STATUS_CONNECTING_TO_SERVER
		ifTrue: [^'INTERNET_STATUS_CONNECTING_TO_SERVER'].
	code = INTERNET_STATUS_CONNECTION_CLOSED
		ifTrue: [^'INTERNET_STATUS_CONNECTION_CLOSED'].
	code = INTERNET_STATUS_CTL_RESPONSE_RECEIVED
		ifTrue: [^'INTERNET_STATUS_CTL_RESPONSE_RECEIVED'].
	code = INTERNET_STATUS_HANDLE_CLOSING
		ifTrue: [^'INTERNET_STATUS_HANDLE_CLOSING'].
	code = INTERNET_STATUS_HANDLE_CREATED
		ifTrue: [^'INTERNET_STATUS_HANDLE_CREATED'].
	code = INTERNET_STATUS_NAME_RESOLVED
		ifTrue: [^'INTERNET_STATUS_NAME_RESOLVED'].
	code = INTERNET_STATUS_RECEIVING_RESPONSE
		ifTrue: [^'INTERNET_STATUS_RECEIVING_RESPONSE'].
	code = INTERNET_STATUS_REDIRECT ifTrue: [^'INTERNET_STATUS_REDIRECT'].
	code = INTERNET_STATUS_REQUEST_COMPLETE
		ifTrue: [^'INTERNET_STATUS_REQUEST_COMPLETE'].
	code = INTERNET_STATUS_REQUEST_SENT
		ifTrue: [^'INTERNET_STATUS_REQUEST_SENT'].
	code = INTERNET_STATUS_RESOLVING_NAME
		ifTrue: [^'INTERNET_STATUS_RESOLVING_NAME'].
	code = INTERNET_STATUS_RESPONSE_RECEIVED
		ifTrue: [^'INTERNET_STATUS_RESPONSE_RECEIVED'].
	code = INTERNET_STATUS_SENDING_REQUEST
		ifTrue: [^'INTERNET_STATUS_SENDING_REQUEST'].
	^'Unknown status ' , code asString]

{ #category : #configuration }
InternetSession >> useProxy [
	accessType := INTERNET_OPEN_TYPE_PROXY]

{ #category : #configuration }
InternetSession >> useRegistry [
	accessType := INTERNET_OPEN_TYPE_PRECONFIG]

