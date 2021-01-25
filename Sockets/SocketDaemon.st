"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SocketDaemon,
	#superclass : #SocketService,
	#instVars : [
		'socket'
	],
	#category : #sockets
}

{ #category : #private }
SocketDaemon class >> newSocket [
	^self socketClass newDaemon port: self defaultPort; yourself]

{ #category : #connection }
SocketDaemon >> accept: aSocket [
	self startServerOn: aSocket accept]

{ #category : #connection }
SocketDaemon >> close [
	socket notNil ifTrue: [socket close]]

{ #category : #accessing }
SocketDaemon >> defaultPort [
	^self class defaultPort]

{ #category : #testing }
SocketDaemon >> isOpen [
	^socket notNil and: [socket isOpen]]

{ #category : #accessing }
SocketDaemon >> port [
	^socket port]

{ #category : #'register events' }
SocketDaemon >> registerHandlersFor: aSocket [
	super registerHandlersFor: aSocket.
	aSocket when: #readyToAccept send: #accept: to: self with: aSocket]

{ #category : #accessing }
SocketDaemon >> serverClass [
	^SocketService]

{ #category : #'remote accessing' }
SocketDaemon >> shuttingDown: aSocket [
	self close]

{ #category : #startup }
SocketDaemon >> start [
	super start.
	self start: socket]

{ #category : #startup }
SocketDaemon >> start: aSocket [
	super start: aSocket.
	socket bind; listen]

{ #category : #connection }
SocketDaemon >> startServerOn: aSocket [
	self subclassResponsibility]

