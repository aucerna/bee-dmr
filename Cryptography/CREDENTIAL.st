"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CREDENTIAL,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #Cryptography
}

{ #category : #private }
CREDENTIAL class >> def [
	^<def>
	typedef struct _CREDENTIALW {
		DWORD Flags;
		DWORD Type;
		LPWSTR TargetName;
		LPWSTR Comment;
		FILETIME LastWritten;
		DWORD CredentialBlobSize;
		LPBYTE CredentialBlob;
		DWORD Persist;
		DWORD AttributeCount;
		PCREDENTIAL_ATTRIBUTEW Attributes;
		LPWSTR TargetAlias;
		LPWSTR UserName;
	} CREDENTIALW, *PCREDENTIALW;
	</def>]

{ #category : #'instance creation' }
CREDENTIAL class >> generic [
	^self new beGeneric]

{ #category : #initialization }
CREDENTIAL class >> initializeConstants [
	self
		initializeFlags;
		initializeTypeConstants;
		initializeTypeConstants2;
		initializePersistConstants;
		initializeErrorConstants.
	WindowsConstants at: 'CRED_MAX_USERNAME_LENGTH' put: 513]

{ #category : #initialization }
CREDENTIAL class >> initializeErrorConstants [
	WindowsConstants
		at: 'ERROR_NOT_FOUND'
		put: 1168 "No credential exists with the specified TargetName.";
		at: 'ERROR_NO_SUCH_LOGON_SESSION'
		put: 1312 "The logon session does not exist or there is no credential set associated with this logon session. Network logon sessions do not have an associated credential set.";
		at: 'ERROR_INVALID_FLAGS'
		put: 1004 "A flag that is not valid was specified for the Flags parameter"]

{ #category : #initialization }
CREDENTIAL class >> initializeFlags [
	WindowsConstants
		at: 'CRED_FLAGS_PROMPT_NOW'
		put: 2 "Bit set if the credential does not persist the CredentialBlob and the credential has not been written during this logon session. This bit is ignored on input and is set automatically when queried.

If Type is CRED_TYPE_DOMAIN_CERTIFICATE, the CredentialBlob is not persisted across logon sessions because the PIN of a certificate is very sensitive information. Indeed, when the credential is written to credential manager, the PIN is passed to the CSP associated with the certificate. The CSP will enforce a PIN retention policy appropriate to the certificate.

If Type is CRED_TYPE_DOMAIN_PASSWORD or CRED_TYPE_DOMAIN_CERTIFICATE, an authentication package always fails an authentication attempt when using credentials marked as CRED_FLAGS_PROMPT_NOW. The application (typically through the key ring UI) prompts the user for the password. The application saves the credential and retries the authentication. Because the credential has been recently written, the authentication package now gets a credential that is not marked as CRED_FLAGS_PROMPT_NOW.";
		at: 'CRED_FLAGS_USERNAME_TARGET'
		put: 4 "Bit is set if this credential has a TargetName member set to the same value as the UserName member. Such a credential is one designed to store the CredentialBlob for a specific user. For more information, see the CredMarshalCredential function.

This bit can only be specified if Type is CRED_TYPE_DOMAIN_PASSWORD or CRED_TYPE_DOMAIN_CERTIFICATE."]

{ #category : #initialization }
CREDENTIAL class >> initializePersistConstants [
	WindowsConstants
		at: 'CRED_PERSIST_SESSION'
		put: 1 "The credential persists for the life of the logon session. It will not be visible to other logon sessions of this same user. It will not exist after this user logs off and back on.";
		at: 'CRED_PERSIST_LOCAL_MACHINE'
		put: 2 "The credential persists for all subsequent logon sessions on this same computer. It is visible to other logon sessions of this same user on this same computer and not visible to logon sessions for this user on other computers.

Windows Vista Home Basic, Windows Vista Home Premium, Windows Vista Starter and Windows XP Home Edition:  This value is not supported.";
		at: 'CRED_PERSIST_ENTERPRISE'
		put: 3 "The credential persists for all subsequent logon sessions on this same computer. It is visible to other logon sessions of this same user on this same computer and to logon sessions for this user on other computers.

This option can be implemented as locally persisted credential if the administrator or user configures the user account to not have roam-able state. For instance, if the user has no roaming profile, the credential will only persist locally.

Windows Vista Home Basic, Windows Vista Home Premium, Windows Vista Starter and Windows XP Home Edition:  This value is not supported."]

{ #category : #initialization }
CREDENTIAL class >> initializeTypeConstants [
	WindowsConstants
		at: 'CRED_TYPE_GENERIC'
		put: 1 "The credential is a generic credential. The credential will not be used by any particular authentication package. The credential will be stored securely but has no other significant characteristics.";
		at: 'CRED_TYPE_DOMAIN_PASSWORD'
		put: 2 "The credential is a password credential and is specific to Microsoft's authentication packages. The NTLM, Kerberos, and Negotiate authentication packages will automatically use this credential when connecting to the named target.";
		at: 'CRED_TYPE_DOMAIN_CERTIFICATE'
		put: 3 "The credential is a certificate credential and is specific to Microsoft's authentication packages. The Kerberos, Negotiate, and Schannel authentication packages automatically use this credential when connecting to the named target.";
		at: 'CRED_TYPE_DOMAIN_VISIBLE_PASSWORD'
		put: 4 "This value is no longer supported.

Windows Server 2003 and Windows XP:  The credential is a password credential and is specific to authentication packages from Microsoft. The Passport authentication package will automatically use this credential when connecting to the named target.

Additional values will be defined in the future. Applications should be written to allow for credential types they do not understand.";
		at: 'CRED_TYPE_GENERIC_CERTIFICATE'
		put: 5 "The credential is a certificate credential that is a generic authentication package.

Windows Server 2008, Windows Vista, Windows Server 2003 and Windows XP:  This value is not supported.";
		at: 'CRED_TYPE_DOMAIN_EXTENDED'
		put: 6 "The credential is supported by extended Negotiate packages.

Windows Server 2008, Windows Vista, Windows Server 2003 and Windows XP:  This value is not supported.";
		at: 'CRED_TYPE_MAXIMUM'
		put: 7 "The maximum number of supported credential types.

Windows Server 2008, Windows Vista, Windows Server 2003 and Windows XP:  This value is not supported."]

{ #category : #initialization }
CREDENTIAL class >> initializeTypeConstants2 [
	WindowsConstants
		at: 'CRED_TYPE_MAXIMUM_EX'
		put: CRED_TYPE_MAXIMUM
			+ 1000 "The extended maximum number of supported credential types that now allow new applications to run on older operating systems.

Windows Server 2008, Windows Vista, Windows Server 2003 and Windows XP:  This value is not supported."]

{ #category : #private }
CREDENTIAL class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 80;
		at: 'Flags' put: 0;
		at: 'Type' put: 4;
		at: 'TargetName' put: 8;
		at: 'Comment' put: 16;
		at: 'LastWritten' put: 24;
		at: 'CredentialBlobSize' put: 32;
		at: 'CredentialBlob' put: 40;
		at: 'Persist' put: 48;
		at: 'AttributeCount' put: 52;
		at: 'Attributes' put: 56;
		at: 'TargetAlias' put: 64;
		at: 'UserName' put: 72;
		yourself]

{ #category : #accessing }
CREDENTIAL class >> sizeInBytes [
	^sizeInBytes]

{ #category : #private }
CREDENTIAL class >> typedefTable [
	^Advapi32DLL typedefTable]

{ #category : #accessing }
CREDENTIAL >> AttributeCount [
	^self uLongAtOffset: AttributeCount]

{ #category : #accessing }
CREDENTIAL >> AttributeCount: anInteger [
	self uLongAtOffset: AttributeCount put: anInteger]

{ #category : #accessing }
CREDENTIAL >> Attributes [
	^self pointerAtOffset: Attributes]

{ #category : #accessing }
CREDENTIAL >> Attributes: anInteger [
	self pointerAtOffset: Attributes put: anInteger]

{ #category : #input }
CREDENTIAL >> beGeneric [
	self Type: CRED_TYPE_GENERIC]

{ #category : #finalization }
CREDENTIAL >> clear [
	"
	self CredentialBlob clear: self CredentialBlobSize.
	"
	| blob |
	blob := self CredentialBlob.
	blob isValid ifTrue: [blob clear: self CredentialBlobSize]]

{ #category : #accessing }
CREDENTIAL >> Comment [
	^self addressAtOffset: Comment]

{ #category : #accessing }
CREDENTIAL >> Comment: anInteger [
	self addressAtOffset: Comment register: anInteger]

{ #category : #accessing }
CREDENTIAL >> CredentialBlob [
	^self addressAtOffset: CredentialBlob]

{ #category : #accessing }
CREDENTIAL >> CredentialBlob: anExternalMemory [
	self addressAtOffset: CredentialBlob register: anExternalMemory]

{ #category : #accessing }
CREDENTIAL >> CredentialBlobSize [
	^self uLongAtOffset: CredentialBlobSize]

{ #category : #accessing }
CREDENTIAL >> CredentialBlobSize: anInteger [
	self uLongAtOffset: CredentialBlobSize put: anInteger]

{ #category : #output }
CREDENTIAL >> credentials [
	^UserCredentials new username: self username; password: self password]

{ #category : #finalization }
CREDENTIAL >> credFree [
	Advapi32DLL current CredFree: contents asParameter]

{ #category : #input }
CREDENTIAL >> expireWithSession [
	self Persist: CRED_PERSIST_SESSION]

{ #category : #accessing }
CREDENTIAL >> Flags [
	^self uLongAtOffset: Flags]

{ #category : #accessing }
CREDENTIAL >> Flags: anInteger [
	self uLongAtOffset: Flags put: anInteger]

{ #category : #finalization }
CREDENTIAL >> free [
	self clear.
	super free]

{ #category : #initialization }
CREDENTIAL >> initialize: anInteger [
	super initialize: anInteger.
	self beGeneric; persistGlobally]

{ #category : #accessing }
CREDENTIAL >> LastWritten [
	^self structureAtOffset: LastWritten ofClass: FILETIME]

{ #category : #accessing }
CREDENTIAL >> LastWritten: aFILETIME [
	self bytesAtOffset: LastWritten put: aFILETIME asParameter]

{ #category : #output }
CREDENTIAL >> password [
	^self CredentialBlob isValid
		ifTrue: [Password at: self CredentialBlob length: self CredentialBlobSize]]

{ #category : #input }
CREDENTIAL >> password: aString [
	| memory |
	memory := aString externalCopy.
	self
		CredentialBlobSize: memory length - 2;
		CredentialBlob: memory]

{ #category : #accessing }
CREDENTIAL >> Persist [
	^self uLongAtOffset: Persist]

{ #category : #accessing }
CREDENTIAL >> Persist: anInteger [
	self uLongAtOffset: Persist put: anInteger]

{ #category : #input }
CREDENTIAL >> persistent: aBoolean [
	aBoolean ifTrue: [self persistGlobally] ifFalse: [self expireWithSession]]

{ #category : #input }
CREDENTIAL >> persistGlobally [
	self Persist: CRED_PERSIST_ENTERPRISE]

{ #category : #input }
CREDENTIAL >> persistLocally [
	self Persist: CRED_PERSIST_LOCAL_MACHINE]

{ #category : #accessing }
CREDENTIAL >> TargetAlias [
	^self addressAtOffset: TargetAlias]

{ #category : #accessing }
CREDENTIAL >> TargetAlias: anInteger [
	self addressAtOffset: TargetAlias register: anInteger]

{ #category : #accessing }
CREDENTIAL >> TargetName [
	^self addressAtOffset: TargetName]

{ #category : #output }
CREDENTIAL >> targetName [
	| memory |
	memory := self TargetName.
	^memory isValid ifTrue: [WideString fromMemory: memory]]

{ #category : #accessing }
CREDENTIAL >> TargetName: anInteger [
	self addressAtOffset: TargetName register: anInteger]

{ #category : #input }
CREDENTIAL >> targetName: aString [
	self TargetName: aString externalCopy]

{ #category : #accessing }
CREDENTIAL >> Type [
	^self uLongAtOffset: Type]

{ #category : #accessing }
CREDENTIAL >> Type: anInteger [
	self uLongAtOffset: Type put: anInteger]

{ #category : #accessing }
CREDENTIAL >> UserName [
	^self addressAtOffset: UserName]

{ #category : #output }
CREDENTIAL >> username [
	| memory |
	memory := self UserName.
	^memory isValid
		ifTrue: [UTF16 decodeFromAddress: memory length: CRED_MAX_USERNAME_LENGTH]]

{ #category : #input }
CREDENTIAL >> username: aString [
	| memory |
	memory := aString externalCopy.
	self UserName: memory]

{ #category : #accessing }
CREDENTIAL >> UserName: anInteger [
	self addressAtOffset: UserName register: anInteger]

