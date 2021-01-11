"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_RESPONSE_V1,
	#superclass : #HttpResponseStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_RESPONSE_V1 class >> aspects [
	^#(#Flags
		#Version
		#StatusCode
		#reason
		#Headers
		#EntityChunkCount
		#pEntityChunks)]

{ #category : #accessing }
HTTP_RESPONSE_V1 class >> def [
	^<def>
	typedef struct _HTTP_RESPONSE {
		ULONG                 Flags;
		HTTP_VERSION          Version;
		USHORT                StatusCode;
		USHORT                ReasonLength;
		PCSTR                 pReason;
		HTTP_RESPONSE_HEADERS Headers;
		USHORT                EntityChunkCount;
		PHTTP_DATA_CHUNK      pEntityChunks;
	} HTTP_RESPONSE_V1, *PHTTP_RESPONSE_V1;
	</def>]

{ #category : #initialization }
HTTP_RESPONSE_V1 class >> initializeConstants [
	"
	HTTP_RESPONSE initializeConstants
	"
	self initializeStatusCodes]

{ #category : #initialization }
HTTP_RESPONSE_V1 class >> initializeStatusCodes [
	WinConstants
		at: 'HTTP_STATUS_CONTINUE' put: 100 
		"The request can be continued.";
		at: 'HTTP_STATUS_SWITCH_PROTOCOLS'
		put: 101 
		"The server has switched protocols in an upgrade header.";
		at: 'HTTP_STATUS_OK' put: 200 
		"The request completed successfully.";
		at: 'HTTP_STATUS_CREATED'
		put: 201 
		"The request has been fulfilled and resulted in the creation of a new resource.";
		at: 'HTTP_STATUS_ACCEPTED'
		put: 202 
		"The request has been accepted for processing, but the processing has not been completed.";
		at: 'HTTP_STATUS_PARTIAL'
		put: 203 
		"The returned meta information in the entity-header is not the definitive set available from the origin server.";
		at: 'HTTP_STATUS_NO_CONTENT'
		put: 204 
		"The server has fulfilled the request, but there is no new information to send back.";
		at: 'HTTP_STATUS_RESET_CONTENT'
		put: 205 
		"The request has been completed, and the client program should reset the document view that caused the request to be sent to allow the user to easily initiate another input action.";
		at: 'HTTP_STATUS_PARTIAL_CONTENT'
		put: 206 
		"The server has fulfilled the partial GET request for the resource.";
		at: 'HTTP_STATUS_AMBIGUOUS'
		put: 300 
		"The server couldn't decide what to return.";
		at: 'HTTP_STATUS_MOVED'
		put: 301 
		"The requested resource has been assigned to a new permanent URI (Uniform Resource Identifier), and any future references to this resource should be done using one of the returned URIs.";
		at: 'HTTP_STATUS_REDIRECT'
		put: 302 
		"The requested resource resides temporarily under a different URI (Uniform Resource Identifier).";
		at: 'HTTP_STATUS_REDIRECT_METHOD'
		put: 303 
		"The response to the request can be found under a different URI (Uniform Resource Identifier) and should be retrieved using a GET HTTP verb on that resource.";
		at: 'HTTP_STATUS_NOT_MODIFIED'
		put: 304 
		"The requested resource has not been modified.";
		at: 'HTTP_STATUS_USE_PROXY'
		put: 305 
		"The requested resource must be accessed through the proxy given by the location field.";
		at: 'HTTP_STATUS_REDIRECT_KEEP_VERB'
		put: 307 
		"The redirected request keeps the same HTTP verb. HTTP/1.1 behavior.";
		at: 'HTTP_STATUS_BAD_REQUEST'
		put: 400 
		"The request could not be processed by the server due to invalid syntax.";
		at: 'HTTP_STATUS_DENIED'
		put: 401 
		"The requested resource requires user authentication.";
		at: 'HTTP_STATUS_PAYMENT_REQ'
		put: 402 
		"Not currently implemented in the HTTP protocol.";
		at: 'HTTP_STATUS_FORBIDDEN'
		put: 403 
		"The server understood the request, but is refusing to fulfill it.";
		at: 'HTTP_STATUS_NOT_FOUND'
		put: 404 
		"The server has not found anything matching the requested URI (Uniform Resource Identifier).";
		at: 'HTTP_STATUS_BAD_METHOD'
		put: 405 
		"The HTTP verb used is not allowed.";
		at: 'HTTP_STATUS_NONE_ACCEPTABLE'
		put: 406 
		"No responses acceptable to the client were found.";
		at: 'HTTP_STATUS_PROXY_AUTH_REQ'
		put: 407 
		"Proxy authentication required.";
		at: 'HTTP_STATUS_REQUEST_TIMEOUT'
		put: 408 
		"The server timed out waiting for the request.";
		at: 'HTTP_STATUS_CONFLICT'
		put: 409 
		"The request could not be completed due to a conflict with the current state of the resource. The user should resubmit with more information.";
		at: 'HTTP_STATUS_GONE'
		put: 410 
		"The requested resource is no longer available at the server, and no forwarding address is known.";
		at: 'HTTP_STATUS_LENGTH_REQUIRED'
		put: 411 
		"The server refuses to accept the request without a defined content length.";
		at: 'HTTP_STATUS_PRECOND_FAILED'
		put: 412 
		"The precondition given in one or more of the request header fields evaluated to false when it was tested on the server.";
		at: 'HTTP_STATUS_REQUEST_TOO_LARGE'
		put: 413 
		"The server is refusing to process a request because the request entity is larger than the server is willing or able to process.";
		at: 'HTTP_STATUS_URI_TOO_LONG'
		put: 414 
		"The server is refusing to service the request because the request URI (Uniform Resource Identifier) is longer than the server is willing to interpret.";
		at: 'HTTP_STATUS_UNSUPPORTED_MEDIA'
		put: 415 
		"The server is refusing to service the request because the entity of the request is in a format not supported by the requested resource for the requested method.";
		at: 'HTTP_STATUS_RETRY_WITH'
		put: 449 
		"The request should be retried after doing the appropriate action.";
		at: 'HTTP_STATUS_SERVER_ERROR'
		put: 500 
		"The server encountered an unexpected condition that prevented it from fulfilling the request.";
		at: 'HTTP_STATUS_NOT_SUPPORTED'
		put: 501 
		"The server does not support the functionality required to fulfill the request.";
		at: 'HTTP_STATUS_BAD_GATEWAY'
		put: 502 
		"The server, while acting as a gateway or proxy, received an invalid response from the upstream server it accessed in attempting to fulfill the request.";
		at: 'HTTP_STATUS_SERVICE_UNAVAIL'
		put: 503 
		"The service is temporarily overloaded.";
		at: 'HTTP_STATUS_GATEWAY_TIMEOUT'
		put: 504 
		"The request was timed out waiting for a gateway.";
		at: 'HTTP_STATUS_VERSION_NOT_SUP'
		put: 505 
		"The server does not support, or refuses to support, the HTTP protocol version that was used in the request message."]

{ #category : #accessing }
HTTP_RESPONSE_V1 class >> offsets64 [
^PoolDictionary new
		at: 'Version' put: 4;
		at: 'Flags' put: 0;
		at: 'StatusCode' put: 8;
		at: 'sizeInBytes' put: 552;
		at: 'Headers' put: 24;
		at: 'pEntityChunks' put: 544;
		at: 'pReason' put: 16;
		at: 'ReasonLength' put: 10;
		at: 'EntityChunkCount' put: 536;
		yourself]

{ #category : #accessing }
HTTP_RESPONSE_V1 class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
HTTP_RESPONSE_V1 >> EntityChunkCount [
	^self uShortAtOffset: EntityChunkCount]

{ #category : #accessing }
HTTP_RESPONSE_V1 >> EntityChunkCount: anInteger [
	self uShortAtOffset: EntityChunkCount put: anInteger]

{ #category : #accessing }
HTTP_RESPONSE_V1 >> Flags [
	^self uLongAtOffset: Flags]

{ #category : #accessing }
HTTP_RESPONSE_V1 >> Flags: anInteger [
	self uLongAtOffset: Flags put: anInteger]

{ #category : #accessing }
HTTP_RESPONSE_V1 >> Headers [
	| data |
	data := self
		bytesAtOffset: Headers
		count: HTTP_RESPONSE_HEADERS sizeInBytes.
	^HTTP_RESPONSE_HEADERS usingBytes: data]

{ #category : #accessing }
HTTP_RESPONSE_V1 >> Headers: anHTTP_RESPONSE_HEADERS [
	self bytesAtOffset: Headers put: anHTTP_RESPONSE_HEADERS contents.
	anHTTP_RESPONSE_HEADERS transferRegistryTo: self]

{ #category : #accessing }
HTTP_RESPONSE_V1 >> pEntityChunks [
	^self addressAtOffset: pEntityChunks]

{ #category : #accessing }
HTTP_RESPONSE_V1 >> pEntityChunks: anExternalMemory [
	self addressAtOffset: pEntityChunks register: anExternalMemory]

{ #category : #accessing }
HTTP_RESPONSE_V1 >> pReason [
	^self addressAtOffset: pReason]

{ #category : #accessing }
HTTP_RESPONSE_V1 >> pReason: anExternalMemory [
	anExternalMemory isNil ifTrue: [^self].
	^self addressAtOffset: pReason register: anExternalMemory]

{ #category : #accessing }
HTTP_RESPONSE_V1 >> ReasonLength [
	^self uShortAtOffset: ReasonLength]

{ #category : #accessing }
HTTP_RESPONSE_V1 >> ReasonLength: anInteger [
	self uShortAtOffset: ReasonLength put: anInteger]

{ #category : #accessing }
HTTP_RESPONSE_V1 >> StatusCode [
	^self uShortAtOffset: StatusCode]

{ #category : #accessing }
HTTP_RESPONSE_V1 >> StatusCode: anInteger [
	self uShortAtOffset: StatusCode put: anInteger]

{ #category : #accessing }
HTTP_RESPONSE_V1 >> Version [
	^self structureAtOffset: Version ofClass: HTTP_VERSION]

{ #category : #accessing }
HTTP_RESPONSE_V1 >> Version: anHTTP_VERSION [
	self bytesAtOffset: Version put: anHTTP_VERSION asParameter]

