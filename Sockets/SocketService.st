"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SocketService,
	#superclass : #Object,
	#category : #sockets
}

{ #category : #accessing }
SocketService class >> defaultPort [
	^nil]

{ #category : #accessing }
SocketService class >> errorClass [
	^SocketError]

{ #category : #testing }
SocketService class >> isValid: hostName [
	| return |
	CursorPointer execute
		showWhile: [return := [SOCKADDR forHost: hostName port: self defaultPort]
			on: SocketError
			do: []].
	^return notNil]

{ #category : #'instance creation' }
SocketService class >> new [
	^super new initialize]

{ #category : #private }
SocketService class >> newSocket [
	^self socketClass new]

{ #category : #services }
SocketService class >> open [
	^self openOnSocket: self newSocket]

{ #category : #services }
SocketService class >> openOnHost: hostName [
	^self openOnHost: hostName port: self defaultPort]

{ #category : #services }
SocketService class >> openOnHost: hostname port: port [
	| socket |
	socket := self socketOn: hostname port: port.
	^self openOnSocket: socket]

{ #category : #services }
SocketService class >> openOnSocket: aSocket [
	^self new openOnSocket: aSocket]

{ #category : #private }
SocketService class >> socketClass [
	^Socket currentClass]

{ #category : #services }
SocketService class >> socketOn: hostname port: port [
	^self newSocket host: hostname; port: port]

{ #category : #accessing }
SocketService >> errorClass [
	^self class errorClass]

{ #category : #startup }
SocketService >> openOnSocket: aSocket [
	self registerHandlersFor: aSocket.
	aSocket isOpen ifFalse: [aSocket open]]

{ #category : #'register events' }
SocketService >> registerHandlersFor: aSocket [
	aSocket when: #shuttingDown send: #shuttingDown: to: self with: aSocket]

{ #category : #'remote accessing' }
SocketService >> shuttingDown: aSocket [
	self subclassResponsibility]

{ #category : #connection }
SocketService >> start [
	]

{ #category : #startup }
SocketService >> start: aSocket [
	aSocket nonBlocking]

