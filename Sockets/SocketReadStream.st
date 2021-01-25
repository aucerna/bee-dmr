"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SocketReadStream,
	#superclass : #ReadStream,
	#instVars : [
		'socket',
		'buffer',
		'timeout',
		'semaphore',
		'critical',
		'eol'
	],
	#category : #sockets
}

{ #category : #private }
SocketReadStream >> aboutToClose [
	self read]

{ #category : #testing }
SocketReadStream >> atEnd [
	^buffer isEmpty
		and: [self isConnected not]
		and: [socket isDataAvailable not]]

{ #category : #private }
SocketReadStream >> beBinary [
	buffer beBinary]

{ #category : #accessing }
SocketReadStream >> bufferSize: anInteger [
	| class |
	class := socket isBinary ifTrue: [ByteArray] ifFalse: [String].
	buffer := CircularBuffer on: (class new: anInteger)]

{ #category : #services }
SocketReadStream >> close [
	socket isOpen ifTrue: [socket close]]

{ #category : #accessing }
SocketReadStream >> collectorClass [
	^buffer collectorClass]

{ #category : #private }
SocketReadStream >> collectorOfSize: n [
	| class |
	class := socket isBinary ifTrue: [ByteArray] ifFalse: [String].
	^class new: n]

{ #category : #private }
SocketReadStream >> dataArrived [
	self read.
	semaphore resume]

{ #category : #accessing }
SocketReadStream >> defaultTimeout [
	^15 seconds]

{ #category : #private }
SocketReadStream >> eol [
	^eol]

{ #category : #accessing }
SocketReadStream >> eol: aString [
	eol := aString]

{ #category : #testing }
SocketReadStream >> hasPendingData [
	^buffer size > 0]

{ #category : #initialization }
SocketReadStream >> initialize [
	super initialize.
	critical := false.
	semaphore := Delay new.
	self timeout: self defaultTimeout]

{ #category : #testing }
SocketReadStream >> isBinary [
	^socket isBinary]

{ #category : #testing }
SocketReadStream >> isConnected [
	^socket isConnected]

{ #category : #testing }
SocketReadStream >> isEmpty [
	self hasPendingData ifTrue: [^false].
	^socket hasPendingData]

{ #category : #accessing }
SocketReadStream >> lineDelimiter [
	^eol first]

{ #category : #accessing }
SocketReadStream >> lineDelimiter: aCharacter [
	eol := (aCharacter isCharacter and: [aCharacter isCr])
		ifTrue: [aCharacter , aCharacter class lf]
		ifFalse: [aCharacter asString]]

{ #category : #reading }
SocketReadStream >> next [
	| data |
	data := self next: 1.
	^data notEmpty ifTrue: [data anyone]]

{ #category : #reading }
SocketReadStream >> next: anInteger [
	| data |
	data := self peek: anInteger.
	buffer discard: data size.
	^data]

{ #category : #accessing }
SocketReadStream >> on: aSocket [
	self socket: aSocket]

{ #category : #reading }
SocketReadStream >> peek [
	| data |
	data := self peek: 1.
	^data notEmpty ifTrue: [data anyone]]

{ #category : #reading }
SocketReadStream >> peek: anInteger [
	| data |
	[anInteger <= buffer size]
		whileFalse: [self waitForDataRetrying: self retries; read].
	data := buffer peek: anInteger.
	data size < anInteger ifTrue: [self readingError].
	^data]

{ #category : #peeking }
SocketReadStream >> peekFor: token [
	^self peek = token ifTrue: [self next]; yourself]

{ #category : #private }
SocketReadStream >> read [
	| data |
	socket isOpen ifFalse: [^self].
	critical ifTrue: [^self].
	critical := true.
	[
		[
			data := socket read.
			data isEmpty]
			whileFalse: [buffer appendAll: data]]
		ensure: [critical := false]]

{ #category : #private }
SocketReadStream >> readAll [
	self read.
	^self next: buffer size]

{ #category : #accessing }
SocketReadStream >> retries [
	^(socket notNil and: [socket isBlocking]) ifTrue: [100] ifFalse: [10]]

{ #category : #accessing }
SocketReadStream >> socket: aSocket [
	socket := aSocket.
	self bufferSize: 4096.
	socket
		when: #readyToRead send: #dataArrived to: self;
		when: #shuttingDown send: #aboutToClose to: self.
	self updateDelayTime]

{ #category : #accessing }
SocketReadStream >> timeout [
	^timeout]

{ #category : #accessing }
SocketReadStream >> timeout: aDuration [
	timeout := aDuration.
	self updateDelayTime]

{ #category : #private }
SocketReadStream >> updateDelayTime [
	semaphore duration: timeout // self retries]

{ #category : #private }
SocketReadStream >> waitForData [
	self hasPendingData ifFalse: [self waitForDataRetrying: nil]]

{ #category : #private }
SocketReadStream >> waitForDataRetrying: times [
	| n retries |
	n := buffer size.
	retries := times ifNil: [SmallInteger maximum].
	[
		retries <= 0 ifTrue: [Timeout signal].
		socket isOpen and: [socket bytesToRead = 0] and: [buffer size = n]]
		whileTrue: [
			semaphore wait.
			retries := retries - 1]]

