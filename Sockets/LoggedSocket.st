"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #LoggedSocket,
	#superclass : #Socket,
	#instVars : [
		'logging'
	],
	#classVars : [
		'Reading',
		'Writing'
	],
	#category : #sockets
}

{ #category : #initialization }
LoggedSocket class >> initialize [
	super initialize.
	Reading := Set new.
	Writing := Set new]

{ #category : #initialization }
LoggedSocket >> initialize [
	super initialize.
	logging := false]

{ #category : #events }
LoggedSocket >> log: aString [
	SmalltalkSession current log: aString]

{ #category : #events }
LoggedSocket >> logCritical: aString [
	SmalltalkSession current log: 'CRITICAL: ' , aString]

{ #category : #private }
LoggedSocket >> logReadWhile: aBlock [
	logging := #reading.
	[
		self readingLogFile appendStream
			nextPutAll: 'XXXXX' , Timestamp now ddmmyyyyhhmmssms;
			close] evaluateAtomically.
	aBlock ensure: [logging := false]]

{ #category : #private }
LoggedSocket >> logWriteWhile: aBlock [
	logging := #writing.
	[
		self writingLogFile appendStream
			nextPutAll: 'XXXXX' , Timestamp now ddmmyyyyhhmmssms;
			close] evaluateAtomically.
	aBlock ensure: [logging := false]]

{ #category : #private }
LoggedSocket >> readingLogFile [
	| file |
	file := self propertyAt: #readingLogFile ifAbsentPut: [| entity fn |
		entity := 'loggingREAD-' , KernelLibrary GetCurrentProcessId printString
			, '-'
			, descriptor printString.
		fn := SmalltalkSession current logsDirectory filename \ entity
			withExtension: 'log'.
		fn asFile].
	file exists ifFalse: [file create].
	^file]

{ #category : #private }
LoggedSocket >> readInto: data
startingAt: anInteger
length: length
flags: flags [
	| return fragment |
	(Reading includes: self)
		ifTrue: [self logCritical: 'Read while reading ' , descriptor printString].
	Reading add: self.
	[return := super
		readInto: data
		startingAt: anInteger
		length: length
		flags: flags]
		ensure: [
			Reading remove: self ifAbsent: [
				self
					logCritical: 'Socket ' , descriptor printString
						, ' already removed from Read']].
	logging == #reading ifTrue: [
		fragment := data copyFrom: anInteger to: return + anInteger - 1.
		self readingLogFile appendStream nextPutAll: fragment; close].
	^return]

{ #category : #private }
LoggedSocket >> receiveInBuffer: anExternalMemory length: length flags: flags [
	| return |
	return := super
		receiveInBuffer: anExternalMemory
		length: length
		flags: flags.
	self log: 'read ' , return printString.
	^return]

{ #category : #private }
LoggedSocket >> sendBuffer: data length: length flags: flags [
	| return fragment |
	(Writing includes: self)
		ifTrue: [self
			logCritical: 'Write while writing on' , descriptor printString].
	Writing add: self.
	[return := super sendBuffer: data length: length flags: flags] ensure: [
		Writing remove: self ifAbsent: [
			self
				logCritical: 'Socket ' , descriptor printString
					, ' already removed from Write']].
	logging == #writing ifTrue: [
		fragment := data copyFrom: 1 to: return.
		self writingLogFile appendStream nextPutAll: fragment; close].
	self log: 'sent ' , return printString.
	^return]

{ #category : #errors }
LoggedSocket >> socketError: code [
	| c |
	c := code = WSAEWOULDBLOCK
		ifTrue: ['WSAEWOULDBLOCKREAD']
		ifFalse: [code asString].
	self log: 'SocketError: ' , c.
	^super socketError: code]

{ #category : #private }
LoggedSocket >> writingLogFile [
	| file |
	file := self propertyAt: #writingLogFile ifAbsentPut: [| entity fn |
		entity := 'loggingWRITE-' , KernelLibrary GetCurrentProcessId printString
			, '-'
			, descriptor printString.
		fn := SmalltalkSession current logsDirectory filename \ entity
			withExtension: 'log'.
		fn asFile].
	file exists ifFalse: [file create].
	^file]

