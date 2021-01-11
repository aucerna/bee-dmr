"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Package { 
	#name : #'HTTP\Client',
	#requires : [
		'Cryptography',
		'HTTP',
		'Kernel'
	]
	#classes : [
		'DirectHttpClient',
		'FTPConnection',
		'HTTP_REQUEST_TOKEN',
		'HttpClient',
		'HttpClientConfiguration',
		'HttpClientError',
		'HTTPConnection',
		'HttpConnectionError',
		'HTTPRequest',
		'HttpRequestCancelled',
		'HttpRequestError',
		'HttpRequestFailed',
		'HttpRequestTimeout',
		'HttpResponseError',
		'HTTPSConnection',
		'HTTPSRequest',
		'INTERNET_ASYNC_RESULT',
		'INTERNET_BUFFERS',
		'INTERNET_CERTIFICATE_INFO',
		'InternetConnection',
		'InternetFile',
		'InternetFileFinder',
		'InternetSession',
		'InternetSessionObject',
		'UnexpectedInternetData',
		'URL_COMPONENTS',
		'WebServiceClient',
		'Win32InternetObject',
		'WininetDLL',
		'WinInetError'
	]
}

