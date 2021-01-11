"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #INTERNET_CERTIFICATE_INFO,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Client'
}

{ #category : #inspecting }
INTERNET_CERTIFICATE_INFO class >> aspects [
	^super aspects
		, #(#subject
			#issuer
			#protocol
			#signatureAlgorithm
			#encryptionAlgorithm)]

{ #category : #accessing }
INTERNET_CERTIFICATE_INFO class >> def [
	^<def>
	typedef struct {
		FILETIME ftExpiry;
		FILETIME ftStart;
		LPTSTR   lpszSubjectInfo;
		LPTSTR   lpszIssuerInfo;
		LPTSTR   lpszProtocolName;
		LPTSTR   lpszSignatureAlgName;
		LPTSTR   lpszEncryptionAlgName;
		DWORD    dwKeySize;
	} INTERNET_CERTIFICATE_INFO, * LPINTERNET_CERTIFICATE_INFO;
	</def>]

{ #category : #private }
INTERNET_CERTIFICATE_INFO class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 64;
		at: 'ftExpiry' put: 0;
		at: 'ftStart' put: 8;
		at: 'lpszSubjectInfo' put: 16;
		at: 'lpszIssuerInfo' put: 24;
		at: 'lpszProtocolName' put: 32;
		at: 'lpszSignatureAlgName' put: 40;
		at: 'lpszEncryptionAlgName' put: 48;
		at: 'dwKeySize' put: 56;
		yourself]

{ #category : #accessing }
INTERNET_CERTIFICATE_INFO class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
INTERNET_CERTIFICATE_INFO >> dwKeySize [
	^self uLongAtOffset: dwKeySize]

{ #category : #output }
INTERNET_CERTIFICATE_INFO >> encryptionAlgorithm [
	| memory |
	memory := self lpszEncryptionAlgName.
	^memory isValid ifTrue: [String fromMemory: memory]]

{ #category : #finalization }
INTERNET_CERTIFICATE_INFO >> free [
	super free.
	self
		freeAddressAtOffset: lpszSubjectInfo;
		freeAddressAtOffset: lpszIssuerInfo;
		freeAddressAtOffset: lpszProtocolName;
		freeAddressAtOffset: lpszSignatureAlgName;
		freeAddressAtOffset: lpszEncryptionAlgName]

{ #category : #finalization }
INTERNET_CERTIFICATE_INFO >> freeAddressAtOffset: offset [
	| memory result |
	memory := self addressAtOffset: offset.
	memory isValid ifTrue: [
		result := KernelDLL current LocalFree: memory.
		result = 0
			ifTrue: [self addressAtOffset: offset put: 0 pointedMemory]
			ifFalse: [self winError]]]

{ #category : #accessing }
INTERNET_CERTIFICATE_INFO >> ftExpiry [
	| bytes |
	bytes := self bytesAtOffset: ftExpiry count: FILETIME sizeInBytes.
	^FILETIME usingBytes: bytes]

{ #category : #accessing }
INTERNET_CERTIFICATE_INFO >> ftStart [
	| bytes |
	bytes := self bytesAtOffset: ftStart count: FILETIME sizeInBytes.
	^FILETIME usingBytes: bytes]

{ #category : #output }
INTERNET_CERTIFICATE_INFO >> issuer [
	| memory |
	memory := self lpszIssuerInfo.
	^memory isValid ifTrue: [String fromMemory: memory]]

{ #category : #output }
INTERNET_CERTIFICATE_INFO >> keySize [
	^self dwKeySize]

{ #category : #accessing }
INTERNET_CERTIFICATE_INFO >> lpszEncryptionAlgName [
	^self addressAtOffset: lpszEncryptionAlgName]

{ #category : #accessing }
INTERNET_CERTIFICATE_INFO >> lpszIssuerInfo [
	^self addressAtOffset: lpszIssuerInfo]

{ #category : #accessing }
INTERNET_CERTIFICATE_INFO >> lpszProtocolName [
	^self addressAtOffset: lpszProtocolName]

{ #category : #accessing }
INTERNET_CERTIFICATE_INFO >> lpszSignatureAlgName [
	^self addressAtOffset: lpszSignatureAlgName]

{ #category : #accessing }
INTERNET_CERTIFICATE_INFO >> lpszSubjectInfo [
	^self addressAtOffset: lpszSubjectInfo]

{ #category : #output }
INTERNET_CERTIFICATE_INFO >> protocol [
	| memory |
	memory := self lpszProtocolName.
	^memory isValid ifTrue: [String fromMemory: memory]]

{ #category : #output }
INTERNET_CERTIFICATE_INFO >> signatureAlgorithm [
	| memory |
	memory := self lpszSignatureAlgName.
	^memory isValid ifTrue: [String fromMemory: memory]]

{ #category : #output }
INTERNET_CERTIFICATE_INFO >> subject [
	| memory |
	memory := self lpszSubjectInfo.
	^memory isValid ifTrue: [String fromMemory: memory]]

