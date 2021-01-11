"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Package { 
	#name : #HTTP,
	#requires : [
		'Cryptography',
		'GUIbase',
		'Kernel',
		'PetitParser\Parsers',
		'PetitParser\Tools',
		'Sockets'
	]
	#classes : [
		'HttpBasicAuthenticator',
		'HttpConfiguration',
		'HttpConnection',
		'HttpCookie',
		'HttpHeaders',
		'HttpMessage',
		'HttpOIDCAuthenticator',
		'HttpRequest',
		'HttpRequestAuthenticator',
		'HttpResponse',
		'MediaType',
		'MediaTypeGrammar',
		'MediaTypeParser',
		'PercentEncoder',
		'URL',
		'URLGrammar',
		'URLParser'
	]
}

