"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SOCKADDR,
	#superclass : #SocketStructure,
	#category : #sockets
}

{ #category : #'instance creation' }
SOCKADDR class >> atMemory: anExternalMemory [
	| family |
	self == SOCKADDR ifFalse: [^super atMemory: anExternalMemory].
	family := anExternalMemory pointedMemory uShortAtOffset: 0.
	family = AF_INET ifTrue: [^SOCKADDR_IN atMemory: anExternalMemory].
	family = AF_INET6 ifTrue: [^SOCKADDR_IN6 atMemory: anExternalMemory].
	^nil]

{ #category : #private }
SOCKADDR class >> classFor: aString [
	"
	SOCKADDR classFor: '127.0.0.1:80'
	"
	^(aString occurrencesOf: $.) = 3
		ifTrue: [SOCKADDR_IN]
		ifFalse: [SOCKADDR_IN6]]

{ #category : #private }
SOCKADDR class >> def [
	^<def>
typedef struct sockaddr {
	ADDRESS_FAMILY sa_family; // 0
	CHAR sa_data[14]; // 2
} SOCKADDR; // sizeInBytes = 16
	</def>]

{ #category : #'instance creation' }
SOCKADDR class >> forHost: aString [
	"
	SOCKADDR forHost: (SOCKADDR resolveIP: '::0')
	SOCKADDR forHost: (SOCKADDR resolveIP: '127.0.0.1')
	"
	| info |
	info := ADDRINFOW forHost: aString.
	^self fromIP: info ip]

{ #category : #'instance creation' }
SOCKADDR class >> forHost: aString port: anInteger [
	| info |
	info := ADDRINFOW forHost: aString port: anInteger.
	^info sockaddr]

{ #category : #'instance creation' }
SOCKADDR class >> fromAddress: anExternalMemory size: anInteger [
	| struct |
	struct := self new: anInteger.
	^struct fillFrom: anExternalMemory]

{ #category : #'instance creation' }
SOCKADDR class >> fromIP: aString [
	"
	(SOCKADDR fromIP: '::1') ip
	(SOCKADDR fromIP: '127.0.0.1') ip
	"
	| class |
	class := self classFor: aString.
	^class sockaddrFrom: aString]

{ #category : #'instance creation' }
SOCKADDR class >> fromIP: aString port: anInteger [
	| addr |
	addr := self fromIP: aString.
	^addr port: anInteger]

{ #category : #'instance creation' }
SOCKADDR class >> fromMemory: anExternalMemory [
	| struct |
	struct := self atMemory: anExternalMemory.
	struct isNil ifTrue: [^super fromMemory: anExternalMemory].
	^struct localCopy]

{ #category : #services }
SOCKADDR class >> resolveIP: aString [
	"
	SOCKADDR_IN6 resolveIP: '::1'
	"
	| sockaddr |
	sockaddr := self fromIP: aString.
	^sockaddr resolve]

{ #category : #services }
SOCKADDR class >> resolveService: ip [
	"
	SOCKADDR resolveService: '[fe80::504a:cfc3:78a6:ab76%11]:21'
	SOCKADDR resolveService: '127.0.0.1:80'
	"
	| addr buffer long |
	addr := self fromIP: ip.
	addr := addr externalCopy.
	buffer := NI_MAXSERV externalBytes.
	^[
		long := Ws2_32DLL current
			getnameinfo: addr asParameter
			salen: addr sizeInBytes
			host: 0
			hostlen: 0
			serv: buffer asParameter
			servlen: NI_MAXSERV
			flags: 0.
		long ~= 0
			ifTrue: [self socketError]
			ifFalse: [Ansi current decode: buffer]]
		ensure: [
			addr free.
			buffer free]]

{ #category : #private }
SOCKADDR class >> sockaddrFrom: ip [
	| string memory length return |
	string := ip externalCopy.
	memory := self external.
	length := ExternalInt32 external fromInteger: self sizeInBytes.
	return := Ws2_32DLL current
		WSAStringToAddressW: string asParameter
		addressFamily: memory family
		lpProtocolInfo: 0
		lpAddress: memory asParameter
		lpAddressLength: length asParameter.
	return = 0 ifFalse: [^self socketError].
	string free.
	length free.
	^memory makeLocal]

{ #category : #output }
SOCKADDR >> familyName [
	| family |
	family := self family.
	family = AF_INET ifTrue: [^'IPv4'].
	family = AF_INET6 ifTrue: [^'IPv6'].
	family = AF_UNSPEC ifTrue: [^'AF_UNSPEC'].
	^family asString]

{ #category : #marshalling }
SOCKADDR >> hostFromNetwork: data [
	| dll |
	dll := Ws2_32DLL current.
	data size = 4 ifTrue: [^dll ntohl: data asParameter].
	data size = 2 ifTrue: [^dll ntohs: data asParameter].
	self error: 'cannot convert network integer']

{ #category : #services }
SOCKADDR >> ip [
	| copy buffer length return |
	copy := self externalCopy.
	buffer := 256 externalCharacters.
	length := ExternalInt32 external fromInteger: 256.
	return := Ws2_32DLL current
		WSAAddressToStringW: copy asParameter
		dwAddressLength: copy sizeInBytes
		lpProtocolInfo: 0
		lpszAddressString: buffer asParameter
		lpdwAddressStringLength: length asParameter.
	return = 0 ifFalse: [^self class socketError].
	copy == self ifFalse: [copy free].
	length free.
	^buffer makeUnicode reduced]

{ #category : #marshalling }
SOCKADDR >> networkFromLong: anInteger [
	^self class networkFromLong: anInteger]

{ #category : #marshalling }
SOCKADDR >> networkFromShort: anInteger [
	^self class networkFromShort: anInteger]

{ #category : #printing }
SOCKADDR >> printOn: aStream [
	| ip |
	ip := [self ip] on: SocketError do: ['-unknonw ip-'].
	aStream
		nextPutAll: self class name;
		space;
		nextPutAll: self familyName;
		space;
		nextPutAll: ip]

{ #category : #services }
SOCKADDR >> resolve [
	| copy buffer |
	copy := self externalCopy.
	buffer := NI_MAXHOST externalBytes.
	^[| long |
		long := Ws2_32DLL current
			getnameinfo: copy asParameter
			salen: copy sizeInBytes
			host: buffer asParameter
			hostlen: NI_MAXHOST
			serv: 0
			servlen: 0
			flags: 0.
		long != 0
			ifTrue: [self class socketError]
			ifFalse: [Ansi current decode: buffer]]
		ensure: [
			copy free.
			buffer free]]

