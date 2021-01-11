"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_RESPONSE_HEADERS,
	#superclass : #HttpHeadersStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_RESPONSE_HEADERS class >> aspects [
	^#(#UnknownHeaderCount
		#pUnknownHeaders
		#TrailerCount
		#pTrailers
		#KnownHeaders)]

{ #category : #accessing }
HTTP_RESPONSE_HEADERS class >> def [
	^<def>
	typedef struct _HTTP_RESPONSE_HEADERS {
		USHORT               UnknownHeaderCount;
		PHTTP_UNKNOWN_HEADER pUnknownHeaders;
		USHORT               TrailerCount;
		PHTTP_UNKNOWN_HEADER pTrailers;
		HTTP_KNOWN_HEADER    KnownHeaders[HttpHeaderResponseMaximum];
	} HTTP_RESPONSE_HEADERS, *PHTTP_RESPONSE_HEADERS;
	</def>]

{ #category : #initialization }
HTTP_RESPONSE_HEADERS class >> initializeRequestConstants [
	WinConstants at: 'HttpHeaderResponseMaximum' put: 30]

{ #category : #private }
HTTP_RESPONSE_HEADERS class >> offsets64 [
	^PoolDictionary new
		at: 'pTrailers' put: 24;
		at: 'sizeInBytes' put: 512;
		at: 'TrailerCount' put: 16;
		at: 'UnknownHeaderCount' put: 0;
		at: 'KnownHeaders' put: 32;
		at: 'pUnknownHeaders' put: 8;
		yourself]

{ #category : #accessing }
HTTP_RESPONSE_HEADERS class >> sizeInBytes [
	^sizeInBytes]

{ #category : #private }
HTTP_RESPONSE_HEADERS >> knownHeadersOffset [
	^KnownHeaders]

{ #category : #private }
HTTP_RESPONSE_HEADERS >> maxHeaders [
	^HttpHeaderResponseMaximum]

{ #category : #accessing }
HTTP_RESPONSE_HEADERS >> pTrailers [
	^self pointerAtOffset: pTrailers]

{ #category : #accessing }
HTTP_RESPONSE_HEADERS >> pTrailers: anInteger [
	self pointerAtOffset: pTrailers put: anInteger]

{ #category : #accessing }
HTTP_RESPONSE_HEADERS >> pUnknownHeaders [
	^self addressAtOffset: pUnknownHeaders]

{ #category : #accessing }
HTTP_RESPONSE_HEADERS >> pUnknownHeaders: anExternalMemory [
	self addressAtOffset: pUnknownHeaders register: anExternalMemory]

{ #category : #accessing }
HTTP_RESPONSE_HEADERS >> TrailerCount [
	^self uShortAtOffset: TrailerCount]

{ #category : #accessing }
HTTP_RESPONSE_HEADERS >> TrailerCount: anInteger [
	self uShortAtOffset: TrailerCount put: anInteger]

{ #category : #accessing }
HTTP_RESPONSE_HEADERS >> UnknownHeaderCount [
	^self uShortAtOffset: UnknownHeaderCount]

{ #category : #accessing }
HTTP_RESPONSE_HEADERS >> UnknownHeaderCount: anInteger [
	self uShortAtOffset: UnknownHeaderCount put: anInteger]

{ #category : #updating }
HTTP_RESPONSE_HEADERS >> updateFrom: headers [
	| unknown |
	unknown := OrderedCollection new.
	headers keysAndValuesDo: [:key :value | | selector |
		selector := ((key copyWithout: $-) , ':') asSymbol.
		(self respondsTo: selector)
			ifTrue: [self perform: selector with: value]
			ifFalse: [unknown add: key -> value]].
	unknown notEmpty ifTrue: [self unknownHeaders: unknown]]

