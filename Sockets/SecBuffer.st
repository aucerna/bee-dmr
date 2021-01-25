"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SecBuffer,
	#superclass : #SocketStructure,
	#classVars : [
		'Offsets'
	],
	#category : #sockets
}

{ #category : #accessing }
SecBuffer class >> def [
	^<def>
	typedef struct _SecBuffer {
		ULONG cbBuffer;
		ULONG BufferType;
		PVOID pvBuffer;
	} SecBuffer, *PSecBuffer;
	</def>]

{ #category : #initialization }
SecBuffer class >> initializeConstants [
	"
	SecBuffer initializeConstants
	"
	WindowsConstants
		at: 'SECBUFFER_ALERT'
		put: 16r11
		"The buffer contains an alert message.";
		at: 'SECBUFFER_ATTRMASK'
		put: 16rF0000000
		"The buffer contains a bitmask for a SECBUFFER_READONLY_WITH_CHECKSUM buffer.";
		at: 'SECBUFFER_CHANNEL_BINDINGS'
		put: 16rE
		"The buffer contains channel binding information.";
		at: 'SECBUFFER_CHANGE_PASS_RESPONSE'
		put: 16rF
		"The buffer contains a DOMAIN_PASSWORD_INFORMATION structure.";
		at: 'SECBUFFER_DATA'
		put: 16r1
		"This buffer type is used for common data. The security package can read and write this data, for example, to encrypt some or all of it.";
		at: 'SECBUFFER_EMPTY'
		put: 16r0
		"This is a placeholder in the buffer array. The caller can supply several such entries in the array, and the security package can return information in them. For more information, see SSPI Context Semantics.";
		at: 'SECBUFFER_EXTRA'
		put: 16r5
		"The security package uses this value to indicate the number of extra or unprocessed bytes in a message.";
		at: 'SECBUFFER_MECHLIST'
		put: 16rB
		"This buffer type indicates a protocol-specific list of object identifiers (OIDs). It is not usually of interest to callers.";
		at: 'SECBUFFER_MECHLIST_SIGNATURE'
		put: 16rC
		"The buffer contains a signature of a SECBUFFER_MECHLIST buffer. It is not usually of interest to callers.";
		at: 'SECBUFFER_MISSING'
		put: 16r4
		"The security package uses this value to indicate the number of missing bytes in a particular message. The pvBuffer member is ignored in this type.";
		at: 'SECBUFFER_PKG_PARAMS'
		put: 16r3
		"These are transport-to-packagespecific parameters. For example, the NetWare redirector may supply the server object identifier, while DCE RPC can supply an association UUID, and so on.";
		at: 'SECBUFFER_STREAM_HEADER'
		put: 16r7
		"This buffer type indicates a protocol-specific header for a particular record. It is not usually of interest to callers.";
		at: 'SECBUFFER_STREAM_TRAILER'
		put: 16r6
		"This buffer type indicates a protocol-specific trailer for a particular record. It is not usually of interest to callers.";
		at: 'SECBUFFER_TARGET'
		put: 16rD
		"This flag is reserved. Do not use it.";
		at: 'SECBUFFER_TARGET_HOST'
		put: 16r10
		"The buffer specifies the service principal name (SPN) of the target.

This value is supported by the Digest security package when used with channel bindings.

Windows Server 2008, Windows Vista, Windows Server 2003, and Windows XP:  This value is not supported.";
		at: 'SECBUFFER_TOKEN'
		put: 16r2
		"This buffer type is used to indicate the security token portion of the message. This is read-only for input parameters or read/write for output parameters.";
		at: 'SECBUFFER_APPLICATION_PROTOCOLS'
		put: 16r12
		"This buffer is used to pass a list of application protocol IDs, one list per application protocol negotiation extension type to be enabled."]

{ #category : #private }
SecBuffer class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 16;
		at: 'cbBuffer' put: 0;
		at: 'BufferType' put: 4;
		at: 'pvBuffer' put: 8;
		yourself]

{ #category : #accessing }
SecBuffer class >> sizeInBytes [
	^sizeInBytes]

{ #category : #input }
SecBuffer >> beData [
	self type: SECBUFFER_DATA]

{ #category : #input }
SecBuffer >> beEmpty [
	self type: SECBUFFER_EMPTY]

{ #category : #input }
SecBuffer >> beToken [
	self type: SECBUFFER_TOKEN]

{ #category : #accessing }
SecBuffer >> BufferType [
	^self uLongAtOffset: BufferType]

{ #category : #accessing }
SecBuffer >> BufferType: anInteger [
	self uLongAtOffset: BufferType put: anInteger]

{ #category : #accessing }
SecBuffer >> cbBuffer [
	^self uLongAtOffset: cbBuffer]

{ #category : #accessing }
SecBuffer >> cbBuffer: anInteger [
	self uLongAtOffset: cbBuffer put: anInteger]

{ #category : #output }
SecBuffer >> data [
	^self pvBuffer copyFrom: 1 to: self cbBuffer]

{ #category : #finalization }
SecBuffer >> free [
	| memory |
	memory := self pvBuffer.
	memory isValid
		ifTrue: [Secur32DLL current FreeContextBuffer: memory asParameter].
	self pvBuffer: ExternalMemory new.
	super free]

{ #category : #finalization }
SecBuffer >> freeSecBuffer: aSecBuffer [
	| return |
	return := Secur32DLL current
		FreeContextBuffer: aSecBuffer pvBuffer asParameter.
	return = SEC_E_OK ifFalse: [self winError].
	aSecBuffer pvBuffer: 0; cbBuffer: 0]

{ #category : #testing }
SecBuffer >> isToken [
	^self type = SECBUFFER_TOKEN]

{ #category : #accessing }
SecBuffer >> printOn: aStream [
	super printOn: aStream.
	aStream
		space;
		nextPut: $[;
		nextPutAll: self typeString;
		nextPut: $(;
		nextPutAll: self cbBuffer asString;
		nextPut: $);
		nextPut: $]]

{ #category : #accessing }
SecBuffer >> pvBuffer [
	^self addressAtOffset: pvBuffer]

{ #category : #accessing }
SecBuffer >> pvBuffer: anExternalMemory [
	self addressAtOffset: pvBuffer put: anExternalMemory pointedMemory]

{ #category : #input }
SecBuffer >> reset [
	self free; cbBuffer: 0]

{ #category : #input }
SecBuffer >> token: aStream [
	self beToken; cbBuffer: aStream size; pvBuffer: aStream collection]

{ #category : #output }
SecBuffer >> type [
	^self BufferType]

{ #category : #input }
SecBuffer >> type: anInteger [
	self BufferType: anInteger]

{ #category : #accessing }
SecBuffer >> typeString [
	| type |
	type := self type.
	type = SECBUFFER_TOKEN ifTrue: [^'SECBUFFER_TOKEN'].
	type = SECBUFFER_DATA ifTrue: [^'SECBUFFER_DATA'].
	type = SECBUFFER_EMPTY ifTrue: [^'SECBUFFER_EMPTY'].
	type = SECBUFFER_PKG_PARAMS ifTrue: [^'SECBUFFER_PKG_PARAMS'].
	type = SECBUFFER_MISSING ifTrue: [^'SECBUFFER_MISSING'].
	type = SECBUFFER_EXTRA ifTrue: [^'SECBUFFER_EXTRA'].
	type = SECBUFFER_STREAM_TRAILER ifTrue: [^'SECBUFFER_STREAM_TRAILER'].
	type = SECBUFFER_STREAM_HEADER ifTrue: [^'SECBUFFER_STREAM_HEADER'].
	^'UNKNOWN TYPE']

