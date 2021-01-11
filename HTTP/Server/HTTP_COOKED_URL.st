"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_COOKED_URL,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_COOKED_URL class >> aspects [
	^#(
		#fullUrl
		#host
		#absPath
		#queryString)]

{ #category : #accessing }
HTTP_COOKED_URL class >> def [
	^<def>
	typedef struct _HTTP_COOKED_URL {
		USHORT FullUrlLength;
		USHORT HostLength;
		USHORT AbsPathLength;
		USHORT QueryStringLength;
		PCWSTR pFullUrl;
		PCWSTR pHost;
		PCWSTR pAbsPath;
		PCWSTR pQueryString;
	} HTTP_COOKED_URL, *PHTTP_COOKED_URL;
	</def>]

{ #category : #private }
HTTP_COOKED_URL class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 40;
		at: 'FullUrlLength' put: 0;
		at: 'HostLength' put: 2;
		at: 'AbsPathLength' put: 4;
		at: 'QueryStringLength' put: 6;
		at: 'pFullUrl' put: 8;
		at: 'pHost' put: 16;
		at: 'pAbsPath' put: 24;
		at: 'pQueryString' put: 32;
		yourself]

{ #category : #accessing }
HTTP_COOKED_URL class >> sizeInBytes [
	^sizeInBytes]

{ #category : #output }
HTTP_COOKED_URL >> absPath [
	^WideString fromMemory: self pAbsPath length: self AbsPathLength // 2]

{ #category : #input }
HTTP_COOKED_URL >> absPath: aString [
	| memory |
	memory := aString externalCopy.
	self pAbsPath: memory; AbsPathLength: memory length]

{ #category : #accessing }
HTTP_COOKED_URL >> AbsPathLength [
	^self uShortAtOffset: AbsPathLength]

{ #category : #accessing }
HTTP_COOKED_URL >> AbsPathLength: anInteger [
	self uShortAtOffset: AbsPathLength put: anInteger]

{ #category : #converting }
HTTP_COOKED_URL >> asURL [
	| encoded encoder |
	encoder := Smalltalk at: #WininetDLL ifPresent: [:c | c current].
	encoded := encoder notNil
		ifTrue: [encoder encodeUrl: self fullUrl]
		ifFalse: [self fullUrl].
	^encoded asURL]

{ #category : #output }
HTTP_COOKED_URL >> fullUrl [
	^UTF16 decodeFromAddress: self pFullUrl length: self FullUrlLength // 2]

{ #category : #input }
HTTP_COOKED_URL >> fullUrl: aString [
	| memory |
	memory := aString externalCopy.
	self pFullUrl: memory; FullUrlLength: memory length]

{ #category : #accessing }
HTTP_COOKED_URL >> FullUrlLength [
	^self uShortAtOffset: FullUrlLength]

{ #category : #accessing }
HTTP_COOKED_URL >> FullUrlLength: anInteger [
	self uShortAtOffset: FullUrlLength put: anInteger]

{ #category : #output }
HTTP_COOKED_URL >> host [
	^UTF16 decodeFromAddress: self pHost length: self HostLength // 2]

{ #category : #input }
HTTP_COOKED_URL >> host: aString [
	| memory |
	memory := aString externalCopy.
	self pHost: memory; HostLength: memory length]

{ #category : #accessing }
HTTP_COOKED_URL >> HostLength [
	^self uShortAtOffset: HostLength]

{ #category : #accessing }
HTTP_COOKED_URL >> HostLength: anInteger [
	self uShortAtOffset: HostLength put: anInteger]

{ #category : #accessing }
HTTP_COOKED_URL >> pAbsPath [
	^self addressAtOffset: pAbsPath]

{ #category : #accessing }
HTTP_COOKED_URL >> pAbsPath: anExternalMemory [
	self addressAtOffset: pAbsPath register: anExternalMemory]

{ #category : #accessing }
HTTP_COOKED_URL >> pFullUrl [
	^self addressAtOffset: pFullUrl]

{ #category : #accessing }
HTTP_COOKED_URL >> pFullUrl: anExternalMemory [
	self addressAtOffset: pFullUrl register: anExternalMemory]

{ #category : #accessing }
HTTP_COOKED_URL >> pHost [
	^self addressAtOffset: pHost]

{ #category : #accessing }
HTTP_COOKED_URL >> pHost: anExternalMemory [
	self addressAtOffset: pHost register: anExternalMemory]

{ #category : #accessing }
HTTP_COOKED_URL >> pQueryString [
	^self addressAtOffset: pQueryString]

{ #category : #printing }
HTTP_COOKED_URL >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		space;
		nextPutAll: self fullUrl asString]

{ #category : #output }
HTTP_COOKED_URL >> queryString [
	^WideString
		fromMemory: self pQueryString
		length: self QueryStringLength // 2]

{ #category : #accessing }
HTTP_COOKED_URL >> QueryStringLength [
	^self uShortAtOffset: QueryStringLength]

{ #category : #output }
HTTP_COOKED_URL >> uri [
	^self absPath]

