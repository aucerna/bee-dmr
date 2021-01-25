"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #WSADATA,
	#superclass : #SocketStructure,
	#classVars : [
		'Offsets'
	],
	#category : #sockets
}

{ #category : #inspecting }
WSADATA class >> aspects [
	^super aspects , #(#vendorInfo)]

{ #category : #accessing }
WSADATA class >> def [
	self ASSERT: WordSize == 4.
	^'typedef struct WSAData {
	WORD		wVersion;
	WORD		wHighVersion;
//#ifdef _WIN64
//	unsigned short	iMaxSockets;
//	unsigned short	iMaxUdpDg;
//	char		*lpVendorInfo;
//	char		szDescription[WSADESCRIPTION_LEN+1];
//	char		szSystemStatus[WSASYS_STATUS_LEN+1];
//#else
	char		szDescription[WSADESCRIPTION_LEN+1];
	char		szSystemStatus[WSASYS_STATUS_LEN+1];
	ushort	iMaxSockets;
	ushort	iMaxUdpDg;
	char		*lpVendorInfo;
 //#endif
} WSADATA, *LPWSADATA;
']

{ #category : #initialization }
WSADATA class >> initializeConstants [
	"
	WSADATA initializeConstants
	"
	WindowsConstants
		at: 'WSADESCRIPTION_LEN' put: 256;
		at: 'WSASYS_STATUS_LEN' put: 128]

{ #category : #initialization }
WSADATA class >> initializeOffsets [
	| offsets |
	offsets := WordSize = 4 ifTrue: [self offsets32] ifFalse: [self offsets64].
	Offsets addAll: offsets]

{ #category : #accessing }
WSADATA class >> offsets32 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 400;
		at: 'wVersion' put: 0;
		at: 'wHighVersion' put: 2;
		at: 'szDescription' put: 4;
		at: 'szSystemStatus' put: 261;
		at: 'iMaxSockets' put: 390;
		at: 'iMaxUdpDg' put: 392;
		at: 'lpVendorInfo' put: 396;
		yourself]

{ #category : #private }
WSADATA class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 408;
		at: 'wVersion' put: 0;
		at: 'wHighVersion' put: 2;
		at: 'iMaxSockets' put: 4;
		at: 'iMaxUdpDg' put: 6;
		at: 'lpVendorInfo' put: 8;
		at: 'szDescription' put: 16;
		at: 'szSystemStatus' put: 273;
		yourself]

{ #category : #accessing }
WSADATA class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
WSADATA >> iMaxSockets [
	^self uShortAtOffset: iMaxSockets]

{ #category : #accessing }
WSADATA >> iMaxUdpDg [
	^self
		uShortAtOffset: iMaxUdpDg]

{ #category : #accessing }
WSADATA >> lpVendorInfo [
	^self
		addressAtOffset: lpVendorInfo]

{ #category : #accessing }
WSADATA >> szDescription [
	| data |
	data := self bytesAtOffset: szDescription count: WSADESCRIPTION_LEN + 1.
	^data asString]

{ #category : #accessing }
WSADATA >> szSystemStatus [
	| status |
	status := self bytesAtOffset: szSystemStatus count: WSASYS_STATUS_LEN + 1.
	^status asString]

{ #category : #output }
WSADATA >> vendorInfo [
	| memory |
	memory := self lpVendorInfo.
	^memory isValid ifTrue: [String fromMemory: memory]]

{ #category : #accessing }
WSADATA >> wHighVersion [
	^self uShortAtOffset: wHighVersion]

{ #category : #accessing }
WSADATA >> wVersion [
	^self uShortAtOffset: wVersion]

