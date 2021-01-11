"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #InternetFile,
	#superclass : #HTTPConnection,
	#category : #'HTTP\Client'
}

{ #category : #'instance creation' }
InternetFile class >> on: anInterentSession handle: anExternalHandle address: aFilename [
	| file |
	file := self on: anInterentSession handle: anExternalHandle.
	file address: aFilename.
	^file]

{ #category : #services }
InternetFile class >> readFile: url [
	| file |
	file := self new addFlagDontCache; addFlagInternetReload.
	^[| response |
		file address: url.
		response := file request.
		response isNotFound ifFalse: [response data]]
		ensure: [file release]]

{ #category : #initialization }
InternetFile >> initializeFlags [
	super initializeFlags.
	self addFlag: INTERNET_FLAG_PRAGMA_NOCACHE]

{ #category : #testing }
InternetFile >> isInternetFile [
	^true]

{ #category : #'open/close' }
InternetFile >> open [
	]

{ #category : #'os messages' }
InternetFile >> request [
	^self requestWith: nil]

{ #category : #'os messages' }
InternetFile >> requestWith: aString [
	| request url ulong context headers |
	request := self newRequest.
	url := self address externalCopy.
	headers := aString externalCopy.
	context := session isAsynchronous ifTrue: [request token].
	self ASSERT: (semaphore isNil orNot: [semaphore isSignaled]).
	ulong := self dll
		InternetOpenUrl: session asParameter
		lpszUrl: url asParameter
		lpszHeaders: headers asParameter
		dwHeadersLength: -1
		dwFlags: flags
		dwContext: context asParameter.
	ulong = 0 ifTrue: [self winError] ifFalse: [request handle: ulong].
	request wait; wait.
	url free.
	headers free.
	^request response]

{ #category : #configuration }
InternetFile >> useSecureLayer [
	port := INTERNET_DEFAULT_HTTPS_PORT.
	flags := INTERNET_FLAG_SECURE]

