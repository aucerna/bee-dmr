"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SocketTest,
	#superclass : #TestCase,
	#category : #sockets
}

{ #category : #sockets }
SocketTest >> return: anInteger [
	anInteger = SOCKET_ERROR
		ifTrue: [SocketError signalOSCode: Ws2_32DLL current getLastError].
	^anInteger]

{ #category : #'remote messaging' }
SocketTest >> testAbruptClose [
	| deamon client server |
	deamon := Socket newDaemon port: 0.
	[
		deamon open; bind; listen.
		client := Socket open: '::1' port: deamon port.
		client nonBlocking; connect.
		server := deamon accept.
		server close.
		Smalltalk processAllMessages.
		self deny: client isConnected; deny: client isOpen]
		ensure: [
			deamon close.
			server close.
			client close]]

{ #category : #marshalling }
SocketTest >> testAddressToString [
	| hints result return first memory |
	hints := ADDRINFOW new
		ai_family: AF_INET6;
		ai_socktype: SOCK_STREAM;
		ai_flags: AI_PASSIVE.
	result := ExternalPointer new externalCopy.
	return := Ws2_32DLL current
		GetAddrInfoW: 'localhost' externalCopy asParameter
		pServiceName: 0
		pHints: hints externalCopy asParameter
		ppResult: result asParameter.
	self precondition: return = 0.
	memory := ExternalMemory at: result asInteger.
	first := ADDRINFOW fromMemory: memory.
	self assert: first ip notEmpty]

{ #category : #marshalling }
SocketTest >> testAddressToString2 [
	| hints result return first memory |
	hints := ADDRINFOW new
		ai_family: AF_UNSPEC;
		ai_socktype: SOCK_STREAM;
		ai_flags: AI_PASSIVE.
	result := ExternalPointer new externalCopy.
	return := Ws2_32DLL current
		GetAddrInfoW: 'www.petrovr.com' externalCopy asParameter
		pServiceName: 'http' externalCopy asParameter
		pHints: hints externalCopy asParameter
		ppResult: result asParameter.
	self assert: return = 0.
	memory := ExternalMemory at: result asInteger.
	first := ADDRINFOW fromMemory: memory.
	self assert: (first ip endsWith: ':80')]

{ #category : #sockets }
SocketTest >> testBind [
	| info descriptor sockaddr |
	info := ADDRINFOW forHost: (SOCKADDR resolveIP: '::1').
	descriptor := Ws2_32DLL current
		socket: info ai_family
		type: info ai_socktype
		protocol: info ai_protocol.
	sockaddr := info sockaddr.
	sockaddr port: 6048.
	[
		self
			shouldnt: [| return |
				return := Ws2_32DLL current
					bind: descriptor
					name: sockaddr externalCopy asParameter
					namelen: sockaddr sizeInBytes.
				self return: return]
			raise: SocketError]
		ensure: [Ws2_32DLL current closesocket: descriptor]]

{ #category : #sockets }
SocketTest >> testBlockingSocket [
	| control client server |
	control := Socket open: '::1' port: 16rA009.
	[
		control beBlocking; bind; listen.
		client := Socket open: '::1' port: 16rA009.
		client beBlocking; connect.
		server := control accept.
		client write: 'Bee Smalltalk'.
		self
			assert: server bytesToRead = 'Bee Smalltalk' size;
			assert: server read = 'Bee Smalltalk']
		ensure: [
			client notNil ifTrue: [client close].
			server notNil ifTrue: [server close].
			control close]]

{ #category : #'byte sex' }
SocketTest >> testByteSex [
	| dll net |
	dll := Ws2_32DLL current.
	net := SOCKADDR fromIP: '127.0.0.1'.
	self
		assert: (dll ntohl: net sin_addr asParameter) hex = '7F000001';
		assert: net ip = '127.0.0.1']

{ #category : #queries }
SocketTest >> testGetaddrinfo [
	| hints result return memory first |
	hints := ADDRINFOW new ai_socktype: SOCK_STREAM; ai_flags: AI_PASSIVE.
	result := ExternalInt32 new externalCopy.
	return := Ws2_32DLL current
		GetAddrInfoW: 'localhost' externalCopy asParameter
		pServiceName: nil
		pHints: hints externalCopy asParameter
		ppResult: result asParameter.
	self assert: return = 0.
	memory := ExternalMemory at: result asInteger.
	first := ADDRINFOW fromMemory: memory.
	self
		assert: first list size > 1;
		assert: first ai_socktype = SOCK_STREAM;
		assert: (first list anySatisfy: [:ai | ai ai_family = AF_INET6]).
	hints := ADDRINFOW new
		ai_family: AF_INET;
		ai_socktype: SOCK_STREAM;
		ai_flags: AI_PASSIVE.
	result := ExternalPointer new externalCopy.
	return := Ws2_32DLL current
		GetAddrInfoW: 'localhost' externalCopy asParameter
		pServiceName: 0
		pHints: hints externalCopy asParameter
		ppResult: result asParameter.
	self assert: return = 0.
	memory := ExternalMemory at: result asInteger.
	first := ADDRINFOW fromMemory: memory.
	self
		assert: first list size = 1;
		assert: first ai_family = AF_INET]

{ #category : #queries }
SocketTest >> testGetaddrinfo2 [
	| hints result name return memory first |
	hints := ADDRINFOW external
		ai_family: AF_INET6;
		ai_socktype: SOCK_STREAM;
		ai_flags: AI_PASSIVE.
	result := ExternalPointer external.
	name := '3490' externalCopy.
	return := Ws2_32DLL current
		GetAddrInfoW: '::1' externalCopy asParameter
		pServiceName: name asParameter
		pHints: hints asParameter
		ppResult: result asParameter.
	self assert: return = 0.
	memory := result makeAddress.
	hints free.
	name free.
	first := ADDRINFOW fromMemory: memory.
	self assert: first sockaddr sin6_port = 3490]

{ #category : #sockets }
SocketTest >> testGetsockname [
	| info descriptor sockaddr |
	info := ADDRINFOW forHost: (SOCKADDR resolveIP: '::1').
	descriptor := Ws2_32DLL current
		socket: info ai_family
		type: info ai_socktype
		protocol: info ai_protocol.
	sockaddr := info sockaddr.
	sockaddr port: 6048.
	[| return length copy |
		self
			shouldnt: [
				return := Ws2_32DLL current
					bind: descriptor
					name: sockaddr externalCopy asParameter
					namelen: sockaddr sizeInBytes.
				self return: return]
			raise: SocketError;
			shouldnt: [
				length := sockaddr sizeInBytes asExternalInt32 externalCopy.
				copy := sockaddr externalCopy.
				return := Ws2_32DLL current
					getsockname: descriptor
					name: copy asParameter
					namelen: length asParameter.
				self return: return]
			raise: SocketError;
			assert: length asInteger <= sockaddr sizeInBytes;
			assert: copy ip = sockaddr ip]
		ensure: [Ws2_32DLL current closesocket: descriptor]]

{ #category : #sockets }
SocketTest >> testGmail [
	| socket |
	socket := Socket open: 'pop.gmail.com' port: 995.
	[self assert: socket connect] ensure: [socket close]]

{ #category : #streams }
SocketTest >> testSecureSocketStreams [
	| server stream cert socket |
	cert := Crypt32DLL current getCertificateFor: 'server example'.
	'\\gauss\Tools\Certificates\certificado server example (cachavacha).pfx' asFilename.
	self precondition: cert notNil.
	true ifTrue: [^self].
	[| message |
		server := SecureServer open start.
		socket := Socket open: 'localhost' port: server port.
		socket binary: true; connect; sslConnectTo: 'server example'.
		stream := server connections anyone.
		self assert: stream notNil.
		message := 'Hello from secure socket stream client'.
		socket writeStream nextPutAll: message; flush.
		self assert: stream nextAvailable = message]
		ensure: [
			server close.
			socket close]]

{ #category : #'remote messaging' }
SocketTest >> testServerAccept [
	| control client server |
	control := Socket newDaemon port: 0.
	[
		control open; bind; listen.
		client := Socket open: '::1' port: control port.
		client connect.
		server := control accept]
		ensure: [
			control close.
			server close.
			client close]]

{ #category : #queries }
SocketTest >> testServiceResolution [
	| info service |
	info := ADDRINFOW forHost: 'localhost'.
	service := SOCKADDR resolveService: info ipString , ':21'.
	self assert: service = 'ftp'.
	service := SOCKADDR resolveService: '127.0.0.1:80'.
	self assert: service = 'http']

{ #category : #sockets }
SocketTest >> testSocket [
	| addrinfo descriptor |
	addrinfo := ADDRINFOW forHost: (SOCKADDR resolveIP: '::1').
	descriptor := Ws2_32DLL current
		socket: addrinfo ai_family
		type: addrinfo ai_socktype
		protocol: addrinfo ai_protocol.
	self assert: descriptor > 0.
	Ws2_32DLL current closesocket: descriptor]

{ #category : #sockets }
SocketTest >> testSocket2 [
	| socket |
	socket := Socket open: 'mail.dm.uba.ar' port: 995.
	[| success peer |
		success := socket connect.
		self assert: success.
		peer := socket peerName.
		self assert: peer notEmpty]
		ensure: [socket close]]

{ #category : #streams }
SocketTest >> testSocketStreams [
	| control server client reader |
	control := Socket newDaemon port: 0.
	[| ok writer |
		ok := false.
		control
			open;
			bind;
			listen;
			nonBlocking;
			when: #readyToAccept do: [
				ok := true.
				server := control accept.
				writer := SocketWriteStream on: server.
				writer nextPutAll: 'Smalltalk'].
		client := Socket open: '::1' port: control port.
		client nonBlocking.
		reader := SocketReadStream on: client.
		client connect.
		Delay wait: 100.
		Smalltalk processAllMessages.
		self assert: ok; assert: reader hasPendingData]
		ensure: [
			reader close.
			control close].
	Smalltalk processAllMessages.
	self
		assert: server asParameter isNil;
		deny: reader isConnected;
		assert: SocketEvent registeredSockets isEmpty]

{ #category : #streams }
SocketTest >> testSocketStreams3 [
	| data control server client reader |
	self precondition: SocketEvent registeredSockets isEmpty.
	data := ByteArray new: 8192 * 99 + 8192.
	1 to: data size // 8192 do: [:i | data at: 8192 * i put: i \\ 256].
	control := Socket open: '::1' port: 0.
	[| ok |
		ok := false.
		control beDaemon
			bind;
			listen;
			nonBlocking;
			when: #readyToAccept do: [| writer |
				ok := true.
				server := control accept.
				writer := SocketWriteStream on: server.
				writer nextPutAll: data].
		client := Socket open: '::1' port: control port.
		client binary: true; nonBlocking.
		reader := SocketReadStream on: client.
		client connect.
		Delay wait: 100.
		Smalltalk processAllMessages.
		self
			assert: ok;
			assert: reader hasPendingData;
			assert: ((reader peek: data size) copyWithout: 0) = (data copyWithout: 0)]
		ensure: [
			reader close.
			control close].
	Smalltalk processAllMessages.
	self
		assert: server asParameter isNil;
		deny: reader isConnected;
		assert: SocketEvent registeredSockets isEmpty]

{ #category : #streams }
SocketTest >> testSocketStreamsTimeout [
	| control server client reader s |
	#testTP57513.
	control := Socket newDaemon port: 0.
	s := Semaphore new.
	[| writer answer timeout |
		control
			open;
			bind;
			listen;
			nonBlocking;
			when: #readyToAccept do: [
				server := control accept.
				s signal].
		client := Socket open: '::1' port: control port.
		reader := SocketReadStream on: client.
		timeout := 100 milliseconds.
		reader timeout: timeout.
		client connect.
		s wait.
		[
			writer := SocketWriteStream on: server.
			writer nextPutAll: 'A'.
			Delay wait: timeout - 50 milliseconds.
			writer nextPutAll: 'B'] fork.
		self shouldnt: [answer := reader next: 2] raise: Timeout.
		self assert: answer = 'AB'.
		[
			writer := SocketWriteStream on: server.
			writer nextPutAll: 'c'.
			Delay wait: timeout * 3.
			writer nextPutAll: 'd'] fork.
		reader timeout: timeout * 4.
		self
			shouldnt: [answer := reader next: 2]
			raise: Timeout
			description: 'New timeout is not considered'.
		self assert: answer = 'cd']
		ensure: [
			reader close.
			control close]]

{ #category : #marshalling }
SocketTest >> testString6ToAddress [
	| sockaddr |
	sockaddr := SOCKADDR fromIP: '[2001:db8:8c00:22::171]:80'.
	self
		assert: sockaddr address Byte asByteArray
			= #[16r20 16r01 16r0D 16rB8 16r8C 16r00 16r00 16r22 16r00 16r00 16r00 16r00 16r00 16r00 16r01 16r71]]

{ #category : #marshalling }
SocketTest >> testStringToAddress [
	| addr |
	addr := SOCKADDR fromIP: '127.0.0.1'.
	self assert: addr address contents = #[127 0 0 1]]

{ #category : #structures }
SocketTest >> testTimeval [
	| tv tau |
	tv := timeval new milliseconds: 1017.
	self
		assert: tv tv_sec = 1;
		assert: tv tv_usec = 17000;
		assert: tv milliseconds = 1017.
	tau := Duration days: 1 hours: 2 minutes: 3 seconds: 4.
	tv := timeval fromDuration: tau.
	self assert: tv asDuration = tau]

{ #category : #structures }
SocketTest >> testWSADATA [
	| data |
	data := Ws2_32DLL classVariables at: 'WsaData'.
	self
		assert: Ws2_32DLL current notNil;
		assert: data wVersion = 16r202;
		assert: data wVersion <= data wHighVersion;
		assert: data szDescription isString;
		assert: data szSystemStatus = 'Running';
		assert: data szDescription notEmpty]

