"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpWorker,
	#superclass : #WebServer,
	#instVars : [
		'queue'
	],
	#category : #'HTTP\Server'
}

{ #category : #'instance creation' }
HttpWorker class >> fromCommandLine: aCommandLine [
	| queue app |
	queue := aCommandLine argumentAt: 'queue'.
	self current useQueueNamed: queue.
	app := WebApplication fromCommandLine: aCommandLine.
	app notNil
		ifTrue: [self current addApplication: app with: app configuration; start]]

{ #category : #'instance creation' }
HttpWorker class >> onQueueNamed: aString [
	| queue |
	queue := HttpRequestQueue new name: aString.
	^HttpWorker new queue: queue]

{ #category : #'startup/shutdown' }
HttpWorker class >> queueName [
	^SmalltalkSession current commandLine argumentAt: 'queue']

{ #category : #'startup/shutdown' }
HttpWorker class >> startup [
	self queueName ifNotNil: [:q | self current queue name: q].
	^super startup]

{ #category : #applications }
HttpWorker >> addApplication: aWebApplication [
	super addApplication: aWebApplication.
	aWebApplication acceptsWebSockets
		ifTrue: [self webSocketServer addApplication: aWebApplication]]

{ #category : #private }
HttpWorker >> closeRequestQueue [
	queue isNil ifTrue: [^self].
	queue close]

{ #category : #private }
HttpWorker >> createThreadpoolIo [
	queue createThreadpoolIo]

{ #category : #initialization }
HttpWorker >> initialize [
	super initialize.
	queue := HttpRequestQueue new]

{ #category : #private }
HttpWorker >> initializeService [
	| version return |
	version := HTTPAPI_VERSION major: 2 minor: 0.
	return := HttpApiDLL current
		HttpInitialize: version asParameter
		Flags: HTTP_INITIALIZE_SERVER
		pReserved: 0.
	return = 0 ifFalse: [self winError: return]]

{ #category : #logging }
HttpWorker >> loggingFor: anHttpMessage [
	^nil]

{ #category : #logging }
HttpWorker >> logRequest: anHttpRequest [
	| logging |
	logging := self loggingFor: anHttpRequest.
	(logging notNil and: [logging isEnabled])
		ifTrue: [logging logRequest: anHttpRequest]]

{ #category : #logging }
HttpWorker >> logResponse: anHttpResponse [
	| logging |
	logging := self loggingFor: anHttpResponse.
	(logging notNil and: [logging isEnabled])
		ifTrue: [logging logResponse: anHttpResponse]]

{ #category : #private }
HttpWorker >> openRequestQueue [
	queue open]

{ #category : #private }
HttpWorker >> processNextRequest [
	| request |
	request := self receiveRequest.
	request isNil ifTrue: [^self].
	[self processRequest: request]
		forkNamed: 'Processing request ' , request id asString]

{ #category : #private }
HttpWorker >> processRequest: anHttpRequest [
	| response |
	[
		anHttpRequest hasPendingData
			ifTrue: [queue readRequestBody: anHttpRequest].
		self logRequest: anHttpRequest.
		response := self responseFor: anHttpRequest.
		self logResponse: response; sendResponse: response]
		on: Error
		do: [:error | self handleError: error]]

{ #category : #accessing }
HttpWorker >> queue [
	^queue]

{ #category : #private }
HttpWorker >> queue: anHttpRequestQueue [
	queue := anHttpRequestQueue]

{ #category : #private }
HttpWorker >> receiveRequest [
	^[queue receiveRequest]
		on: Error
		do: [:e | self dumpProcess; handleError: e]]

{ #category : #applications }
HttpWorker >> removeApplication: aWebApplication [
	super removeApplication: aWebApplication.
	aWebApplication acceptsWebSockets
		ifTrue: [self webSocketServer removeApplication: aWebApplication]]

{ #category : #actions }
HttpWorker >> run [
	self isStarted ifFalse: [^self].
	state := #running.
	[state == #running] whileTrue: [self processNextRequest]]

{ #category : #private }
HttpWorker >> sendResponse: anHttpResponse [
	queue sendResponse: anHttpResponse]

{ #category : #private }
HttpWorker >> setUp [
	self initializeService; openRequestQueue.
	super setUp.
	self createThreadpoolIo]

{ #category : #actions }
HttpWorker >> start [
	super start.
	self webSocketServer start]

{ #category : #actions }
HttpWorker >> stop [
	super stop.
	self webSocketServer stop]

{ #category : #private }
HttpWorker >> tearDown [
	super tearDown.
	self closeRequestQueue]

{ #category : #logging }
HttpWorker >> useCustomLogging [
	]

{ #category : #logging }
HttpWorker >> useIISLogging [
	]

{ #category : #logging }
HttpWorker >> useNCSALogging [
	]

{ #category : #private }
HttpWorker >> useQueueNamed: aString [
	queue := HttpRequestQueue new name: aString]

{ #category : #logging }
HttpWorker >> useRawLogging [
	]

{ #category : #logging }
HttpWorker >> useW3CLogging [
	]

{ #category : #private }
HttpWorker >> webSocketServer [
	^self
		propertyAt: #webSocketServer
		ifAbsentPut: [BeeHttpServer new webSocketOnly]]

