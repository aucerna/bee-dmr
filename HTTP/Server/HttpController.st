"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpController,
	#superclass : #HttpServer,
	#instVars : [
		'session',
		'queues',
		'groups',
		'workers'
	],
	#category : #'HTTP\Server'
}

{ #category : #'adding / removing' }
HttpController >> addQueueNamed: aString [
	| queue |
	queue := HttpRequestQueue new name: aString.
	^queues at: aString put: queue]

{ #category : #'adding / removing' }
HttpController >> addQueueNamed: aString forUrl: anURL [
	| queue group |
	queue := self addQueueNamed: aString.
	group := self addUrlGroupNamed: aString , ' group'.
	group queue: queue; addUrl: anURL.
	^queue]

{ #category : #'adding / removing' }
HttpController >> addUrlGroupNamed: aString [
	| group |
	group := UrlGroup on: session.
	group name: aString.
	^groups add: group]

{ #category : #'adding / removing' }
HttpController >> addWorker: anHttpWorker [
	^workers add: anHttpWorker]

{ #category : #private }
HttpController >> closeRequestQueues [
	queues do: [:queue | queue close]]

{ #category : #private }
HttpController >> closeServerSession [
	session close]

{ #category : #private }
HttpController >> closeUrlGroups [
	groups do: [:group | group close]]

{ #category : #private }
HttpController >> createRequestQueues [
	queues do: [:queue | queue create]]

{ #category : #private }
HttpController >> createServerSession [
	session create]

{ #category : #private }
HttpController >> createUrlGroups [
	groups do: [:group | group create; bind]]

{ #category : #initialization }
HttpController >> initialize [
	super initialize.
	session := HttpServerSession new.
	queues := Dictionary new.
	groups := OrderedCollection new.
	workers := OrderedCollection new]

{ #category : #private }
HttpController >> initializeService [
	| version return |
	version := HTTPAPI_VERSION major: 2 minor: 0.
	return := HttpApiDLL current
		HttpInitialize: version asParameter
		Flags: HTTP_INITIALIZE_SERVER
		pReserved: 0.
	return = 0 ifFalse: [self winError: return]]

{ #category : #inquiries }
HttpController >> queueNamed: aString [
	^queues at: aString ifAbsent: nil]

{ #category : #accessing }
HttpController >> queues [
	^queues]

{ #category : #actions }
HttpController >> start [
	self wasStarted ifTrue: [^self].
	self requireFinalization.
	[
		self
			initializeService;
			createServerSession;
			createRequestQueues;
			createUrlGroups.
		state := #started]
		ifCurtailed: [state := #error].
	self print]

{ #category : #actions }
HttpController >> stop [
	self isStopped ifTrue: [^self].
	state := #stopping.
	[
		self
			closeUrlGroups;
			closeRequestQueues;
			closeServerSession;
			terminateService.
		state := #stopped]
		ifCurtailed: [state := #error]]

{ #category : #private }
HttpController >> terminateService [
	| return |
	return := HttpApiDLL current
		HttpTerminate: HTTP_INITIALIZE_SERVER asParameter
		pReserved: 0.
	return = 0 ifFalse: [self winError: return].
	^return]

