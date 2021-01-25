"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SOCKADDR_IN,
	#superclass : #SOCKADDR,
	#classVars : [
		'Offsets'
	],
	#category : #sockets
}

{ #category : #accessing }
SOCKADDR_IN class >> def [
	^<def>
		typedef struct sockaddr_in {
			short sin_family; // 0
			ushort sin_port; // 2
			in_addr sin_addr; // 4
			char sin_zero[8]; // 8
		} sockaddr_in; // sizeInBytes = 16
	</def>]

{ #category : #accessing }
SOCKADDR_IN class >> inaddr: ipAddr [
	self ASSERT: ipAddr isSymbol not.
	ipAddr == #INADDR_ANY ifTrue: [^INADDR_ANY].
	ipAddr == #INADDR_LOOPBACK ifTrue: [^INADDR_LOOPBACK].
	ipAddr == #INADDR_BROADCAST ifTrue: [^INADDR_BROADCAST].
	ipAddr == #INADDR_NONE ifTrue: [^INADDR_NONE].
	^ipAddr]

{ #category : #'instance creation' }
SOCKADDR_IN class >> inaddr: inaddr port: port [
	| address |
	address := self inaddr: inaddr.
	^self new sin_port: port; sin_addr: address]

{ #category : #'instance creation' }
SOCKADDR_IN class >> ipNumber: ipNumber port: port [
	^self new sin_port: port; sin_addr: ipNumber]

{ #category : #accessing }
SOCKADDR_IN class >> sizeInBytes [
	^sizeInBytes]

{ #category : #output }
SOCKADDR_IN >> address [
	^self sin_addr]

{ #category : #input }
SOCKADDR_IN >> address: anInteger [
	self sin_addr: anInteger]

{ #category : #output }
SOCKADDR_IN >> family [
	^self sin_family]

{ #category : #initialization }
SOCKADDR_IN >> initialize: anInteger [
	super initialize: anInteger.
	self sin_family: AF_INET]

{ #category : #output }
SOCKADDR_IN >> port [
	^self sin_port]

{ #category : #input }
SOCKADDR_IN >> port: anInteger [
	self sin_port: anInteger]

{ #category : #accessing }
SOCKADDR_IN >> sin_addr [
	| data |
	data := self bytesAtOffset: sin_addr count: 4.
	^in_addr fromBytes: data]

{ #category : #accessing }
SOCKADDR_IN >> sin_addr: anInteger [
	| net |
	net := self networkFromLong: anInteger.
	self uLongAtOffset: sin_addr put: net]

{ #category : #accessing }
SOCKADDR_IN >> sin_family [
	^self shortAtOffset: sin_family]

{ #category : #accessing }
SOCKADDR_IN >> sin_family: anInteger [
	self shortAtOffset: sin_family put: anInteger]

{ #category : #accessing }
SOCKADDR_IN >> sin_port [
	| net |
	net := self bytesAtOffset: sin_port count: 2.
	^self hostFromNetwork: net]

{ #category : #accessing }
SOCKADDR_IN >> sin_port: anInteger [
	| net |
	net := self networkFromShort: anInteger.
	self uShortAtOffset: sin_port put: net]

{ #category : #accessing }
SOCKADDR_IN >> sin_zero [
	^self bytesAtOffset: sin_zero count: 16]

