"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #InternetSessionObject,
	#superclass : #Win32InternetObject,
	#instVars : [
		'session',
		'flags',
		'token',
		'semaphore',
		'error',
		'closing'
	],
	#category : #'HTTP\Client'
}

{ #category : #'instance creation' }
InternetSessionObject class >> on: anInterentSession [
	^self new session: anInterentSession]

{ #category : #'instance creation' }
InternetSessionObject class >> on: anInterentSession handle: anExternalHandle [
	^self new session: anInterentSession; handle: anExternalHandle]

{ #category : #configuration }
InternetSessionObject >> addFlag: anInteger [
	flags := flags | anInteger]

{ #category : #'open/close' }
InternetSessionObject >> close [
	| result |
	self isValid ifFalse: [^true].
	self ASSERT: (semaphore isNil orNot: [semaphore isSignaled]).
	closing := true.
	result := self dll InternetCloseHandle: self asParameter.
	result ifFalse: [self winError].
	self wait; invalidate; ignoreFinalization.
	^result]

{ #category : #services }
InternetSessionObject >> closed [
	closing ifTrue: [self signal].
	self invalidate]

{ #category : #services }
InternetSessionObject >> error: aNumber [
	semaphore isNil ifTrue: [self winError: aNumber] ifFalse: [
		self log: 'ERROR ' , aNumber asString.
		error := aNumber.
		self signal]]

{ #category : #accessing }
InternetSessionObject >> flags [
	^flags]

{ #category : #initialization }
InternetSessionObject >> initialize [
	super initialize.
	flags := 0.
	closing := false]

{ #category : #services }
InternetSessionObject >> log: aString [
	session log: aString , ' - ' , self class name , ' - ' , token printString]

{ #category : #accessing }
InternetSessionObject >> session [
	^session]

{ #category : #accessing }
InternetSessionObject >> session: anInternetSession [
	session := anInternetSession.
	(semaphore isNil orNot: [semaphore isSignaled])
		ifFalse: [self error: 'cannot change the current internet session'].
	semaphore := session isAsynchronous ifTrue: [Semaphore new]]

{ #category : #services }
InternetSessionObject >> signal [
	semaphore notNil ifTrue: [
		self log: 'SIGNAL(' , semaphore asString , ')'.
		semaphore signal]]

{ #category : #accessing }
InternetSessionObject >> token [
	^token]

{ #category : #accessing }
InternetSessionObject >> token: anHTTP_REQUEST_TOKEN [
	token := anHTTP_REQUEST_TOKEN externalCopy]

{ #category : #services }
InternetSessionObject >> wait [
	| e |
	semaphore notNil ifTrue: [
		self log: 'WAIT(' , semaphore asString , ')'.
		semaphore wait.
		error notNil ifTrue: [
			e := error.
			error := nil.
			self winError: e]]]

{ #category : #errors }
InternetSessionObject >> winError: anInteger [
	(anInteger = ERROR_IO_PENDING and: [session isAsynchronous]) ifTrue: [^self].
	super winError: anInteger]

