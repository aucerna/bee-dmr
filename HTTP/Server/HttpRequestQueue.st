"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpRequestQueue,
	#superclass : #Object,
	#instVars : [
		'handle',
		'name',
		'io',
		'state'
	],
	#category : #'HTTP\Server'
}

{ #category : #'instance creation' }
HttpRequestQueue class >> new [
	^super new initialize]

{ #category : #properties }
HttpRequestQueue >> activate [
	HttpApiDLL current
		HttpSetRequestQueueProperty: handle asParameter
		Property: HttpServerStateProperty
		PropertyInformation: HttpEnabledStateActive]

{ #category : #converting }
HttpRequestQueue >> asParameter [
	^handle asParameter]

{ #category : #properties }
HttpRequestQueue >> basicVerbosity [
	self verbosityOn503: Http503ResponseVerbosityBasic]

{ #category : #actions }
HttpRequestQueue >> cacheAtUri: aString [
	| prefix length return data bytes |
	prefix := aString externalCopy.
	length := ExternalInt32 external.
	return := HttpApiDLL current
		HttpReadFragmentFromCache: handle asParameter
		pUrlPrefix: prefix asParameter
		pByteRange: 0
		pBuffer: 0
		BufferLength: 0
		pBytesRead: length asParameter
		pOverlapped: 0.
	return = 0 ifTrue: [^''].
	(return = ERROR_MORE_DATA or: [return = ERROR_INSUFFICIENT_BUFFER])
		ifFalse: [self winError].
	data := length asInteger externalBytes.
	return := HttpApiDLL current
		HttpReadFragmentFromCache: handle asParameter
		pUrlPrefix: prefix asParameter
		pByteRange: 0
		pBuffer: data asParameter
		BufferLength: length asInteger
		pBytesRead: length
		pOverlapped: 0.
	prefix free.
	bytes := data copyFrom: 1 to: length makeInteger.
	data free.
	^bytes]

{ #category : #actions }
HttpRequestQueue >> cacheAtUri: aString put: aByteArray [
	| chunk policy prefix return |
	chunk := HTTP_DATA_CHUNK external buffer: aByteArray.
	policy := HTTP_CACHE_POLICY external timeless.
	prefix := aString externalCopy.
	return := HttpApiDLL current
		HttpAddFragmentToCache: handle asParameter
		pUrlPrefix: prefix asParameter
		pDataChunk: chunk asParameter
		pCachePolicy: policy asParameter
		pOverlapped: 0.
	return = 0 ifFalse: [self winError].
	chunk free.
	policy free]

{ #category : #private }
HttpRequestQueue >> chunkLimit [
	^128 kbytes]

{ #category : #actions }
HttpRequestQueue >> close [
	| return ulong |
	handle isNil ifTrue: [^self].
	state := #closed.
	return := HttpApiDLL current HttpShutdownRequestQueue: handle asParameter.
	return = NO_ERROR ifFalse: [self winError].
	io notNil ifTrue: [
		[io hasWaitingProcesses] whileTrue: [
			Smalltalk eventDispatcher processAllMessages.
			ActiveProcess yield].
		io close].
	ulong := handle.
	handle := nil.
	return := HttpApiDLL current HttpCloseRequestQueue: ulong asParameter.
	return = 0 ifFalse: [self winError: return]]

{ #category : #actions }
HttpRequestQueue >> create [
	| flag |
	flag := name isNil
		ifTrue: [0]
		ifFalse: [HTTP_CREATE_REQUEST_QUEUE_FLAG_CONTROLLER].
	self create: flag]

{ #category : #private }
HttpRequestQueue >> create: flags [
	| pointer version attributes identifier return |
	pointer := ExternalPointer external.
	version := HTTPAPI_VERSION major: 2 minor: 0.
	attributes := name isNil ifTrue: [SECURITY_ATTRIBUTES external].
	identifier := name externalCopy.
	return := HttpApiDLL current
		HttpCreateRequestQueue: version asParameter
		pName: identifier asParameter
		pSecurityAttributes: attributes asParameter
		Flags: flags
		pReqQueueHandle: pointer asParameter.
	return = 0 ifFalse: [self winError: return].
	handle := pointer makeInteger.
	attributes free.
	version free.
	identifier free.
	state := #open]

{ #category : #actions }
HttpRequestQueue >> createThreadpoolIo [
	io := IOPending on: handle]

{ #category : #properties }
HttpRequestQueue >> deactivate [
	HttpApiDLL current
		HttpSetRequestQueueProperty: handle asParameter
		Property: HttpServerStateProperty
		PropertyInformation: HttpEnabledStateInactive]

{ #category : #properties }
HttpRequestQueue >> fullVerbosity [
	self verbosityOn503: Http503ResponseVerbosityFull]

{ #category : #private }
HttpRequestQueue >> getOverlappedResult: overlapped [
	| transferred success |
	transferred := ExternalInt32 external.
	success := self getOverlappedResult: overlapped transferred: transferred.
	transferred free.
	^success]

{ #category : #private }
HttpRequestQueue >> getOverlappedResult: overlapped transferred: transferred [
	| success error |
	success := KernelDLL current
		GetOverlappedResult: handle asParameter
		lpOverlapped: overlapped asParameter
		lpNumberOfBytesTransferred: transferred asParameter
		bWait: false asParameter.
	success ifFalse: [error := self lastWinError].
	success ifTrue: [^true].
	state == #open
		ifTrue: [self winError: error]
		ifFalse: [self ASSERT: error = WSA_OPERATION_ABORTED].
	^false]

{ #category : #initialization }
HttpRequestQueue >> initialize [
	super initialize.
	state := #closed]

{ #category : #testing }
HttpRequestQueue >> isActive [
	| s |
	s := HttpApiDLL current
		HttpQueryRequestQueueProperty: handle asParameter
		Property: HttpServerStateProperty.
	^s = HttpEnabledStateActive]

{ #category : #properties }
HttpRequestQueue >> length [
	^HttpApiDLL current
		HttpQueryRequestQueueProperty: handle asParameter
		Property: HttpServerQueueLengthProperty]

{ #category : #properties }
HttpRequestQueue >> length: anInteger [
	HttpApiDLL current
		HttpSetRequestQueueProperty: handle asParameter
		Property: HttpServerQueueLengthProperty
		PropertyInformation: anInteger]

{ #category : #properties }
HttpRequestQueue >> limitedVerbosity [
	self verbosityOn503: Http503ResponseVerbosityLimited]

{ #category : #accessing }
HttpRequestQueue >> name [
	^name]

{ #category : #accessing }
HttpRequestQueue >> name: aString [
	name := aString]

{ #category : #actions }
HttpRequestQueue >> open [
	self create: HTTP_CREATE_REQUEST_QUEUE_FLAG_OPEN_EXISTING]

{ #category : #printing }
HttpRequestQueue >> printOn: aStream [
	| identifier |
	aStream
		nextPutAll: 'Request Queue: ';
		nextPutAll: (name ifNil: ['Unnamed']).
	identifier := handle isNil ifTrue: ['invalid'] ifFalse: [handle asString].
	aStream
		space;
		nextPut: $(;
		nextPutAll: identifier;
		nextPut: $)]

{ #category : #actions }
HttpRequestQueue >> readRequestBody: anHttpRequest [
	| length overlapped data chunk transferred return |
	length := anHttpRequest contentLength asInteger.
	overlapped := OVERLAPPED external.
	data := (ByteArray new: length) writeStream.
	chunk := 16 kbytes externalBytes readStream.
	transferred := ExternalInt32 external.
	[
		[
			io startOn: overlapped.
			return := HttpApiDLL current
				receiveRequestEntityBody: handle asParameter
				RequestId: anHttpRequest id
				Flags: 0
				pBuffer: chunk collection asParameter
				BufferLength: chunk collection length asParameter
				pBytesReceived: 0
				pOverlapped: overlapped asParameter.
			return = NO_ERROR or: [return = ERROR_IO_PENDING]]
			whileTrue: [| bytes |
				io waitFor: overlapped.
				self getOverlappedResult: overlapped transferred: transferred.
				bytes := chunk next: transferred asInteger.
				data nextPutAll: bytes.
				chunk reset].
		return != ERROR_HANDLE_EOF
			ifTrue: [io osError: return on: overlapped]
			ifFalse: [io cancel: overlapped].
		self ASSERT: data size = length.
		anHttpRequest body: data contents]
		ensure: [
			chunk collection free.
			transferred free]]

{ #category : #actions }
HttpRequestQueue >> receiveRequest [
	| overlapped buffer return success native request |
	overlapped := OVERLAPPED external.
	buffer := (HTTP_REQUEST_V2 sizeInBytes + 16 kbytes) externalBytes.
	io startOn: overlapped.
	return := HttpApiDLL current
		receiveHttpRequest: handle asParameter
		RequestId: 0
		Flags: 0
		RequestBuffer: buffer asParameter
		RequestBufferLength: buffer length asParameter
		pBytesReceived: 0
		pOverlapped: overlapped asParameter.
	(return = NO_ERROR or: [return = ERROR_IO_PENDING])
		ifTrue: [io waitFor: overlapped]
		ifFalse: [io osErrorOn: overlapped].
	success := self getOverlappedResult: overlapped.
	success ifTrue: [
		native := HTTP_REQUEST_V2 fromMemory: buffer.
		request := HttpRequest from: native].
	overlapped free.
	buffer free.
	^request]

{ #category : #private }
HttpRequestQueue >> sendFullResponse: anHttpResponse [
	| native flags overlapped sent struct return |
	native := HTTP_RESPONSE_V2 external fromResponse: anHttpResponse.
	flags := (anHttpResponse hasContentLength not
		andNot: [anHttpResponse hasTransferEncoding])
		ifTrue: [HTTP_SEND_RESPONSE_FLAG_DISCONNECT]
		ifFalse: [0].
	overlapped := OVERLAPPED external.
	io startOn: overlapped.
	sent := ExternalInt32 external.
	struct := HTTP_LOG_FIELDS_DATA external fromResponse: anHttpResponse.
	return := HttpApiDLL current
		sendHttpResponse: handle asParameter
		RequestId: anHttpResponse requestId
		Flags: flags
		pHttpResponse: native asParameter
		pCachePolicy: 0
		pBytesSent: sent asParameter
		pReserved2: 0
		Reserved3: 0
		pOverlapped: overlapped asParameter
		pLogData: struct asParameter.
	(return = NO_ERROR or: [return = ERROR_IO_PENDING])
		ifTrue: [io waitFor: overlapped]
		ifFalse: [io osErrorOn: overlapped].
	self getOverlappedResult: overlapped.
	struct free.
	sent free.
	native free]

{ #category : #actions }
HttpRequestQueue >> sendResponse: anHttpResponse [
	anHttpResponse body sizeInBytes < self chunkLimit
		ifTrue: [^self sendFullResponse: anHttpResponse].
	self sendResponseHeaders: anHttpResponse.
	anHttpResponse body notNil ifTrue: [self sendResponseBody: anHttpResponse]]

{ #category : #private }
HttpRequestQueue >> sendResponseBody: anHttpResponse [
	| overlapped chunks return flags |
	flags := 0.
	overlapped := OVERLAPPED external.
	chunks := HTTP_DATA_CHUNK
		fromData: anHttpResponse body
		maxBytes: self chunkLimit.
	(anHttpResponse hasContentLength not
		andNot: [anHttpResponse hasTransferEncoding])
		ifTrue: [flags := HTTP_SEND_RESPONSE_FLAG_DISCONNECT].
	io startOn: overlapped.
	return := HttpApiDLL current
		sendResponseEntityBody: handle asParameter
		RequestId: anHttpResponse requestId
		Flags: flags
		EntityChunkCount: chunks count
		pEntityChunks: chunks asParameter
		pBytesSent: 0
		pOverlapped: overlapped asParameter
		pLogData: 0.
	(return = NO_ERROR or: [return = ERROR_IO_PENDING])
		ifTrue: [io waitFor: overlapped]
		ifFalse: [io osErrorOn: overlapped].
	self getOverlappedResult: overlapped]

{ #category : #private }
HttpRequestQueue >> sendResponseHeaders: anHttpResponse [
	| native flags sent struct return |
	native := HTTP_RESPONSE_V2 external
		version1;
		StatusCode: anHttpResponse status;
		reason: anHttpResponse reason;
		updateHeadersFrom: anHttpResponse.
	flags := anHttpResponse body notNil
		ifTrue: [HTTP_SEND_RESPONSE_FLAG_MORE_DATA]
		ifFalse: [0].
	sent := ExternalInt32 external.
	struct := HTTP_LOG_FIELDS_DATA external fromResponse: anHttpResponse.
	return := HttpApiDLL current
		sendHttpResponse: handle asParameter
		RequestId: anHttpResponse requestId
		Flags: flags
		pHttpResponse: native asParameter
		pCachePolicy: 0
		pBytesSent: sent asParameter
		pReserved2: 0
		Reserved3: 0
		pOverlapped: 0
		pLogData: struct asParameter.
	return = 0 ifFalse: [^self winError: return].
	anHttpResponse body isNil ifTrue: [native free].
	struct free.
	^sent makeInteger]

{ #category : #properties }
HttpRequestQueue >> verbosityOn503 [
	^HttpApiDLL current
		HttpQueryRequestQueueProperty: handle asParameter
		Property: HttpServer503VerbosityProperty]

{ #category : #properties }
HttpRequestQueue >> verbosityOn503: anInteger [
	self ASSERT: (anInteger between: 0 and: 2).
	HttpApiDLL current
		HttpSetRequestQueueProperty: handle asParameter
		Property: HttpServer503VerbosityProperty
		PropertyInformation: anInteger]

{ #category : #actions }
HttpRequestQueue >> waitForDemandStart [
	| overlapped return success |
	overlapped := OVERLAPPED external.
	io startOn: overlapped.
	return := HttpApiDLL current
		HttpWaitForDemandStart: handle asParameter
		pOverlapped: overlapped asParameter.
	(return = NO_ERROR or: [return = ERROR_IO_PENDING])
		ifTrue: [io waitFor: overlapped]
		ifFalse: [io osErrorOn: overlapped].
	success := self getOverlappedResult: overlapped.
	overlapped free.
	^success]

