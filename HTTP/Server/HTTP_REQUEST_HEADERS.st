"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_REQUEST_HEADERS,
	#superclass : #HttpHeadersStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_REQUEST_HEADERS class >> aspects [
	^#(#UnknownHeaderCount
		#pUnknownHeaders
		#TrailerCount
		#pTrailers
		#KnownHeaders)]

{ #category : #accessing }
HTTP_REQUEST_HEADERS class >> def [
	^<def>
	typedef struct _HTTP_REQUEST_HEADERS {
		USHORT               UnknownHeaderCount;
		PHTTP_UNKNOWN_HEADER pUnknownHeaders;
		USHORT               TrailerCount;
		PHTTP_UNKNOWN_HEADER pTrailers;
		HTTP_KNOWN_HEADER    KnownHeaders[HttpHeaderRequestMaximum];
	} HTTP_REQUEST_HEADERS, *PHTTP_REQUEST_HEADERS;
	</def>]

{ #category : #initialization }
HTTP_REQUEST_HEADERS class >> initializeConstants [
	"
	HTTP_REQUEST_HEADERS initializeConstants
	"
	self initializeRequestConstants]

{ #category : #initialization }
HTTP_REQUEST_HEADERS class >> initializeRequestConstants [
	WinConstants
		at: 'HttpHeaderCacheControl' put: 0;
		at: 'HttpHeaderConnection' put: 1;
		at: 'HttpHeaderDate' put: 2;
		at: 'HttpHeaderKeepAlive' put: 3;
		at: 'HttpHeaderPragma' put: 4;
		at: 'HttpHeaderTrailer' put: 5;
		at: 'HttpHeaderTransferEncoding' put: 6;
		at: 'HttpHeaderUpgrade' put: 7;
		at: 'HttpHeaderVia' put: 8;
		at: 'HttpHeaderWarning' put: 9;
		at: 'HttpHeaderAllow' put: 10;
		at: 'HttpHeaderContentLength' put: 11;
		at: 'HttpHeaderContentType' put: 12;
		at: 'HttpHeaderContentEncoding' put: 13;
		at: 'HttpHeaderContentLanguage' put: 14;
		at: 'HttpHeaderContentLocation' put: 15;
		at: 'HttpHeaderContentMd5' put: 16;
		at: 'HttpHeaderContentRange' put: 17;
		at: 'HttpHeaderExpires' put: 18;
		at: 'HttpHeaderLastModified' put: 19;
		at: 'HttpHeaderAccept' put: 20 "request-header [section 5.3]";
		at: 'HttpHeaderAcceptCharset' put: 21 "request-header [section 5.3]";
		at: 'HttpHeaderAcceptEncoding' put: 22 "request-header [section 5.3]";
		at: 'HttpHeaderAcceptLanguage' put: 23 "request-header [section 5.3]";
		at: 'HttpHeaderAuthorization' put: 24 "request-header [section 5.3]";
		at: 'HttpHeaderCookie' put: 25 "request-header [not in rfc]";
		at: 'HttpHeaderExpect' put: 26 "request-header [section 5.3]";
		at: 'HttpHeaderFrom' put: 27 "request-header [section 5.3]";
		at: 'HttpHeaderHost' put: 28 "request-header [section 5.3]";
		at: 'HttpHeaderIfMatch' put: 29 "request-header [section 5.3]";
		at: 'HttpHeaderIfModifiedSince' put: 30 "request-header [section 5.3]";
		at: 'HttpHeaderIfNoneMatch' put: 31 "request-header [section 5.3]";
		at: 'HttpHeaderIfRange' put: 32 "request-header [section 5.3]";
		at: 'HttpHeaderIfUnmodifiedSince' put: 33 "request-header [section 5.3]";
		at: 'HttpHeaderMaxForwards' put: 34 "request-header [section 5.3]";
		at: 'HttpHeaderProxyAuthorization' put: 35 "request-header [section 5.3]";
		at: 'HttpHeaderReferer' put: 36 "request-header [section 5.3]";
		at: 'HttpHeaderRange' put: 37 "request-header [section 5.3]";
		at: 'HttpHeaderTe' put: 38 "request-header [section 5.3]";
		at: 'HttpHeaderTranslate'
		put: 39 "request-header [webDAV; not in rfc 2518]";
		at: 'HttpHeaderUserAgent' put: 40 "request-header [section 5.3]";
		at: 'HttpHeaderRequestMaximum' put: 41]

{ #category : #private }
HTTP_REQUEST_HEADERS class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 688;
		at: 'UnknownHeaderCount' put: 0;
		at: 'pUnknownHeaders' put: 8;
		at: 'TrailerCount' put: 16;
		at: 'pTrailers' put: 24;
		at: 'KnownHeaders' put: 32;
		yourself]

{ #category : #accessing }
HTTP_REQUEST_HEADERS class >> sizeInBytes [
	^sizeInBytes]

{ #category : #private }
HTTP_REQUEST_HEADERS >> knownHeadersOffset [
	^KnownHeaders]

{ #category : #private }
HTTP_REQUEST_HEADERS >> maxHeaders [
	^HttpHeaderRequestMaximum]

{ #category : #accessing }
HTTP_REQUEST_HEADERS >> pTrailers [
	^self pointerAtOffset: pTrailers]

{ #category : #accessing }
HTTP_REQUEST_HEADERS >> pTrailers: anInteger [
	self pointerAtOffset: pTrailers put: anInteger]

{ #category : #accessing }
HTTP_REQUEST_HEADERS >> pUnknownHeaders [
	^self addressAtOffset: pUnknownHeaders]

{ #category : #accessing }
HTTP_REQUEST_HEADERS >> pUnknownHeaders: anExternalMemory [
	self addressAtOffset: pUnknownHeaders register: anExternalMemory]

{ #category : #accessing }
HTTP_REQUEST_HEADERS >> TrailerCount [
	^self uShortAtOffset: TrailerCount]

{ #category : #accessing }
HTTP_REQUEST_HEADERS >> TrailerCount: anInteger [
	self uShortAtOffset: TrailerCount put: anInteger]

{ #category : #accessing }
HTTP_REQUEST_HEADERS >> UnknownHeaderCount [
	^self uShortAtOffset: UnknownHeaderCount]

{ #category : #accessing }
HTTP_REQUEST_HEADERS >> UnknownHeaderCount: anInteger [
	self uShortAtOffset: UnknownHeaderCount put: anInteger]

