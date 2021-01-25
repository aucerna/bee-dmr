"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SocketEvent,
	#superclass : #Object,
	#instVars : [
		'id',
		'name',
		'selector'
	],
	#classVars : [
		'Events',
		'SocketMessage',
		'SocketWindow'
	],
	#category : #sockets
}

{ #category : #'instance creation' }
SocketEvent class >> add: aSocketEvent [
	Events at: aSocketEvent id put: aSocketEvent]

{ #category : #private }
SocketEvent class >> codeForEvents: aCollection [
	^aCollection inject: 0 into: [:r :code | r bitOr: code]]

{ #category : #logging }
SocketEvent class >> disableEventLogging [
	Smalltalk eventDispatcher removeHooksFor: SocketWindow]

{ #category : #logging }
SocketEvent class >> enableEventLogging [
	Smalltalk eventDispatcher
		spyMessage: #WM_SOCKETEVENT:lparam:
		for: SocketWindow
		evaluating: [:aMSG | | ev socket |
			socket := registry at: aMSG wParam ifAbsent: nil.
			socket notNil ifTrue: [
				ev := self eventNameFor: aMSG lParam lowWord.
				socket log: ev , '@' , aMSG timestamp ddmmyyyyhhmmssms]]]

{ #category : #logging }
SocketEvent class >> eventNameFor: anInteger [
	^(Events at: anInteger) name]

{ #category : #'instance creation' }
SocketEvent class >> id: anInteger name: aString selector: aSymbol [
	^self new id: anInteger name: aString selector: aSymbol]

{ #category : #initialization }
SocketEvent class >> initialize [
	super initialize.
	registry := Dictionary new.
	self initializeEvents]

{ #category : #private }
SocketEvent class >> initializeEvents [
	Events := Dictionary new.
	self
		add: (self id: FD_READ name: 'FD_READ' selector: #readyToRead);
		add: (self id: FD_WRITE name: 'FD_WRITE' selector: #readyToWrite);
		add: (self id: FD_OOB name: 'FD_OOB' selector: #outOfBandData);
		add: (self id: FD_ACCEPT name: 'FD_ACCEPT' selector: #readyToAccept);
		add: (self
			id: FD_CONNECT
			name: 'FD_CONNECT'
			selector: #connectionCompleted);
		add: (self id: FD_CLOSE name: 'FD_CLOSE' selector: #shuttingDown);
		add: (self id: FD_QOS name: 'FD_QOS' selector: #qualityChanged);
		add: (self
			id: FD_GROUP_QOS
			name: 'FD_GROUP_QOS'
			selector: #groupQualityChanged);
		add: (self
			id: FD_ROUTING_INTERFACE_CHANGE
			name: 'FD_ROUTING_INTERFACE_CHANGE'
			selector: #routingChanged);
		add: (self
			id: FD_ADDRESS_LIST_CHANGE
			name: 'FD_ADDRESS_LIST_CHANGE'
			selector: #addressListChanged)]

{ #category : #'startup/shutdown' }
SocketEvent class >> initializeSocketMessage [
	"
	SocketNotifier initializeSocketMessage
	"
	SocketMessage := Window
		registerWindowMessage: 'WM_SOCKETEVENT'
		selector: #WM_SOCKETEVENT:lparam:]

{ #category : #'startup/shutdown' }
SocketEvent class >> initializeSocketWindow [
	| box |
	SocketWindow := Window new.
	box := 0 @ 0 extent: 0 @ 0.
	SocketWindow
		style: 0;
		extendedStyle: 0;
		rectangle: box;
		createWindowNamed: 'Bee Sockets';
		register]

{ #category : #accessing }
SocketEvent class >> register: aSocket [
	registry at: aSocket descriptor ifAbsentPut: [aSocket].
	self registerEvents: aSocket enabledEvents descriptor: aSocket asParameter]

{ #category : #accessing }
SocketEvent class >> registeredSockets [
	^registry values]

{ #category : #accessing }
SocketEvent class >> registerEvents: aCollection descriptor: anInteger [
	| code return |
	code := self codeForEvents: aCollection.
	return := Ws2_32DLL current
		WSAAsyncSelect: anInteger
		hWnd: SocketWindow asParameter
		wMsg: SocketMessage
		lEvent: code.
	return = SOCKET_ERROR
		ifTrue: [SocketError signalOSCode: Ws2_32DLL current getLastError]]

{ #category : #'startup/shutdown' }
SocketEvent class >> startup [
	"
	SocketEvent  startup
	"
	registry := Dictionary new.
	Events size = 0 ifTrue: [self initializeEvents].
	self initializeSocketMessage; initializeSocketWindow.
	SocketWindow delegate: #WM_SOCKETEVENT:lparam: to: self]

{ #category : #accessing }
SocketEvent class >> unregister: aSocket [
	| s return |
	registry removeKey: aSocket descriptor ifAbsent: [^self].
	s := aSocket asParameter.
	return := Ws2_32DLL current
		WSAAsyncSelect: s
		hWnd: SocketWindow asParameter
		wMsg: 0
		lEvent: 0.
	return = SOCKET_ERROR
		ifTrue: [SocketError signalOSCode: Ws2_32DLL current getLastError]]

{ #category : #accessing }
SocketEvent class >> unregisterAll [
	"
	SocketEventDispatcher current unregisterAll
	"
	self registeredSockets do: [:s | self unregister: s]]

{ #category : #'startup/shutdown' }
SocketEvent class >> WM_SOCKETEVENT: wparam lparam: lparam in: aWindow [
	| event msg socket error |
	error := lparam highWord.
	event := Events at: lparam lowWord.
	socket := registry at: wparam ifAbsent: [^nil].
	msg := error = 0
		ifTrue: [#handleEvent: messageFor: socket with: event]
		ifFalse: [#socketError: messageFor: socket with: error].
	Smalltalk eventDispatcher queueMessage: msg]

{ #category : #accessing }
SocketEvent >> id [
	^id]

{ #category : #accessing }
SocketEvent >> id: anInteger name: aString selector: aSymbol [
	id := anInteger.
	name := aString.
	selector := aSymbol]

{ #category : #accessing }
SocketEvent >> name [
	^name]

{ #category : #printing }
SocketEvent >> printOn: aStream [
	aStream nextPutAll: self symbol]

{ #category : #accessing }
SocketEvent >> selector [
	^selector]

{ #category : #accessing }
SocketEvent >> symbol [
	^selector]

