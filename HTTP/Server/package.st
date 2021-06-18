"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Package { 
	#name : #'HTTP\Server',
	#requires : [
		'HTTP',
		'Kernel',
		'Sockets'
	]
	#classes : [
		'BeeHttpServer',
		'CustomLogging',
		'HTTP_BANDWIDTH_LIMIT_INFO',
		'HTTP_BINDING_INFO',
		'HTTP_BYTE_RANGE',
		'HTTP_CACHE_POLICY',
		'HTTP_CONNECTION_LIMIT_INFO',
		'HTTP_COOKED_URL',
		'HTTP_DATA_CHUNK',
		'HTTP_FLOWRATE_INFO',
		'HTTP_KNOWN_HEADER',
		'HTTP_LOG_DATA',
		'HTTP_LOG_FIELDS_DATA',
		'HTTP_LOGGING_INFO',
		'HTTP_PROPERTY_FLAGS',
		'HTTP_QOS_SETTING_INFO',
		'HTTP_REQUEST_AUTH_INFO',
		'HTTP_REQUEST_HEADERS',
		'HTTP_REQUEST_INFO',
		'HTTP_REQUEST_V1',
		'HTTP_REQUEST_V2',
		'HTTP_RESPONSE_HEADERS',
		'HTTP_RESPONSE_INFO',
		'HTTP_RESPONSE_V1',
		'HTTP_RESPONSE_V2',
		'HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS',
		'HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS',
		'HTTP_SERVER_AUTHENTICATION_INFO',
		'HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM',
		'HTTP_SERVICE_CONFIG_SSL_KEY',
		'HTTP_SERVICE_CONFIG_SSL_PARAM',
		'HTTP_SERVICE_CONFIG_SSL_SET',
		'HTTP_SERVICE_CONFIG_SSL_SNI_KEY',
		'HTTP_SERVICE_CONFIG_SSL_SNI_SET',
		'HTTP_SERVICE_CONFIG_TIMEOUT_SET',
		'HTTP_SERVICE_CONFIG_URLACL_KEY',
		'HTTP_SERVICE_CONFIG_URLACL_PARAM',
		'HTTP_SERVICE_CONFIG_URLACL_SET',
		'HTTP_SSL_CLIENT_CERT_INFO',
		'HTTP_SSL_INFO',
		'HTTP_STATE_INFO',
		'HTTP_TIMEOUT_LIMIT_INFO',
		'HTTP_TRANSPORT_ADDRESS',
		'HTTP_UNKNOWN_HEADER',
		'HTTP_VERSION',
		'HTTPAPI_VERSION',
		'HttpApiDLL',
		'HttpApiStructure',
		'HttpController',
		'HttpCreator',
		'HttpHeadersStructure',
		'HttpRequestQueue',
		'HttpRequestStructure',
		'HttpResponseStructure',
		'HttpServer',
		'HttpServerLogging',
		'HttpServerSession',
		'HttpVersion',
		'HttpWorker',
		'IISLogging',
		'NCSALogging',
		'Netapi32DLL',
		'RawLogging',
		'SOCKADDR_STORAGE',
		'UrlGroup',
		'W3CLogging',
		'WebServer'
	]
}
