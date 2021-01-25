"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SCHANNEL_CRED,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #sockets
}

{ #category : #accessing }
SCHANNEL_CRED class >> def [
	^<def>
	typedef struct _SCHANNEL_CRED {
		DWORD           dwVersion;
		DWORD           cCreds;
		PCCERT_CONTEXT  *paCred;
		HCERTSTORE      hRootStore;
		DWORD           cMappers;
		_HMAPPER  **aphMappers;
		DWORD           cSupportedAlgs;
		ALG_ID          *palgSupportedAlgs;
		DWORD           grbitEnabledProtocols;
		DWORD           dwMinimumCipherStrength;
		DWORD           dwMaximumCipherStrength;
		DWORD           dwSessionLifespan;
		DWORD           dwFlags;
		DWORD           dwCredFormat;
	} SCHANNEL_CRED, *PSCHANNEL_CRED;
	</def>]

{ #category : #'instance creation' }
SCHANNEL_CRED class >> forClient [
	^self new forClient]

{ #category : #initialization }
SCHANNEL_CRED class >> initializeConstants [
	"
	SCHANNEL_CRED initializeConstants
	"
	WindowsConstants
		at: 'SCHANNEL_CRED_VERSION' put: 4;
		at: 'SCH_CRED_USE_DEFAULT_CREDS' put: 16r40.
	self intializeProtocols]

{ #category : #initialization }
SCHANNEL_CRED class >> intializeProtocols [
	"
	SCHANNEL_CRED intializeProtocols
	"
	WindowsConstants
		at: 'SCH_CRED_V1' put: 1;
		at: 'SCH_CRED_V2' put: 2;
		at: 'SCH_CRED_VERSION' put: 2;
		at: 'SCH_CRED_V3' put: 3;
		at: 'SCHANNEL_CRED_VERSION' put: 4;
		at: 'SCHANNEL_RENEGOTIATE' put: 0;
		at: 'SCHANNEL_SHUTDOWN' put: 1;
		at: 'SCHANNEL_ALERT' put: 2;
		at: 'SCHANNEL_SESSION' put: 3;
		at: 'SP_PROT_TLS1_CLIENT' put: 128;
		at: 'SP_PROT_TLS1_1_CLIENT' put: 512;
		at: 'SP_PROT_TLS1_0_CLIENT' put: 128;
		at: 'SP_PROT_TLS1_2_CLIENT' put: 2048;
		at: 'SP_PROT_TLS1_SERVER' put: 64;
		at: 'SP_PROT_SSL3_CLIENT' put: 32;
		at: 'SP_PROT_SSL3_SERVER' put: 16;
		at: 'SP_PROT_SSL2_CLIENT' put: 8;
		at: 'SP_PROT_SSL2_SERVER' put: 4;
		at: 'SP_PROT_PCT1_CLIENT' put: 2;
		at: 'SP_PROT_PCT1_SERVER' put: 1;
		at: 'SP_PROT_TLS1' put: 128 | 16;
		at: 'SP_PROT_SSL3' put: 32 | 16;
		at: 'SP_PROT_SSL2' put: 8 | 4;
		at: 'SP_PROT_PCT1' put: 2 | 1;
		at: 'SP_PROT_TLS1_1PLUS_CLIENT' put: 512 | 2048;
		at: 'SCH_CRED_NO_SYSTEM_MAPPER' put: 2;
		at: 'SCH_CRED_NO_SERVERNAME_CHECK' put: 4;
		at: 'SCH_CRED_MANUAL_CRED_VALIDATION' put: 8;
		at: 'SCH_CRED_NO_DEFAULT_CREDS' put: 16;
		at: 'SCH_CRED_AUTO_CRED_VALIDATION' put: 32;
		at: 'SCH_CRED_USE_DEFAULT_CREDS' put: 64;
		at: 'SCH_CRED_REVOCATION_CHECK_CHAIN_END_CERT' put: 256;
		at: 'SCH_CRED_REVOCATION_CHECK_CHAIN' put: 512;
		at: 'SCH_CRED_REVOCATION_CHECK_CHAIN_EXCLUDE_ROOT'
		put: 1024;
		at: 'SCH_CRED_IGNORE_NO_REVOCATION_CHECK' put: 2048;
		at: 'SCH_CRED_IGNORE_REVOCATION_OFFLINE' put: 4096;
		at: 'SECPKG_ATTR_ISSUER_LIST' put: 16r50;
		at: 'SECPKG_ATTR_LOCAL_CRED' put: 16r52;
		at: 'SECPKG_ATTR_REMOTE_CRED' put: 16r51;
		at: 'SECPKG_ATTR_REMOTE_CERT_CONTEXT' put: 16r53;
		at: 'SECPKG_ATTR_LOCAL_CERT_CONTEXT' put: 16r54;
		at: 'SECPKG_ATTR_ROOT_STORE' put: 16r55;
		at: 'SECPKG_ATTR_SUPPORTED_ALGS' put: 16r56;
		at: 'SECPKG_ATTR_CIPHER_STRENGTHS' put: 16r57;
		at: 'SECPKG_ATTR_SUPPORTED_PROTOCOLS' put: 16r58;
		at: 'SECPKG_ATTR_ISSUER_LIST_EX' put: 16r59;
		at: 'SECPKG_ATTR_CONNECTION_INFO' put: 16r5A;
		at: 'SECPKG_ATTR_EAP_KEY_BLOCK' put: 16r5B;
		at: 'SECPKG_ATTR_MAPPED_CRED_ATTR' put: 16r5C;
		at: 'SECPKG_ATTR_SESSION_INFO' put: 16r5D;
		at: 'SECPKG_ATTR_APP_DATA' put: 16r5E;
		at: 'UNISP_RPC_ID' put: 14]

{ #category : #private }
SCHANNEL_CRED class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 80;
		at: 'dwVersion' put: 0;
		at: 'cCreds' put: 4;
		at: 'paCred' put: 8;
		at: 'hRootStore' put: 16;
		at: 'cMappers' put: 24;
		at: 'aphMappers' put: 32;
		at: 'cSupportedAlgs' put: 40;
		at: 'palgSupportedAlgs' put: 48;
		at: 'grbitEnabledProtocols' put: 56;
		at: 'dwMinimumCipherStrength' put: 60;
		at: 'dwMaximumCipherStrength' put: 64;
		at: 'dwSessionLifespan' put: 68;
		at: 'dwFlags' put: 72;
		at: 'dwCredFormat' put: 76;
		yourself]

{ #category : #accessing }
SCHANNEL_CRED class >> sizeInBytes [
	^sizeInBytes]

{ #category : #private }
SCHANNEL_CRED class >> typedefTable [
	^Crypt32DLL typedefTable]

{ #category : #services }
SCHANNEL_CRED >> addFlag: anInteger [
	self dwFlags: self dwFlags | anInteger]

{ #category : #accessing }
SCHANNEL_CRED >> aphMappers [
	^self addressAtOffset: aphMappers]

{ #category : #accessing }
SCHANNEL_CRED >> cCreds [
	^self uLongAtOffset: cCreds]

{ #category : #accessing }
SCHANNEL_CRED >> cCreds: anInteger [
	self uLongAtOffset: cCreds put: anInteger]

{ #category : #accessing }
SCHANNEL_CRED >> cMappers [
	^self uLongAtOffset: cMappers]

{ #category : #output }
SCHANNEL_CRED >> contexts [
	| buffer |
	buffer := BufferArray
		at: self paCred
		count: self cCreds
		type: ExternalPointer.
	^buffer asArray collect: [:address | CERT_CONTEXT atMemory: address]]

{ #category : #input }
SCHANNEL_CRED >> contexts: anArray [
	| pointers array |
	pointers := anArray collect: #address.
	array := BufferArray externalOn: pointers type: ExternalMemory.
	self paCred: array address; cCreds: anArray size]

{ #category : #accessing }
SCHANNEL_CRED >> cSupportedAlgs [
	^self uLongAtOffset: cSupportedAlgs]

{ #category : #accessing }
SCHANNEL_CRED >> dwCredFormat [
	^self uLongAtOffset: dwCredFormat]

{ #category : #accessing }
SCHANNEL_CRED >> dwFlags [
	^self uLongAtOffset: dwFlags]

{ #category : #accessing }
SCHANNEL_CRED >> dwFlags: anInteger [
	self uLongAtOffset: dwFlags put: anInteger]

{ #category : #accessing }
SCHANNEL_CRED >> dwMaximumCipherStrength [
	^self uLongAtOffset: dwMaximumCipherStrength]

{ #category : #accessing }
SCHANNEL_CRED >> dwMinimumCipherStrength [
	^self uLongAtOffset: dwMinimumCipherStrength]

{ #category : #accessing }
SCHANNEL_CRED >> dwSessionLifespan [
	^self uLongAtOffset: dwSessionLifespan]

{ #category : #accessing }
SCHANNEL_CRED >> dwVersion [
	^self uLongAtOffset: dwVersion]

{ #category : #accessing }
SCHANNEL_CRED >> dwVersion: anInteger [
	self uLongAtOffset: dwVersion put: anInteger]

{ #category : #private }
SCHANNEL_CRED >> forClient [
	self dwFlags: SCH_CRED_USE_DEFAULT_CREDS]

{ #category : #accessing }
SCHANNEL_CRED >> grbitEnabledProtocols [
	^self uLongAtOffset: grbitEnabledProtocols]

{ #category : #accessing }
SCHANNEL_CRED >> grbitEnabledProtocols: anInteger [
	^self uLongAtOffset: grbitEnabledProtocols put: anInteger]

{ #category : #accessing }
SCHANNEL_CRED >> hRootStore [
	^self addressAtOffset: hRootStore]

{ #category : #initialization }
SCHANNEL_CRED >> initialize: anInteger [
	super initialize: anInteger.
	self dwVersion: SCHANNEL_CRED_VERSION]

{ #category : #accessing }
SCHANNEL_CRED >> paCred [
	^self addressAtOffset: paCred]

{ #category : #accessing }
SCHANNEL_CRED >> paCred: anExternalMemory [
	self addressAtOffset: paCred register: anExternalMemory]

{ #category : #accessing }
SCHANNEL_CRED >> palgSupportedAlgs [
	^self pointerAtOffset: palgSupportedAlgs]

