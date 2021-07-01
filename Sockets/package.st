"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Package { 
	#name : #sockets,
	#requires : [
		'Cryptography',
		'Kernel',
		'SUnit',
		'Utilities'
	],
	#classes : [
		'ADDRINFOW',
		'CredHandle',
		'Crypt32Test',
		'CtxtHandle',
		'fd_set',
		'in_addr',
		'IN6_ADDR',
		'LoggedSocket',
		'MockSocketStream',
		'SCHANNEL_CRED',
		'SCOPE_ID',
		'SecBuffer',
		'SecBufferDesc',
		'SecHandle',
		'SecPkgContext_ConnectionInfo',
		'SecPkgContext_StreamSizes',
		'SecPkgCred_CipherStrengths',
		'SecPkgCredentials_Names',
		'SecPkgInfo',
		'Secur32DLL',
		'SecureServer',
		'SOCKADDR',
		'SOCKADDR_IN',
		'SOCKADDR_IN6',
		'Socket',
		'SocketDaemon',
		'SocketError',
		'SocketEvent',
		'SocketReadStream',
		'SocketService',
		'SocketStructure',
		'SocketTest',
		'SocketWriteStream',
		'SSL',
		'SSLTest',
		'timeval',
		'Ws2_32DLL',
		'WSADATA'
	]
}

