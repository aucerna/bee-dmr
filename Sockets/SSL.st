"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SSL,
	#superclass : #Object,
	#instVars : [
		'socket',
		'credentials',
		'context',
		'input',
		'inBuffer',
		'outBuffer',
		'status',
		'info',
		'certificate',
		'package',
		'target',
		'missing'
	],
	#category : #sockets
}

{ #category : #'instance creation' }
SSL class >> acceptOn: aSocket [
	| ssl |
	ssl := self new.
	ssl socket: aSocket; accept.
	^ssl]

{ #category : #'instance creation' }
SSL class >> acceptOn: aSocket target: aString [
	| ssl |
	ssl := self new.
	ssl socket: aSocket; target: aString; accept.
	^ssl]

{ #category : #'instance creation' }
SSL class >> startOn: aSocket [
	| ssl |
	ssl := self new.
	ssl socket: aSocket; start.
	^ssl]

{ #category : #'instance creation' }
SSL class >> startOn: aSocket target: aString [
	"
	SSL startOn: (Socket2 connectedTo: 'smtp.gmail.com' port: 465) target: 'smtp.gmail.com'
	"
	| ssl |
	ssl := self new.
	ssl socket: aSocket; target: aString; start.
	^ssl]

{ #category : #connection }
SSL >> accept [
	| cert struct |
	package := Secur32DLL current availablePackages
		detect: [:pckg | pckg name = 'Schannel'].
	cert := Crypt32DLL current getCertificateNamed: target currentUser: true.
	struct := SCHANNEL_CRED external.
	struct grbitEnabledProtocols: 0; contexts: {cert}.
	credentials := Secur32DLL current
		acquireServerCredentialsNamed: 'Schannel'
		data: struct.
	self allocateInputBuffer; serverHandshake.
	status = SEC_E_OK ifFalse: [^self winError].
	info := self connectionInfo.
	self allocateBuffers.
	struct free]

{ #category : #connection }
SSL >> acceptSecurityContext: aSecBufferDesc [
	| attributes next return |
	attributes := ExternalInt32 external.
	next := CtxtHandle external.
	return := Secur32DLL current
		AcceptSecurityContextW: credentials asParameter
		phContext: context asParameter
		pInput: inBuffer asParameter
		fContextReq: ASC_REQ_ALLOCATE_MEMORY | ASC_REQ_CONFIDENTIALITY
			| ASC_REQ_EXTENDED_ERROR
			| ASC_REQ_REPLAY_DETECT
			| ASC_REQ_SEQUENCE_DETECT
			| ASC_REQ_STREAM
		TargetDataRep: 0
		phNewContext: next asParameter
		pOutput: aSecBufferDesc asParameter
		pfContextAttr: attributes asParameter
		ptsTimeStamp: 0.
	context isNil ifTrue: [context := next].
	attributes free.
	^return]

{ #category : #accessing }
SSL >> aiHash [
	| cipher |
	info isNil ifTrue: [^nil].
	cipher := info aiHash.
	cipher = CALG_MD5 ifTrue: [^'MD5'].
	cipher = CALG_SHA ifTrue: [^'SHA'].
	^'Other']

{ #category : #private }
SSL >> allocateBuffers [
	| size |
	size := self maxBufferLength.
	inBuffer := size externalBytes writeStream.
	outBuffer := size externalBytes writeStream]

{ #category : #private }
SSL >> allocateInputBuffer [
	| memory |
	memory := ExternalMemory allocate: 16r10000.
	input := memory writeStream]

{ #category : #finalization }
SSL >> applyShutdownToken [
	| token out success sent |
	token := ExternalInt32 external fromInteger: SCHANNEL_SHUTDOWN.
	out := SecBufferDesc external forToken.
	out buffer cbBuffer: 1; pvBuffer: token asParameter.
	success := Secur32DLL current applyControlToken: context buffer: out.
	token free.
	token := nil.
	success ifTrue: [
		status := self initializeSecurityContext: out.
		token := out token.
		self freeSecBuffer: out buffer.
		sent := socket write: token.
		self ASSERT: sent = token size].
	^success]

{ #category : #connection }
SSL >> authenticateServer [
	certificate := self serverCertificate]

{ #category : #accessing }
SSL >> cipher [
	| cipher |
	info isNil ifTrue: [^nil].
	cipher := info aiCipher.
	cipher = CALG_RC4 ifTrue: [^'RC4'].
	cipher = CALG_3DES ifTrue: [^'Triple DES'].
	cipher = CALG_RC2 ifTrue: [^'RC2'].
	cipher = CALG_DES ifTrue: [^'DES'].
	cipher = CALG_AES ifTrue: [^'Advanced Encryption Standard (AES)'].
	^'Other']

{ #category : #finalization }
SSL >> cleanup [
	self deleteContext; freeCredentials; free]

{ #category : #private }
SSL >> connectionInfo [
	^self
		contextAttribute: SECPKG_ATTR_CONNECTION_INFO
		in: SecPkgContext_ConnectionInfo]

{ #category : #private }
SSL >> contextAttribute: attribute in: aClass [
	| struct return |
	struct := aClass external.
	return := Secur32DLL current
		QueryContextAttributes: context asParameter
		ulAttribute: attribute
		pBuffer: struct asParameter.
	^return = SEC_E_OK
		ifTrue: [struct makeLocal]
		ifFalse: [self winError: return]]

{ #category : #private }
SSL >> credentialsAttribute: attribute in: aClass [
	| struct return |
	struct := aClass external.
	return := Secur32DLL current
		QueryCredentialsAttributes: credentials asParameter
		ulAttribute: attribute
		pBuffer: struct asParameter.
	^return = SEC_E_OK ifTrue: [struct makeLocal]]

{ #category : #services }
SSL >> decrypt: aStream [
	| decrypt |
	decrypt := ByteArray writeStream.
	self decrypt: aStream on: decrypt.
	^decrypt contents]

{ #category : #services }
SSL >> decrypt: aStream on: resultStream [
	| done |
	done := false.
	[done] whileFalse: [| message |
		message := self decryptMessage: aStream.
		status = SEC_E_INCOMPLETE_MESSAGE ifTrue: [
			missing := message buffersArray first cbBuffer.
			^self].
		resultStream nextPutAll: message dataBuffer data.
		message extraDataBuffer
			ifNil: [
				aStream position: 0; truncate.
				done := true]
			ifNotNil: [:extra | | n |
				n := extra cbBuffer.
				extra pvBuffer move: n bytesTo: aStream collection.
				aStream position: n; truncate]]]

{ #category : #private }
SSL >> decryptMessage: aStream [
	| data buffers message |
	data := SecBuffer new
		beData;
		pvBuffer: aStream collection;
		cbBuffer: aStream position.
	buffers := {data. SecBuffer new beEmpty. SecBuffer new beEmpty.
		SecBuffer new beEmpty}.
	message := SecBufferDesc external.
	message buffers: buffers.
	status := Secur32DLL current decrypt: context message: message.
	status = SEC_E_UNSUPPORTED_FUNCTION ifTrue: [^nil].
	^message]

{ #category : #finalization }
SSL >> deleteContext [
	| return |
	context isNil ifTrue: [^self].
	return := Secur32DLL current DeleteSecurityContext: context asParameter.
	return = SEC_E_OK ifFalse: [self winError].
	context := nil]

{ #category : #finalization }
SSL >> disconnectFromServer [
	status = SEC_E_OK ifTrue: [self applyShutdownToken].
	self cleanup]

{ #category : #services }
SSL >> encrypt: aString [
	| sizes header trailer array message |
	sizes := self streamSizes.
	header := sizes cbHeader.
	trailer := sizes cbTrailer.
	outBuffer position: header; nextPutAll: aString.
	message := SecBufferDesc external.
	array := Array new: 4.
	array
		at: 1 put: (SecBuffer new
			type: SECBUFFER_STREAM_HEADER;
			pvBuffer: outBuffer collection;
			cbBuffer: header);
		at: 2 put: (SecBuffer new
			type: SECBUFFER_DATA;
			pvBuffer: outBuffer collection + header;
			cbBuffer: aString size);
		at: 3 put: (SecBuffer new
			type: SECBUFFER_STREAM_TRAILER;
			pvBuffer: outBuffer collection + header + aString size;
			cbBuffer: trailer);
		at: 4 put: SecBuffer new beEmpty.
	message buffers: array.
	Secur32DLL current encrypt: context message: message.
	^outBuffer position: message totalSize; truncate; contents]

{ #category : #finalization }
SSL >> free [
	inBuffer collection free.
	outBuffer collection free.
	input notNil ifTrue: [
		input collection free.
		input := nil]]

{ #category : #finalization }
SSL >> freeCredentials [
	| return |
	credentials isNil ifTrue: [^self].
	return := Secur32DLL current FreeCredentialsHandle: credentials asParameter.
	return = SEC_E_OK ifFalse: [self winError].
	credentials := nil]

{ #category : #finalization }
SSL >> freeSecBuffer: aSecBuffer [
	| return |
	return := Secur32DLL current
		FreeContextBuffer: aSecBuffer pvBuffer asParameter.
	return = SEC_E_OK ifFalse: [self winError].
	aSecBuffer pvBuffer: 0]

{ #category : #connection }
SSL >> handshake [
	| token sent |
	outBuffer := SecBufferDesc external forToken.
	status := self initializeSecurityContext: outBuffer.
	token := outBuffer token.
	self freeSecBuffer: outBuffer buffer.
	sent := socket write: token.
	self ASSERT: sent = token size.
	self handshakeLoop: true]

{ #category : #connection }
SSL >> handshakeLoop: aBoolean [
	| sent read |
	self allocateInputBuffer.
	sent := 0.
	read := aBoolean.
	outBuffer := SecBufferDesc external forToken.
	[self shouldContinue] whileTrue: [| data |
		input position = 0 | (status = SEC_E_INCOMPLETE_MESSAGE)
			ifTrue: [read ifTrue: [self readInto: input] ifFalse: [read := true]].
		inBuffer := SecBufferDesc external emptyAndToken: input.
		outBuffer buffer pvBuffer: 0; cbBuffer: 0; beToken.
		status := self initializeSecurityContext: outBuffer.
		status = SEC_I_INCOMPLETE_CREDENTIALS
			ifTrue: [status := self initializeSecurityContext: outBuffer].
		status = SEC_E_OK | (status = SEC_I_CONTINUE_NEEDED) ifTrue: [
			data := outBuffer buffer data.
			data notEmpty ifTrue: [
				sent := socket write: data.
				self ASSERT: outBuffer buffer data size = sent].
			self freeSecBuffer: outBuffer buffer].
		status = SEC_E_OK ifTrue: [].
		status = SEC_E_INCOMPLETE_MESSAGE ifFalse: [input position: 0; truncate]].
	status = SEC_E_OK ifFalse: [
		self deleteContext.
		socket close].
	^status]

{ #category : #private }
SSL >> increaseInBuffer [
	| size new |
	size := inBuffer position + inBuffer sizeToEnd.
	new := (size + 4096) externalBytes writeStream.
	new nextPutAll: inBuffer contents.
	inBuffer collection free.
	inBuffer := new]

{ #category : #connection }
SSL >> initializeSecurityContext: aSecBufferDesc [
	| server attributes next return |
	server := context isNil ifTrue: [target externalCopy].
	attributes := ExternalInt32 external.
	next := CtxtHandle external.
	return := Secur32DLL current
		InitializeSecurityContextW: credentials asParameter
		phContext: context asParameter
		pszTargetName: server asParameter
		fContextReq: ISC_REQ_ALLOCATE_MEMORY | ISC_REQ_CONFIDENTIALITY
			| ISC_REQ_EXTENDED_ERROR
			| ISC_REQ_REPLAY_DETECT
			| ISC_REQ_SEQUENCE_DETECT
			| ISC_REQ_STREAM
		Reserved1: 0
		TargetDataRep: 0
		pInput: inBuffer asParameter
		Reserved2: 0
		phNewContext: next asParameter
		pOutput: aSecBufferDesc asParameter
		pfContextAttr: attributes asParameter
		ptsExpiry: 0.
	context isNil ifTrue: [context := next].
	server notNil ifTrue: [server free].
	attributes free.
	^return]

{ #category : #accessing }
SSL >> maxBufferLength [
	^self streamSizes maxLength]

{ #category : #accessing }
SSL >> missing [
	^missing]

{ #category : #printing }
SSL >> printOn: aStream [
	super printOn: aStream.
	info isNil ifTrue: [
		aStream nextPutAll: ' - No info '.
		^self].
	aStream
		space;
		nextPutAll: 'Connected to: ' , socket host;
		cr;
		nextPutAll: 'Security package: ';
		nextPutAll: package name;
		cr;
		nextPutAll: 'Protocol: ';
		nextPutAll: self protocol;
		cr;
		nextPutAll: 'Cipher: ';
		nextPutAll: self cipher;
		cr;
		nextPutAll: 'Cipher strength: ';
		nextPutAll: info dwCipherStrength asString;
		cr;
		nextPutAll: 'Hash: ';
		nextPutAll: self aiHash;
		cr;
		nextPutAll: 'Hash strength: ';
		nextPutAll: info dwHashStrength asString;
		cr;
		nextPutAll: 'Server certificate: '.
	certificate printOn: aStream]

{ #category : #accessing }
SSL >> protocol [
	| protocol |
	info isNil ifTrue: [^nil].
	protocol := info dwProtocol.
	protocol = SP_PROT_TLS1_CLIENT ifTrue: [^'TLS1'].
	protocol = SP_PROT_SSL2_CLIENT ifTrue: [^'SSL2'].
	protocol = SP_PROT_SSL3_CLIENT ifTrue: [^'SSL3'].
	protocol = SP_PROT_PCT1_CLIENT ifTrue: [^'PCT'].
	^'Other']

{ #category : #services }
SSL >> queryCredentialsAttributesNames [
	^self
		credentialsAttribute: SECPKG_CRED_ATTR_NAMES
		in: SecPkgCredentials_Names]

{ #category : #services }
SSL >> queryCredentialsCipherStrengths [
	^self
		credentialsAttribute: SECPKG_CRED_ATTR_NAMES
		in: SecPkgCred_CipherStrengths]

{ #category : #private }
SSL >> readInput [
	| read |
	read := self readInto: input.
	inBuffer tokenBuffer cbBuffer: input position.
	^read]

{ #category : #private }
SSL >> readInto: aStream [
	| position read |
	position := aStream position.
	socket waitForDataFor: 15 seconds.
	read := socket readInto: aStream collection startingAt: position + 1.
	aStream position: position + read; truncate.
	^read]

{ #category : #services }
SSL >> securityPackageInfoFor: aString [
	| memory pointer return i |
	memory := aString externalCopy.
	pointer := ExternalPointer external.
	return := Secur32DLL current
		QuerySecurityPackageInfo: memory asParameter
		info: pointer asParameter.
	return = SEC_E_OK ifFalse: [self winError].
	memory free.
	i := SecPkgInfo fromMemory: pointer makeExternalMemory.
	^i makeLocal]

{ #category : #connection }
SSL >> serverCertificate [
	| ulong |
	ulong := self
		contextAttribute: SECPKG_ATTR_REMOTE_CERT_CONTEXT
		in: ExternalInt32.
	^CERT_CONTEXT fromMemory: ulong pointedMemory]

{ #category : #connection }
SSL >> serverHandshake [
	| data sent |
	status := SEC_I_CONTINUE_NEEDED.
	[self shouldContinue] whileTrue: [
		outBuffer := SecBufferDesc external forToken.
		inBuffer := SecBufferDesc external withToken: input.
		self readInput.
		status := self acceptSecurityContext: outBuffer.
		status = SEC_E_INCOMPLETE_MESSAGE ifFalse: [input position: 0].
		status = SEC_E_OK | (status = SEC_I_CONTINUE_NEEDED) ifTrue: [
			data := outBuffer buffer data.
			data notEmpty ifTrue: [
				sent := socket write: data.
				self ASSERT: outBuffer buffer data size = sent]]]]

{ #category : #testing }
SSL >> shouldContinue [
	status = SEC_I_CONTINUE_NEEDED ifTrue: [^true].
	status = SEC_E_INCOMPLETE_MESSAGE ifTrue: [^true].
	status = SEC_I_INCOMPLETE_CREDENTIALS ifTrue: [^true].
	^false]

{ #category : #testing }
SSL >> shouldContinueReading [
	^status = SEC_E_INCOMPLETE_MESSAGE]

{ #category : #accessing }
SSL >> socket: aSocket [
	socket := aSocket]

{ #category : #connection }
SSL >> start [
	package := Secur32DLL current availablePackages
		detect: [:pckg | pckg name = 'Schannel'].
	credentials := Secur32DLL current acquireCredentialsNamed: 'Schannel'.
	context := nil.
	self handshake.
	status = SEC_E_OK ifFalse: [^self].
	info := self connectionInfo.
	self authenticateServer; allocateBuffers]

{ #category : #private }
SSL >> streamSizes [
	^self
		contextAttribute: SECPKG_ATTR_STREAM_SIZES
		in: SecPkgContext_StreamSizes]

{ #category : #accessing }
SSL >> target: aString [
	target := aString]

