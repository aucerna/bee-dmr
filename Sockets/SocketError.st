"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SocketError,
	#superclass : #Win32Error,
	#category : #sockets
}

{ #category : #accessing }
SocketError class >> descriptionFor: anInteger [
	^(self new code: anInteger) errorMessage]

{ #category : #services }
SocketError class >> ignoreErrorsWhile: aBlock [
	| saved p |
	saved := defaultAction.
	p := ActiveProcess.
	defaultAction := [:e | 
		e activeHandler
			ifNil: [
				(ActiveProcess !== p andNot: [e isResumable])
					ifTrue: [ActiveProcess terminate]]
			ifNotNil: [:h | h return: nil]].
	aBlock ensure: [defaultAction := saved]]

{ #category : #signaling }
SocketError class >> signal [
	self shouldNotImplement]

{ #category : #signaling }
SocketError class >> signal: aString [
	self shouldNotImplement]

{ #category : #signaling }
SocketError class >> signalOSCode: anInteger [
	^self new code: anInteger; signal]

{ #category : #accessing }
SocketError >> code: anInteger [
	code := anInteger.
	code < 10000 ifTrue: [code := 10000 + code].
	code = 10001 ifTrue: [description := 'EPERM: Not owner'].
	code = 10003 ifTrue: [description := 'ESRCH: No such process'].
	code = 10006 ifTrue: [description := 'ENXIO: Not such device or address']]

{ #category : #private }
SocketError >> errorMessage [
	description notNil ifTrue: [^description].
	^KernelDLL current formatMessage: code fromModule: Ws2_32DLL]

{ #category : #testing }
SocketError >> isNormalInNonBlockingCall [
	^code = WSAEWOULDBLOCK or: [code = WSAEINPROGRESS]]

