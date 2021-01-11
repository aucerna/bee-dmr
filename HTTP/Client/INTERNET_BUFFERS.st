"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #INTERNET_BUFFERS,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Client'
}

{ #category : #inspecting }
INTERNET_BUFFERS class >> aspects [
	^super aspects , #(#next #headers #buffer)]

{ #category : #accessing }
INTERNET_BUFFERS class >> def [
	^<def>
	typedef struct _INTERNET_BUFFERS {
		DWORD             dwStructSize;
		_INTERNET_BUFFERS *Next;
		LPCTSTR           lpcszHeader;
		DWORD             dwHeadersLength;
		DWORD             dwHeadersTotal;
		LPVOID            lpvBuffer;
		DWORD             dwBufferLength;
		DWORD             dwBufferTotal;
		DWORD             dwOffsetLow;
		DWORD             dwOffsetHigh;
	} INTERNET_BUFFERS, * LPINTERNET_BUFFERS;
	</def>]

{ #category : #private }
INTERNET_BUFFERS class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 56;
		at: 'dwStructSize' put: 0;
		at: 'Next' put: 8;
		at: 'lpcszHeader' put: 16;
		at: 'dwHeadersLength' put: 24;
		at: 'dwHeadersTotal' put: 28;
		at: 'lpvBuffer' put: 32;
		at: 'dwBufferLength' put: 40;
		at: 'dwBufferTotal' put: 44;
		at: 'dwOffsetLow' put: 48;
		at: 'dwOffsetHigh' put: 52;
		yourself]

{ #category : #accessing }
INTERNET_BUFFERS class >> sizeInBytes [
	^sizeInBytes]

{ #category : #output }
INTERNET_BUFFERS >> buffer [
	| memory |
	memory := self lpvBuffer.
	^memory isValid ifTrue: [memory copyFrom: 1 to: self dwBufferLength]]

{ #category : #input }
INTERNET_BUFFERS >> buffer: aByteArray [
	| n |
	aByteArray isNil ifTrue: [^self].
	n := aByteArray sizeInBytes.
	self
		lpvBuffer: aByteArray externalCopy;
		dwBufferLength: n;
		dwBufferTotal: n]

{ #category : #input }
INTERNET_BUFFERS >> clear [
	| blank |
	blank := ByteArray new: self dwBufferLength.
	self buffer: blank]

{ #category : #accessing }
INTERNET_BUFFERS >> dwBufferLength [
	^self uLongAtOffset: dwBufferLength]

{ #category : #accessing }
INTERNET_BUFFERS >> dwBufferLength: anInteger [
	self uLongAtOffset: dwBufferLength put: anInteger]

{ #category : #accessing }
INTERNET_BUFFERS >> dwBufferTotal [
	^self uLongAtOffset: dwBufferTotal]

{ #category : #accessing }
INTERNET_BUFFERS >> dwBufferTotal: anInteger [
	self uLongAtOffset: dwBufferTotal put: anInteger]

{ #category : #accessing }
INTERNET_BUFFERS >> dwHeadersLength [
	^self uLongAtOffset: dwHeadersLength]

{ #category : #accessing }
INTERNET_BUFFERS >> dwHeadersLength: anInteger [
	self uLongAtOffset: dwHeadersLength put: anInteger]

{ #category : #accessing }
INTERNET_BUFFERS >> dwHeadersTotal [
	^self uLongAtOffset: dwHeadersTotal]

{ #category : #accessing }
INTERNET_BUFFERS >> dwHeadersTotal: anInteger [
	self uLongAtOffset: dwHeadersTotal put: anInteger]

{ #category : #accessing }
INTERNET_BUFFERS >> dwStructSize [
	^self uLongAtOffset: dwStructSize]

{ #category : #accessing }
INTERNET_BUFFERS >> dwStructSize: anInteger [
	self uLongAtOffset: dwStructSize put: anInteger]

{ #category : #output }
INTERNET_BUFFERS >> headers [
	| memory |
	memory := self lpcszHeader.
	memory isValid ifFalse: [^nil].
	^WideString fromMemory: memory length: self dwHeadersLength]

{ #category : #input }
INTERNET_BUFFERS >> headers: aString [
	| n |
	aString isNil ifTrue: [^self].
	n := aString size.
	self
		lpcszHeader: aString externalCopy;
		dwHeadersLength: n;
		dwHeadersTotal: n]

{ #category : #initialization }
INTERNET_BUFFERS >> initialize: anInteger [
	super initialize: anInteger.
	self dwStructSize: anInteger]

{ #category : #accessing }
INTERNET_BUFFERS >> lpcszHeader [
	^self addressAtOffset: lpcszHeader]

{ #category : #accessing }
INTERNET_BUFFERS >> lpcszHeader: anExternalMemory [
	self addressAtOffset: lpcszHeader register: anExternalMemory]

{ #category : #accessing }
INTERNET_BUFFERS >> lpvBuffer [
	^self addressAtOffset: lpvBuffer]

{ #category : #accessing }
INTERNET_BUFFERS >> lpvBuffer: anExternalMemory [
	self addressAtOffset: lpvBuffer register: anExternalMemory]

{ #category : #accessing }
INTERNET_BUFFERS >> Next [
	^self addressAtOffset: Next]

{ #category : #output }
INTERNET_BUFFERS >> next [
	| memory |
	memory := self Next.
	^memory isValid ifTrue: [self class atMemory: memory]]

{ #category : #accessing }
INTERNET_BUFFERS >> Next: anExternalMemory [
	self addressAtOffset: Next register: anExternalMemory]

{ #category : #input }
INTERNET_BUFFERS >> next: anINTERNET_BUFFERS [
	self Next: anINTERNET_BUFFERS externalCopy pointedMemory]

{ #category : #input }
INTERNET_BUFFERS >> totalSize: anInteger [
	self dwBufferTotal: anInteger]

