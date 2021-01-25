"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SocketWriteStream,
	#superclass : #WriteStream,
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

{ #category : #'instance creation' }
SocketWriteStream class >> on: aSocket [
	^self new socket: aSocket]

{ #category : #services }
SocketWriteStream >> aboutToClose [
	[self write] on: SocketError do: []]

{ #category : #private }
SocketWriteStream >> beBinary [
	buffer beBinary]

{ #category : #private }
SocketWriteStream >> bufferSize: anInteger [
	self bufferSize: anInteger binary: socket isBinary]

{ #category : #private }
SocketWriteStream >> bufferSize: anInteger binary: aBoolean [
	| class |
	class := aBoolean ifTrue: [ByteArray] ifFalse: [String].
	buffer := CircularBuffer on: (class new: anInteger)]

{ #category : #services }
SocketWriteStream >> close [
	super close.
	socket isOpen ifTrue: [socket close]]

{ #category : #accessing }
SocketWriteStream >> collectorClass [
	^buffer collectorClass]

{ #category : #private }
SocketWriteStream >> eol [
	^eol]

{ #category : #accessing }
SocketWriteStream >> eol: aString [
	eol := aString]

{ #category : #writing }
SocketWriteStream >> flush [
	[buffer isEmpty] whileFalse: [self write]]

{ #category : #services }
SocketWriteStream >> flushPossible [
	semaphore resume]

{ #category : #initialization }
SocketWriteStream >> initialize [
	super initialize.
	timeout := 30.
	critical := false.
	semaphore := Delay forMilliseconds: 100]

{ #category : #testing }
SocketWriteStream >> isBinary [
	^buffer isBinary]

{ #category : #accessing }
SocketWriteStream >> lineDelimiter [
	^eol first]

{ #category : #accessing }
SocketWriteStream >> lineDelimiter: aCharacter [
	eol := (aCharacter isCharacter and: [aCharacter isCr])
		ifTrue: [aCharacter , aCharacter class lf]
		ifFalse: [aCharacter asString]]

{ #category : #writing }
SocketWriteStream >> nextPut: anObject [
	buffer isFull ifTrue: [self flush].
	buffer append: anObject]

{ #category : #writing }
SocketWriteStream >> nextPutAll: aCollection [
	self putBytesFrom: aCollection from: 1 to: aCollection length]

{ #category : #writing }
SocketWriteStream >> putBytesFrom: aByteArray from: start to: stop [
	| first last |
	buffer isFull ifTrue: [self flush].
	first := start.
	[
		last := first + buffer freeSlots - 1 min: stop.
		buffer append: aByteArray from: first to: last.
		self flush.
		last < stop]
		whileTrue: [first := last + 1]]

{ #category : #accessing }
SocketWriteStream >> socket: aSocket [
	socket := aSocket.
	self bufferSize: 4096.
	socket
		when: #readyToWrite send: #flushPossible to: self;
		when: #shuttingDown send: #aboutToClose to: self.
	self updateDelayTime]

{ #category : #accessing }
SocketWriteStream >> updateDelayTime [
	semaphore milliseconds: (socket isBlocking ifTrue: [10] ifFalse: [100])]

{ #category : #private }
SocketWriteStream >> write [
	| n data |
	critical ifTrue: [^self].
	critical := true.
	[
		data := buffer removeAll.
		data size = 0 ifTrue: [^self].
		n := 0.
		[
			[n := socket write: data]
				on: SocketError
				do: [:ex | ex isNormalInNonBlockingCall
					ifTrue: [ex return: 0]
					ifFalse: [ex pass]].
			n < data size]
			whileTrue: [
				data := data copyFrom: n + 1 to: data size.
				semaphore wait]]
		ensure: [critical := false].
	^n]

{ #category : #private }
SocketWriteStream >> writeAfter: aBlock [
	| try |
	try := buffer isEmpty.
	aBlock value.
	try ifTrue: [self write]]

