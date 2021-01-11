"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_SERVICE_CONFIG_SSL_PARAM,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_SERVICE_CONFIG_SSL_PARAM class >> aspects [
	^#(#SslHashLength
		#pSslHash
		#AppId
		#pSslCertStoreName
		#DefaultCertCheckMode
		#DefaultRevocationFreshnessTime
		#DefaultRevocationUrlRetrievalTimeout
		#pDefaultSslCtlIdentifier
		#pDefaultSslCtlStoreName
		#DefaultFlags)]

{ #category : #private }
HTTP_SERVICE_CONFIG_SSL_PARAM class >> def [
	^<def>
	typedef struct _HTTP_SERVICE_CONFIG_SSL_PARAM {
		ULONG SslHashLength;
		PVOID pSslHash;
		GUID  AppId;
		PWSTR pSslCertStoreName;
		DWORD DefaultCertCheckMode;
		DWORD DefaultRevocationFreshnessTime;
		DWORD DefaultRevocationUrlRetrievalTimeout;
		PWSTR pDefaultSslCtlIdentifier;
		PWSTR pDefaultSslCtlStoreName;
		DWORD DefaultFlags;
	} HTTP_SERVICE_CONFIG_SSL_PARAM, *PHTTP_SERVICE_CONFIG_SSL_PARAM;
	</def>]

{ #category : #initialization }
HTTP_SERVICE_CONFIG_SSL_PARAM class >> initializeConstants [
	self initializeDefaultFlagConstants]

{ #category : #initialization }
HTTP_SERVICE_CONFIG_SSL_PARAM class >> initializeDefaultFlagConstants [
	WinConstants
		at: 'HTTP_SERVICE_CONFIG_SSL_FLAG_NEGOTIATE_CLIENT_CERT'
		put: 2 "Enables a client certificate to be cached locally for subsequent use.";
		at: 'HTTP_SERVICE_CONFIG_SSL_FLAG_NO_RAW_FILTER'
		put: 4 "Prevents SSL requests from being passed to low-level ISAPI filters.";
		at: 'HTTP_SERVICE_CONFIG_SSL_FLAG_USE_DS_MAPPER'
		put: 1 "Client certificates are mapped where possible to corresponding operating-system user accounts based on the certificate mapping rules stored in Active Directory. 
If this flag is set and the mapping is successful, the Token member of the HTTP_SSL_CLIENT_CERT_INFO structure is a handle to an access token. Release this token explicitly by closing the handle when the HTTP_SSL_CLIENT_CERT_INFO structure is no longer required."]

{ #category : #private }
HTTP_SERVICE_CONFIG_SSL_PARAM class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 80;
		at: 'SslHashLength' put: 0;
		at: 'pSslHash' put: 8;
		at: 'AppId' put: 16;
		at: 'pSslCertStoreName' put: 32;
		at: 'DefaultCertCheckMode' put: 40;
		at: 'DefaultRevocationFreshnessTime' put: 44;
		at: 'DefaultRevocationUrlRetrievalTimeout' put: 48;
		at: 'pDefaultSslCtlIdentifier' put: 56;
		at: 'pDefaultSslCtlStoreName' put: 64;
		at: 'DefaultFlags' put: 72;
		yourself]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_PARAM class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_PARAM >> AppId [
	^self structureAtOffset: AppId ofClass: GUID]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_PARAM >> AppId: aGUID [
	self bytesAtOffset: AppId put: aGUID asParameter]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_PARAM >> DefaultCertCheckMode [
	^self uLongAtOffset: DefaultCertCheckMode]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_PARAM >> DefaultCertCheckMode: anInteger [
	self uLongAtOffset: DefaultCertCheckMode put: anInteger]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_PARAM >> DefaultFlags [
	^self uLongAtOffset: DefaultFlags]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_PARAM >> DefaultFlags: anInteger [
	self uLongAtOffset: DefaultFlags put: anInteger]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_PARAM >> DefaultRevocationFreshnessTime [
	^self uLongAtOffset: DefaultRevocationFreshnessTime]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_PARAM >> DefaultRevocationFreshnessTime: anInteger [
	self uLongAtOffset: DefaultRevocationFreshnessTime put: anInteger]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_PARAM >> DefaultRevocationUrlRetrievalTimeout [
	^self uLongAtOffset: DefaultRevocationUrlRetrievalTimeout]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_PARAM >> DefaultRevocationUrlRetrievalTimeout: anInteger [
	self uLongAtOffset: DefaultRevocationUrlRetrievalTimeout put: anInteger]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_PARAM >> pDefaultSslCtlIdentifier [
	^self addressAtOffset: pDefaultSslCtlIdentifier]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_PARAM >> pDefaultSslCtlIdentifier: anInteger [
	self addressAtOffset: pDefaultSslCtlIdentifier register: anInteger]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_PARAM >> pDefaultSslCtlStoreName [
	^self addressAtOffset: pDefaultSslCtlStoreName]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_PARAM >> pDefaultSslCtlStoreName: anInteger [
	self addressAtOffset: pDefaultSslCtlStoreName register: anInteger]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_PARAM >> pSslCertStoreName [
	^self addressAtOffset: pSslCertStoreName]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_PARAM >> pSslCertStoreName: anInteger [
	self addressAtOffset: pSslCertStoreName register: anInteger]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_PARAM >> pSslHash [
	^self pointerAtOffset: pSslHash]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_PARAM >> pSslHash: anInteger [
	self pointerAtOffset: pSslHash put: anInteger]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_PARAM >> SslHashLength [
	^self uLongAtOffset: SslHashLength]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_SSL_PARAM >> SslHashLength: anInteger [
	self uLongAtOffset: SslHashLength put: anInteger]

