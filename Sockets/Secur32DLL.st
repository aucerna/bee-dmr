"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #Secur32DLL,
	#superclass : #WindowsLibrary,
	#type : #bytes,
	#category : #sockets
}

{ #category : #parsing }
Secur32DLL class >> h [
	^SmalltalkSession current devDirectory \ 'sspi.h']

{ #category : #initialization }
Secur32DLL class >> initializeAttributeConstants [
	"
	Secur32DLL initializeAttributeConstants
	"
	WindowsConstants
		at: 'SECPKG_ATTR_ACCESS_TOKEN'
		put: 16rD
		"The pBuffer parameter contains a pointer to a SecPkgContext_AccessToken structure.

Returns a handle to the access token.";
		at: 'SECPKG_ATTR_APP_DATA'
		put: 16r5E
		"The pBuffer parameter contains a pointer to a SecPkgContext_SessionAppData structure.

Returns or specifies application data for the session.

This attribute is supported only by the Schannel security package.";
		at: 'SECPKG_ATTR_AUTHORITY'
		put: 16r6
		"The pBuffer parameter contains a pointer to a SecPkgContext_Authority structure.

Queries the name of the authenticating authority.";
		at: 'SECPKG_ATTR_CONNECTION_INFO'
		put: 16r5A
		"The pBuffer parameter contains a pointer to a SecPkgContext_ConnectionInfo structure.

Returns detailed information on the established connection.";
		at: 'SECPKG_ATTR_CREDS_2'
		put: 16r80000086
		"The pBuffer parameter contains a pointer to a SecPkgContext_ClientCreds structure that specifies client credentials.

If the client credential is user name and password, the buffer is a packed KERB_INTERACTIVE_LOGON structure.

If the client credential is user name and smart card PIN, the buffer is a packed KERB_CERTIFICATE_LOGON structure.

If the client credential is an online identity credential, the buffer is a marshaled SEC_WINNT_AUTH_IDENTITY_EX2 structure.

This attribute is supported only on the CredSSP server.

Windows Server 2008 R2, Windows 7, Windows Server 2008, Windows Vista, Windows Server 2003, and Windows XP:  This value is not supported.";
		at: 'SECPKG_ATTR_DCE_INFO'
		put: 16r3
		"The pBuffer parameter contains a pointer to a SecPkgContext_DceInfo structure.

Queries for authorization data used by DCE services.";
		at: 'SECPKG_ATTR_EAP_KEY_BLOCK'
		put: 16r5B
		"The pBuffer parameter contains a pointer to a SecPkgContext_EapKeyBlock structure.

Queries for key data used by the EAP TLS protocol.

This attribute is supported only by the Schannel security package.";
		at: 'SECPKG_ATTR_ENDPOINT_BINDINGS'
		put: 16r1A
		"The pBuffer parameter contains a pointer to a SecPkgContext_Bindings structure that contains the Channel Bindings for TLS (RFC 5929).

Windows Server 2008, Windows Vista, Windows Server 2003, and Windows XP:  This value is not supported.";
		at: 'SECPKG_ATTR_FLAGS'
		put: 16rE
		"The pBuffer parameter contains a pointer to a SecPkgContext_Flags structure.

Returns information about the negotiated context flags.";
		at: 'SECPKG_ATTR_ISSUER_LIST_EX'
		put: 16r59
		"The pBuffer parameter contains a pointer to a SecPkgContext_IssuerListInfoEx structure.

Returns a list of certificate issuers that are accepted by the server.

This attribute is supported only by the Schannel security package.";
		at: 'SECPKG_ATTR_KEY_INFO'
		put: 16r5
		"The pBuffer parameter contains a pointer to a SecPkgContext_KeyInfo structure.

Queries information about the keys used in a security context.";
		at: 'SECPKG_ATTR_LIFESPAN'
		put: 16r2
		"The pBuffer parameter contains a pointer to a SecPkgContext_Lifespan structure.

Queries the life span of the context.";
		at: 'SECPKG_ATTR_LOCAL_CERT_CONTEXT'
		put: 16r54
		"The pBuffer parameter contains a pointer to a PCCERT_CONTEXT structure.

Finds a certificate context that contains a local end certificate.

This attribute is supported only by the Schannel security package.

SECPKG_ATTR_LOCAL_CRED

	

The pBuffer parameter contains a pointer to a SecPkgContext_LocalCredentialInfo structure. (obsolete)

Superseded by SECPKG_ATTR_LOCAL_CERT_CONTEXT.";
		at: 'SECPKG_ATTR_NAMES'
		put: 16r1
		"The pBuffer parameter contains a pointer to a SecPkgContext_Names structure.

Queries the name associated with the context.";
		at: 'SECPKG_ATTR_NATIVE_NAMES'
		put: 16rD
		"The pBuffer parameter contains a pointer to a SecPkgContext_NativeNames structure.

Returns the principal name (CNAME) from the outbound ticket.";
		at: 'SECPKG_ATTR_NEGOTIATION_INFO'
		put: 16rC
		"The pBuffer parameter contains a pointer to a SecPkgContext_NegotiationInfo structure.

Returns information about the security package to be used with the negotiation process and the current state of the negotiation for the use of that package.";
		at: 'SECPKG_ATTR_PACKAGE_INFO'
		put: 16rA
		"The pBuffer parameter contains a pointer to a SecPkgContext_PackageInfo structure.

Returns information on the SSP in use.";
		at: 'SECPKG_ATTR_PASSWORD_EXPIRY'
		put: 16r8
		"The pBuffer parameter contains a pointer to a SecPkgContext_PasswordExpiry structure.

Returns password expiration information.";
		at: 'SECPKG_ATTR_REMOTE_CERT_CONTEXT'
		put: 16r53
		"The pBuffer parameter contains a pointer to a PCCERT_CONTEXT structure.

Finds a certificate context that contains the end certificate supplied by the server.

This attribute is supported only by the Schannel security package.";
		at: 'SECPKG_ATTR_ROOT_STORE'
		put: 16r55
		"The pBuffer parameter contains a pointer to a HCERTCONTEXT. Finds a certificate context that contains a certificate supplied by the Root store.";
		at: 'SECPKG_ATTR_SESSION_INFO'
		put: 16r5D
		"The pBuffer parameter contains a pointer to a SecPkgContext_SessionInfo structure.

Returns information about the session.

Windows Server 2008, Windows Vista, Windows Server 2003, and Windows XP:  This value is not supported.";
		at: 'SECPKG_ATTR_SESSION_KEY'
		put: 16r9
		"The pBuffer parameter contains a pointer to a SecPkgContext_SessionKey structure.

Returns information about the session keys.";
		at: 'SECPKG_ATTR_SIZES'
		put: 16r0
		"The pBuffer parameter contains a pointer to a SecPkgContext_Sizes structure.

Queries the sizes of the structures used in the per-message functions.";
		at: 'SECPKG_ATTR_STREAM_SIZES'
		put: 16r4
		"The pBuffer parameter contains a pointer to a SecPkgContext_StreamSizes structure.

Queries the sizes of the various parts of a stream used in the per-message functions.";
		at: 'SECPKG_ATTR_SUPPORTED_SIGNATURES'
		put: 16r66
		"The pBuffer parameter contains a pointer to a SecPkgContext_SupportedSignatures structure.

This value returns information about the signature types that are supported for the connection.

Windows Server 2008, Windows Vista, Windows Server 2003, and Windows XP:  This value is not supported.";
		at: 'SECPKG_ATTR_TARGET_INFORMATION'
		put: 16r11
		"The pBuffer parameter contains a pointer to a SecPkgContext_TargetInformation structure.

Returns information about the name of the remote server.";
		at: 'SECPKG_ATTR_UNIQUE_BINDINGS'
		put: 16r19
		"The pBuffer parameter contains a pointer to a SecPkgContext_Bindings structure that contains channel binding information.

Windows Server 2008, Windows Vista, Windows Server 2003, and Windows XP:  This value is not supported.";
		at: 'SECPKG_ATTR_APPLICATION_PROTOCOL'
		put: 16r23
		"The pBuffer parameter contains a negotiated application protocol."]

{ #category : #initialization }
Secur32DLL class >> initializeConstants [
	"
	Secur32DLL initializeConstants
	"
	self
		initializeRequestConstants;
		initializeAttributeConstants;
		initializeErrorConstants]

{ #category : #initialization }
Secur32DLL class >> initializeErrorConstants [
	"
	Secur32DLL initializeErrorConstants
	"
	WindowsConstants
		at: 'SEC_E_OK' put: 0;
		at: 'SEC_E_ALGORITHM_MISMATCH' put: -2146893007;
		at: 'SEC_E_DECRYPT_FAILURE' put: -2146893008;
		at: 'SEC_E_ILLEGAL_MESSAGE' put: -2146893018;
		at: 'SEC_E_UNTRUSTED_ROOT' put: -2146893019;
		at: 'SEC_E_INSUFFICIENT_MEMORY' put: -2146893056;
		at: 'SEC_E_INTERNAL_ERROR' put: -2146893052;
		at: 'SEC_E_NO_CREDENTIALS' put: -2146893042;
		at: 'SEC_E_NOT_OWNER' put: -2146893050;
		at: 'SEC_E_SECPKG_NOT_FOUND' put: -2146893051;
		at: 'SEC_E_UNKNOWN_CREDENTIALS' put: -2146893043;
		at: 'SEC_E_CERT_EXPIRED' put: -2146893016;
		at: 'SEC_E_INCOMPLETE_MESSAGE' put: -2146893032;
		at: 'SEC_E_INVALID_HANDLE' put: -2146893055;
		at: 'SEC_E_INVALID_TOKEN' put: -2146893048;
		at: 'SEC_E_LOGON_DENIED' put: -2146893044;
		at: 'SEC_E_NO_AUTHENTICATING_AUTHORITY' put: -2146893039;
		at: 'SEC_E_TARGET_UNKNOWN' put: -2146893053;
		at: 'SEC_E_UNSUPPORTED_FUNCTION' put: -2146893054;
		at: 'SEC_E_UNTRUSTED_ROOT' put: -2146893019;
		at: 'SEC_E_WRONG_PRINCIPAL' put: -2146893022;
		at: 'SEC_E_QOP_NOT_SUPPORTED' put: -2146893046;
		at: 'SEC_I_RENEGOTIATE' put: 590625;
		at: 'SEC_I_COMPLETE_AND_CONTINUE' put: 590612;
		at: 'SEC_I_COMPLETE_NEEDED' put: 590611;
		at: 'SEC_I_CONTINUE_NEEDED' put: 590610;
		at: 'SEC_I_INCOMPLETE_CREDENTIALS' put: 590624]

{ #category : #initialization }
Secur32DLL class >> initializeRequestConstants [
	"
	Secur32DLL initializeRequestConstants
	"
	WindowsConstants
		at: 'ISC_REQ_DELEGATE' put: 16r1;
		at: 'ISC_REQ_MUTUAL_AUTH' put: 16r2;
		at: 'ISC_REQ_REPLAY_DETECT' put: 16r4;
		at: 'ISC_REQ_SEQUENCE_DETECT' put: 16r8;
		at: 'ISC_REQ_CONFIDENTIALITY' put: 16r10;
		at: 'ISC_REQ_USE_SESSION_KEY' put: 16r20;
		at: 'ISC_REQ_PROMPT_FOR_CREDS' put: 16r40;
		at: 'ISC_REQ_USE_SUPPLIED_CREDS' put: 16r80;
		at: 'ISC_REQ_ALLOCATE_MEMORY' put: 16r100;
		at: 'ISC_REQ_USE_DCE_STYLE' put: 16r200;
		at: 'ISC_REQ_DATAGRAM' put: 16r400;
		at: 'ISC_REQ_CONNECTION' put: 16r800;
		at: 'ISC_REQ_CALL_LEVEL' put: 16r1000;
		at: 'ISC_REQ_FRAGMENT_SUPPLIED' put: 16r2000;
		at: 'ISC_REQ_EXTENDED_ERROR' put: 16r4000;
		at: 'ISC_REQ_STREAM' put: 16r8000;
		at: 'ISC_REQ_INTEGRITY' put: 16r10000;
		at: 'ISC_REQ_IDENTIFY' put: 16r20000;
		at: 'ISC_REQ_NULL_SESSION' put: 16r40000;
		at: 'ISC_REQ_MANUAL_CRED_VALIDATION' put: 16r80000;
		at: 'ISC_REQ_RESERVED1' put: 16r100000;
		at: 'ISC_REQ_FRAGMENT_TO_FIT' put: 16r200000;
		at: 'ISC_REQ_HTTP' put: 16r10000000;
		at: 'ASC_REQ_DELEGATE' put: 16r1;
		at: 'ASC_REQ_MUTUAL_AUTH' put: 16r2;
		at: 'ASC_REQ_REPLAY_DETECT' put: 16r4;
		at: 'ASC_REQ_SEQUENCE_DETECT' put: 16r8;
		at: 'ASC_REQ_CONFIDENTIALITY' put: 16r10;
		at: 'ASC_REQ_USE_SESSION_KEY' put: 16r20;
		at: 'ASC_REQ_ALLOCATE_MEMORY' put: 16r100;
		at: 'ASC_REQ_USE_DCE_STYLE' put: 16r200;
		at: 'ASC_REQ_DATAGRAM' put: 16r400;
		at: 'ASC_REQ_CONNECTION' put: 16r800;
		at: 'ASC_REQ_CALL_LEVEL' put: 16r1000;
		at: 'ASC_REQ_EXTENDED_ERROR' put: 16r8000;
		at: 'ASC_REQ_STREAM' put: 16r10000;
		at: 'ASC_REQ_INTEGRITY' put: 16r20000;
		at: 'ASC_REQ_LICENSING' put: 16r40000;
		at: 'ASC_REQ_IDENTIFY' put: 16r80000;
		at: 'ASC_REQ_ALLOW_NULL_SESSION' put: 16r100000;
		at: 'ASC_REQ_ALLOW_NON_USER_LOGONS' put: 16r200000;
		at: 'ASC_REQ_ALLOW_CONTEXT_REPLAY' put: 16r400000;
		at: 'ASC_REQ_FRAGMENT_TO_FIT' put: 16r800000;
		at: 'ASC_REQ_FRAGMENT_SUPPLIED' put: 16r2000;
		at: 'ASC_REQ_NO_TOKEN' put: 16r1000000;
		at: 'ASC_REQ_HTTP' put: 16r10000000]

{ #category : #accessing }
Secur32DLL class >> moduleName [
	^'secur32']

{ #category : #'ffi - certificates' }
Secur32DLL >> AcceptSecurityContextW: phCredential
phContext: context
pInput: aPSecBufferDesc
fContextReq: req
TargetDataRep: zero
phNewContext: aCtxtHandle
pOutput: otherSecBufferDesc
pfContextAttr: attributes
ptsTimeStamp: aFILETIME [
	<long: AcceptSecurityContext>
	^self invalidCall

"
SECURITY_STATUS SEC_Entry AcceptSecurityContext(
  _In_opt_    PCredHandle    phCredential,
  _Inout_opt_ PCtxtHandle    phContext,
  _In_opt_    PSecBufferDesc pInput,
  _In_        ULONG          fContextReq,
  _In_        ULONG          TargetDataRep,
  _Inout_opt_ PCtxtHandle    phNewContext,
  _Inout_opt_ PSecBufferDesc pOutput,
  _Out_       PULONG         pfContextAttr,
  _Out_opt_   PTimeStamp     ptsTimeStamp
);
"]

{ #category : #services }
Secur32DLL >> acquireCredentials [
	| struct credentials |
	struct := SCHANNEL_CRED external forClient.
	struct grbitEnabledProtocols: 0.
	credentials := self
		acquireCredentialsNamed: 'Microsoft Unified Security Protocol Provider'
		data: struct.
	struct free.
	^credentials]

{ #category : #'ffi - certificates' }
Secur32DLL >> AcquireCredentialsHandleW: pszPrincipal
pszPackage: unisp_name
fCredentialUse: flag
pvLogonID: zero1
pAuthData: aSCHANNEL_CRED
pGetKeyFn: zero2
pvGetKeyArgument: zero3
phCredential: aCredHandle
ptsExpiry: aFILETIME [
	<long: AcquireCredentialsHandleW>
	^self invalidCall

"
SECURITY_STATUS SEC_ENTRY AcquireCredentialsHandle(
  _In_opt_   SEC_CHAR       *pszPrincipal,
  _In_       SEC_CHAR       *pszPackage,
  _In_       unsigned long  fCredentialUse,
  _In_opt_   void           *pvLogonID,
  _In_opt_   void           *pAuthData,
  _In_opt_   SEC_GET_KEY_FN pGetKeyFn,
  _Reserved_ void           *pvGetKeyArgument,
  _Out_      PCredHandle    phCredential,
  _Out_opt_  PTimeStamp     ptsExpiry
);
"]

{ #category : #services }
Secur32DLL >> acquireCredentialsNamed: aString [
	| struct credentials |
	struct := SCHANNEL_CRED external.
	credentials := self acquireCredentialsNamed: aString data: struct.
	struct free.
	^credentials]

{ #category : #services }
Secur32DLL >> acquireCredentialsNamed: aString data: aSCHANNEL_CRED [
	| name credentials return |
	name := aString externalCopy.
	credentials := CredHandle external.
	return := self
		AcquireCredentialsHandleW: 0
		pszPackage: name asParameter
		fCredentialUse: SECPKG_CRED_OUTBOUND
		pvLogonID: 0
		pAuthData: aSCHANNEL_CRED asParameter
		pGetKeyFn: 0
		pvGetKeyArgument: 0
		phCredential: credentials asParameter
		ptsExpiry: 0.
	return = SEC_E_OK ifFalse: [self winError].
	name free.
	^credentials]

{ #category : #services }
Secur32DLL >> acquireServerCredentialsNamed: aString data: aSCHANNEL_CRED [
	| name credentials return |
	name := aString externalCopy.
	credentials := CredHandle external.
	return := self
		AcquireCredentialsHandleW: 0
		pszPackage: name asParameter
		fCredentialUse: SECPKG_CRED_INBOUND
		pvLogonID: 0
		pAuthData: aSCHANNEL_CRED asParameter
		pGetKeyFn: 0
		pvGetKeyArgument: 0
		phCredential: credentials asParameter
		ptsExpiry: 0.
	return = SEC_E_OK ifFalse: [self winError].
	name free.
	^credentials]

{ #category : #services }
Secur32DLL >> applyControlToken: aCtxHandle buffer: aBufferDesc [
	| return |
	return := self
		ApplyControlToken: aCtxHandle asParameter
		pInput: aBufferDesc asParameter.
	return = SEC_E_UNSUPPORTED_FUNCTION ifTrue: [^false].
	return = SEC_E_OK ifFalse: [self winError].
	^true]

{ #category : #'ffi - certificates' }
Secur32DLL >> ApplyControlToken: aCtxHandle pInput: aSecBufferDesc [
	<long: ApplyControlToken>
	^self invalidCall

"
SECURITY_STATUS SEC_Entry ApplyControlToken(
	  _In_  PCtxtHandle phContext,
	  _In_  PSecBufferDesc pInput
);
"]

{ #category : #services }
Secur32DLL >> availablePackages [
	"
	Secur32DLL current availablePackages
	"
	| size array return pointer |
	size := ExternalInt32 external.
	pointer := ExternalPointer external.
	return := self
		EnumerateSecurityPackagesW: size asParameter
		ppPackageInfo: pointer asParameter.
	return = SEC_E_OK ifFalse: [self winError].
	array := BufferArray
		at: pointer makeExternalMemory
		count: size makeInteger
		type: SecPkgInfo.
	^array asArray]

{ #category : #'ffi - certificates' }
Secur32DLL >> CompleteAuth: aCtxtHandle token: aSecBufferDesc [
	<long: CompleteAuthToken>
	^self invalidCall

"
SECURITY_STATUS SEC_Entry CompleteAuthToken(
  _In_  PCtxtHandle phContext,
  _In_  PSecBufferDesc pToken
);
"]

{ #category : #services }
Secur32DLL >> completeToken: aSecBufferDesc for: aCtxtHandle [
	^self
		CompleteAuth: aCtxtHandle asParameter
		token: aSecBufferDesc asParameter]

{ #category : #services }
Secur32DLL >> decrypt: aCtxHandle message: aSecBufferDesc [
	| return seq |
	seq := 0 asExternalInt32 externalCopy.
	return := self
		DecryptMessage: aCtxHandle asParameter
		pMessage: aSecBufferDesc asParameter
		MessageSeqNo: seq asParameter
		pfQOP: 0.
	seq free.
	(return = SEC_E_OK or: [return = SEC_E_INCOMPLETE_MESSAGE])
		ifFalse: [self winError].
	^return]

{ #category : #'ffi - certificates' }
Secur32DLL >> DecryptMessage: aCtxtHandle
pMessage: aSecBufferDesc
MessageSeqNo: integer
pfQOP: pointer [
	<long: DecryptMessage>
	^self invalidCall

"
SECURITY_STATUS SEC_Entry DecryptMessage(
  _In_     PCtxtHandle phContext,
  _Inout_  PSecBufferDesc pMessage,
  _In_     ULONG MessageSeqNo,
  _Out_    PULONG pfQOP
);
"]

{ #category : #'ffi - certificates' }
Secur32DLL >> DeleteSecurityContext: phContext [
	<long: DeleteSecurityContext>
	^self invalidCall

"
SECURITY_STATUS SEC_Entry DeleteSecurityContext(
	  _In_  PCtxtHandle phContext
);
"]

{ #category : #services }
Secur32DLL >> encrypt: aCtxHandle message: aSecBufferDesc [
	| return |
	return := self
		EncryptMessage: aCtxHandle asParameter
		fQOP: 0
		pMessage: aSecBufferDesc asParameter
		MessageSeqNo: 0.
	return = SEC_E_OK ifFalse: [self winError].
	^return]

{ #category : #'ffi - certificates' }
Secur32DLL >> EncryptMessage: aCtxtHandle
fQOP: pointer
pMessage: aSecBufferDesc
MessageSeqNo: integer [
	<long: EncryptMessage>
	^self invalidCall

"
SECURITY_STATUS SEC_Entry EncryptMessage(
  _In_     PCtxtHandle phContext,
  _In_     ULONG fQOP,
  _Inout_  PSecBufferDesc pMessage,
  _In_     ULONG MessageSeqNo
);
"]

{ #category : #'ffi - certificates' }
Secur32DLL >> EnumerateSecurityPackagesW: pcPackages ppPackageInfo: aPSecPkgInfo [
	<long: EnumerateSecurityPackagesW>
	self invalidCall

"
SECURITY_STATUS SEC_Entry EnumerateSecurityPackages(
	_In_  PULONG pcPackages,
	_In_  PSecPkgInfo *ppPackageInfo
);
"]

{ #category : #'ffi - certificates' }
Secur32DLL >> FreeContextBuffer: pvContextBuffer [
	<long: FreeContextBuffer>
	^self invalidCall

"
SECURITY_STATUS SEC_Entry FreeContextBuffer(
	_In_  PVOID pvContextBuffer
);
"]

{ #category : #'ffi - certificates' }
Secur32DLL >> FreeCredentialsHandle: phCredential [
	<long: FreeCredentialsHandle>
	^self invalidCall

"
SECURITY_STATUS SEC_Entry FreeCredentialsHandle(
  _In_ PCredHandle phCredential
);
"]

{ #category : #'ffi - certificates' }
Secur32DLL >> InitializeSecurityContextW: phCredential
phContext: context
pszTargetName: aString
fContextReq: req
Reserved1: zero1
TargetDataRep: zero
pInput: aSecBufferDesc
Reserved2: zero2
phNewContext: aCtxtHandle
pOutput: otherSecBufferDesc
pfContextAttr: attributes
ptsExpiry: aFILETIME [
	<long: InitializeSecurityContextW>
	^self invalidCall

"
SECURITY_STATUS SEC_ENTRY InitializeSecurityContext(
  _In_opt_    PCredHandle    phCredential,
  _In_opt_    PCtxtHandle    phContext,
  _In_opt_    SEC_CHAR       *pszTargetName,
  _In_        unsigned long  fContextReq,
  _Reserved_  unsigned long  Reserved1,
  _In_        unsigned long  TargetDataRep,
  _Inout_opt_ PSecBufferDesc pInput,
  _In_        unsigned long  Reserved2,
  _Inout_opt_ PCtxtHandle    phNewContext,
  _Out_opt_   PSecBufferDesc pOutput,
  _Out_       unsigned long  *pfContextAttr,
  _Out_opt_   PTimeStamp     ptsExpiry
);
);
"]

{ #category : #'ffi - certificates' }
Secur32DLL >> QueryContextAttributes: phContext ulAttribute: attribute pBuffer: buffer [
	<ulong: QueryContextAttributesW>
	self invalidCall

"
SECURITY_STATUS SEC_Entry QueryContextAttributes( 
	_In_   PCtxtHandle phContext,
	_In_   ULONG ulAttribute,
	_Out_  PVOID pBuffer
);
"]

{ #category : #'ffi - certificates' }
Secur32DLL >> QueryCredentialsAttributes: pCredHandle ulAttribute: attribute pBuffer: buffer [
	<long: QueryCredentialsAttributesW>
	self invalidCall

"
SECURITY_STATUS SEC_Entry QueryCredentialsAttributes(
	_In_   PCredHandle phCredential, 
	_In_   ULONG ulAttribute,
	_Out_  PVOID pBuffer
);
"]

{ #category : #'ffi - certificates' }
Secur32DLL >> QuerySecurityPackageInfo: pszPackageName info: ppPackageInfo [
	<long: QuerySecurityPackageInfoW>
	self invalidCall

"
SECURITY_STATUS SEC_Entry QuerySecurityPackageInfo(
	_In_   SEC_CHAR *pszPackageName, 
	_Out_  PSecPkgInfo *ppPackageInfo
);
"]

