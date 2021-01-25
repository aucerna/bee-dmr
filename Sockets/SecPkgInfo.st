"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SecPkgInfo,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #sockets
}

{ #category : #inspecting }
SecPkgInfo class >> aspects [
	^super aspects , #(#name #comment)]

{ #category : #accessing }
SecPkgInfo class >> def [
	^<def>
	typedef struct _SecPkgInfo {
		ULONG    fCapabilities;
		USHORT   wVersion;
		USHORT   wRPCID;
		ULONG    cbMaxToken;
		SEC_CHAR *Name;
		SEC_CHAR *Comment;
	} SecPkgInfo, *PSecPkgInfo;
	</def>]

{ #category : #initialization }
SecPkgInfo class >> initializeFlags [
	"
	SecPkgInfo initializeFlags
	"
	WindowsConstants
		at: 'SECPKG_FLAG_INTEGRITY'
		put: 16r1 "0x00000001  // Supports integrity on messages";
		at: 'SECPKG_FLAG_PRIVACY'
		put: 16r2 "0x00000002  // Supports privacy (confidentiality)";
		at: 'SECPKG_FLAG_TOKEN_ONLY'
		put: 16r4 "0x00000004  // Only security token needed";
		at: 'SECPKG_FLAG_DATAGRAM'
		put: 16r8 "0x00000008  // Datagram RPC support";
		at: 'SECPKG_FLAG_CONNECTION'
		put: 16r10 "0x00000010  // Connection oriented RPC support";
		at: 'SECPKG_FLAG_MULTI_REQUIRED'
		put: 16r20 "0x00000020  // Full 3-leg required for re-auth.";
		at: 'SECPKG_FLAG_CLIENT_ONLY'
		put: 16r40 "0x00000040  // Server side functionality not available";
		at: 'SECPKG_FLAG_EXTENDED_ERROR'
		put: 16r80 "0x00000080  // Supports extended error msgs";
		at: 'SECPKG_FLAG_IMPERSONATION'
		put: 16r100 "0x00000100  // Supports impersonation";
		at: 'SECPKG_FLAG_ACCEPT_WIN32_NAME'
		put: 16r200 "0x00000200  // Accepts Win32 names";
		at: 'SECPKG_FLAG_STREAM'
		put: 16r400 "0x00000400  // Supports stream semantics";
		at: 'SECPKG_FLAG_NEGOTIABLE'
		put: 16r800 "0x00000800  // Can be used by the negotiate package";
		at: 'SECPKG_FLAG_GSS_COMPATIBLE'
		put: 16r1000 "0x00001000  // GSS Compatibility Available";
		at: 'SECPKG_FLAG_LOGON'
		put: 16r2000 "0x00002000  // Supports common LsaLogonUser";
		at: 'SECPKG_FLAG_ASCII_BUFFERS'
		put: 16r4000 "0x00004000  // Token Buffers are in ASCII";
		at: 'SECPKG_FLAG_FRAGMENT'
		put: 16r8000 "0x00008000  // Package can fragment to fit";
		at: 'SECPKG_FLAG_MUTUAL_AUTH'
		put: 16r10000 "0x00010000  // Package can perform mutual authentication";
		at: 'SECPKG_FLAG_DELEGATION'
		put: 16r20000 "0x00020000  // Package can delegate"]

{ #category : #private }
SecPkgInfo class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 32;
		at: 'fCapabilities' put: 0;
		at: 'wVersion' put: 4;
		at: 'wRPCID' put: 6;
		at: 'cbMaxToken' put: 8;
		at: 'Name' put: 16;
		at: 'Comment' put: 24;
		yourself]

{ #category : #accessing }
SecPkgInfo class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
SecPkgInfo class >> typedefTable [
	^Crypt32DLL typedefTable]

{ #category : #services }
SecPkgInfo >> canFragment [
	^self fCapabilities & SECPKG_FLAG_FRAGMENT = SECPKG_FLAG_FRAGMENT]

{ #category : #accessing }
SecPkgInfo >> cbMaxToken [
	^self uLongAtOffset: cbMaxToken]

{ #category : #output }
SecPkgInfo >> comment [
	^WideString fromMemory: self Comment]

{ #category : #accessing }
SecPkgInfo >> Comment [
	^self addressAtOffset: Comment]

{ #category : #accessing }
SecPkgInfo >> fCapabilities [
	^self uLongAtOffset: fCapabilities]

{ #category : #services }
SecPkgInfo >> hasAsciiBuffers [
	^self fCapabilities & SECPKG_FLAG_ASCII_BUFFERS = SECPKG_FLAG_ASCII_BUFFERS]

{ #category : #output }
SecPkgInfo >> name [
	^WideString fromMemory: self Name]

{ #category : #accessing }
SecPkgInfo >> Name [
	^self addressAtOffset: Name]

{ #category : #printing }
SecPkgInfo >> printOn: aStream [
	aStream nextPutAll: 'Security Package:'; space; nextPutAll: self name]

{ #category : #services }
SecPkgInfo >> requiresMultipleLegs [
	^self fCapabilities & SECPKG_FLAG_MULTI_REQUIRED
		= SECPKG_FLAG_MULTI_REQUIRED]

{ #category : #services }
SecPkgInfo >> supportsConnectionOrientedAuthentication [
	^self fCapabilities & SECPKG_FLAG_CONNECTION = SECPKG_FLAG_CONNECTION]

{ #category : #services }
SecPkgInfo >> supportsDatagramAuthentication [
	^self fCapabilities & SECPKG_FLAG_DATAGRAM = SECPKG_FLAG_DATAGRAM]

{ #category : #services }
SecPkgInfo >> supportsDelegation [
	^self fCapabilities & SECPKG_FLAG_DELEGATION = SECPKG_FLAG_DELEGATION]

{ #category : #services }
SecPkgInfo >> supportsExtendedErrorHandling [
	^self fCapabilities & SECPKG_FLAG_EXTENDED_ERROR
		= SECPKG_FLAG_EXTENDED_ERROR]

{ #category : #services }
SecPkgInfo >> supportsGSSCompatibility [
	^self fCapabilities & SECPKG_FLAG_GSS_COMPATIBLE
		= SECPKG_FLAG_GSS_COMPATIBLE]

{ #category : #services }
SecPkgInfo >> supportsImpersonation [
	^self fCapabilities & SECPKG_FLAG_IMPERSONATION = SECPKG_FLAG_IMPERSONATION]

{ #category : #services }
SecPkgInfo >> supportsIntegrity [
	^self fCapabilities & SECPKG_FLAG_INTEGRITY = SECPKG_FLAG_INTEGRITY]

{ #category : #services }
SecPkgInfo >> supportsLSALogonUser [
	^self fCapabilities & SECPKG_FLAG_LOGON = SECPKG_FLAG_LOGON]

{ #category : #services }
SecPkgInfo >> supportsMutualAuthentication [
	^self fCapabilities & SECPKG_FLAG_MUTUAL_AUTH = SECPKG_FLAG_MUTUAL_AUTH]

{ #category : #services }
SecPkgInfo >> supportsNegotiate [
	^self fCapabilities & SECPKG_FLAG_NEGOTIABLE = SECPKG_FLAG_NEGOTIABLE]

{ #category : #services }
SecPkgInfo >> supportsPrivacy [
	^self fCapabilities & SECPKG_FLAG_NEGOTIABLE = SECPKG_FLAG_NEGOTIABLE]

{ #category : #services }
SecPkgInfo >> supportsSeverAuthentication [
	^self fCapabilities & SECPKG_FLAG_CLIENT_ONLY = SECPKG_FLAG_CLIENT_ONLY]

{ #category : #services }
SecPkgInfo >> supportsStreamSemantic [
	^self fCapabilities & SECPKG_FLAG_STREAM = SECPKG_FLAG_STREAM]

{ #category : #services }
SecPkgInfo >> understandsPrincipalAndTargetNames [
	^self fCapabilities & SECPKG_FLAG_ACCEPT_WIN32_NAME
		= SECPKG_FLAG_ACCEPT_WIN32_NAME]

{ #category : #services }
SecPkgInfo >> usesTokenOnly [
	^self fCapabilities & SECPKG_FLAG_TOKEN_ONLY = SECPKG_FLAG_TOKEN_ONLY]

{ #category : #accessing }
SecPkgInfo >> wRPCID [
	^self uShortAtOffset: wRPCID]

{ #category : #accessing }
SecPkgInfo >> wVersion [
	^self uShortAtOffset: wVersion]

