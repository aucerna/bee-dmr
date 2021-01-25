"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SecBufferDesc,
	#superclass : #SocketStructure,
	#classVars : [
		'Offsets'
	],
	#category : #sockets
}

{ #category : #inspecting }
SecBufferDesc class >> aspects [
	^super aspects , #(#buffersArray)]

{ #category : #accessing }
SecBufferDesc class >> def [
	^<def>
	typedef struct _SecBufferDesc {
		ULONG      ulVersion;
		ULONG      cBuffers;
		PSecBuffer pBuffers;
	} SecBufferDesc, *PSecBufferDesc;
	</def>]

{ #category : #initialization }
SecBufferDesc class >> initializeConstants [
	"
	SecBufferDesc initializeConstants
	"
	WindowsConstants at: 'SECBUFFER_VERSION' put: 0]

{ #category : #private }
SecBufferDesc class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 16;
		at: 'ulVersion' put: 0;
		at: 'cBuffers' put: 4;
		at: 'pBuffers' put: 8;
		yourself]

{ #category : #accessing }
SecBufferDesc class >> sizeInBytes [
	^sizeInBytes]

{ #category : #output }
SecBufferDesc >> buffer [
	^SecBuffer atMemory: self pBuffers]

{ #category : #output }
SecBufferDesc >> bufferAt: index [
	| offset |
	offset := SecBuffer sizeInBytes * (index - 1).
	^SecBuffer atMemory: self pBuffers + offset]

{ #category : #private }
SecBufferDesc >> bufferOfType: type [
	1 to: self cBuffers do: [:i | | buffer |
		buffer := self bufferAt: i.
		buffer type = type ifTrue: [^buffer]].
	^nil]

{ #category : #output }
SecBufferDesc >> buffers [
	^BufferArray at: self pBuffers count: self cBuffers type: SecBuffer]

{ #category : #input }
SecBufferDesc >> buffers: aCollection [
	| buffers |
	buffers := BufferArray externalOn: aCollection type: SecBuffer.
	self cBuffers: aCollection size; pBuffers: buffers]

{ #category : #output }
SecBufferDesc >> buffersArray [
	^self buffers asArray]

{ #category : #accessing }
SecBufferDesc >> cBuffers [
	^self uLongAtOffset: cBuffers]

{ #category : #accessing }
SecBufferDesc >> cBuffers: anInteger [
	self uLongAtOffset: cBuffers put: anInteger]

{ #category : #output }
SecBufferDesc >> dataBuffer [
	^self bufferOfType: SECBUFFER_DATA]

{ #category : #input }
SecBufferDesc >> emptyAndToken: aStream [
	| buffer |
	buffer := SecBuffer new token: aStream.
	self buffers: {buffer. SecBuffer new beEmpty}]

{ #category : #output }
SecBufferDesc >> emptyBuffer [
	^self bufferOfType: SECBUFFER_EMPTY]

{ #category : #output }
SecBufferDesc >> extraDataBuffer [
	^self bufferOfType: SECBUFFER_EXTRA]

{ #category : #input }
SecBufferDesc >> forToken [
	self buffers: {SecBuffer new beToken}]

{ #category : #finalization }
SecBufferDesc >> free [
	self buffers do: #free.
	super free]

{ #category : #initialization }
SecBufferDesc >> initialize: anInteger [
	super initialize: anInteger.
	self ulVersion: SECBUFFER_VERSION]

{ #category : #accessing }
SecBufferDesc >> pBuffers [
	^self addressAtOffset: pBuffers]

{ #category : #accessing }
SecBufferDesc >> pBuffers: aSecBuffer [
	self addressAtOffset: pBuffers register: aSecBuffer pointedMemory]

{ #category : #input }
SecBufferDesc >> reset [
	self buffers do: #reset]

{ #category : #output }
SecBufferDesc >> token [
	^self tokenBuffer data]

{ #category : #output }
SecBufferDesc >> tokenBuffer [
	^self bufferOfType: SECBUFFER_TOKEN]

{ #category : #services }
SecBufferDesc >> totalSize [
	^self buffers asArray sum: [:buffer | buffer cbBuffer]]

{ #category : #accessing }
SecBufferDesc >> ulVersion [
	^self uLongAtOffset: ulVersion]

{ #category : #accessing }
SecBufferDesc >> ulVersion: anInteger [
	self uLongAtOffset: ulVersion put: anInteger]

{ #category : #input }
SecBufferDesc >> withToken: aStream [
	self buffers: {SecBuffer new token: aStream}]

