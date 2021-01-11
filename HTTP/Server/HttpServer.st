"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpServer,
	#superclass : #Object,
	#instVars : [
		'state',
		'debug'
	],
	#category : #'HTTP\Server'
}

{ #category : #'pm support' }
HttpServer class >> aboutToSaveLibraryOn: aCodeSegmentBuilder [
	aCodeSegmentBuilder map: current to: nil]

{ #category : #accessing }
HttpServer class >> current [
	current isNil ifTrue: [current := self new].
	^current]

{ #category : #services }
HttpServer class >> currentHost [
	^ShellDLL current IsUserAnAdmin
		ifTrue: [(ADDRINFOW forHost: KernelLibrary getComputerName) ip]
		ifFalse: ['localhost']]

{ #category : #initialization }
HttpServer class >> initializeConstants [
	HTTP_RESPONSE_V1 initializeStatusCodes.
	HttpApiDLL initializeConstants.
	HTTP_REQUEST_HEADERS initializeConstants.
	HTTP_RESPONSE_HEADERS initializeRequestConstants.
	HTTP_DATA_CHUNK initializeConstants.
	HTTP_LOGGING_INFO initializeConstants]

{ #category : #'instance creation' }
HttpServer class >> new [
	^self == HttpServer
		ifTrue: [HttpCreator new]
		ifFalse: [super new initialize]]

{ #category : #accessing }
HttpServer >> beDebuggable [
	debug := true]

{ #category : #accessing }
HttpServer >> currentHost [
	^self class currentHost]

{ #category : #accessing }
HttpServer >> debuggable: aBoolean [
	debug := aBoolean]

{ #category : #logging }
HttpServer >> errorLogFilename [
	"
	HttpServer new errorLogFilename
	"
	^self loggingDirectory \ 'httpserver.log']

{ #category : #finalization }
HttpServer >> finalizationRegistry [
	^Smalltalk resourceRegistry]

{ #category : #finalization }
HttpServer >> finalize [
	self stop]

{ #category : #private }
HttpServer >> handleError: anError [
	debug ifTrue: [anError pass].
	(anError isResumable andNot: [anError isKindOf: Timeout])
		ifTrue: [anError resume].
	self logError: anError description.
	anError return: nil]

{ #category : #initialization }
HttpServer >> initialize [
	super initialize.
	state := #stopped.
	debug := false]

{ #category : #testing }
HttpServer >> isDebuggable [
	^debug]

{ #category : #testing }
HttpServer >> isRunning [
	^state == #running]

{ #category : #testing }
HttpServer >> isStarted [
	^state == #started]

{ #category : #testing }
HttpServer >> isStopped [
	^state == #stopped]

{ #category : #logging }
HttpServer >> logError: aString [
	| ts stream |
	aString print.
	ts := Timestamp now.
	stream := self errorLogFilename asFile appendStream.
	stream
		lineDelimiter: Character cr;
		cr;
		nextPutAll: ts ddmmyyyyhhmmssms;
		space;
		nextPutAll: aString;
		close]

{ #category : #logging }
HttpServer >> loggingDirectory [
	"
	HttpServer new looggingDirectory
	"
	| dir |
	dir := Directory current directoryNamed: 'HttpServer\logs'.
	dir exists ifFalse: [dir createPath].
	^dir]

{ #category : #finalization }
HttpServer >> sessionShutdown [
	self stop]

{ #category : #testing }
HttpServer >> supportsWebSockets [
	^false]

{ #category : #testing }
HttpServer >> wasStarted [
	^state == #started | (state == #running)]

