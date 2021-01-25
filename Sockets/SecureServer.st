"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SecureServer,
	#superclass : #SocketDaemon,
	#instVars : [
		'connections'
	],
	#category : #sockets
}

{ #category : #accessing }
SecureServer class >> defaultName [
	^'target server']

{ #category : #accessing }
SecureServer class >> defaultPort [
	^62409]

{ #category : #connection }
SecureServer >> close [
	connections do: #close.
	super close]

{ #category : #accessing }
SecureServer >> connections [
	^connections]

{ #category : #accessing }
SecureServer >> defaultName [
	^'server example']

{ #category : #initialization }
SecureServer >> initialize [
	super initialize.
	connections := Dictionary new]

{ #category : #connection }
SecureServer >> startServerNamed: aString on: aSocket [
	aSocket sslAcceptTarget: aString.
	connections at: aSocket descriptor put: aSocket]

{ #category : #connection }
SecureServer >> startServerOn: aSocket [
	^self startServerNamed: self defaultName on: aSocket]

