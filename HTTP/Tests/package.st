"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Package { 
	#name : #'HTTP\Tests',
	#requires : [
		'Cryptography',
		'HTML',
		'HTTP',
		'HTTP\Client',
		'HTTP\Server',
		'JSON',
		'Kernel',
		'SUnit'
	],
	#classes : [
		'HttpClientTest',
		'HttpConfigurationTest',
		'HttpMessageTest',
		'MediaTypeParserTest',
		'URLTest'
	]
}

