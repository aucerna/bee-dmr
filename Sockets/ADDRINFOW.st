"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ADDRINFOW,
	#superclass : #SocketStructure,
	#classVars : [
		'Offsets'
	],
	#category : #sockets
}

{ #category : #'instance creation' }
ADDRINFOW class >> aspects [
	^super aspects , #(#sockaddr #ip)]

{ #category : #accessing }
ADDRINFOW class >> def [
	^<def>
	typedef struct addrinfoW {
		int              ai_flags;
		int              ai_family;
		int              ai_socktype;
		int              ai_protocol;
		size_t           ai_addrlen;
		PWSTR            ai_canonname;
		sockaddr  *ai_addr;
		addrinfoW *ai_next;
	} ADDRINFOW, *PADDRINFOW;
	</def>]

{ #category : #'instance creation' }
ADDRINFOW class >> forHost: aString [
	"
	ADDRINFOW forHost: 'localhost'
	"
	^self forHost: aString port: nil]

{ #category : #'instance creation' }
ADDRINFOW class >> forHost: aString port: port [
	"
	ADDRINFOW forHost: 'localhost' port: 3333
	"
	| socket |
	socket := Socket new host: aString; port: port.
	^self fromSocket: socket]

{ #category : #'instance creation' }
ADDRINFOW class >> fromSocket: aSocket [
	| new |
	new := self new
		ai_family: aSocket family;
		ai_socktype: aSocket type;
		ai_protocol: aSocket protocol.
	aSocket isDaemon ifTrue: [new ai_flags: AI_PASSIVE].
	^new forHost: aSocket host port: aSocket port]

{ #category : #initialization }
ADDRINFOW class >> initializeConstants [
	"
	Addrinfo initializeConstants
	"
	self
		initializeFlags;
		initializeFamilyConstants;
		initializeSocktypeConstants;
		initializeProtoConstants]

{ #category : #initialization }
ADDRINFOW class >> initializeFamilyConstants [
	"
	Addrinfo initializeFamilyConstants
	"
	WindowsConstants
		at: 'AF_UNSPEC'
		put: 16r0
		"The address family is unspecified.";
		at: 'AF_INET'
		put: 16r2
		"The Internet Protocol version 4 (IPv4) address family.";
		at: 'AF_NETBIOS'
		put: 16r11
		"The NetBIOS address family. This address family is only supported if a Windows Sockets provider for NetBIOS is installed.";
		at: 'AF_INET6'
		put: 16r17
		"The Internet Protocol version 6 (IPv6) address family.";
		at: 'AF_IRDA'
		put: 16r1A
		"The Infrared Data Association (IrDA) address family. This address family is only supported if the computer has an infrared port and driver installed.";
		at: 'AF_BTH'
		put: 16r20
		"The Bluetooth address family. This address family is only supported if a Bluetooth adapter is installed on Windows Server�2003 or later."]

{ #category : #initialization }
ADDRINFOW class >> initializeFlags [
	"
	Addrinfo initializeFlags
	"
	WindowsConstants
		at: 'AI_PASSIVE'
		put: 16r1
		"The socket address will be used in a call to the bind <http://msdn.microsoft.com/en-us/library/windows/desktop/ms737550(v=vs.85).aspx> function.";
		at: 'AI_CANONNAME'
		put: 16r2
		"The canonical name is returned in the first ai_canonname member.";
		at: 'AI_NUMERICHOST'
		put: 16r4
		"The nodename parameter passed to the getaddrinfo <http://msdn.microsoft.com/en-us/library/windows/desktop/ms738520(v=vs.85).aspx> function must be a numeric string.";
		at: 'AI_ADDRCONFIG'
		put: 16r400
		"The getaddrinfo <http://msdn.microsoft.com/en-us/library/windows/desktop/ms738520(v=vs.85).aspx> will resolve only if a global address is configured. The IPv6 and IPv4 loopback address is not considered a valid global address. This option is only supported on Windows Vista or later.";
		at: 'AI_NON_AUTHORITATIVE'
		put: 16r4000
		"The address information can be from a non-authoritative namespace provider. This option is only supported on Windows Vista or later for the NS_EMAIL namespace.";
		at: 'AI_SECURE'
		put: 16r8000
		"The address information is from a secure channel. This option is only supported on Windows Vista or later for the NS_EMAIL namespace.";
		at: 'AI_RETURN_PREFERRED_NAMES'
		put: 16r10000
		"The address information is for a preferred name for a user. This option is only supported on Windows Vista or later for the NS_EMAIL namespace.";
		at: 'AI_FILESERVER'
		put: 16r40000
		"A hint to the namespace provider that the hostname being queried is being used in file share scenario. The namespace provider may ignore this hint."]

{ #category : #initialization }
ADDRINFOW class >> initializeProtoConstants [
	"
	Addrinfo initializeProtoConstants
	"
	WindowsConstants
		at: 'IPPROTO_TCP'
		put: 6
	"The Transmission Control Protocol (TCP). This is a possible value when the ai_family member is AF_INET or AF_INET6 and the ai_socktype member is SOCK_STREAM.";
		at: 'IPPROTO_UDP'
		put: 17
	"The User Datagram Protocol (UDP). This is a possible value when the ai_family member is AF_INET or AF_INET6 and the type parameter is SOCK_DGRAM.";
		at: 'IPPROTO_RM'
		put: 113
	"The PGM protocol for reliable multicast. This is a possible value when the ai_family member is AF_INET and the ai_socktype member is SOCK_RDM. On the Windows SDK released for Windows Vista and later, this value is also called
 IPPROTO_PGM."]

{ #category : #initialization }
ADDRINFOW class >> initializeSocktypeConstants [
	"
	Addrinfo initializeSocktypeConstants
	"
	WindowsConstants
		at: 'SOCK_STREAM'
		put: 16r1
		"Provides sequenced, reliable, two-way, connection-based byte streams with an OOB data transmission mechanism. Uses the Transmission Control Protocol (TCP) for the Internet address family (AF_INET or AF_INET6). If the ai_family member is AF_IRDA, then SOCK_STREAM is the only supported socket type.";
		at: 'SOCK_DGRAM'
		put: 16r2
		"Supports datagrams, which are connectionless, unreliable buffers of a fixed (typically small) maximum length. Uses the User Datagram Protocol (UDP) for the Internet address family (AF_INET or AF_INET6).";
		at: 'SOCK_RAW'
		put: 16r3
		"Provides a raw socket that allows an application to manipulate the next upper-layer protocol header. To manipulate the IPv4 header, the IP_HDRINCL <http://msdn.microsoft.com/en-us/library/windows/desktop/ms738586(v=vs.85).aspx> socket option must be set on the socket. To manipulate the IPv6 header, the IPV6_HDRINCL <http://msdn.microsoft.com/en-us/library/windows/desktop/ms738574(v=vs.85).aspx> socket option must be set on the socket.";
		at: 'SOCK_RDM'
		put: 16r4
		"Provides a reliable message datagram. An example of this type is the Pragmatic General Multicast (PGM) multicast protocol implementation in Windows, often referred to as reliable multicast programming <http://msdn.microsoft.com/en-us/library/windows/desktop/ms740125(v=vs.85).aspx>.";
		at: 'SOCK_SEQPACKET'
		put: 16r5
		"Provides a pseudo-stream packet based on datagrams."]

{ #category : #accessing }
ADDRINFOW class >> offsets64 [
^PoolDictionary new
		at: 'ai_flags' put: 0;
		at: 'ai_canonname' put: 24;
		at: 'ai_addrlen' put: 16;
		at: 'ai_family' put: 4;
		at: 'ai_socktype' put: 8;
		at: 'ai_addr' put: 32;
		at: 'sizeInBytes' put: 48;
		at: 'ai_next' put: 40;
		at: 'ai_protocol' put: 12;
		yourself]

{ #category : #accessing }
ADDRINFOW class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
ADDRINFOW >> ai_addr [
	^self addressAtOffset: ai_addr]

{ #category : #accessing }
ADDRINFOW >> ai_addr: anExternalMemory [
	self addressAtOffset: ai_addr register: anExternalMemory pointedMemory]

{ #category : #accessing }
ADDRINFOW >> ai_addrlen [
	^self pointerAtOffset: ai_addrlen]

{ #category : #accessing }
ADDRINFOW >> ai_addrlen: anInteger [
	self uLongAtOffset: ai_addrlen put: anInteger]

{ #category : #accessing }
ADDRINFOW >> ai_canonname [
	^self addressAtOffset: ai_canonname]

{ #category : #accessing }
ADDRINFOW >> ai_canonname: anInteger [
	self pointerAtOffset: ai_canonname put: anInteger]

{ #category : #accessing }
ADDRINFOW >> ai_family [
	^self longAtOffset: ai_family]

{ #category : #accessing }
ADDRINFOW >> ai_family: anInteger [
	self longAtOffset: ai_family put: anInteger]

{ #category : #accessing }
ADDRINFOW >> ai_flags [
	^self longAtOffset: ai_flags]

{ #category : #accessing }
ADDRINFOW >> ai_flags: anInteger [
	self longAtOffset: ai_flags put: anInteger]

{ #category : #accessing }
ADDRINFOW >> ai_next [
	^self addressAtOffset: ai_next]

{ #category : #accessing }
ADDRINFOW >> ai_next: anExternalMemory [
	self addressAtOffset: ai_next register: anExternalMemory pointedMemory]

{ #category : #accessing }
ADDRINFOW >> ai_protocol [
	^self longAtOffset: ai_protocol]

{ #category : #accessing }
ADDRINFOW >> ai_protocol: anInteger [
	self longAtOffset: ai_protocol put: anInteger]

{ #category : #accessing }
ADDRINFOW >> ai_socktype [
	^self longAtOffset: ai_socktype]

{ #category : #accessing }
ADDRINFOW >> ai_socktype: anInteger [
	self longAtOffset: ai_socktype put: anInteger]

{ #category : #accessing }
ADDRINFOW >> canonname [
	| memory unicode |
	memory := self ai_canonname.
	memory isValid ifFalse: [^nil].
	unicode := WideString fromMemory: memory.
	^unicode reduced]

{ #category : #output }
ADDRINFOW >> family [
	^self ai_family]

{ #category : #input }
ADDRINFOW >> family: anInteger [
	self ai_family: anInteger]

{ #category : #input }
ADDRINFOW >> forHost: aString port: aNumber [
	| hints host port result return |
	hints := self externalCopy.
	host := aString externalCopy.
	port := aNumber ifNotNil: [:p | p asString externalCopy].
	result := ExternalPointer external.
	return := Ws2_32DLL current
		GetAddrInfoW: host asParameter
		pServiceName: port asParameter
		pHints: hints asParameter
		ppResult: result asParameter.
	return = 0 ifFalse: [^self class socketError].
	self fillFrom: result pointedMemory.
	hints free.
	host free.
	port free.
	result free]

{ #category : #output }
ADDRINFOW >> ip [
	^self sockaddr ip]

{ #category : #accessing }
ADDRINFOW >> ipString [
	| family |
	family := self ai_family.
	family = AF_INET ifTrue: [^self ip].
	family = AF_INET6 ifTrue: [^'[' , self ip , ']'].
	self ASSERT: false]

{ #category : #output }
ADDRINFOW >> list [
	^Array streamContents: [:strm | | next |
		next := self.
		[next notNil] whileTrue: [
			strm nextPut: next.
			next := next next]]]

{ #category : #output }
ADDRINFOW >> next [
	| memory |
	memory := self ai_next.
	^memory isValid ifTrue: [self class fromMemory: memory]]

{ #category : #input }
ADDRINFOW >> protocol: anInteger [
	self ai_protocol: anInteger]

{ #category : #output }
ADDRINFOW >> sockaddr [
	^self sockaddrClass fromAddress: self ai_addr size: self ai_addrlen]

{ #category : #private }
ADDRINFOW >> sockaddrClass [
	| family |
	family := self ai_family.
	family = AF_INET ifTrue: [^SOCKADDR_IN].
	family = AF_INET6 ifTrue: [^SOCKADDR_IN6].
	self error: 'Unsupported Socket Family ' , family printString]

{ #category : #output }
ADDRINFOW >> sockaddrData [
	| buffer |
	buffer := MemoryBuffer atMemory: self ai_addr.
	^buffer bytesAtOffset: ai_flags count: self ai_addrlen]

{ #category : #input }
ADDRINFOW >> socktype: anInteger [
	self ai_socktype: anInteger]

