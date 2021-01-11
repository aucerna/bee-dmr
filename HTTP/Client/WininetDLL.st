"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #WininetDLL,
	#superclass : #WindowsLibrary,
	#type : #bytes,
	#category : #'HTTP\Client'
}

{ #category : #callbacks }
WininetDLL class >> callbackTable [
	"
	WininetDLL callbackTable
	"
	^#(
	"(callBackName (arguments...) returnType callingConvertion)"

	"typedef
		VOID
		(CALLBACK * INTERNET_STATUS_CALLBACK)(
			IN HINTERNET hInternet,
			IN DWORD dwContext,
			IN DWORD dwInternetStatus,
			IN LPVOID lpvStatusInformation OPTIONAL,
			IN DWORD dwStatusInformationLength
		);
	"
	(internetStatusCallback (ulong ulong ulong ulong ulong) none api)

	"
	typedef
	BOOL
	(CALLBACK * GOPHER_ATTRIBUTE_ENUMERATOR)(
		LPGOPHER_ATTRIBUTE_TYPE lpAttributeInfo,
		DWORD dwError
		);
	"
	(gopherAttributeEnumerator (ulong ulong) boolean api)

	)]

{ #category : #parsing }
WininetDLL class >> h [
	^SmalltalkSession current devDirectory \ 'wininet.h']

{ #category : #initialization }
WininetDLL class >> initializeConstants [
	"
	WininetDLL initializeConstants.
	"
	self
		initializeInternetConstants;
		initializeInternetStatusConstants;
		initializeInternetStateConstants;
		initializeInternetFlags;
		initializeInternetFlags2]

{ #category : #initialization }
WininetDLL class >> initializeInternetConstants [
	"
	WininetDLL initializeInternetConstants.
	"
	WinInetConstants := PoolDictionary new.
	WinInetConstants
		at: 'CERN_PROXY_INTERNET_ACCESS' put: 16r3;
		at: 'ERROR_FTP_DROPPED' put: 16r2F4F;
		at: 'ERROR_FTP_TRANSFER_IN_PROGRESS' put: 16r2F4E;
		at: 'ERROR_HTTP_DOWNLEVEL_SERVER' put: 16r2F77;
		at: 'ERROR_HTTP_HEADER_ALREADY_EXISTS' put: 16r2F7B;
		at: 'ERROR_HTTP_HEADER_NOT_FOUND' put: 16r2F76;
		at: 'ERROR_HTTP_INVALID_HEADER' put: 16r2F79;
		at: 'ERROR_HTTP_INVALID_QUERY_REQUEST' put: 16r2F7A;
		at: 'ERROR_HTTP_INVALID_SERVER_RESPONSE' put: 16r2F78;
		at: 'ERROR_INTERNET_BAD_OPTION_LENGTH' put: 16r2EEA;
		at: 'ERROR_INTERNET_BAD_REGISTRY_PARAMETER' put: 16r2EF6;
		at: 'ERROR_INTERNET_CANNOT_CONNECT' put: 16r2EFD;
		at: 'ERROR_INTERNET_CONNECTION_ABORTED' put: 16r2EFE;
		at: 'ERROR_INTERNET_CONNECTION_RESET' put: 16r2EFF;
		at: 'ERROR_INTERNET_EXTENDED_ERROR' put: 16r2EE3;
		at: 'ERROR_INTERNET_FORCE_RETRY' put: 16r2F00;
		at: 'ERROR_INTERNET_HANDLE_EXISTS' put: 16r2F04;
		at: 'ERROR_INTERNET_INCORRECT_FORMAT' put: 16r2EFB;
		at: 'ERROR_INTERNET_INCORRECT_HANDLE_STATE' put: 16r2EF3;
		at: 'ERROR_INTERNET_INCORRECT_HANDLE_TYPE' put: 16r2EF2;
		at: 'ERROR_INTERNET_INCORRECT_PASSWORD' put: 16r2EEE;
		at: 'ERROR_INTERNET_INCORRECT_USER_NAME' put: 16r2EED;
		at: 'ERROR_INTERNET_INTERNAL_ERROR' put: 16r2EE4;
		at: 'ERROR_INTERNET_INVALID_OPERATION' put: 16r2EF0;
		at: 'ERROR_INTERNET_INVALID_OPTION' put: 16r2EE9;
		at: 'ERROR_INTERNET_INVALID_URL' put: 16r2EE5;
		at: 'ERROR_INTERNET_ITEM_NOT_FOUND' put: 16r2EFC;
		at: 'ERROR_INTERNET_LOGIN_FAILURE' put: 16r2EEF;
		at: 'ERROR_INTERNET_MIXED_SECURITY' put: 16r2F02;
		at: 'ERROR_INTERNET_NAME_NOT_RESOLVED' put: 16r2EE7;
		at: 'ERROR_INTERNET_NO_CALLBACK' put: 16r2EF9;
		at: 'ERROR_INTERNET_NO_CONTEXT' put: 16r2EF8;
		at: 'ERROR_INTERNET_NO_DIRECT_ACCESS' put: 16r2EF7;
		at: 'ERROR_INTERNET_NOT_PROXY_REQUEST' put: 16r2EF4;
		at: 'ERROR_INTERNET_OPERATION_CANCELLED' put: 16r2EF1;
		at: 'ERROR_INTERNET_OPTION_NOT_SETTABLE' put: 16r2EEB;
		at: 'ERROR_INTERNET_OUT_OF_HANDLES' put: 16r2EE1;
		at: 'ERROR_INTERNET_PROTOCOL_NOT_FOUND' put: 16r2EE8;
		at: 'ERROR_INTERNET_REGISTRY_VALUE_NOT_FOUND' put: 16r2EF5;
		at: 'ERROR_INTERNET_REQUEST_PENDING' put: 16r2EFA;
		at: 'ERROR_INTERNET_SHUTDOWN' put: 16r2EEC;
		at: 'ERROR_INTERNET_SSL_CERT_CN_INVALID' put: 16r2F03;
		at: 'ERROR_INTERNET_TIMEOUT' put: 16r2EE2;
		at: 'ERROR_INTERNET_UNRECOGNIZED_SCHEME' put: 16r2EE6;
		at: 'ERROR_INTERNET_ZONE_CROSSING' put: 16r2F01;
		at: 'FLAGS_ERROR_UI_FILTER_FOR_ERRORS' put: 16r1;
		at: 'FLAGS_ERROR_UI_FLAGS_CHANGE_OPTIONS' put: 16r2;
		at: 'FLAGS_ERROR_UI_FLAGS_GENERATE_DATA' put: 16r4;
		at: 'FTP_TRANSFER_TYPE_ASCII' put: 16r1;
		at: 'FTP_TRANSFER_TYPE_BINARY' put: 16r2;
		at: 'FTP_TRANSFER_TYPE_MASK' put: 16r3;
		at: 'FTP_TRANSFER_TYPE_UNKNOWN' put: 16r0;
		at: 'GATEWAY_INTERNET_ACCESS' put: 16r2;
		at: 'HTTP_ADDREQ_FLAG_ADD' put: 16r20000000;
		at: 'HTTP_ADDREQ_FLAG_ADD_IF_NEW' put: 16r10000000;
		at: 'HTTP_ADDREQ_FLAG_COALESCE' put: 16r40000000;
		at: 'HTTP_ADDREQ_FLAG_REPLACE' put: 16r80000000;
		at: 'HTTP_ADDREQ_FLAGS_MASK' put: 16rFFFF0000;
		at: 'HTTP_ADDREQ_INDEX_MASK' put: 16rFFFF;
		at: 'HTTP_MAJOR_VERSION' put: 16r1;
		at: 'HTTP_MINOR_VERSION' put: 16r0;
		at: 'HTTP_QUERY_ACCEPT' put: 16r18;
		at: 'HTTP_QUERY_ACCEPT_CHARSET' put: 16r19;
		at: 'HTTP_QUERY_ACCEPT_ENCODING' put: 16r1A;
		at: 'HTTP_QUERY_ACCEPT_LANGUAGE' put: 16r1B;
		at: 'HTTP_QUERY_ACCEPT_RANGES' put: 16r2A;
		at: 'HTTP_QUERY_ALLOW' put: 16r7;
		at: 'HTTP_QUERY_AUTHORIZATION' put: 16r1C;
		at: 'HTTP_QUERY_CONNECTION' put: 16r17;
		at: 'HTTP_QUERY_CONTENT_DESCRIPTION' put: 16r4;
		at: 'HTTP_QUERY_CONTENT_ENCODING' put: 16r1D;
		at: 'HTTP_QUERY_CONTENT_ID' put: 16r3;
		at: 'HTTP_QUERY_CONTENT_LANGUAGE' put: 16r6;
		at: 'HTTP_QUERY_CONTENT_LENGTH' put: 16r5;
		at: 'HTTP_QUERY_CONTENT_TRANSFER_ENCODING' put: 16r2;
		at: 'HTTP_QUERY_CONTENT_TYPE' put: 16r1;
		at: 'HTTP_QUERY_COST' put: 16rF;
		at: 'HTTP_QUERY_CUSTOM' put: 16rFFFF;
		at: 'HTTP_QUERY_DATE' put: 16r9;
		at: 'HTTP_QUERY_DERIVED_FROM' put: 16rE;
		at: 'HTTP_QUERY_EXPIRES' put: 16rA;
		at: 'HTTP_QUERY_FLAG_COALESCE' put: 16r10000000;
		at: 'HTTP_QUERY_FLAG_NUMBER' put: 16r20000000;
		at: 'HTTP_QUERY_FLAG_REQUEST_HEADERS' put: 16r80000000;
		at: 'HTTP_QUERY_FLAG_SYSTEMTIME' put: 16r40000000;
		at: 'HTTP_QUERY_FORWARDED' put: 16r1E;
		at: 'HTTP_QUERY_FROM' put: 16r1F;
		at: 'HTTP_QUERY_HEADER_MASK' put: 16r0;
		at: 'HTTP_QUERY_IF_MODIFIED_SINCE' put: 16r20;
		at: 'HTTP_QUERY_LAST_MODIFIED' put: 16rB;
		at: 'HTTP_QUERY_LINK' put: 16r10;
		at: 'HTTP_QUERY_LOCATION' put: 16r21;
		at: 'HTTP_QUERY_MAX' put: 16r2A;
		at: 'HTTP_QUERY_MESSAGE_ID' put: 16rC;
		at: 'HTTP_QUERY_MIME_VERSION' put: 16r0;
		at: 'HTTP_QUERY_MODIFIER_FLAGS_MASK' put: 16rF0000000;
		at: 'HTTP_QUERY_ORIG_URI' put: 16r22;
		at: 'HTTP_QUERY_PRAGMA' put: 16r11;
		at: 'HTTP_QUERY_PROXY_AUTHENTICATE' put: 16r29;
		at: 'HTTP_QUERY_PUBLIC' put: 16r8;
		at: 'HTTP_QUERY_RAW_HEADERS' put: 16r15;
		at: 'HTTP_QUERY_RAW_HEADERS_CRLF' put: 16r16;
		at: 'HTTP_QUERY_REFERER' put: 16r23;
		at: 'HTTP_QUERY_RETRY_AFTER' put: 16r24;
		at: 'HTTP_QUERY_SERVER' put: 16r25;
		at: 'HTTP_QUERY_STATUS_CODE' put: 16r13;
		at: 'HTTP_QUERY_STATUS_TEXT' put: 16r14;
		at: 'HTTP_QUERY_TITLE' put: 16r26;
		at: 'HTTP_QUERY_URI' put: 16rD;
		at: 'HTTP_QUERY_USER_AGENT' put: 16r27;
		at: 'HTTP_QUERY_VERSION' put: 16r12;
		at: 'HTTP_QUERY_WWW_AUTHENTICATE' put: 16r28;
		at: 'HTTP_STATUS_ACCEPTED' put: 16rCA;
		at: 'HTTP_STATUS_AMBIGUOUS' put: 16r12C;
		at: 'HTTP_STATUS_AUTH_REFUSED' put: 16r19B;
		at: 'HTTP_STATUS_BAD_GATEWAY' put: 16r1F6;
		at: 'HTTP_STATUS_BAD_METHOD' put: 16r195;
		at: 'HTTP_STATUS_BAD_REQUEST' put: 16r190;
		at: 'HTTP_STATUS_CONFLICT' put: 16r199;
		at: 'HTTP_STATUS_CREATED' put: 16rC9;
		at: 'HTTP_STATUS_DENIED' put: 16r191;
		at: 'HTTP_STATUS_FORBIDDEN' put: 16r193;
		at: 'HTTP_STATUS_GATEWAY_TIMEOUT' put: 16r1F8;
		at: 'HTTP_STATUS_GONE' put: 16r19A;
		at: 'HTTP_STATUS_MOVED' put: 16r12D;
		at: 'HTTP_STATUS_NO_CONTENT' put: 16rCC;
		at: 'HTTP_STATUS_NONE_ACCEPTABLE' put: 16r196;
		at: 'HTTP_STATUS_NOT_FOUND' put: 16r194;
		at: 'HTTP_STATUS_NOT_MODIFIED' put: 16r130;
		at: 'HTTP_STATUS_NOT_SUPPORTED' put: 16r1F5;
		at: 'HTTP_STATUS_OK' put: 16rC8;
		at: 'HTTP_STATUS_PARTIAL' put: 16rCB;
		at: 'HTTP_STATUS_PAYMENT_REQ' put: 16r192;
		at: 'HTTP_STATUS_PROXY_AUTH_REQ' put: 16r197;
		at: 'HTTP_STATUS_REDIRECT' put: 16r12E;
		at: 'HTTP_STATUS_REDIRECT_METHOD' put: 16r12F;
		at: 'HTTP_STATUS_REQUEST_TIMEOUT' put: 16r198;
		at: 'HTTP_STATUS_SERVER_ERROR' put: 16r1F4;
		at: 'HTTP_STATUS_SERVICE_UNAVAIL' put: 16r1F7;
		at: 'HTTP_VERSION' put: 'HTTP/1.0';
		at: 'ICU_ESCAPE' put: 16r80000000;
		at: 'ICU_USERNAME' put: 16r40000000;
		at: 'ICU_NO_ENCODE' put: 16r20000000;
		at: 'ICU_DECODE' put: 16r10000000;
		at: 'ICU_NO_META' put: 16r8000000;
		at: 'ICU_ENCODE_SPACES_ONLY' put: 16r4000000;
		at: 'ICU_BROWSER_MODE' put: 16r2000000;
		at: 'INTERNET_DEFAULT_FTP_PORT' put: 16r15;
		at: 'INTERNET_DEFAULT_HTTP_PORT' put: 16r50;
		at: 'INTERNET_DEFAULT_HTTPS_PORT' put: 16r1BB;
		at: 'INTERNET_ERROR_BASE' put: 16r2EE0;
		at: 'INTERNET_FIRST_OPTION' put: 16r1;
		at: 'INTERNET_FLAGS_MASK' put: 16rFFC00000;
		at: 'INTERNET_HANDLE_TYPE_CONNECT_FTP' put: 16r2;
		at: 'INTERNET_HANDLE_TYPE_CONNECT_HTTP' put: 16r4;
		at: 'INTERNET_HANDLE_TYPE_FTP_FILE' put: 16r7;
		at: 'INTERNET_HANDLE_TYPE_FTP_FILE_HTML' put: 16r8;
		at: 'INTERNET_HANDLE_TYPE_FTP_FIND' put: 16r5;
		at: 'INTERNET_HANDLE_TYPE_FTP_FIND_HTML' put: 16r6;
		at: 'INTERNET_HANDLE_TYPE_HTTP_REQUEST' put: 16rD;
		at: 'INTERNET_HANDLE_TYPE_INTERNET' put: 16r1;
		at: 'INTERNET_INVALID_PORT_NUMBER' put: 16r0;
		at: 'INTERNET_INVALID_STATUS_CALLBACK' put: '-1';
		at: 'INTERNET_KEEP_ALIVE_DISABLED' put: 16r0;
		at: 'INTERNET_KEEP_ALIVE_ENABLED' put: 16r1;
		at: 'INTERNET_KEEP_ALIVE_UNKNOWN' put: -16r1;
		at: 'INTERNET_LAST_OPTION' put: 16r20;
		at: 'INTERNET_MAX_HOST_NAME_LENGTH' put: 16r100;
		at: 'INTERNET_MAX_PASSWORD_LENGTH' put: 16r80;
		at: 'INTERNET_MAX_PATH_LENGTH' put: 16r400;
		at: 'INTERNET_MAX_PORT_NUMBER_LENGTH' put: 16r5;
		at: 'INTERNET_MAX_PORT_NUMBER_VALUE' put: 16rFFFF;
		at: 'INTERNET_MAX_PROTOCOL_NAME' put: 'gopher';
		at: 'INTERNET_MAX_URL_LENGTH' put: 16r408;
		at: 'INTERNET_MAX_USER_NAME_LENGTH' put: 16r80;
		at: 'INTERNET_NO_CALLBACK' put: 16r0;
		at: 'INTERNET_OPTION_BYPASS_EDITED_ENTRY' put: 16r40;
		at: 'INTERNET_OPEN_TYPE_DIRECT' put: 16r1;
		at: 'INTERNET_OPEN_TYPE_PRECONFIG' put: 16r0;
		at: 'INTERNET_OPEN_TYPE_PROXY' put: 16r3;
		at: 'INTERNET_OPTION_ASYNC' put: 16r1E;
		at: 'INTERNET_OPTION_ASYNC_ID' put: 16rF;
		at: 'INTERNET_OPTION_ASYNC_PRIORITY' put: 16r10;
		at: 'INTERNET_OPTION_ASYNC_QUEUE_DEPTH' put: 16r13;
		at: 'INTERNET_OPTION_ASYNC_REQUEST_COUNT' put: 16r11;
		at: 'INTERNET_OPTION_CACHE_STREAM_HANDLE' put: 16r1B;
		at: 'INTERNET_OPTION_CALLBACK' put: 16r1;
		at: 'INTERNET_OPTION_CONNECT_BACKOFF' put: 16r4;
		at: 'INTERNET_OPTION_CONNECT_RETRIES' put: 16r3;
		at: 'INTERNET_OPTION_CONNECT_TIMEOUT' put: 16r2;
		at: 'INTERNET_OPTION_CONTEXT_VALUE' put: 16rA;
		at: 'INTERNET_OPTION_CONTROL_RECEIVE_TIMEOUT' put: 16r6;
		at: 'INTERNET_OPTION_CONTROL_SEND_TIMEOUT' put: 16r5;
		at: 'INTERNET_OPTION_DATA_RECEIVE_TIMEOUT' put: 16r8;
		at: 'INTERNET_OPTION_DATA_SEND_TIMEOUT' put: 16r7;
		at: 'INTERNET_OPTION_EXTENDED_ERROR' put: 16r18;
		at: 'INTERNET_OPTION_GATEWAY_NAME' put: 16rE;
		at: 'INTERNET_OPTION_HANDLE_TYPE' put: 16r9;
		at: 'INTERNET_OPTION_KEEP_CONNECTION' put: 16r16;
		at: 'INTERNET_OPTION_MAXIMUM_WORKER_THREADS' put: 16r12;
		at: 'INTERNET_OPTION_NAME_RES_THREAD' put: 16rB;
		at: 'INTERNET_OPTION_OFFLINE_MODE' put: 16r1A;
		at: 'INTERNET_OPTION_PARENT_HANDLE' put: 16r15;
		at: 'INTERNET_OPTION_PASSWORD' put: 16r1D;
		at: 'INTERNET_OPTION_READ_BUFFER_SIZE' put: 16rC;
		at: 'INTERNET_OPTION_RECEIVE_ALL_MODE' put: 16r19;
		at: 'INTERNET_OPTION_RECEIVE_TIMEOUT' put: 16r6;
		at: 'INTERNET_OPTION_REQUEST_FLAGS' put: 16r17;
		at: 'INTERNET_OPTION_SECURITY_CERTIFICATE' put: 16r23;
		at: 'INTERNET_OPTION_SECURITY_CERTIFICATE_STRUCT' put: 16r20;
		at: 'INTERNET_OPTION_SECURITY_KEY_BITNESS' put: 16r1F;
		at: 'INTERNET_OPTION_SEND_TIMEOUT' put: 16r5;
		at: 'INTERNET_OPTIONS_MASK' put: 16r0;
		at: 'INTERNET_OPTION_USERNAME' put: 16r1C;
		at: 'INTERNET_OPTION_WORKER_THREAD_TIMEOUT' put: 16r14;
		at: 'INTERNET_OPTION_WRITE_BUFFER_SIZE' put: 16rD;
		at: 'INTERNET_PRIORITY_FOREGROUND' put: 16r3E8;
		at: 'INTERNET_REQFLAG_ASYNC' put: 16r2;
		at: 'INTERNET_REQFLAG_FROM_CACHE' put: 16r1;
		at: 'INTERNET_SCHEME_DEFAULT' put: 16r0;
		at: 'INTERNET_SCHEME_FTP' put: 16r1;
		at: 'INTERNET_SCHEME_HTTP' put: 16r3;
		at: 'INTERNET_SCHEME_HTTPS' put: 16r4;
		at: 'INTERNET_SERVICE_FTP' put: 16r1;
		at: 'INTERNET_SERVICE_HTTP' put: 16r3;
		at: 'LOCAL_INTERNET_ACCESS' put: 16r1;
		at: 'PRE_CONFIG_INTERNET_ACCESS' put: 16r0]

{ #category : #initialization }
WininetDLL class >> initializeInternetFlags [
	"
	WininetDLL initializeInternetFlags
	"
	WinInetConstants
		at: 'INTERNET_COOKIE_EVALUATE_P3P'
		put: 16r80
		"Indicates that a Platform for Privacy Protection (P3P) header is to be associated with a cookie.";
		at: 'INTERNET_COOKIE_THIRD_PARTY'
		put: 16r10
		"Indicates that a third-party cookie is being set or retrieved.";
		at: 'INTERNET_FLAG_ASYNC'
		put: 16r10000000
		"Makes only asynchronous requests on handles descended from the handle returned from this function. Only the InternetOpen function uses this flag.";
		at: 'INTERNET_FLAG_CACHE_ASYNC'
		put: 16r80
		"Allows a lazy cache write.";
		at: 'INTERNET_FLAG_CACHE_IF_NET_FAIL'
		put: 16r10000
		"Returns the resource from the cache if the network request for the resource fails due to an ERROR_INTERNET_CONNECTION_RESET or ERROR_INTERNET_CANNOT_CONNECT error. This flag is used by HttpOpenRequest.";
		at: 'INTERNET_FLAG_DONT_CACHE'
		put: 16r4000000
		"Does not add the returned entity to the cache. This is identical to the preferred value, iNTERNET_FLAG_NO_CACHE_WRITE.";
		at: 'INTERNET_FLAG_EXISTING_CONNECT'
		put: 16r20000000
		"Attempts to use an existing InternetConnect object if one exists with the same attributes required to make the request. This is useful only with FTP operations, since FTP is the only protocol that typically performs multiple operations during the same session. WinINet caches a single connection handle for each HINTERNET handle generated by InternetOpen. The InternetOpenUrl and InternetConnect functions use this flag for Http and Ftp connections.";
		at: 'INTERNET_FLAG_FORMS_SUBMIT'
		put: 16r40
		"Indicates that this is a Forms submission.";
		at: 'INTERNET_FLAG_FROM_CACHE'
		put: 16r1000000
		"Does not make network requests. All entities are returned from the cache. If the requested item is not in the cache, a suitable error, such as ERROR_FILE_NOT_FOUND, is returned. Only the InternetOpen function uses this flag.";
		at: 'INTERNET_FLAG_FWD_BACK'
		put: 16r20
		"Indicates that the function should use the copy of the resource that is currently in the Internet cache. The expiration date and other information about the resource is not checked. If the requested item is not found in the Internet cache, the system attempts to locate the resource on the network. This value was introduced in Microsoft Internet Explorer 5 and is associated with the Forward and Back button operations of Internet Explorer.";
		at: 'INTERNET_FLAG_HYPERLINK'
		put: 16r400
		"Forces a reload if there is no Expires time and no LastModified time returned from the server when determining whether to reload the item from the network. This flag can be used by FtpFindFirstFile, FtpGetFile, FtpOpenFile, FtpPutFile, HttpOpenRequest, and InternetOpenUrl.

    Windows XP and Windows Server 2003 R2 and earlier:  Also used by GopherFindFirstFile and GopherOpenFile.";
		at: 'INTERNET_FLAG_IGNORE_CERT_CN_INVALID'
		put: 16r1000
		"Disables checking of SSL/PCT-based certificates that are returned from the server against the host name given in the request. WinINet uses a simple check against certificates by comparing for matching host names and simple wildcarding rules. This flag can be used by HttpOpenRequest and InternetOpenUrl (for HTTP requests).";
		at: 'INTERNET_FLAG_IGNORE_CERT_DATE_INVALID'
		put: 16r2000
		"Disables checking of SSL/PCT-based certificates for proper validity dates. This flag can be used by HttpOpenRequest and InternetOpenUrl (for HTTP requests).";
		at: 'INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP'
		put: 16r8000
		"Disables detection of this special type of redirect. When this flag is used, WinINet transparently allows redirects from HTTPS to HTTP URLs. This flag can be used by HttpOpenRequest and InternetOpenUrl (for HTTP requests).";
		at: 'INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS'
		put: 16r4000
		"Disables detection of this special type of redirect. When this flag is used, WinINet transparently allow redirects from HTTP to HTTPS URLs. This flag can be used by HttpOpenRequest and InternetOpenUrl (for HTTP requests).";
		at: 'INTERNET_FLAG_KEEP_CONNECTION'
		put: 16r400000
		"Uses keep-alive semantics, if available, for the connection. This flag is used by HttpOpenRequest and InternetOpenUrl (for HTTP requests). This flag is required for Microsoft Network (MSN), NTLM, and other types of authentication.";
		at: 'INTERNET_FLAG_MAKE_PERSISTENT'
		put: 16r2000000
		"No longer supported.";
		at: 'INTERNET_FLAG_MUST_CACHE_REQUEST'
		put: 16r10
		"Identical to the preferred value, INTERNET_FLAG_NEED_FILE. Causes a temporary file to be created if the file cannot be cached. This flag can be used by FtpFindFirstFile, FtpGetFile, FtpOpenFile, FtpPutFile, HttpOpenRequest, and InternetOpenUrl.
Windows XP and Windows Server 2003 R2 and earlier:  Also used by GopherFindFirstFile and GopherOpenFile.";
		at: 'INTERNET_FLAG_NEED_FILE'
		put: 16r10
		"Causes a temporary file to be created if the file cannot be cached. This flag can be used by FtpFindFirstFile, FtpGetFile, FtpOpenFile, FtpPutFile, HttpOpenRequest, and InternetOpenUrl.
Windows XP and Windows Server 2003 R2 and earlier:  Also used by GopherFindFirstFile and GopherOpenFile.";
		at: 'INTERNET_FLAG_NO_AUTH'
		put: 16r40000
		"Does not attempt authentication automatically. This flag can be used by HttpOpenRequest and InternetOpenUrl (for HTTP requests).";
		at: 'INTERNET_FLAG_NO_AUTO_REDIRECT'
		put: 16r200000
		"Does not automatically handle redirection in HttpSendRequest. This flag can also be used by InternetOpenUrl for HTTP requests.";
		at: 'INTERNET_FLAG_NO_CACHE_WRITE'
		put: 16r4000000
		"Does not add the returned entity to the cache. This flag is used by , HttpOpenRequest, and InternetOpenUrl.
Windows XP and Windows Server 2003 R2 and earlier:  Also used by GopherFindFirstFile and GopherOpenFile.";
		at: 'INTERNET_FLAG_NO_COOKIES'
		put: 16r80000
		"Does not automatically add cookie headers to requests, and does not automatically add returned cookies to the cookie database. This flag can be used by HttpOpenRequest and InternetOpenUrl (for HTTP requests).";
		at: 'INTERNET_FLAG_NO_UI'
		put: 16r200
		"Disables the cookie dialog box. This flag can be used by HttpOpenRequest and InternetOpenUrl (HTTP requests only).";
		at: 'INTERNET_FLAG_OFFLINE'
		put: 16r1000000
		"Identical to INTERNET_FLAG_FROM_CACHE. Does not make network requests. All entities are returned from the cache. If the requested item is not in the cache, a suitable error, such as ERROR_FILE_NOT_FOUND, is returned. Only the InternetOpen function uses this flag.";
		at: 'INTERNET_FLAG_PASSIVE'
		put: 16r8000000
		"Uses passive FTP semantics. Only InternetConnect and InternetOpenUrl use this flag. InternetConnect uses this flag for FTP requests, and InternetOpenUrl uses this flag for FTP files and directories.";
		at: 'INTERNET_FLAG_PRAGMA_NOCACHE'
		put: 16r100
		"Forces the request to be resolved by the origin server, even if a cached copy exists on the proxy. The InternetOpenUrl function (on HTTP and HTTPS requests only) and HttpOpenRequest function use this flag.";
		at: 'INTERNET_FLAG_RAW_DATA'
		put: 16r40000000
		"Returns the data as a WIN32_FIND_DATA structure when retrieving FTP directory information. If this flag is not specified or if the call is made through a CERN proxy, InternetOpenUrl returns the HTML version of the directory. Only the InternetOpenUrl function uses this flag.
Windows XP and Windows Server 2003 R2 and earlier:  Also returns a GOPHER_FIND_DATA structure when retrieving Gopher directory information.";
		at: 'INTERNET_FLAG_READ_PREFETCH'
		put: 16r100000
		"This flag is currently disabled.";
		at: 'INTERNET_FLAG_RELOAD'
		put: 16r80000000
		"Forces a download of the requested file, object, or directory listing from the origin server, not from the cache. The FtpFindFirstFile, FtpGetFile, FtpOpenFile, FtpPutFile, HttpOpenRequest, and InternetOpenUrl functions use this flag.
Windows XP and Windows Server 2003 R2 and earlier:  Also used by GopherFindFirstFile and GopherOpenFile.";
		at: 'INTERNET_FLAG_RESTRICTED_ZONE'
		put: 16r20000
		"Indicates that the cookie being set is associated with an untrusted site.";
		at: 'INTERNET_FLAG_RESYNCHRONIZE'
		put: 16r800
		"Reloads HTTP resources if the resource has been modified since the last time it was downloaded. All FTP resources are reloaded. This flag can be used by FtpFindFirstFile, FtpGetFile, FtpOpenFile, FtpPutFile, HttpOpenRequest, and InternetOpenUrl.
Windows XP and Windows Server 2003 R2 and earlier:  Also used by GopherFindFirstFile and GopherOpenFile, and Gopher resources are reloaded.";
		at: 'INTERNET_FLAG_SECURE'
		put: 16r800000
		"Uses secure transaction semantics. This translates to using Secure Sockets Layer/Private Communications Technology (SSL/PCT) and is only meaningful in HTTP requests. This flag is used by HttpOpenRequest and InternetOpenUrl, but this is redundant if https:// appears in the URL.The InternetConnect function uses this flag for HTTP connections; all the request handles created under this connection will inherit this flag.";
		at: 'INTERNET_FLAG_TRANSFER_ASCII'
		put: 16r1
		"Transfers file as ASCII (FTP only). This flag can be used by FtpOpenFile, FtpGetFile, and FtpPutFile.";
		at: 'INTERNET_FLAG_TRANSFER_BINARY'
		put: 16r2
		"Transfers file as binary (FTP only). This flag can be used by FtpOpenFile, FtpGetFile, and FtpPutFile.";
		at: 'INTERNET_NO_CALLBACK'
		put: 16r0
		"Indicates that no callbacks should be made for that API. This is used for the dxContext parameter of the functions that allow asynchronous operations.";
		at: 'INTERNET_OPTION_SUPPRESS_SERVER_AUTH'
		put: 16r68
		"Sets an HTTP request object such that it will not logon to origin servers, but will perform automatic logon to HTTP proxy servers. This option differs from the Request flag INTERNET_FLAG_NO_AUTH, which prevents authentication to both proxy servers and origin servers. Setting this mode will suppress the use of any credential material (either previously provided username/password or client SSL certificate) when communicating with an origin server. However, if the request must transit via an authenticating proxy, WinINet will still perform automatic authentication to the HTTP proxy per the Intranet Zone settings for the user. The default Intranet Zone setting is to permit automatic logon using the users default credentials. To ensure suppression of all identifying information, the caller should combine INTERNET_OPTION_SUPPRESS_SERVER_AUTH with the INTERNET_FLAG_NO_COOKIES request flag. This option may only be set on request objects before they have been sent. Attempts to set this option after the request has been sent will return ERROR_INTERNET_INCORRECT_HANDLE_STATE. No buffer is required for this option. This is used by InternetSetOption on handles returned by HttpOpenRequest only. Version: Requires Internet Explorer 8.0 or later.";
		at: 'WININET_API_FLAG_ASYNC'
		put: 16r1
		"Forces asynchronous operations.";
		at: 'WININET_API_FLAG_SYNC' put: 16r4
		"Forces synchronous operations.";
		at: 'WININET_API_FLAG_USE_CONTEXT'
		put: 16r8
		"Forces the API to use the context value, even if it is set to zero."]

{ #category : #initialization }
WininetDLL class >> initializeInternetFlags2 [
	"
	WininetDLL initializeInternetFlags2
	"
	WinInetConstants
		at: 'HSR_INITIATE' put: 8;
		at: 'HSR_DOWNLOAD' put: 16;
		at: 'HSR_CHUNKED' put: 32]

{ #category : #initialization }
WininetDLL class >> initializeInternetStateConstants [
	"
	WininetDLL initializeInternetStateConstants
	"
	WinInetConstants
		at: 'INTERNET_STATE_CONNECTED' put: 1;
		at: 'INTERNET_STATE_DISCONNECTED' put: 2;
		at: 'INTERNET_STATE_DISCONNECTED_BY_USER' put: 16;
		at: 'INTERNET_STATE_IDLE' put: 256;
		at: 'INTERNET_STATE_BUSY' put: 512]

{ #category : #initialization }
WininetDLL class >> initializeInternetStatusConstants [
	"
	WininetDLL initializeInternetStatusConstants
	"
	WinInetConstants
		at: 'INTERNET_STATUS_CLOSING_CONNECTION' put: 50;
		at: 'INTERNET_STATUS_CONNECTED_TO_SERVER' put: 21;
		at: 'INTERNET_STATUS_CONNECTING_TO_SERVER' put: 20;
		at: 'INTERNET_STATUS_CONNECTION_CLOSED' put: 51;
		at: 'INTERNET_STATUS_COOKIE_HISTORY' put: 327;
		at: 'INTERNET_STATUS_COOKIE_RECEIVED' put: 321;
		at: 'INTERNET_STATUS_COOKIE_SENT' put: 320;
		at: 'INTERNET_STATUS_CTL_RESPONSE_RECEIVED' put: 42;
		at: 'INTERNET_STATUS_DETECTING_PROXY' put: 80;
		at: 'INTERNET_STATUS_HANDLE_CLOSING' put: 70;
		at: 'INTERNET_STATUS_HANDLE_CREATED' put: 60;
		at: 'INTERNET_STATUS_INTERMEDIATE_RESPONSE' put: 120;
		at: 'INTERNET_STATUS_NAME_RESOLVED' put: 11;
		at: 'INTERNET_STATUS_P3P_HEADER' put: 325;
		at: 'INTERNET_STATUS_P3P_POLICYREF' put: 326;
		at: 'INTERNET_STATUS_PREFETCH' put: 43;
		at: 'INTERNET_STATUS_COOKIE_SENT' put: 320;
		at: 'INTERNET_STATUS_COOKIE_RECEIVED' put: 321;
		at: 'INTERNET_STATUS_PRIVACY_IMPACTED' put: 324;
		at: 'INTERNET_STATUS_RECEIVING_RESPONSE' put: 40;
		at: 'INTERNET_STATUS_REDIRECT' put: 110;
		at: 'INTERNET_FLAG_NO_AUTO_REDIRECT' put: 2097152;
		at: 'INTERNET_STATUS_REQUEST_COMPLETE' put: 100;
		at: 'INTERNET_STATUS_REQUEST_SENT' put: 31;
		at: 'INTERNET_STATUS_RESOLVING_NAME' put: 10;
		at: 'INTERNET_STATUS_RESPONSE_RECEIVED' put: 41;
		at: 'INTERNET_STATUS_SENDING_REQUEST' put: 30;
		at: 'INTERNET_STATUS_STATE_CHANGE' put: 200;
		at: 'INTERNET_STATUS_USER_INPUT_REQUIRED' put: 140]

{ #category : #accessing }
WininetDLL class >> moduleName [
	^'wininet']

{ #category : #private }
WininetDLL class >> typedefTable [
	^#(
		('HINTERNET' #pointer)
		('INTERNET_SCHEME' #long)
		('INTERNET_PORT' #ushort)
		('BOOLAPI' #boolean)
	)]

{ #category : #'internet services' }
WininetDLL >> canConnectTo: url [
	"
	WininetDLL current canConnectTo: 'https://ws.caesarsystems.com/test/'
	"
	| memory connected |
	memory := url externalCopy.
	connected := self
		InternetCheckConnection: memory asParameter
		dwFlags: 1
		dwReserved: 0.
	memory free.
	^connected]

{ #category : #closing }
WininetDLL >> close [
	InternetSession close.
	^super close]

{ #category : #'internet services' }
WininetDLL >> encodeUrl: aString [
	| url buffer size success retriable trials error |
	url := aString externalCopy.
	buffer := 1 externalCharacters.
	size := 1 asExternalInt32 externalCopy.
	success := false.
	retriable := true.
	trials := 0.
	KernelDLL current SetLastError: 0.
	[success not and: [trials < 2] and: [retriable]] whileTrue: [
		trials := trials + 1.
		success := self
			InternetCanonicalizeUrl: url asParameter
			lpszBuffer: buffer asParameter
			lpdwBufferLength: size asParameter
			dwFlags: 0.
		success ifFalse: [
			error := self lastWinError.
			error = ERROR_INSUFFICIENT_BUFFER ifTrue: [
				buffer free.
				buffer := size asInteger externalCharacters].
			retriable := error = 0 or: [error = ERROR_INSUFFICIENT_BUFFER]]].
	success ifFalse: [self winError: error].
	url free.
	size free.
	^buffer makeUnicode]

{ #category : #'ftp api' }
WininetDLL >> FtpCommand: hConnect
fExpectResponse: response
dwFlags: flags
lpszCommand: command
dwContext: context
phFtpCommand: cmd [
	<boolean: FtpCommandW>
	^self invalidArgument

"
BOOL FtpCommand(
  _In_   HINTERNET hConnect,
  _In_   BOOL fExpectResponse,
  _In_   DWORD dwFlags,
  _In_   LPCTSTR lpszCommand,
  _In_   DWORD_PTR dwContext,
  _Out_  HINTERNET *phFtpCommand
);
"]

{ #category : #'ftp api' }
WininetDLL >> FtpCreateDirectory: hConnect lpszDirectory: lpszDirectory [
	<boolean: FtpCreateDirectoryW>
	^self invalidArgument

"
BOOL FtpCreateDirectory(
  _In_  HINTERNET hConnect,
  _In_  LPCTSTR lpszDirectory
);
"]

{ #category : #'ftp api' }
WininetDLL >> FtpDeleteFile: hConnect lpszFileName: lpszFileName [
	<boolean: FtpDeleteFileW>
	^self invalidArgument

"
BOOL FtpDeleteFile(
  _In_  HINTERNET hConnect,
  _In_  LPCTSTR lpszFileName
);
"]

{ #category : #'ftp api' }
WininetDLL >> FtpFindFirstFile: hConnect
lpszSearchFile: aFilename
lpFindFileData: aWIN32_FIND_DATA
dwFlags: flags
dwContext: context [
	<pointer: FtpFindFirstFileW>
	^self invalidArgument

"
HINTERNET FtpFindFirstFile(
  _In_   HINTERNET hConnect,
  _In_   LPCTSTR lpszSearchFile,
  _Out_  LPWIN32_FIND_DATA lpFindFileData,
  _In_   DWORD dwFlags,
  _In_   DWORD_PTR dwContext
);
"]

{ #category : #'ftp api' }
WininetDLL >> FtpGetCurrentDirectory: hConnect lpszCurrentDirectory: lpszCurrentDirectory lpdwCurrentDirectory: lpdwCurrentDirectorySize [
	<boolean: FtpGetCurrentDirectoryW>
	^self invalidArgument

"
BOOL FtpGetCurrentDirectory(
  _In_     HINTERNET hConnect,
  _Out_    LPTSTR lpszCurrentDirectory,
  _Inout_  LPDWORD lpdwCurrentDirectory
);
"]

{ #category : #'ftp api' }
WininetDLL >> FtpGetFile: hConnect
lpszRemoteFile: lpszRemoteFile
lpszNewFile: lpszNewFile
fFailIfExists: aBoolean
dwFlagsAndAttributes: dwFlagsAndAttributes
dwFlags: dwFlags
dwContext: dwContext [
	<boolean: FtpGetFileW>
	^self invalidArgument

"
BOOL FtpGetFile(
  _In_  HINTERNET hConnect,
  _In_  LPCTSTR lpszRemoteFile,
  _In_  LPCTSTR lpszNewFile,
  _In_  BOOL fFailIfExists,
  _In_  DWORD dwFlagsAndAttributes,
  _In_  DWORD dwFlags,
  _In_  DWORD_PTR dwContext
);
"]

{ #category : #'ftp api' }
WininetDLL >> FtpOpenFile: hConnect
lpszFileName: lpszFileName
dwAccess: dwAccess
dwFlags: dwFlags
dwContext: dwContext [
	<pointer: FtpOpenFileW>
	^self invalidArgument

"
HINTERNET FtpOpenFile(
  _In_  HINTERNET hConnect,
  _In_  LPCTSTR lpszFileName,
  _In_  DWORD dwAccess,
  _In_  DWORD dwFlags,
  _In_  DWORD_PTR dwContext
);
"]

{ #category : #'ftp api' }
WininetDLL >> FtpPutFile: hConnect
lpszLocalFile: lpszLocalFile
lpszNewRemoteFile: lpszNewRemoteFile
dwFlags: dwFlags
dwContext: dwContext [
	<boolean: FtpPutFileW>
	^self invalidArgument

"
BOOL FtpPutFile(
  _In_  HINTERNET hConnect,
  _In_  LPCTSTR lpszLocalFile,
  _In_  LPCTSTR lpszNewRemoteFile,
  _In_  DWORD dwFlags,
  _In_  DWORD_PTR dwContext
);
"]

{ #category : #'ftp api' }
WininetDLL >> FtpRemoveDirectory: hConnect lpszDirectory: lpszDirectory [
	<boolean: FtpRemoveDirectoryW>
	^self invalidArgument

"
BOOL FtpRemoveDirectory(
  _In_  HINTERNET hConnect,
  _In_  LPCTSTR lpszDirectory
);
"]

{ #category : #'ftp api' }
WininetDLL >> FtpRenameFile: hConnect lpszExisting: lpszExisting lpszNew: lpszNew [
	<boolean: FtpRenameFileW>
	^self invalidArgument

"
BOOL FtpRenameFile(
  _In_  HINTERNET hConnect,
  _In_  LPCTSTR lpszExisting,
  _In_  LPCTSTR lpszNew
);
"]

{ #category : #'ftp api' }
WininetDLL >> FtpSetCurrentDirectory: hConnect lpszDirectory: lpszDirectory [
	<boolean: FtpSetCurrentDirectoryW>
	^self invalidArgument

"
BOOL FtpSetCurrentDirectory(
  _In_  HINTERNET hConnect,
  _In_  LPCTSTR lpszDirectory
);
"]

{ #category : #'http api' }
WininetDLL >> HttpAddRequestHeaders: hRequest
lpszHeaders: lpszHeaders
dwHeadersLength: dwHeadersLength
dwModifiers: dwModifiers [
	<boolean: HttpAddRequestHeadersW>
	^self invalidArgument

"
BOOL HttpAddRequestHeaders(
  _In_  HINTERNET hRequest,
  _In_  LPCTSTR lpszHeaders,
  _In_  DWORD dwHeadersLength,
  _In_  DWORD dwModifiers
);
"]

{ #category : #'http api' }
WininetDLL >> HttpEndRequest: hRequest
lpBuffersOut: null
dwFlags: flags
dwContext: address [
	<boolean: HttpEndRequestW>
	^self invalidArgument

"
BOOL HttpEndRequest(
  _In_      HINTERNET          hRequest,
  _Out_opt_ LPINTERNET_BUFFERS lpBuffersOut,
  _In_      DWORD              dwFlags,
  _In_opt_  DWORD_PTR          dwContext
);
"]

{ #category : #'http api' }
WininetDLL >> HttpOpenRequest: hConnect
lpszVerb: lpszVerb
lpszObjectName: lpszObjectName
lpszVersion: lpszVersion
lpszReferrer: lpszReferrer
lplpszAcceptTypes: lplpszAcceptTypes
dwFlags: dwFlags
dwContext: dwContext [
	<pointer: HttpOpenRequestW>
	^self invalidArgument

"
HINTERNET HttpOpenRequest(
  _In_  HINTERNET hConnect,
  _In_  LPCTSTR lpszVerb,
  _In_  LPCTSTR lpszObjectName,
  _In_  LPCTSTR lpszVersion,
  _In_  LPCTSTR lpszReferer,
  _In_  LPCTSTR *lplpszAcceptTypes,
  _In_  DWORD dwFlags,
  _In_  DWORD_PTR dwContext
);
"]

{ #category : #'http api' }
WininetDLL >> HttpQueryInfo: hRequest
dwInfoLevel: dwInfoLevel
lpBuffer: lpBuffer
lpdwBufferLength: lpdwBufferLength
lpdwIndex: lpdwIndex [
	<boolean: HttpQueryInfoW>
	^self invalidArgument

"
BOOL HttpQueryInfo(
  _In_     HINTERNET hRequest,
  _In_     DWORD dwInfoLevel,
  _Inout_  LPVOID lpvBuffer,
  _Inout_  LPDWORD lpdwBufferLength,
  _Inout_  LPDWORD lpdwIndex
);
"]

{ #category : #'http api' }
WininetDLL >> HttpSendRequest: hRequest
lpszHeaders: lpszHeaders
dwHeadersLength: dwHeadersLength
lpOptional: lpOptional
dwOptionalLength: dwOptionalLength [
	<boolean: HttpSendRequestW>
	^self invalidArgument

"
BOOL HttpSendRequest(
  _In_  HINTERNET hRequest,
  _In_  LPCTSTR lpszHeaders,
  _In_  DWORD dwHeadersLength,
  _In_  LPVOID lpOptional,
  _In_  DWORD dwOptionalLength
);
"]

{ #category : #'http api' }
WininetDLL >> HttpSendRequestEx: hRequest
lpBuffersIn: anINTERNET_BUFFERS
lpBuffersOut: null
dwFlags: flags
dwContext: address [
	<boolean: HttpSendRequestExW>
	^self invalidArgument

"
BOOL HttpSendRequestEx(
  _In_  HINTERNET          hRequest,
  _In_  LPINTERNET_BUFFERS lpBuffersIn,
  _Out_ LPINTERNET_BUFFERS lpBuffersOut,
  _In_  DWORD              dwFlags,
  _In_  DWORD_PTR          dwContext
);
"]

{ #category : #'internet api' }
WininetDLL >> InternetCanonicalizeUrl: lpszUrl
lpszBuffer: buffer
lpdwBufferLength: length
dwFlags: dwFlags [
	<boolean: InternetCanonicalizeUrlW>
	^self invalidArgument

"
BOOL InternetCanonicalizeUrl(
  _In_    LPCTSTR lpszUrl,
  _Out_   LPTSTR  lpszBuffer,
  _Inout_ LPDWORD lpdwBufferLength,
  _In_    DWORD   dwFlags
);
"]

{ #category : #'internet api' }
WininetDLL >> InternetCheckConnection: url dwFlags: flags dwReserved: reserved [
	<boolean: InternetCheckConnectionW>
	^self invalidArgument

"
BOOL InternetCheckConnection(
  _In_ LPCTSTR lpszUrl,
  _In_ DWORD   dwFlags,
  _In_ DWORD   dwReserved
);"]

{ #category : #'internet api' }
WininetDLL >> InternetCloseHandle: hInternet [
	<boolean: InternetCloseHandle>
	^self invalidArgument

"
BOOL InternetCloseHandle(
  _In_  HINTERNET hInternet
);
"]

{ #category : #'internet api' }
WininetDLL >> InternetConnect: hInternet
lpszServerName: lpszServerName
nServerPort: nServerPort
lpszUserName: lpszUserName
lpszPassword: lpszPassword
dwService: dwService
dwFlags: dwFlags
dwContext: dwContext [
	<pointer: InternetConnectW>
	^self invalidArgument

"
HINTERNET InternetConnect(
  _In_  HINTERNET hInternet,
  _In_  LPCTSTR lpszServerName,
  _In_  INTERNET_PORT nServerPort,
  _In_  LPCTSTR lpszUsername,
  _In_  LPCTSTR lpszPassword,
  _In_  DWORD dwService,
  _In_  DWORD dwFlags,
  _In_  DWORD_PTR dwContext
);
"]

{ #category : #'internet api' }
WininetDLL >> InternetCrackUrl: lpszUrl
dwUrlLength: dwUrlLength
dwFlags: dwFlags
lpUrlComponents: lpUrlComponents [
	<boolean: InternetCrackUrlW>
	^self invalidArgument

"
BOOL InternetCrackUrl(
  _In_     LPCTSTR lpszUrl,
  _In_     DWORD dwUrlLength,
  _In_     DWORD dwFlags,
  _Inout_  LPURL_COMPONENTS lpUrlComponents
);
"]

{ #category : #'internet api' }
WininetDLL >> InternetCreateUrl: lpUrlComponents
dwFlags: dwFlags
lpszUrl: lpszUrl
lpdwUrlLength: lpdwUrlLength [
	<boolean: InternetCreateUrlW>
	^self invalidArgument

"
BOOL InternetCreateUrl(
  _In_     LPURL_COMPONENTS lpUrlComponents,
  _In_     DWORD dwFlags,
  _Out_    LPTSTR lpszUrl,
  _Inout_  LPDWORD lpdwUrlLength
);
"]

{ #category : #'internet api' }
WininetDLL >> InternetErrorDlg: hWnd
hRequest: hRequest
dwError: dwError
dwFlags: dwFlags
lppvData: lppvData [
	<ulong: InternetErrorDlg>
	^self invalidArgument

"
DWORD InternetErrorDlg(
  _In_     HWND hWnd,
  _Inout_  HINTERNET hRequest,
  _In_     DWORD dwError,
  _In_     DWORD dwFlags,
  _Inout_  LPVOID *lppvData
);
"]

{ #category : #'internet api' }
WininetDLL >> InternetFindNextFile: hFind lpvFindData: aWIN32_FIND_DATA [
	<boolean: InternetFindNextFileW>
	^self invalidArgument

"
BOOL InternetFindNextFile(
  _In_   HINTERNET hFind,
  _Out_  LPVOID lpvFindData
);
"]

{ #category : #'internet api' }
WininetDLL >> InternetGetLastResponseInfo: lpdwError lpszBuffer: aString lpdwBufferLength: anInteger [
	<boolean: InternetGetLastResponseInfoW>
	^self invalidArgument

"
BOOL InternetGetLastResponseInfo(
  _Out_    LPDWORD lpdwError,
  _Out_    LPTSTR lpszBuffer,
  _Inout_  LPDWORD lpdwBufferLength
);
"]

{ #category : #'internet api' }
WininetDLL >> InternetOpen: lpszAgent
dwAccessType: dwAccessType
lpszProxyName: lpszProxy
lpszProxyBypass: lpszProxyBypass
dwFlags: dwFlags [
	<pointer: InternetOpenW>
	^self invalidArgument

"
HINTERNET InternetOpen(
  _In_  LPCTSTR lpszAgent,
  _In_  DWORD dwAccessType,
  _In_  LPCTSTR lpszProxyName,
  _In_  LPCTSTR lpszProxyBypass,
  _In_  DWORD dwFlags
);
"]

{ #category : #'internet api' }
WininetDLL >> InternetOpenUrl: hInternetSession
lpszUrl: lpszUrl
lpszHeaders: lpszHeaders
dwHeadersLength: dwHeadersLength
dwFlags: dwFlags
dwContext: dwContext [
	<pointer: InternetOpenUrlW>
	^self invalidArgument

"
HINTERNET InternetOpenUrl(
  _In_  HINTERNET hInternet,
  _In_  LPCTSTR lpszUrl,
  _In_  LPCTSTR lpszHeaders,
  _In_  DWORD dwHeadersLength,
  _In_  DWORD dwFlags,
  _In_  DWORD_PTR dwContext
);
"]

{ #category : #'internet api' }
WininetDLL >> InternetOpenUrlA: hInternetSession
lpszUrl: lpszUrl
lpszHeaders: lpszHeaders
dwHeadersLength: dwHeadersLength
dwFlags: dwFlags
dwContext: dwContext [
	<pointer: InternetOpenUrlA>
	^self invalidArgument

"
HINTERNET InternetOpenUrl(
  _In_  HINTERNET hInternet,
  _In_  LPCTSTR lpszUrl,
  _In_  LPCTSTR lpszHeaders,
  _In_  DWORD dwHeadersLength,
  _In_  DWORD dwFlags,
  _In_  DWORD_PTR dwContext
);
"]

{ #category : #'internet api' }
WininetDLL >> InternetQueryDataAvailable: hInternetFile
lpdwNumberOfBytesAvailable: lpdwNumberOfBytesAvailable
dwFlags: dwFlags
dwContext: dwContext [
	<boolean: InternetQueryDataAvailable>
	^self invalidArgument

"
BOOL InternetQueryDataAvailable(
  _In_   HINTERNET hFile,
  _Out_  LPDWORD lpdwNumberOfBytesAvailable,
  _In_   DWORD dwFlags,
  _In_   DWORD_PTR dwContext
);
"]

{ #category : #'internet api' }
WininetDLL >> InternetQueryOption: hInternet
dwOption: dwOption
lpBuffer: aString
lpdwBufferLength: anInteger [
	<boolean: InternetQueryOptionW>
	^self invalidArgument

"
BOOL InternetQueryOption(
  _In_     HINTERNET hInternet,
  _In_     DWORD dwOption,
  _Out_    LPVOID lpBuffer,
  _Inout_  LPDWORD lpdwBufferLength
);
"]

{ #category : #'internet api' }
WininetDLL >> InternetReadFile: hInternetFile
lpBuffer: lpBuffer
dwNumberOfBytesToRead: dwNumberOfBytesToRead
lpdwNumberOfBytesRead: lpdwNumberOfBytesRead [
	<boolean: InternetReadFile>
	^self invalidArgument

"
BOOL InternetReadFile(
  _In_   HINTERNET hFile,
  _Out_  LPVOID lpBuffer,
  _In_   DWORD dwNumberOfBytesToRead,
  _Out_  LPDWORD lpdwNumberOfBytesRead
);
"]

{ #category : #'internet api' }
WininetDLL >> InternetReadFileEx: hFile
lpBuffersOut: anINTERNET_BUFFERS
dwFlags: flags
dwContext: context [
	<boolean: InternetReadFileExW>
	^self invalidArgument

"
BOOL InternetReadFileEx(
  _In_  HINTERNET          hFile,
  _Out_ LPINTERNET_BUFFERS lpBuffersOut,
  _In_  DWORD              dwFlags,
  _In_  DWORD_PTR          dwContext
);
"]

{ #category : #'internet api' }
WininetDLL >> InternetSetFilePointer: hInternetFile
lDistanceToMove: lDistanceToMove
pReserved: pReserved
dwMoveMethod: dwMoveMethod
dwContext: context [
	<ulong: InternetSetFilePointer>
	^self invalidArgument

"
DWORD InternetSetFilePointer(
  _In_     HINTERNET hFile,
  _In_     LONG lDistanceToMove,
  _Inout_  PLONG lpDistanceToMoveHigh,
  _In_     DWORD dwMoveMethod,
  _In_     DWORD_PTR dwContext
);
"]

{ #category : #'internet api' }
WininetDLL >> InternetSetOption: hInternet
dwOption: dwOption
lpBuffer: lpBuffer
dwBufferLength: dwBufferLength [
	<boolean: InternetSetOptionW>
	^self invalidArgument

"
BOOL InternetSetOption(
  _In_  HINTERNET hInternet,
  _In_  DWORD dwOption,
  _In_  LPVOID lpBuffer,
  _In_  DWORD dwBufferLength
);
"]

{ #category : #'internet api' }
WininetDLL >> InternetSetStatusCallback: hInternet lpfnInternetCallback: lpfnInternetCallback [
	<pointer: InternetSetStatusCallback>
	^self invalidArgument

"
INTERNET_STATUS_CALLBACK InternetSetStatusCallback(
  _In_  HINTERNET hInternet,
  _In_  INTERNET_STATUS_CALLBACK lpfnInternetCallback
);
"]

{ #category : #'internet api' }
WininetDLL >> InternetWriteFile: hInternetFile
lpBuffer: lpBuffer
dwNumberOfBytesToWrite: dwNumberOfBytesToWrite
lpdwNumberOfBytesWritten: lpdwNumberOfBytesWritten [
	<boolean: InternetWriteFile>
	^self invalidArgument

"
BOOL InternetWriteFile(
  _In_   HINTERNET hFile,
  _In_   LPCVOID lpBuffer,
  _In_   DWORD dwNumberOfBytesToWrite,
  _Out_  LPDWORD lpdwNumberOfBytesWritten
);
"]

{ #category : #'internet services' }
WininetDLL >> queryOption: dwOption handle: aWin32InternetObject [
	| length success error buffer |
	buffer := 8 kbytes externalBytes.
	length := buffer length asExternalInt32 externalCopy.
	success := self
		InternetQueryOption: aWin32InternetObject asParameter
		dwOption: dwOption asParameter
		lpBuffer: buffer asParameter
		lpdwBufferLength: length asParameter.
	success ifFalse: [
		error := self lastWinError.
		error = ERROR_INSUFFICIENT_BUFFER
			ifTrue: [
				buffer free.
				buffer := length asInteger externalBytes.
				success := self
					InternetQueryOption: aWin32InternetObject asParameter
					dwOption: dwOption asParameter
					lpBuffer: buffer asParameter
					lpdwBufferLength: length asParameter.
				success ifFalse: [self winError]]
			ifFalse: [self winError: error]].
	^buffer makeBytes copyFrom: 1 to: length makeInteger]

{ #category : #'internet services' }
WininetDLL >> queryOption: dwOption session: anInternetSession [
	| length success output error buffer |
	buffer := 8 kbytes externalBytes.
	length := buffer length asExternalInt32 externalCopy.
	success := self
		InternetQueryOption: anInternetSession asParameter
		dwOption: dwOption asParameter
		lpBuffer: buffer asParameter
		lpdwBufferLength: length asParameter.
	success ifFalse: [
		error := self lastWinError.
		error = ERROR_INSUFFICIENT_BUFFER
			ifTrue: [
				buffer free.
				buffer := length asInteger externalBytes.
				success := self
					InternetQueryOption: anInternetSession asParameter
					dwOption: dwOption asParameter
					lpBuffer: buffer asParameter
					lpdwBufferLength: length asParameter.
				success ifFalse: [self winError]]
			ifFalse: [self winError: error]].
	output := WideString fromMemory: buffer length: length makeLocal asInteger.
	buffer free.
	^output]

{ #category : #errors }
WininetDLL >> winError: anInteger [
	anInteger = 0 ifTrue: [^self].
	^WinInetError signalErrorCode: anInteger]

