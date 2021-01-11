"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpApiDLL,
	#superclass : #WindowsLibrary,
	#type : #bytes,
	#category : #'HTTP\Server'
}

{ #category : #initialization }
HttpApiDLL class >> initializeAuthEnableConstants [
	WinConstants
		at: 'HTTP_AUTH_ENABLE_BASIC' put: 16r1;
		at: 'HTTP_AUTH_ENABLE_DIGEST' put: 16r2;
		at: 'HTTP_AUTH_ENABLE_NTLM' put: 16r4;
		at: 'HTTP_AUTH_ENABLE_NEGOTIATE' put: 16r8;
		at: 'HTTP_AUTH_ENABLE_KERBEROS' put: 16r10]

{ #category : #initialization }
HttpApiDLL class >> initializeAuthStatusConstants [
	WinConstants
		at: 'HttpAuthStatusSuccess' put: 0;
		at: 'HttpAuthStatusNotAuthenticated' put: 1;
		at: 'HttpAuthStatusFailure' put: 2]

{ #category : #initialization }
HttpApiDLL class >> initializeConstants [
	"
	HttpServerDLL initializeConstants
	"
	self
		initializeHttpServerConstants;
		initializeErrorCodes;
		initializePropertyConstants;
		initializeAuthEnableConstants;
		initializeAuthStatusConstants;
		initializeHttpRequestConstants;
		initializeVerbosityConstants]

{ #category : #initialization }
HttpApiDLL class >> initializeErrorCodes [
	WinConstants
		at: 'ERROR_INVALID_PARAMETER' put: 87;
		at: 'ERROR_IO_INCOMPLETE' put: 996;
		at: 'ERROR_IO_PENDING' put: 997;
		at: 'ERROR_NOACCESS' put: 998;
		at: 'ERROR_CONNECTION_INVALID' put: 1229]

{ #category : #initialization }
HttpApiDLL class >> initializeHttpRequestConstants [
	"
	HttpServerDLL initializeHttpRequestConstants.
	"
	WinConstants
		at: 'HTTP_CREATE_REQUEST_QUEUE_FLAG_OPEN_EXISTING' put: 0x00000001;
		at: 'HTTP_CREATE_REQUEST_QUEUE_FLAG_CONTROLLER' put: 0x00000002]

{ #category : #initialization }
HttpApiDLL class >> initializeHttpServerConstants [
	"
	HttpServerDLL initializeHttpServerConstants.
	"
	WinConstants
		at: 'HTTP_INITIALIZE_SERVER' put: 16r1;
		at: 'HTTP_INITIALIZE_CONFIG' put: 16r2;
		at: 'HTTP_RECEIVE_REQUEST_FLAG_COPY_BODY' put: 16r1;
		at: 'HTTP_RECEIVE_REQUEST_ENTITY_BODY_FLAG_FILL_BUFFER' put: 16r1;
		at: 'HTTP_RECEIVE_REQUEST_FLAG_FLUSH_BODY' put: 16r2;
		at: 'HTTP_SEND_RESPONSE_FLAG_DISCONNECT' put: 16r1;
		at: 'HTTP_SEND_RESPONSE_FLAG_MORE_DATA' put: 16r2;
		at: 'HTTP_SEND_RESPONSE_FLAG_BUFFER_DATA' put: 16r4;
		at: 'HTTP_SEND_RESPONSE_FLAG_BUFFER_DATA' put: 16r1;
		at: 'HTTP_REQUEST_FLAG_MORE_ENTITY_BODY_EXISTS' put: 16r1]

{ #category : #initialization }
HttpApiDLL class >> initializePropertyConstants [
	WinConstants
		at: 'HttpServerAuthenticationProperty' put: 0;
		at: 'HttpServerLoggingProperty' put: 1;
		at: 'HttpServerQosProperty' put: 2;
		at: 'HttpServerTimeoutsProperty' put: 3;
		at: 'HttpServerQueueLengthProperty' put: 4;
		at: 'HttpServerStateProperty' put: 5;
		at: 'HttpServer503VerbosityProperty' put: 6;
		at: 'HttpServerBindingProperty' put: 7;
		at: 'HttpServerExtendedAuthenticationProperty' put: 8;
		at: 'HttpServerListenEndpointProperty' put: 9;
		at: 'HttpServerChannelBindProperty' put: 10]

{ #category : #initialization }
HttpApiDLL class >> initializeVerbosityConstants [
	WinConstants
		at: 'Http503ResponseVerbosityBasic' put: 0;
		at: 'Http503ResponseVerbosityLimited' put: 1;
		at: 'Http503ResponseVerbosityFull' put: 2]

{ #category : #accessing }
HttpApiDLL class >> moduleName [
	^'httpapi']

{ #category : #private }
HttpApiDLL class >> typedefTable [
	^#(
		('ULARGE_INTEGER' LARGE_INTEGER)
		('HTTP_AUTH_STATUS' #long)
		('HTTP_SERVER_PROPERTY' #ulong)
		('HTTP_URL_CONTEXT' ULONGLONG)
		('HTTP_CACHE_POLICY_TYPE' #ulong)
		('HTTP_DATA_CHUNK_TYPE' #ulong)
		('HTTP_QOS_SETTING_TYPE' #ulong)
		('HTTP_LOG_DATA_TYPE' #ulong)
		('HTTP_LOGGING_TYPE' #ulong)
		('HTTP_LOGGING_ROLLOVER_TYPE' #ulong)
		('HTTP_REQUEST_AUTH_TYPE' #ulong)
		('HTTP_REQUEST_INFO_TYPE' #ulong)
		('HTTP_RESPONSE_INFO_TYPE' #ulong)
		('HTTP_CONNECTION_ID' #large)
		('HTTP_REQUEST_ID' #large)
		('HTTP_RAW_CONNECTION_ID' #large)
		('HTTP_SERVICE_CONFIG_TIMEOUT_KEY' #ulong)
		('HTTP_SERVICE_CONFIG_TIMEOUT_PARAM' #ulong)
		('HTTP_VERB' #ulong)
		('PHTTP_DATA_CHUNK' #address)
		('PHTTP_RESPONSE_INFO' #address)
		('HTTP_ENABLED_STATE' #ulong)
		('SECURITY_STATUS' #long)
		('PSECURITY_DESCRIPTOR' #pointer)
		('PSOCKADDR' #pointer)
	)]

{ #category : #api }
HttpApiDLL >> addUrlToUrlGroup: UrlGroupId pFullyQualifiedUrl: aString UrlContext: UrlContext [
	^WordSize = 4
		ifTrue: [
			self
				HttpAddUrlToUrlGroup: UrlGroupId lowULong
				_: UrlGroupId highULong
				pFullyQualifiedUrl: aString
				UrlContext: UrlContext lowULong
				_: UrlContext highULong
				Reserved: 0]
		ifFalse: [
			self
				HttpAddUrlToUrlGroup: UrlGroupId asParameter
				pFullyQualifiedUrl: aString
				UrlContext: UrlContext asParameter
				Reserved: 0]]

{ #category : #api }
HttpApiDLL >> closeServerSession: serverSessionId [
	^WordSize = 4
		ifTrue: [
			self
				HttpCloseServerSession: serverSessionId lowULong
				_: serverSessionId highULong]
		ifFalse: [self HttpCloseServerSession: serverSessionId asParameter]]

{ #category : #api }
HttpApiDLL >> closeUrlGroup: urlGroupId [
	^WordSize = 4
		ifTrue: [self
			HttpCloseUrlGroup: urlGroupId lowULong
			_: urlGroupId highULong]
		ifFalse: [self HttpCloseUrlGroup: urlGroupId asParameter]]

{ #category : #api }
HttpApiDLL >> createUrlGroup: anHTTP_SERVER_SESSION_ID pUrlGroupId: anHTTP_URL_GROUP_ID [
	^WordSize = 4
		ifTrue: [
			self
				HttpCreateUrlGroup: anHTTP_SERVER_SESSION_ID lowULong
				_: anHTTP_SERVER_SESSION_ID highULong
				pUrlGroupId: anHTTP_URL_GROUP_ID
				Reserved: 0]
		ifFalse: [
			self
				HttpCreateUrlGroup: anHTTP_SERVER_SESSION_ID asParameter
				pUrlGroupId: anHTTP_URL_GROUP_ID
				Reserved: 0]]

{ #category : #api }
HttpApiDLL >> HttpAddFragmentToCache: ReqQueueHandle
pUrlPrefix: aString
pDataChunk: anHTTP_DATA_CHUNK
pCachePolicy: anHTTP_CACHE_POLICY
pOverlapped: anOVERLAPPED [
	<ulong: HttpAddFragmentToCache>
	^self invalidArgument

"
ULONG HttpAddFragmentToCache(
	_In_ HANDLE ReqQueueHandle,
	_In_ PCWSTR pUrlPrefix,
	_In_ PHTTP_DATA_CHUNK pDataChunk,
	_In_ PHTTP_CACHE_POLICY pCachePolicy,
	_In_opt_ LPOVERLAPPED pOverlapped
);
"]

{ #category : #api }
HttpApiDLL >> HttpAddUrl: ReqQueueHandle pFullyQualifiedUrl: aString pReserved: zero [
	<ulong: HttpAddUrl>
	^self invalidArgument

"
ULONG HttpAddUrl(
  _In_  HANDLE ReqQueueHandle,
  _In_  PCWSTR pFullyQualifiedUrl,
  PVOID pReserved
);
"]

{ #category : #api }
HttpApiDLL >> HttpAddUrlToUrlGroup: UrlGroupId
_: hi1
pFullyQualifiedUrl: url
UrlContext: context
_: hi2
Reserved: null [
	<ulong: HttpAddUrlToUrlGroup>
	^self invalidArgument

"
HTTPAPI_LINKAGE ULONG HttpAddUrlToUrlGroup(
  IN HTTP_URL_GROUP_ID           UrlGroupId,
  IN PCWSTR                      pFullyQualifiedUrl,
  IN HTTP_URL_CONTEXT UrlContext OPTIONAL,
  IN ULONG                       Reserved
);
"]

{ #category : #api }
HttpApiDLL >> HttpAddUrlToUrlGroup: UrlGroupId
pFullyQualifiedUrl: aString
UrlContext: UrlContext
Reserved: zero [
	<ulong: HttpAddUrlToUrlGroup>
	^self invalidArgument

"
ULONG HttpAddUrlToUrlGroup(
  _In_        HTTP_URL_GROUP_ID UrlGroupId,
  _In_        PCWSTR pFullyQualifiedUrl,
  _In_opt_    HTTP_URL_CONTEXT UrlContext,
  _Reserved_  ULONG Reserved
);
"]

{ #category : #api }
HttpApiDLL >> HttpCancelHttpRequest: RequestQueueHandle
RequestId: id
_: hi
Overlapped: anOVERLAPPED [
	<ulong: HttpCancelHttpRequest>
	^self invalidArgument

"
HTTPAPI_LINKAGE ULONG HttpCancelHttpRequest(
  IN HANDLE                  RequestQueueHandle,
  IN HTTP_REQUEST_ID         RequestId,
  IN LPOVERLAPPED Overlapped OPTIONAL
);
"]

{ #category : #api }
HttpApiDLL >> HttpCancelHttpRequest: RequestQueueHandle RequestId: id Overlapped: anOVERLAPPED [
	<ulong: HttpCancelHttpRequest>
	^self invalidArgument

"
HTTPAPI_LINKAGE ULONG HttpCancelHttpRequest(
  IN HANDLE                  RequestQueueHandle,
  IN HTTP_REQUEST_ID         RequestId,
  IN LPOVERLAPPED Overlapped OPTIONAL
);
"]

{ #category : #api }
HttpApiDLL >> HttpCloseRequestQueue: ReqQueueHandle [
	<ulong: HttpCloseRequestQueue>
	^self invalidArgument

"
ULONG HttpCloseRequestQueue(
  _In_  HANDLE ReqQueueHandle
);"]

{ #category : #api }
HttpApiDLL >> HttpCloseServerSession: ServerSessionId [
	<ulong: HttpCloseServerSession>
	^self invalidArgument

"
ULONG HttpCloseServerSession(
  _In_  HTTP_SERVER_SESSION_ID ServerSessionId
);"]

{ #category : #api }
HttpApiDLL >> HttpCloseServerSession: ServerSessionIdLow _: hi [
	<ulong: HttpCloseServerSession>
	^self invalidArgument

"
ULONG HttpCloseServerSession(
  _In_  HTTP_SERVER_SESSION_ID ServerSessionId
);"]

{ #category : #api }
HttpApiDLL >> HttpCloseUrlGroup: UrlGroupId [
	<ulong: HttpCloseUrlGroup>
	^self invalidArgument

"
ULONG HttpCloseUrlGroup(
  _In_  HTTP_URL_GROUP_ID UrlGroupId
);"]

{ #category : #api }
HttpApiDLL >> HttpCloseUrlGroup: UrlGroupId _: high [
	<ulong: HttpCloseUrlGroup>
	^self invalidArgument

"
ULONG HttpCloseUrlGroup(
  _In_  HTTP_URL_GROUP_ID UrlGroupId
);"]

{ #category : #api }
HttpApiDLL >> HttpCreateHttpHandle: RequestQueueHandle Reserved: null [
	<ulong: HttpCreateHttpHandle>
	^self invalidArgument

"
HTTPAPI_LINKAGE ULONG HttpCreateHttpHandle(
  OUT PHANDLE RequestQueueHandle,
  ULONG       Reserved
);
"]

{ #category : #api }
HttpApiDLL >> HttpCreateRequestQueue: Version
pName: aString
pSecurityAttributes: aPSECURITY_ATTRIBUTES
Flags: flags
pReqQueueHandle: ulong [
	<ulong: HttpCreateRequestQueue>
	^self invalidArgument

"
ULONG HttpCreateRequestQueue(
  _In_      HTTPAPI_VERSION Version,
  _In_opt_  PCWSTR pName,
  _In_opt_  PSECURITY_ATTRIBUTES pSecurityAttributes,
  _In_opt_  ULONG Flags,
  _Out_     PHANDLE pReqQueueHandle
);
"]

{ #category : #api }
HttpApiDLL >> HttpCreateServerSession: Version pServerSessionId: aHTTP_SERVER_SESSION_ID Reserved: zero [
	<ulong: HttpCreateServerSession>
	^self invalidArgument 

"
ULONG HttpCreateServerSession(
  _In_        HTTPAPI_VERSION Version,
  _Out_       PHTTP_SERVER_SESSION_ID pServerSessionId,
  _Reserved_  ULONG Reserved
);
"]

{ #category : #api }
HttpApiDLL >> HttpCreateUrlGroup: ServerSessionId
_: high
pUrlGroupId: aHTTP_URL_GROUP_ID
Reserved: zero [
	<ulong: HttpCreateUrlGroup>
	^self invalidArgument

"
ULONG HttpCreateUrlGroup(
  _In_        HTTP_SERVER_SESSION_ID ServerSessionId,
  _Out_       PHTTP_URL_GROUP_ID pUrlGroupId,
  _Reserved_  ULONG Reserved
);"]

{ #category : #api }
HttpApiDLL >> HttpCreateUrlGroup: ServerSessionId pUrlGroupId: aHTTP_URL_GROUP_ID Reserved: zero [
	<ulong: HttpCreateUrlGroup>
	^self invalidArgument

"
ULONG HttpCreateUrlGroup(
  _In_        HTTP_SERVER_SESSION_ID ServerSessionId,
  _Out_       PHTTP_URL_GROUP_ID pUrlGroupId,
  _Reserved_  ULONG Reserved
);"]

{ #category : #api }
HttpApiDLL >> HttpDeclarePush: RequestQueueHandle
RequestId: anHTTP_REQUEST_ID
_: hi
Verb: verb
Path: path
Query: query
Headers: anHTTP_REQUEST_HEADERS [
	<ulong: HttpDeclarePush>
	^self invalidArgument

"
HTTPAPI_LINKAGE ULONG HttpDeclarePush(
  HANDLE                RequestQueueHandle,
  HTTP_REQUEST_ID       RequestId,
  HTTP_VERB             Verb,
  PCWSTR                Path,
  PCSTR                 Query,
  PHTTP_REQUEST_HEADERS Headers
);
"]

{ #category : #api }
HttpApiDLL >> HttpDeclarePush: RequestQueueHandle
RequestId: anHTTP_REQUEST_ID
Verb: verb
Path: path
Query: query
Headers: anHTTP_REQUEST_HEADERS [
	<ulong: HttpDeclarePush>
	^self invalidArgument

"
HTTPAPI_LINKAGE ULONG HttpDeclarePush(
  HANDLE                RequestQueueHandle,
  HTTP_REQUEST_ID       RequestId,
  HTTP_VERB             Verb,
  PCWSTR                Path,
  PCSTR                 Query,
  PHTTP_REQUEST_HEADERS Headers
);
"]

{ #category : #api }
HttpApiDLL >> HttpDeleteServiceConfiguration: ServiceHandle
ConfigId: id
pConfigInformation: struct
ConfigInformationLength: length
pOverlapped: anOVERLAPPED [
	<ulong: HttpDeleteServiceConfiguration>
	^self invalidArgument

"
ULONG HttpDeleteServiceConfiguration(
  _In_ HANDLE                 ServiceHandle,
  _In_ HTTP_SERVICE_CONFIG_ID ConfigId,
  _In_ PVOID                  pConfigInformation,
  _In_ ULONG                  ConfigInformationLength,
  _In_ LPOVERLAPPED           pOverlapped
);
"]

{ #category : #api }
HttpApiDLL >> HttpFlushResponseCache: RequestQueueHandle
UrlPrefix: aString
Flags: anInteger
Overlapped: anOVERLAPPED [
	<ulong: HttpFlushResponseCache>
	^self invalidArgument

"
HTTPAPI_LINKAGE ULONG HttpFlushResponseCache(
  IN HANDLE                  RequestQueueHandle,
  IN PCWSTR                  UrlPrefix,
  IN ULONG                   Flags,
  IN LPOVERLAPPED Overlapped OPTIONAL
);
"]

{ #category : #api }
HttpApiDLL >> HttpInitialize: Version Flags: anInteger pReserved: zero [
	<ulong: HttpInitialize>
	^self invalidArgument

"
	ULONG HttpInitialize(
  _In_        HTTPAPI_VERSION Version,
  _In_        ULONG Flags,
  _Reserved_  PVOID pReserved
);
"]

{ #category : #api }
HttpApiDLL >> HttpPrepareUrl: zero1
Flags: zero2
Url: raw
PreparedUrl: normalized [
	<ulong: HttpPrepareUrl>
	^self invalidArgument

"
HTTPAPI_LINKAGE ULONG HttpPrepareUrl(
  PVOID  Reserved,
  ULONG  Flags,
  PCWSTR Url,
  PWSTR  *PreparedUrl
);

Free PreparedUrl using HeapFree.
"]

{ #category : #services }
HttpApiDLL >> HttpQueryRequestQueueProperty: queue Property: property [
	| info return length |
	info := 0 externalBytes.
	length := ExternalInt32 external.
	return := self
		HttpQueryRequestQueueProperty: queue asParameter
		Property: property
		pPropertyInformation: info asParameter
		PropertyInformationLength: 0
		Reserved: 0
		pReturnLength: length asParameter
		pReserved: 0.
	return = ERROR_MORE_DATA ifTrue: [
		info := length asInteger externalBytes.
		return := self
			HttpQueryRequestQueueProperty: queue asParameter
			Property: property
			pPropertyInformation: info asParameter
			PropertyInformationLength: info length
			Reserved: 0
			pReturnLength: length asParameter
			pReserved: 0].
	return = NO_ERROR ifFalse: [self winError: return].
	^info makeULong]

{ #category : #api }
HttpApiDLL >> HttpQueryRequestQueueProperty: handle
Property: property
pPropertyInformation: info
PropertyInformationLength: integer
Reserved: dummy1
pReturnLength: length
pReserved: dummy2 [
	<ulong: HttpQueryRequestQueueProperty>
	^self invalidArgument

"
ULONG HttpQueryRequestQueueProperty(
  _In_       HANDLE               Handle,
  _In_       HTTP_SERVER_PROPERTY Property,
  _Out_      PVOID                pPropertyInformation,
  _In_       ULONG                PropertyInformationLength,
  _Reserved_ ULONG                Reserved,
  _Out_opt_  PULONG               pReturnLength,
  _Reserved_ PVOID                pReserved
);
"]

{ #category : #api }
HttpApiDLL >> HttpQueryServerSessionProperty: ServerSessionId
_: hi
Property: property
pPropertyInformation: info
PropertyInformationLength: integer
pReturnLength: length [
	<ulong: HttpQueryServerSessionProperty>
	^self invalidArgument

"
ULONG HttpQueryServerSessionProperty(
  _In_      HTTP_SERVER_SESSION_ID ServerSessionId,
  _In_      HTTP_SERVER_PROPERTY   Property,
  _Out_     PVOID                  pPropertyInformation,
  _In_      ULONG                  PropertyInformationLength,
  _Out_opt_ PULONG                 pReturnLength
);
"]

{ #category : #services }
HttpApiDLL >> HttpQueryServerSessionProperty: session Property: property [
	| info return length |
	info := 0 externalBytes.
	length := ExternalInt32 external.
	return := self
		queryServerSessionProperty: session
		Property: property
		pPropertyInformation: info asParameter
		PropertyInformationLength: 0
		pReturnLength: length asParameter.
	return = ERROR_MORE_DATA ifTrue: [
		info := length asUnsignedInteger externalBytes.
		return := self
			queryServerSessionProperty: session
			Property: property
			pPropertyInformation: info asParameter
			PropertyInformationLength: info length
			pReturnLength: length asParameter].
	return = NO_ERROR ifFalse: [self winError: return].
	^info copyFrom: 1 to: length makeUnsignedInteger]

{ #category : #api }
HttpApiDLL >> HttpQueryServerSessionProperty: ServerSessionId
Property: property
pPropertyInformation: info
PropertyInformationLength: integer
pReturnLength: length [
	<ulong: HttpQueryServerSessionProperty>
	^self invalidArgument

"
ULONG HttpQueryServerSessionProperty(
  _In_      HTTP_SERVER_SESSION_ID ServerSessionId,
  _In_      HTTP_SERVER_PROPERTY   Property,
  _Out_     PVOID                  pPropertyInformation,
  _In_      ULONG                  PropertyInformationLength,
  _Out_opt_ PULONG                 pReturnLength
);
"]

{ #category : #api }
HttpApiDLL >> HttpQueryServiceConfiguration: ServiceHandle
ConfigId: id
_: hi
pInput: input
InputLength: length1
pOutput: output
OutputLength: length2
pReturnLength: length
pOverlapped: anOVERLAPPED [
	<ulong: HttpQueryServiceConfiguration>
	^self invalidArgument

"
HTTPAPI_LINKAGE ULONG HttpQueryServiceConfiguration(
  HANDLE                 ServiceHandle,
  HTTP_SERVICE_CONFIG_ID ConfigId,
  PVOID                  pInput,
  ULONG                  InputLength,
  PVOID                  pOutput,
  ULONG                  OutputLength,
  PULONG                 pReturnLength,
  LPOVERLAPPED           pOverlapped
);
"]

{ #category : #api }
HttpApiDLL >> HttpQueryServiceConfiguration: ServiceHandle
ConfigId: id
pInput: input
InputLength: length1
pOutput: output
OutputLength: length2
pReturnLength: length
pOverlapped: anOVERLAPPED [
	<ulong: HttpQueryServiceConfiguration>
	^self invalidArgument

"
HTTPAPI_LINKAGE ULONG HttpQueryServiceConfiguration(
  HANDLE                 ServiceHandle,
  HTTP_SERVICE_CONFIG_ID ConfigId,
  PVOID                  pInput,
  ULONG                  InputLength,
  PVOID                  pOutput,
  ULONG                  OutputLength,
  PULONG                 pReturnLength,
  LPOVERLAPPED           pOverlapped
);
"]

{ #category : #api }
HttpApiDLL >> HttpQueryUrlGroupProperty: UrlGroupId
_: high
Property: anHTTP_SERVER_PROPERTY
pPropertyInformation: info
PropertyInformationLength: length
pReturnLength: return [
	<ulong: HttpQueryUrlGroupProperty>
	^self invalidArgument

"
ULONG HttpQueryUrlGroupProperty(
  _In_       HTTP_URL_GROUP_ID UrlGroupId,
  _In_       HTTP_SERVER_PROPERTY Property,
  _Out_      PVOID pPropertyInformation,
  _In_       ULONG PropertyInformationLength,
  _Out_opt_  PULONG pReturnLength
);
"]

{ #category : #api }
HttpApiDLL >> HttpQueryUrlGroupProperty: UrlGroupId
Property: anHTTP_SERVER_PROPERTY
pPropertyInformation: info
PropertyInformationLength: length
pReturnLength: return [
	<ulong: HttpQueryUrlGroupProperty>
	^self invalidArgument

"
ULONG HttpQueryUrlGroupProperty(
  _In_       HTTP_URL_GROUP_ID UrlGroupId,
  _In_       HTTP_SERVER_PROPERTY Property,
  _Out_      PVOID pPropertyInformation,
  _In_       ULONG PropertyInformationLength,
  _Out_opt_  PULONG pReturnLength
);
"]

{ #category : #api }
HttpApiDLL >> HttpReadFragmentFromCache: ReqQueueHandle
pUrlPrefix: aString
pByteRange: anHTTP_BYTE_RANGE
pBuffer: aByteArray
BufferLength: anInteger
pBytesRead: anotherInteger
pOverlapped: anOVERLAPPED [
	<ulong: HttpReadFragmentFromCache>
	^self invalidArgument

"
ULONG HttpReadFragmentFromCache(
  _In_  HANDLE           ReqQueueHandle,
  _In_  PCWSTR           pUrlPrefix,
  _In_  PHTTP_BYTE_RANGE pByteRange,
  _Out_ PVOID            pBuffer,
  _In_  ULONG            BufferLength,
  _Out_ PULONG           pBytesRead,
  _In_  LPOVERLAPPED     pOverlapped
);
"]

{ #category : #api }
HttpApiDLL >> HttpReceiveClientCertificate: RequestQueueHandle
ConnectionId: id
_: hi
Flags: integer
SslClientCertInfo: info
SslClientCertInfoSize: size
BytesReceived: received
Overlapped: anOVERLAPPED [
	<ulong: HttpReceiveClientCertificate>
	^self invalidArgument

"
HTTPAPI_LINKAGE ULONG HttpReceiveClientCertificate(
  IN HANDLE                  RequestQueueHandle,
  IN HTTP_CONNECTION_ID      ConnectionId,
  IN ULONG                   Flags,
  PHTTP_SSL_CLIENT_CERT_INFO SslClientCertInfo,
  IN ULONG                   SslClientCertInfoSize,
  PULONG                     BytesReceived,
  IN LPOVERLAPPED Overlapped OPTIONAL
);
"]

{ #category : #api }
HttpApiDLL >> HttpReceiveClientCertificate: RequestQueueHandle
ConnectionId: id
Flags: integer
SslClientCertInfo: info
SslClientCertInfoSize: size
BytesReceived: received
Overlapped: anOVERLAPPED [
	<ulong: HttpReceiveClientCertificate>
	^self invalidArgument

"
HTTPAPI_LINKAGE ULONG HttpReceiveClientCertificate(
  IN HANDLE                  RequestQueueHandle,
  IN HTTP_CONNECTION_ID      ConnectionId,
  IN ULONG                   Flags,
  PHTTP_SSL_CLIENT_CERT_INFO SslClientCertInfo,
  IN ULONG                   SslClientCertInfoSize,
  PULONG                     BytesReceived,
  IN LPOVERLAPPED Overlapped OPTIONAL
);
"]

{ #category : #api }
HttpApiDLL >> HttpReceiveHttpRequest: ReqQueueHandle
RequestId: RequestId
_: high
Flags: flags
RequestBuffer: buffer
RequestBufferLength: size
pBytesReceived: bytes
pOverlapped: anOVERLAPPED [
	<ulong: HttpReceiveHttpRequest>
	^self invalidArgument

"
ULONG HttpReceiveHttpRequest(
  _In_       HANDLE ReqQueueHandle,
  _In_       HTTP_REQUEST_ID RequestId,
  _In_       ULONG Flags,
  _Out_      PHTTP_REQUEST pRequestBuffer,
  _In_       ULONG RequestBufferLength,
  _Out_opt_  PULONG pBytesReceived,
  _In_opt_   LPOVERLAPPED pOverlapped
);
"]

{ #category : #api }
HttpApiDLL >> HttpReceiveHttpRequest: ReqQueueHandle
RequestId: RequestId
Flags: flags
RequestBuffer: buffer
RequestBufferLength: size
pBytesReceived: bytes
pOverlapped: anOVERLAPPED [
	<ulong: HttpReceiveHttpRequest>
	^self invalidArgument

"
ULONG HttpReceiveHttpRequest(
  _In_       HANDLE ReqQueueHandle,
  _In_       HTTP_REQUEST_ID RequestId,
  _In_       ULONG Flags,
  _Out_      PHTTP_REQUEST pRequestBuffer,
  _In_       ULONG RequestBufferLength,
  _Out_opt_  PULONG pBytesReceived,
  _In_opt_   LPOVERLAPPED pOverlapped
);
"]

{ #category : #api }
HttpApiDLL >> HttpReceiveRequestEntityBody: ReqQueueHandle
RequestId: RequestIdLow
_: RequestIdHigh
Flags: flags
pBuffer: buffer
BufferLength: size
pBytesReceived: bytes
pOverlapped: anOVERLAPPED [
	<ulong: HttpReceiveRequestEntityBody>
	^self invalidArgument

"
ULONG HttpReceiveRequestEntityBody(
  _In_       HANDLE ReqQueueHandle,
  _In_       HTTP_REQUEST_ID RequestId,
  _In_       ULONG Flags,
  _Out_      PVOID pBuffer,
  _In_       ULONG BufferLength,
  _Out_opt_  PULONG pBytesReceived,
  _In_opt_   LPOVERLAPPED pOverlapped
);
"]

{ #category : #api }
HttpApiDLL >> HttpReceiveRequestEntityBody: ReqQueueHandle
RequestId: RequestId
Flags: flags
pBuffer: buffer
BufferLength: size
pBytesReceived: bytes
pOverlapped: anOVERLAPPED [
	<ulong: HttpReceiveRequestEntityBody>
	^self invalidArgument

"
ULONG HttpReceiveRequestEntityBody(
  _In_       HANDLE ReqQueueHandle,
  _In_       HTTP_REQUEST_ID RequestId,
  _In_       ULONG Flags,
  _Out_      PVOID pBuffer,
  _In_       ULONG BufferLength,
  _Out_opt_  PULONG pBytesReceived,
  _In_opt_   LPOVERLAPPED pOverlapped
);
"]

{ #category : #api }
HttpApiDLL >> HttpRemoveUrl: ReqQueueHandle pFullyQualifiedUrl: aString [
	<ulong: HttpRemoveUrl>
	^self invalidArgument

"
ULONG HttpRemoveUrl(
  _In_  HANDLE ReqQueueHandle,
  _In_  PCWSTR pFullyQualifiedUrl
);
"]

{ #category : #api }
HttpApiDLL >> HttpRemoveUrlFromUrlGroup: UrlGroupId
_: high
pFullyQualifiedUrl: aString
Flags: anInteger [
	<ulong: HttpRemoveUrlFromUrlGroup>
	^self invalidArgument

"
ULONG HttpRemoveUrlFromUrlGroup(
  _In_  HTTP_URL_GROUP_ID UrlGroupId,
  _In_  PCWSTR pFullyQualifiedUrl,
  _In_  ULONG Flags
);
"]

{ #category : #api }
HttpApiDLL >> HttpRemoveUrlFromUrlGroup: UrlGroupId pFullyQualifiedUrl: aString Flags: anInteger [
	<ulong: HttpRemoveUrlFromUrlGroup>
	^self invalidArgument

"
ULONG HttpRemoveUrlFromUrlGroup(
  _In_  HTTP_URL_GROUP_ID UrlGroupId,
  _In_  PCWSTR pFullyQualifiedUrl,
  _In_  ULONG Flags
);
"]

{ #category : #api }
HttpApiDLL >> HttpSendHttpResponse: ReqQueueHandle
RequestId: RequestIdLow
_: high
Flags: flags
pHttpResponse: anHTTP_RESPONSE
pCachePolicy: anHTTP_CACHE_POLICY
pBytesSent: sent
pReserved2: zero1
Reserved3: zero2
pOverlapped: anOVERLAPPED
pLogData: aHTTP_LOG_DATA [
	<ulong: HttpSendHttpResponse>
	^self invalidArgument

"
ULONG HttpSendHttpResponse(
  _In_      HANDLE ReqQueueHandle,
  _In_      HTTP_REQUEST_ID RequestId,
  _In_      ULONG Flags,
  _In_      PHTTP_RESPONSE pHttpResponse,
  _In_opt_  PHTTP_CACHE_POLICY pCachePolicy,
  _Out_     PULONG pBytesSent,
  _In_      PVOID pReserved2,
  _In_      ULONG Reserved3,
  _In_      LPOVERLAPPED pOverlapped,
  _In_opt_  PHTTP_LOG_DATA  pLogData
);
"]

{ #category : #api }
HttpApiDLL >> HttpSendHttpResponse: ReqQueueHandle
RequestId: RequestId
Flags: flags
pHttpResponse: anHTTP_RESPONSE
pCachePolicy: anHTTP_CACHE_POLICY
pBytesSent: sent
pReserved2: zero1
Reserved3: zero2
pOverlapped: anOVERLAPPED
pLogData: aHTTP_LOG_DATA [
	<ulong: HttpSendHttpResponse>
	^self invalidArgument

"
ULONG HttpSendHttpResponse(
  _In_      HANDLE ReqQueueHandle,
  _In_      HTTP_REQUEST_ID RequestId,
  _In_      ULONG Flags,
  _In_      PHTTP_RESPONSE pHttpResponse,
  _In_opt_  PHTTP_CACHE_POLICY pCachePolicy,
  _Out_     PULONG pBytesSent,
  _In_      PVOID pReserved2,
  _In_      ULONG Reserved3,
  _In_      LPOVERLAPPED pOverlapped,
  _In_opt_  PHTTP_LOG_DATA  pLogData
);
"]

{ #category : #api }
HttpApiDLL >> HttpSendResponseEntityBody: ReqQueueHandle
RequestId: RequestId
_: high
Flags: flags
EntityChunkCount: count
pEntityChunks: anHTTP_DATA_CHUNK
pBytesSent: sent
pReserved1: zero1
Reserved2: zero2
pOverlapped: anOVERLAPPED
pLogData: anHTTP_LOG_DATA [
	<ulong: HttpSendResponseEntityBody>
	^self invalidArgument

"
ULONG HttpSendResponseEntityBody(
  _In_      HANDLE ReqQueueHandle,
  _In_      HTTP_REQUEST_ID RequestId,
  _In_      ULONG Flags,
  _In_      USHORT EntityChunkCount,
  _In_      PHTTP_DATA_CHUNK pEntityChunks,
  _Out_     PULONG pBytesSent,
  _In_      PVOID pReserved1,
  _In_      ULONG Reserved2,
  _In_      LPOVERLAPPED pOverlapped,
  _In_opt_   PHTTP_LOG_DATA  pLogData
);
"]

{ #category : #api }
HttpApiDLL >> HttpSendResponseEntityBody: ReqQueueHandle
RequestId: RequestId
Flags: flags
EntityChunkCount: count
pEntityChunks: anHTTP_DATA_CHUNK
pBytesSent: sent
pReserved1: zero1
Reserved2: zero2
pOverlapped: anOVERLAPPED
pLogData: anHTTP_LOG_DATA [
	<ulong: HttpSendResponseEntityBody>
	^self invalidArgument

"
ULONG HttpSendResponseEntityBody(
  _In_      HANDLE ReqQueueHandle,
  _In_      HTTP_REQUEST_ID RequestId,
  _In_      ULONG Flags,
  _In_      USHORT EntityChunkCount,
  _In_      PHTTP_DATA_CHUNK pEntityChunks,
  _Out_     PULONG pBytesSent,
  _In_      PVOID pReserved1,
  _In_      ULONG Reserved2,
  _In_      LPOVERLAPPED pOverlapped,
  _In_opt_   PHTTP_LOG_DATA  pLogData
);
"]

{ #category : #api }
HttpApiDLL >> HttpSetRequestQueueProperty: handle
Property: property
pPropertyInformation: info
PropertyInformationLength: integer
Reserved: dummy1
pReserved: dummy2 [
	<ulong: HttpSetRequestQueueProperty>
	^self invalidArgument

"
ULONG HttpSetRequestQueueProperty(
  _In_       HANDLE               Handle,
  _In_       HTTP_SERVER_PROPERTY Property,
  _In_       PVOID                pPropertyInformation,
  _In_       ULONG                PropertyInformationLength,
  _Reserved_ ULONG                Reserved,
  _Reserved_ PVOID                pReserved
);
"]

{ #category : #services }
HttpApiDLL >> HttpSetRequestQueueProperty: queue Property: property PropertyInformation: info [
	| buffer return |
	buffer := info asExternalInt32 externalCopy.
	return := self
		HttpSetRequestQueueProperty: queue asParameter
		Property: property
		pPropertyInformation: buffer asParameter
		PropertyInformationLength: ExternalInt32 sizeInBytes
		Reserved: 0
		pReserved: 0.
	buffer free.
	return = NO_ERROR ifTrue: [^self].
	self winError: return]

{ #category : #all }
HttpApiDLL >> HttpSetServerSessionProperty: ServerSessionId
_: hi
Property: property
pPropertyInformation: info
PropertyInformationLength: integer [
	<ulong: HttpSetServerSessionProperty>
	^self invalidArgument

"
ULONG HttpSetServerSessionProperty(
  _In_ HTTP_SERVER_SESSION_ID ServerSessionId,
  _In_ HTTP_SERVER_PROPERTY   Property,
  _In_ PVOID                  pPropertyInformation,
  _In_ ULONG                  PropertyInformationLength
);
"]

{ #category : #all }
HttpApiDLL >> HttpSetServerSessionProperty: ServerSessionId
Property: property
pPropertyInformation: info
PropertyInformationLength: integer [
	<ulong: HttpSetServerSessionProperty>
	^self invalidArgument

"
ULONG HttpSetServerSessionProperty(
  _In_ HTTP_SERVER_SESSION_ID ServerSessionId,
  _In_ HTTP_SERVER_PROPERTY   Property,
  _In_ PVOID                  pPropertyInformation,
  _In_ ULONG                  PropertyInformationLength
);
"]

{ #category : #services }
HttpApiDLL >> HttpSetServerSessionProperty: session Property: property PropertyInformation: structure [
	| buffer return |
	buffer := structure externalCopy.
	return := self
		setServerSessionProperty: session
		Property: property
		pPropertyInformation: buffer asParameter
		PropertyInformationLength: buffer sizeInBytes.
	return = NO_ERROR ifFalse: [self winError: return].
	buffer == structure ifFalse: [buffer free]]

{ #category : #api }
HttpApiDLL >> HttpSetUrlGroupProperty: UrlGroupIdLow
_: hi
Property: property
pPropertyInformation: info
PropertyInformationLength: length [
	<ulong: HttpSetUrlGroupProperty>
	^self invalidArgument

"
ULONG HttpSetUrlGroupProperty(
  _In_  HTTP_URL_GROUP_ID UrlGroupId,
  _In_  HTTP_SERVER_PROPERTY Property,
  _In_  PVOID pPropertyInformation,
  _In_  ULONG PropertyInformationLength
);
"]

{ #category : #api }
HttpApiDLL >> HttpSetUrlGroupProperty: UrlGroupId
Property: property
pPropertyInformation: info
PropertyInformationLength: length [
	<ulong: HttpSetUrlGroupProperty>
	^self invalidArgument

"
ULONG HttpSetUrlGroupProperty(
  _In_  HTTP_URL_GROUP_ID UrlGroupId,
  _In_  HTTP_SERVER_PROPERTY Property,
  _In_  PVOID pPropertyInformation,
  _In_  ULONG PropertyInformationLength
);
"]

{ #category : #services }
HttpApiDLL >> HttpSetUrlGroupProperty: id Property: anInteger PropertyInformation: structure [
	| buffer return |
	buffer := structure externalCopy.
	return := self
		setUrlGroupProperty: id
		Property: anInteger
		pPropertyInformation: buffer asParameter
		PropertyInformationLength: buffer sizeInBytes.
	return = NO_ERROR ifTrue: [
		buffer == structure ifFalse: [buffer free].
		^self].
	self winError: return]

{ #category : #private }
HttpApiDLL >> HttpShutdownRequestQueue: ReqQueueHandle [
	<ulong: HttpShutdownRequestQueue>
	^self invalidArgument

"
ULONG HttpShutdownRequestQueue(
  _In_ HANDLE ReqQueueHandle
);
"]

{ #category : #api }
HttpApiDLL >> HttpTerminate: Flags pReserved: zero [
	<ulong: HttpTerminate>
	^self invalidArgument

"
ULONG HttpTerminate(
  _In_        ULONG Flags,
  _Reserved_  PVOID pReserved
);
"]

{ #category : #api }
HttpApiDLL >> HttpWaitForDemandStart: ReqQueueHandle pOverlapped: anOVERLAPPED [
	<ulong: HttpWaitForDemandStart>
	^self invalidArgument

"
ULONG HttpWaitForDemandStart(
  _In_     HANDLE       ReqQueueHandle,
  _In_opt_ LPOVERLAPPED pOverlapped
);
"]

{ #category : #api }
HttpApiDLL >> queryServerSessionProperty: serverSessionId
Property: property
pPropertyInformation: info
PropertyInformationLength: integer
pReturnLength: length [
	^WordSize = 4
		ifTrue: [
			self
				HttpQueryServerSessionProperty: serverSessionId lowULong
				_: serverSessionId highULong
				Property: property
				pPropertyInformation: info
				PropertyInformationLength: integer
				pReturnLength: length]
		ifFalse: [
			self
				HttpQueryServerSessionProperty: serverSessionId asParameter
				Property: property
				pPropertyInformation: info
				PropertyInformationLength: integer
				pReturnLength: length]]

{ #category : #api }
HttpApiDLL >> queryUrlGroupProperty: UrlGroupId
Property: anHTTP_SERVER_PROPERTY
pPropertyInformation: info
PropertyInformationLength: length
pReturnLength: return [
	^WordSize = 4
		ifTrue: [
			self
				HttpQueryUrlGroupProperty: UrlGroupId lowULong
				_: UrlGroupId highULong
				Property: anHTTP_SERVER_PROPERTY
				pPropertyInformation: info
				PropertyInformationLength: length
				pReturnLength: return]
		ifFalse: [
			self
				HttpQueryUrlGroupProperty: UrlGroupId asParameter
				Property: anHTTP_SERVER_PROPERTY
				pPropertyInformation: info
				PropertyInformationLength: length
				pReturnLength: return]]

{ #category : #api }
HttpApiDLL >> receiveHttpRequest: reqQueueHandle
RequestId: requestId
Flags: flags
RequestBuffer: buffer
RequestBufferLength: size
pBytesReceived: bytes
pOverlapped: anOVERLAPPED [
	^WordSize = 4
		ifTrue: [
			self
				HttpReceiveHttpRequest: reqQueueHandle
				RequestId: requestId lowULong
				_: requestId highULong
				Flags: flags
				RequestBuffer: buffer
				RequestBufferLength: size
				pBytesReceived: bytes
				pOverlapped: anOVERLAPPED]
		ifFalse: [
			self
				HttpReceiveHttpRequest: reqQueueHandle
				RequestId: requestId asParameter
				Flags: flags
				RequestBuffer: buffer
				RequestBufferLength: size
				pBytesReceived: bytes
				pOverlapped: anOVERLAPPED]]

{ #category : #api }
HttpApiDLL >> receiveRequestEntityBody: ReqQueueHandle
RequestId: RequestId
Flags: flags
pBuffer: buffer
BufferLength: size
pBytesReceived: bytes
pOverlapped: anOVERLAPPED [
	^WordSize = 4
		ifTrue: [
			self
				HttpReceiveRequestEntityBody: ReqQueueHandle
				RequestId: RequestId lowULong
				_: RequestId highULong
				Flags: flags
				pBuffer: buffer
				BufferLength: size
				pBytesReceived: bytes
				pOverlapped: anOVERLAPPED]
		ifFalse: [
			self
				HttpReceiveRequestEntityBody: ReqQueueHandle
				RequestId: RequestId asParameter
				Flags: flags
				pBuffer: buffer
				BufferLength: size
				pBytesReceived: bytes
				pOverlapped: anOVERLAPPED]]

{ #category : #api }
HttpApiDLL >> removeUrlFromUrlGroup: UrlGroupId pFullyQualifiedUrl: aString Flags: anInteger [
	^WordSize = 4
		ifTrue: [
			self
				HttpRemoveUrlFromUrlGroup: UrlGroupId lowULong
				_: UrlGroupId highULong
				pFullyQualifiedUrl: aString
				Flags: anInteger]
		ifFalse: [
			self
				HttpRemoveUrlFromUrlGroup: UrlGroupId asParameter
				pFullyQualifiedUrl: aString
				Flags: anInteger]]

{ #category : #api }
HttpApiDLL >> sendHttpResponse: ReqQueueHandle
RequestId: RequestId
Flags: flags
pHttpResponse: anHTTP_RESPONSE
pCachePolicy: anHTTP_CACHE_POLICY
pBytesSent: sent
pReserved2: zero1
Reserved3: zero2
pOverlapped: anOVERLAPPED
pLogData: aHTTP_LOG_DATA [
	^WordSize = 4
		ifTrue: [
			self
				HttpSendHttpResponse: ReqQueueHandle
				RequestId: RequestId lowULong
				_: RequestId highULong
				Flags: flags
				pHttpResponse: anHTTP_RESPONSE
				pCachePolicy: anHTTP_CACHE_POLICY
				pBytesSent: sent
				pReserved2: zero1
				Reserved3: zero2
				pOverlapped: anOVERLAPPED
				pLogData: aHTTP_LOG_DATA]
		ifFalse: [
			self
				HttpSendHttpResponse: ReqQueueHandle
				RequestId: RequestId asParameter
				Flags: flags
				pHttpResponse: anHTTP_RESPONSE
				pCachePolicy: anHTTP_CACHE_POLICY
				pBytesSent: sent
				pReserved2: zero1
				Reserved3: zero2
				pOverlapped: anOVERLAPPED
				pLogData: aHTTP_LOG_DATA]]

{ #category : #api }
HttpApiDLL >> sendResponseEntityBody: reqQueueHandle
RequestId: requestId
Flags: flags
EntityChunkCount: count
pEntityChunks: anHTTP_DATA_CHUNK
pBytesSent: sent
pOverlapped: anOVERLAPPED
pLogData: anHTTP_LOG_DATA [
	^WordSize = 4
		ifTrue: [
			self
				HttpSendResponseEntityBody: reqQueueHandle
				RequestId: requestId lowULong
				_: requestId highULong
				Flags: flags
				EntityChunkCount: count
				pEntityChunks: anHTTP_DATA_CHUNK
				pBytesSent: sent
				pReserved1: 0
				Reserved2: 0
				pOverlapped: anOVERLAPPED
				pLogData: anHTTP_LOG_DATA]
		ifFalse: [
			self
				HttpSendResponseEntityBody: reqQueueHandle
				RequestId: requestId asParameter
				Flags: flags
				EntityChunkCount: count
				pEntityChunks: anHTTP_DATA_CHUNK
				pBytesSent: sent
				pReserved1: 0
				Reserved2: 0
				pOverlapped: anOVERLAPPED
				pLogData: anHTTP_LOG_DATA]]

{ #category : #all }
HttpApiDLL >> setServerSessionProperty: serverSessionId
Property: property
pPropertyInformation: info
PropertyInformationLength: integer [
	^WordSize = 4
		ifTrue: [
			self
				HttpSetServerSessionProperty: serverSessionId lowULong
				_: serverSessionId highULong
				Property: property
				pPropertyInformation: info
				PropertyInformationLength: integer]
		ifFalse: [
			self
				HttpSetServerSessionProperty: serverSessionId asParameter
				Property: property
				pPropertyInformation: info
				PropertyInformationLength: integer]]

{ #category : #api }
HttpApiDLL >> setUrlGroupProperty: UrlGroupId
Property: property
pPropertyInformation: info
PropertyInformationLength: length [
	^WordSize = 4
		ifTrue: [
			self
				HttpSetUrlGroupProperty: UrlGroupId lowULong
				_: UrlGroupId highULong
				Property: property
				pPropertyInformation: info
				PropertyInformationLength: length]
		ifFalse: [
			self
				HttpSetUrlGroupProperty: UrlGroupId asParameter
				Property: property
				pPropertyInformation: info
				PropertyInformationLength: length]]

