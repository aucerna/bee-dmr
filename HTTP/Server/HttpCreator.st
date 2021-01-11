"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpCreator,
	#superclass : #HttpWorker,
	#instVars : [
		'session',
		'group'
	],
	#category : #'HTTP\Server'
}

{ #category : #services }
HttpCreator >> authentication [
	^group authentication]

{ #category : #private }
HttpCreator >> bindUrlGroup [
	group queue: queue; bind]

{ #category : #private }
HttpCreator >> closeServerSession [
	session close]

{ #category : #private }
HttpCreator >> closeUrlGroup [
	group isNil ifTrue: [^self].
	group close]

{ #category : #private }
HttpCreator >> createRequestQueue [
	queue create]

{ #category : #private }
HttpCreator >> createServerSession [
	session create]

{ #category : #private }
HttpCreator >> createUrlGroup [
	group create]

{ #category : #private }
HttpCreator >> group [
	^group]

{ #category : #initialization }
HttpCreator >> initialize [
	super initialize.
	session := HttpServerSession new.
	session logging directory: self loggingDirectory.
	group := UrlGroup on: session.
	group queue: queue]

{ #category : #logging }
HttpCreator >> loggingFor: anHttpMessage [
	^group logging isEnabled ifTrue: [group logging] ifFalse: [session logging]]

{ #category : #private }
HttpCreator >> registerApplication: aWebApplication [
	super registerApplication: aWebApplication.
	group addUrl: aWebApplication configuration url asString]

{ #category : #actions }
HttpCreator >> session [
	^session]

{ #category : #private }
HttpCreator >> setUp [
	self
		initializeService;
		createServerSession;
		createRequestQueue;
		createUrlGroup;
		registerApplications;
		bindUrlGroup;
		createThreadpoolIo;
		setupLogging]

{ #category : #actions }
HttpCreator >> setupLogging [
	session setupLogging.
	group setupLogging]

{ #category : #private }
HttpCreator >> tearDown [
	super tearDown.
	self
		closeUrlGroup;
		closeRequestQueue;
		closeServerSession;
		terminateService]

{ #category : #private }
HttpCreator >> terminateService [
	| return |
	return := HttpApiDLL current
		HttpTerminate: HTTP_INITIALIZE_SERVER asParameter
		pReserved: 0.
	return = 0 ifFalse: [self winError: return].
	^return]

{ #category : #private }
HttpCreator >> unregisterApplication: aWebApplication [
	super unregisterApplication: aWebApplication.
	group notNil ifTrue: [group removeUrl: aWebApplication url asString]]

{ #category : #logging }
HttpCreator >> useCustomLogging [
	session useCustomLogging]

{ #category : #services }
HttpCreator >> useDigestAuthentication [
	]

{ #category : #logging }
HttpCreator >> useIISLogging [
	session useIISLogging]

{ #category : #logging }
HttpCreator >> useNCSALogging [
	session useNCSALogging]

{ #category : #logging }
HttpCreator >> useRawLogging [
	session useRawLogging]

{ #category : #logging }
HttpCreator >> useW3CLogging [
	session useW3CLogging]

