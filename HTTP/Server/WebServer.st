"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #WebServer,
	#superclass : #HttpServer,
	#instVars : [
		'applications',
		'registry'
	],
	#category : #'HTTP\Server'
}

{ #category : #'startup/shutdown' }
WebServer class >> appConfigurations [
	| data applications |
	data := JsonParser parse: self startupFilename asFile contents.
	applications := data at: 'Applications'.
	^applications
		collect: [:dictionary | WebApplicationConfiguration fromJson: dictionary]]

{ #category : #services }
WebServer class >> start [
	^self current start]

{ #category : #'startup/shutdown' }
WebServer class >> startup [
	| server |
	server := self current.
	self appConfigurations do: [:configuration | | composer app class |
		class := WebApplication named: configuration name.
		app := class notNil
			ifTrue: [class fromConfiguration: configuration]
			ifFalse: [
				composer := WebAPIComposer new.
				configuration apis ifNotNil: [:apis | 
					apis do: [:n | | api |
						api := WebAPI apiNamed: n.
						api notNil ifTrue: [composer addAPI: api]]].
				composer isEmpty
					ifFalse: [WebApplication fromConfiguration: configuration api: composer]].
		app notNil ifTrue: [app startOn: server]]]

{ #category : #'startup/shutdown' }
WebServer class >> startupFilename [
	| filename |
	filename := SmalltalkSession current commandLine argumentAt: 'webconfig'.
	filename isNil ifTrue: [filename := '.\webapps.json'].
	filename := filename asFilename.
	filename exists
		ifFalse: [self
			error: 'web configuration file ' , filename asString , ' missing'].
	^filename]

{ #category : #applications }
WebServer >> addApplication: aWebApplication [
	self wasStarted ifTrue: [
		self registerApplication: aWebApplication.
		aWebApplication aboutToStart].
	applications add: aWebApplication]

{ #category : #applications }
WebServer >> addApplication: aWebApplication with: aWebApplicationConfiguration [
	aWebApplication configuration: aWebApplicationConfiguration.
	self addApplication: aWebApplication]

{ #category : #private }
WebServer >> applicationFor: anHttpRequest [
	^registry valueAt: anHttpRequest baseUri]

{ #category : #applications }
WebServer >> applicationNamed: aString [
	^applications detect: [:app | app name = aString] ifNone: nil]

{ #category : #applications }
WebServer >> applications [
	^applications]

{ #category : #initialization }
WebServer >> initialize [
	super initialize.
	applications := OrderedCollection new.
	registry := Dictionary new]

{ #category : #printing }
WebServer >> print [
	self asText print]

{ #category : #printing }
WebServer >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' State: '; nextPutAll: state asString]

{ #category : #printing }
WebServer >> printTextOn: rtf [
	super printOn: rtf.
	rtf crtab; nextPutAll: 'State: '; nextPutAll: state asString.
	self isStopped ifTrue: [^self].
	rtf crtab; nextPutAll: 'Applications:'.
	applications do: [:app | 
		rtf
			crtab;
			nextPutAll: app name storeString;
			nextPutAll: ' at ';
			nextPutAll: app url asString]]

{ #category : #private }
WebServer >> registerApplication: aWebApplication [
	| uri |
	uri := aWebApplication baseUri.
	registry
		at: uri
		ifPresent: [self error: 'The uri ' , uri , ' is already registered'];
		at: uri put: aWebApplication]

{ #category : #private }
WebServer >> registerApplications [
	applications do: [:app | self registerApplication: app]]

{ #category : #services }
WebServer >> registeredUrls [
	^applications collect: #url]

{ #category : #applications }
WebServer >> removeApplication: aWebApplication [
	self isStopped ifFalse: [aWebApplication aboutToStop].
	self unregisterApplication: aWebApplication.
	applications remove: aWebApplication ifAbsent: []]

{ #category : #applications }
WebServer >> removeApplications [
	applications do: [:app | self removeApplication: app].
	self unregisterApplications]

{ #category : #private }
WebServer >> responseFor: anHttpRequest [
	| app response error |
	response := [
		app := self applicationFor: anHttpRequest.
		app isNil
			ifTrue: [anHttpRequest response notFound]
			ifFalse: [app handleRequest: anHttpRequest]]
		on: Error
		do: [:e | 
			error := e description.
			self handleError: e].
	response isNil
		ifTrue: [response := anHttpRequest response error: error; closeConnection].
	app notNil ifTrue: [response serviceName: app name].
	^response]

{ #category : #private }
WebServer >> setUp [
	self registerApplications]

{ #category : #actions }
WebServer >> start [
	self wasStarted ifTrue: [^self].
	self requireFinalization.
	[
		self setUp.
		state := #started]
		ifCurtailed: [
			self stop.
			state := #error.
			^self].
	self print.
	applications do: #aboutToStart.
	[self run] forkNamed: self class name asPhrase]

{ #category : #actions }
WebServer >> stop [
	self isStopped ifTrue: [^self].
	state := #stopping.
	[
		applications do: #aboutToStop.
		self tearDown.
		state := #stopped]
		ifCurtailed: [state := #error]]

{ #category : #private }
WebServer >> tearDown [
	self unregisterApplications]

{ #category : #private }
WebServer >> unregisterApplication: aWebApplication [
	registry removeKey: aWebApplication baseUri ifAbsent: nil]

{ #category : #private }
WebServer >> unregisterApplications [
	applications do: [:app | self unregisterApplication: app].
	registry removeAll]

