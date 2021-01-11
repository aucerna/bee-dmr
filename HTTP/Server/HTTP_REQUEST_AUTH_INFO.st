"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_REQUEST_AUTH_INFO,
	#superclass : #HttpApiStructure,
	#instVars : [
		'size'
	],
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_REQUEST_AUTH_INFO class >> aspects [
	^#(#AuthStatus
		#SecStatus
		#Flags
		#AuthType
		#AccessToken
		#ContextAttributes
		#PackedContextLength
		#PackedContextType
		#PackedContext
		#MutualAuthDataLength
		#pMutualAuthData
		#PackageNameLength
		#pPackageName)]

{ #category : #'instance creation' }
HTTP_REQUEST_AUTH_INFO class >> atAddress: anExternalMemory length: anInteger [
	| struct |
	struct := self atMemory: anExternalMemory.
	struct initialize: anInteger.
	^struct]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO class >> def [
	^<def>
	typedef struct _HTTP_REQUEST_AUTH_INFO {
		HTTP_AUTH_STATUS       AuthStatus;
		SECURITY_STATUS        SecStatus;
		ULONG                  Flags;
		HTTP_REQUEST_AUTH_TYPE AuthType;
		HANDLE                 AccessToken;
		ULONG                  ContextAttributes;
		ULONG                  PackedContextLength;
		ULONG                  PackedContextType;
		PVOID                  PackedContext;
		ULONG                  MutualAuthDataLength;
		PCHAR                  pMutualAuthData;
		USHORT                 PackageNameLength;
		PWSTR                  pPackageName;
	} HTTP_REQUEST_AUTH_INFO, *PHTTP_REQUEST_AUTH_INFO;
	</def>]

{ #category : #initialization }
HTTP_REQUEST_AUTH_INFO class >> initializeAuthStatusEnumeration [
	WinConstants
		at: 'HttpAuthStatusSuccess' put: 0;
		at: 'HttpAuthStatusNotAuthenticated' put: 1;
		at: 'HttpAuthStatusFailure' put: 2]

{ #category : #initialization }
HTTP_REQUEST_AUTH_INFO class >> initializeConstants [
	self initializeAuthStatusEnumeration; initializeRequestAuthTypeConstants]

{ #category : #initialization }
HTTP_REQUEST_AUTH_INFO class >> initializeRequestAuthTypeConstants [
	WinConstants
		at: 'HttpRequestAuthTypeNone'
		put: 0 "No authentication is attempted for the request.";
		at: 'HttpRequestAuthTypeBasic'
		put: 1 "Basic authentication is attempted for the request.";
		at: 'HttpRequestAuthTypeDigest'
		put: 2 "Digest authentication is attempted for the request.";
		at: 'HttpRequestAuthTypeNTLM'
		put: 3 "NTLM authentication is attempted for the request.";
		at: 'HttpRequestAuthTypeNegotiate'
		put: 4 "Negotiate authentication is attempted for the request.";
		at: 'HttpRequestAuthTypeKerberos'
		put: 5 "Kerberos authentication is attempted for the request."]

{ #category : #private }
HTTP_REQUEST_AUTH_INFO class >> offsets64 [
	^PoolDictionary new
		at: 'PackedContextLength' put: 28;
		at: 'AccessToken' put: 16;
		at: 'MutualAuthDataLength' put: 48;
		at: 'PackageNameLength' put: 64;
		at: 'PackedContextType' put: 32;
		at: 'Flags' put: 8;
		at: 'AuthType' put: 12;
		at: 'AuthStatus' put: 0;
		at: 'pPackageName' put: 72;
		at: 'pMutualAuthData' put: 56;
		at: 'sizeInBytes' put: 80;
		at: 'SecStatus' put: 4;
		at: 'ContextAttributes' put: 24;
		at: 'PackedContext' put: 40;
		yourself]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> AccessToken [
	^self pointerAtOffset: AccessToken]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> AccessToken: anInteger [
	self pointerAtOffset: AccessToken put: anInteger]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> AuthStatus [
	^self longAtOffset: AuthStatus]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> AuthStatus: anInteger [
	self longAtOffset: AuthStatus put: anInteger]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> AuthType [
	^self longAtOffset: AuthType]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> AuthType: anInteger [
	self longAtOffset: AuthType put: anInteger]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> ContextAttributes [
	^self uLongAtOffset: ContextAttributes]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> ContextAttributes: anInteger [
	self uLongAtOffset: ContextAttributes put: anInteger]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> Flags [
	^self uLongAtOffset: Flags]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> Flags: anInteger [
	self uLongAtOffset: Flags put: anInteger]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> initialize: anInteger [
	super initialize: anInteger.
	size := anInteger]

{ #category : #output }
HTTP_REQUEST_AUTH_INFO >> mutualAuthData [
	^String fromMemory: self pMutualAuthData length: self MutualAuthDataLength]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> MutualAuthDataLength [
	^self uLongAtOffset: MutualAuthDataLength]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> MutualAuthDataLength: anInteger [
	self uLongAtOffset: MutualAuthDataLength put: anInteger]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> PackageNameLength [
	^self uShortAtOffset: PackageNameLength]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> PackageNameLength: anInteger [
	self uShortAtOffset: PackageNameLength put: anInteger]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> PackedContext [
	^self pointerAtOffset: PackedContext]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> PackedContext: anInteger [
	self pointerAtOffset: PackedContext put: anInteger]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> PackedContextLength [
	^self uLongAtOffset: PackedContextLength]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> PackedContextLength: anInteger [
	self uLongAtOffset: PackedContextLength put: anInteger]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> PackedContextType [
	^self uLongAtOffset: PackedContextType]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> PackedContextType: anInteger [
	self uLongAtOffset: PackedContextType put: anInteger]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> pMutualAuthData [
	^self addressAtOffset: pMutualAuthData]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> pMutualAuthData: anInteger [
	self addressAtOffset: pMutualAuthData register: anInteger]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> pPackageName [
	^self addressAtOffset: pPackageName]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> pPackageName: anInteger [
	self addressAtOffset: pPackageName register: anInteger]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> SecStatus [
	^self longAtOffset: SecStatus]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> SecStatus: anInteger [
	self longAtOffset: SecStatus put: anInteger]

{ #category : #accessing }
HTTP_REQUEST_AUTH_INFO >> sizeInBytes [
	^size]

