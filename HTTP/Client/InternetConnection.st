"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #InternetConnection,
	#superclass : #InternetSessionObject,
	#instVars : [
		'server',
		'port',
		'service',
		'requests'
	],
	#category : #'HTTP\Client'
}

{ #category : #'open/close' }
InternetConnection >> close [
	requests select: #notNil thenDo: #close; removeAll.
	super close ifFalse: [^false].
	session notNil ifTrue: [session forgetConnection: self]]

{ #category : #accessing }
InternetConnection >> directoryNames [
	^Array
		streamContents: [:strm | self directoryNamesDo: [:dir | strm nextPut: dir]]]

{ #category : #enumerating }
InternetConnection >> directoryNamesDo: aBlock [
	self
		fileFinderDo: [:finder | finder isDirectory
			ifTrue: [aBlock value: finder entityName]]]

{ #category : #enumerating }
InternetConnection >> fileFinderDo: aBlock [
	self fileFinderFor: '*.*' do: [:finder | aBlock value: finder]]

{ #category : #private }
InternetConnection >> fileFinderFor: aFilename [
	^InternetFileFinder on: self pattern: aFilename]

{ #category : #enumerating }
InternetConnection >> fileFinderFor: aString do: aBlock [
	| finder |
	finder := self fileFinderFor: aString.
	finder do: aBlock]

{ #category : #enumerating }
InternetConnection >> fileNames [
	^OrderedCollection from: self iterator: #fileNamesDo:]

{ #category : #enumerating }
InternetConnection >> fileNamesDo: aBlock [
	self
		fileFinderDo: [:finder | finder isFile
			ifTrue: [aBlock value: finder entityName]]]

{ #category : #enumerating }
InternetConnection >> findFirst: aString [
	^(self fileFinderFor: aString) findAnyone]

{ #category : #accessing }
InternetConnection >> flags: anInteger [
	flags := anInteger]

{ #category : #'open/close' }
InternetConnection >> forgetRequest: anHTTPRequest [
	requests replace: anHTTPRequest with: nil]

{ #category : #configuration }
InternetConnection >> ftp [
	service := INTERNET_SERVICE_FTP]

{ #category : #testing }
InternetConnection >> hasDirectoryNamed: aString [
	| finder result |
	finder := self fileFinderFor: aString.
	result := finder findAnyone.
	^result notNil and: [result isDirectory]]

{ #category : #testing }
InternetConnection >> hasFileNamed: aString [
	| finder result |
	finder := self fileFinderFor: aString.
	result := finder findAnyone.
	^result notNil and: [result isFile]]

{ #category : #configuration }
InternetConnection >> http [
	service := INTERNET_SERVICE_HTTP]

{ #category : #initialization }
InternetConnection >> initialize [
	super initialize.
	self
		initializeServer;
		initializePort;
		initializeService;
		initializeFlags.
	requests := OrderedCollection new]

{ #category : #initialization }
InternetConnection >> initializeFlags [
	flags := 0]

{ #category : #initialization }
InternetConnection >> initializePort [
	port := INTERNET_INVALID_PORT_NUMBER]

{ #category : #initialization }
InternetConnection >> initializeServer [
	server := 'LocalHost']

{ #category : #initialization }
InternetConnection >> initializeService [
	self http]

{ #category : #testing }
InternetConnection >> isInternetFile [
	^false]

{ #category : #'open/close' }
InternetConnection >> open [
	| srvr user password pointer context |
	srvr := server externalCopy.
	user := self user externalCopy.
	password := self password externalCopy.
	session isAsynchronous ifTrue: [context := token].
	pointer := self dll
		InternetConnect: session asParameter
		lpszServerName: srvr asParameter
		nServerPort: port asParameter
		lpszUserName: user asParameter
		lpszPassword: password asParameter
		dwService: service asParameter
		dwFlags: flags asParameter
		dwContext: context asParameter.
	pointer = 0 ifTrue: [self winError].
	self wait.
	srvr free.
	user free.
	password free.
	pointer = 0 ifFalse: [self handle: pointer]]

{ #category : #accessing }
InternetConnection >> password [
	^nil]

{ #category : #accessing }
InternetConnection >> port [
	^port]

{ #category : #accessing }
InternetConnection >> port: anInteger [
	port := anInteger]

{ #category : #accessing }
InternetConnection >> requestAt: anInteger [
	^requests at: anInteger ifAbsent: [Error signal: 'unknown request']]

{ #category : #accessing }
InternetConnection >> server [
	^server]

{ #category : #accessing }
InternetConnection >> server: url [
	server := url]

{ #category : #accessing }
InternetConnection >> user [
	^nil]

