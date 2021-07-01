"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Package { 
	#name : #'Cryptography\Tests',
	#requires : [
		'Cryptography',
		'Kernel',
		'SUnit'
	],
	#classes : [
		'Base64EncodingTest',
		'BcryptDLLTest',
		'HMACTest',
		'MD5Test',
		'PasswordTest',
		'QuotedPrintableTest',
		'SHA1Test',
		'SHA256Test'
	]
}

