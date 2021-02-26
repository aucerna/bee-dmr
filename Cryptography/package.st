"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Package { 
	#name : #Cryptography,
	#requires : [
		'Kernel',
		'SUnit',
		'Validations',
		'Windows Registry'
	]
	#classes : [
		'BCRYPT_KEY_DATA_BLOB_HEADER',
		'BcryptDLL',
		'CERT_CONTEXT',
		'CERT_EXTENSION',
		'CERT_INFO',
		'CERT_NAME_BLOB',
		'CERT_PUBLIC_KEY_INFO',
		'CNG',
		'CREDENTIAL',
		'CredentialEntangler',
		'CredentialVault',
		'CRYPT_ALGORITHM_IDENTIFIER',
		'CRYPT_BIT_BLOB',
		'CRYPT_INTEGER_BLOB',
		'CRYPT_OBJID_BLOB',
		'Crypt32DLL',
		'CRYPTOAPI_BLOB',
		'HMAC',
		'MD5',
		'MDHash',
		'Password',
		'QuotedPrintableDecoder',
		'QuotedPrintableEncoder',
		'QuotedPrintableValidator',
		'SHA',
		'SHA1',
		'SHA256',
		'ThirtyTwoBitRegister',
		'UserCredentials'
	]
}

