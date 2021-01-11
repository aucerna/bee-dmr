"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BeeHttpServer,
	#superclass : #WebServer,
	#instVars : [
		'daemons',
		'connections'
	],
	#category : #'HTTP\Server'
}

{ #category : #'instance creation' }
BeeHttpServer class >> fromCommandLine: aCommandLine [
	| ws app |
	ws := aCommandLine new booleanAt: 'wsOnly'.
	ws ifTrue: [self current webSocketOnly].
	app := WebApplication fromCommandLine: aCommandLine.
	app notNil ifTrue: [self current addApplication: app; start]]

{ #category : #applications }
BeeHttpServer >> addApplication: aWebApplication [
	| daemon |
	super addApplication: aWebApplication.
	self wasStarted ifTrue: [
		self isWebSocketOnly
			ifFalse: [self openDaemonOnPort: aWebApplication port].
		(aWebApplication acceptsWebSockets
			and: [aWebApplication wsPort != aWebApplication port])
			ifTrue: [
				daemon := self openDaemonOnPort: aWebApplication wsPort.
				aWebApplication configuration wsPort: daemon port]]]

{ #category : #private }
BeeHttpServer >> applicationFor: anHttpRequest [
	^registry valueAt: anHttpRequest baseUri]

{ #category : #private }
BeeHttpServer >> hostname [
	^applications anyone hostname]

{ #category : #initialization }
BeeHttpServer >> initialize [
	super initialize.
	daemons := OrderedCollection new.
	connections := Set new]

{ #category : #private }
BeeHttpServer >> initializeDaemons [
	| apps |
	self isWebSocketOnly
		ifFalse: [applications do: [:app | self openDaemonOnPort: app port]].
	apps := applications
		select: [:app | app acceptsWebSockets and: [app wsPort != app port]].
	apps
		sortBy: #wsPort;
		reverseDo: [:app | | daemon |
			daemon := self openDaemonOnPort: app wsPort.
			app configuration wsPort: daemon port]]

{ #category : #testing }
BeeHttpServer >> isWebSocketOnly [
	^self propertyAt: #webSocketOnly ifAbsent: false]

{ #category : #private }
BeeHttpServer >> openDaemonOnPort: anInteger [
	| daemon |
	daemon := Socket localOnPort: anInteger.
	daemon
		beDaemon;
		open;
		bind;
		listen;
		nonBlocking;
		respondToExternalEvents: #(#readyToAccept);
		when: #readyToAccept do: [| connection |
			connection := HttpConnection on: daemon accept.
			connection port: daemon port.
			self serveConnection: connection].
	daemons add: daemon.
	^daemon]

{ #category : #private }
BeeHttpServer >> processRequestOn: anHttpConnection [
	| request response failed |
	request := [anHttpConnection receiveRequest]
		on: anHttpConnection errorClass , Timeout
		do: [:e | self handleError: e].
	request isNil ifTrue: [^false].
	request propertyAt: #connection put: anHttpConnection.
	response := self responseFor: request.
	failed := false.
	[anHttpConnection sendResponse: response]
		on: anHttpConnection errorClass
		do: [:e | 
			self handleError: e.
			failed := true].
	failed ifTrue: [^false].
	response hasWebSocketAccept ifTrue: [
		anHttpConnection beUpgraded.
		^false].
	^request shouldCloseConnection not andNot: [response shouldCloseConnection]]

{ #category : #private }
BeeHttpServer >> processRequestsOn: anHttpConnection [
	[self processRequestOn: anHttpConnection] whileTrue]

{ #category : #private }
BeeHttpServer >> registerApplication: aWebApplication [
	| uri |
	uri := aWebApplication baseUri.
	registry
		at: uri
		ifPresent: [self error: 'The uri ' , uri , ' is already registered'];
		at: uri put: aWebApplication]

{ #category : #private }
BeeHttpServer >> responseFor: anHttpRequest [
	| response |
	response := super responseFor: anHttpRequest.
	anHttpRequest shouldCloseConnection ifTrue: [response closeConnection].
	^response]

{ #category : #actions }
BeeHttpServer >> run [
	self isStarted ifFalse: [^self].
	state := #running]

{ #category : #private }
BeeHttpServer >> serveConnection: anHttpConnection [
	[
		connections add: anHttpConnection.
		[self processRequestsOn: anHttpConnection] ensure: [
			anHttpConnection isUpgraded ifFalse: [anHttpConnection disconnect].
			connections remove: anHttpConnection ifAbsent: nil]]
		forkNamed: 'Processing request on ' , anHttpConnection asString]

{ #category : #private }
BeeHttpServer >> setUp [
	super setUp.
	self initializeDaemons]

{ #category : #testing }
BeeHttpServer >> supportsWebSockets [
	^true]

{ #category : #private }
BeeHttpServer >> tearDown [
	super tearDown.
	daemons do: #close; removeAll.
	connections do: #disconnect; removeAll]

{ #category : #accessing }
BeeHttpServer >> webSocketOnly [
	self propertyAt: #webSocketOnly put: true]

