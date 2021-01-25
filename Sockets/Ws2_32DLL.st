"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #Ws2_32DLL,
	#superclass : #WindowsLibrary,
	#type : #bytes,
	#classVars : [
		'SocketMessage',
		'WsaData'
	],
	#category : #sockets
}

{ #category : #accessing }
Ws2_32DLL class >> current [
	current isNil ifTrue: [super current initialize].
	^current]

{ #category : #parsing }
Ws2_32DLL class >> h [
	^SmalltalkSession current devDirectory \ 'winsock2.h']

{ #category : #initialization }
Ws2_32DLL class >> initialize [
	"
	Ws2_32DLL initialize
	"
	super initialize.
	SmalltalkSession current when: #shutdown send: #shutdown to: self.
	self startup]

{ #category : #initialization }
Ws2_32DLL class >> initializeConstants [
	self initializeErrorCodes; initializeFDConstants]

{ #category : #initialization }
Ws2_32DLL class >> initializeErrorCodes [
	"
	Ws2_32DLL initializeErrorCodes
	"
	WindowsConstants
		at: 'SOCKET_ERROR' put: -1;
		at: 'WSASYSNOTREADY' put: 10091;
		at: 'WSAVERNOTSUPPORTED' put: 10092;
		at: 'WSANOTINITIALISED' put: 10093;
		at: 'WSAEINPROGRESS' put: 10036;
		at: 'WSAEPROCLIM' put: 10067;
		at: 'WSAEFAULT' put: 10014]

{ #category : #initialization }
Ws2_32DLL class >> initializeFDConstants [
	"
	Ws2_32DLL initializeFDConstants
	"
	WindowsConstants
		at: 'FD_READ' put: 16r1;
		at: 'FD_WRITE' put: 16r2;
		at: 'FD_OOB' put: 16r4;
		at: 'FD_ACCEPT' put: 16r8;
		at: 'FD_CONNECT' put: 16r10;
		at: 'FD_CLOSE' put: 16r20;
		at: 'FD_QOS' put: 16r40;
		at: 'FD_GROUP_QOS' put: 16r80;
		at: 'FD_ROUTING_INTERFACE_CHANGE' put: 16r100;
		at: 'FD_ADDRESS_LIST_CHANGE' put: 16r200]

{ #category : #accessing }
Ws2_32DLL class >> moduleName [
	^'Ws2_32']

{ #category : #'startup/shutdown' }
Ws2_32DLL class >> shutdown [
	current notNil ifTrue: [current shutdown].
	current := nil]

{ #category : #'startup/shutdown' }
Ws2_32DLL class >> startup [
	current := nil]

{ #category : #private }
Ws2_32DLL class >> typedefTable [
	^#(
		('ADDRESS_FAMILY' #short)
		('socklen_t' #long)
		('SOCKET' #ulong)
		('LPWSAPROTOCOL_INFO' #pointer)
		('LPWSAOVERLAPPED' #pointer)
		('LPWSAOVERLAPPED_COMPLETION_ROUTINE' #pointer)
		('HCERTSTORE' #pointer)
		('WSAEVENT' #pointer)
		('u_char' #byte)
		('u_int' #ulong)
		('u_long' #ulong)
		('u_short' #ushort)
	)]

{ #category : #connection }
Ws2_32DLL >> accept: s addr: addr addrlen: addrlen [
	<long: accept>
	^self invalidCall

"
SOCKET accept(
  _In_    SOCKET          s,
  _Out_   struct sockaddr *addr,
  _Inout_ int             *addrlen
);
"]

{ #category : #connection }
Ws2_32DLL >> bind: s name: name namelen: namelen [
	<long: bind>
	^self invalidCall

"
int bind(
  _In_ SOCKET                s,
  _In_ const struct sockaddr *name,
  _In_ int                   namelen
);
"]

{ #category : #'open/close' }
Ws2_32DLL >> close: s [
	^self closesocket: s]

{ #category : #'open/close' }
Ws2_32DLL >> closesocket: descriptor [
	<long: closesocket>
	^self invalidCall

"
int closesocket(
  _In_ SOCKET s
);
"]

{ #category : #connection }
Ws2_32DLL >> connect: s name: name namelen: namelen [
	<long: connect>
	^self invalidCall

"
int connect(
  _In_ SOCKET                s,
  _In_ const struct sockaddr *name,
  _In_ int                   namelen
);
"]

{ #category : #services }
Ws2_32DLL >> GetAddrInfoW: pNodeName
pServiceName: service
pHints: anAddrinfo
ppResult: list [
	<long: GetAddrInfoW>
	self invalidCall

"
int WSAAPI GetAddrInfoW(
  _In_opt_       PCWSTR     pNodeName,
  _In_opt_       PCWSTR     pServiceName,
  _In_opt_ const ADDRINFOW  *pHints,
  _Out_          PADDRINFOW *ppResult
);
"]

{ #category : #errors }
Ws2_32DLL >> getLastError [
	^self WSAGetLastError]

{ #category : #services }
Ws2_32DLL >> getnameinfo: sockaddr
salen: len
host: buffer
hostlen: hostlen
serv: service
servlen: servlen
flags: flags [
	<long: getnameinfo>
	self invalidCall

"
int WSAAPI getnameinfo(
  _In_  const struct sockaddr FAR *sa,
  _In_  socklen_t                 salen,
  _Out_ char FAR                  *host,
  _In_  DWORD                     hostlen,
  _Out_ char FAR                  *serv,
  _In_  DWORD                     servlen,
  _In_  int                       flags
);
"]

{ #category : #services }
Ws2_32DLL >> getpeername: s name: name namelen: namelen [
	<long: getpeername>
	^self invalidCall

"
int getpeername(
  _In_    SOCKET          s,
  _Out_   struct sockaddr *name,
  _Inout_ int             *namelen
);
"]

{ #category : #services }
Ws2_32DLL >> getprotobyname: name [
	<pointer: getprotobyname>
	^self invalidCall

"
struct PROTOENT* FAR getprotobyname(
  _In_ const char *name
);
"]

{ #category : #services }
Ws2_32DLL >> getprotobynumber: number [
	<pointer: getprotobynumber>
	^self invalidCall

"
struct PROTOENT* FAR getprotobynumber(
  _In_ int number
);
"]

{ #category : #services }
Ws2_32DLL >> getservbyname: name proto: proto [
	<pointer: getservbyname>
	^self invalidCall

"
struct servent* FAR getservbyname(
  _In_ const char *name,
  _In_ const char *proto
);
"]

{ #category : #services }
Ws2_32DLL >> getservbyport: port proto: proto [
	<pointer: getservbyport>
	^self invalidCall

"
struct servent* FAR getservbyport(
  _In_       int  port,
  _In_ const char *proto
);
"]

{ #category : #services }
Ws2_32DLL >> getsockname: s name: name namelen: namelen [
	<long: getsockname>
	^self invalidCall

"
int getsockname(
  _In_    SOCKET          s,
  _Out_   struct sockaddr *name,
  _Inout_ int             *namelen
);
"]

{ #category : #services }
Ws2_32DLL >> getsockopt: s
level: level
optname: opt
optval: ulong
optlen: length [
	<long: getsockopt>
	^self invalidCall

"
int getsockopt(
  _In_    SOCKET s,
  _In_    int    level,
  _In_    int    optname,
  _Out_   char   *optval,
  _Inout_ int    *optlen
);
"]

{ #category : #marshalling }
Ws2_32DLL >> htonl: hostlong [
	<ulong: htonl>
	^self invalidCall

"
u_long WSAAPI htonl(
  _In_ u_long hostlong
);
"]

{ #category : #marshalling }
Ws2_32DLL >> htons: hostshort [
	<ulong: htons>
	^self invalidCall

"
u_short WSAAPI htons(
  _In_ u_short hostshort
);
"]

{ #category : #initialization }
Ws2_32DLL >> initialize [
	super initialize.
	self initializeWsaData]

{ #category : #initialization }
Ws2_32DLL >> initializeWsaData [
	| data result |
	data := WSADATA external.
	result := self WSAStartup: 16r202 lpWSAData: data asParameter.
	result ~= 0 ifTrue: [
		self class current: nil.
		^SocketError signalOSCode: result].
	WsaData := data makeLocal]

{ #category : #connection }
Ws2_32DLL >> ioctlsocket: s cmd: cmd argp: argp [
	<long: ioctlsocket>
	^self invalidCall

"
int ioctlsocket(
  _In_    SOCKET s,
  _In_    long   cmd,
  _Inout_ u_long *argp
);
"]

{ #category : #'read/write' }
Ws2_32DLL >> listen: s backlog: backlog [
	<long: listen>
	^self invalidCall

"
int listen(
  _In_ SOCKET s,
  _In_ int    backlog
);
"]

{ #category : #marshalling }
Ws2_32DLL >> ntohl: netlong [
	<ulong: ntohl>
	^self invalidCall

"
u_long WSAAPI ntohl(
  _In_ u_long netlong
);
"]

{ #category : #marshalling }
Ws2_32DLL >> ntohs: netshort [
	^(self ulong_ntohs: netshort) bitAnd: 16rFFFF]

{ #category : #'read/write' }
Ws2_32DLL >> recv: s
buf: buf
len: len
flags: flags [
	<long: recv>
	^self invalidCall

"
int recv(
  _In_  SOCKET s,
  _Out_ char   *buf,
  _In_  int    len,
  _In_  int    flags
);
"]

{ #category : #'read/write' }
Ws2_32DLL >> recvfrom: s
buf: buf
len: len
flags: flags
from: from
fromlen: fromlen [
	<long: recvfrom>
	^self invalidCall

"
int recvfrom(
  _In_         SOCKET s,
  _Out_        char *buf,
  _In_         int len,
  _In_         int flags,
  _Out_        struct sockaddr *from,
  _Inout_opt_  int *fromlen
);
"]

{ #category : #connection }
Ws2_32DLL >> select: nfds
readfds: readfds
writefds: writefds
exceptfds: exceptfds
timeout: timeout [
	<long: select>
	^self invalidCall

"
int select(
  _In_    int                  nfds,
  _Inout_ fd_set               *readfds,
  _Inout_ fd_set               *writefds,
  _Inout_ fd_set               *exceptfds,
  _In_    const struct timeval *timeout
);
"]

{ #category : #'read/write' }
Ws2_32DLL >> send: s
buf: buf
len: len
flags: flags [
	<long: send>
	^self invalidCall

"
int send(
  _In_  SOCKET s,
  _In_  const char *buf,
  _In_  int len,
  _In_  int flags
);
"]

{ #category : #'read/write' }
Ws2_32DLL >> sendto: s
buf: buf
len: len
flags: flags
to: to
tolen: tolen [
	<long: sendto>
	^self invalidCall

"
int sendto(
  _In_  SOCKET s,
  _In_  const char *buf,
  _In_  int len,
  _In_  int flags,
  _In_  const struct sockaddr *to,
  _In_  int tolen
);
"]

{ #category : #'read/write' }
Ws2_32DLL >> setsockopt: s
level: level
optname: optname
optval: optval
optlen: optlen [
	<long: setsockopt>
	^self invalidCall 

"
int setsockopt(
  _In_  SOCKET s,
  _In_  int level,
  _In_  int optname,
  _In_  const char *optval,
  _In_  int optlen
);
"]

{ #category : #'open/close' }
Ws2_32DLL >> shutdown [
	| code |
	[self WSACleanup = SOCKET_ERROR] whileFalse.
	(code := self WSAGetLastError) = WSANOTINITIALISED
		ifFalse: [^self winError: code]]

{ #category : #'open/close' }
Ws2_32DLL >> shutdown: s how: how [
	<long: shutdown>
	^self invalidCall

"
int shutdown(
  _In_ SOCKET s,
  _In_ int    how
);
"]

{ #category : #connection }
Ws2_32DLL >> socket: af type: type protocol: protocol [
	<long: socket>
	^self invalidCall

"
SOCKET WSAAPI socket(
  _In_ int af,
  _In_ int type,
  _In_ int protocol
);
"]

{ #category : #marshalling }
Ws2_32DLL >> ulong_ntohs: netshort [
	<ulong: ntohs>
	^self invalidCall

"
u_short WSAAPI ntohs(
  _In_ u_short netshort
);
"]

{ #category : #connection }
Ws2_32DLL >> wait: milliseconds
forReadSet: readSet
writeSet: writeSet
errorSet: exceptionSet [
	| read write exception tv answer |
	read := fd_set external fromCollection: readSet.
	write := fd_set external fromCollection: writeSet.
	exception := fd_set external fromCollection: exceptionSet.
	tv := timeval external milliseconds: milliseconds.
	answer := self
		select: 0
		readfds: read asParameter
		writefds: write asParameter
		exceptfds: exception asParameter
		timeout: tv asParameter.
	answer <= 0 ifTrue: [^answer].
	readSet makeLocal
		removeAllSuchThat: [:s | (read fd_isset: s descriptor) not].
	writeSet makeLocal
		removeAllSuchThat: [:s | (write fd_isset: s descriptor) not].
	exceptionSet makeLocal
		removeAllSuchThat: [:s | (exception fd_isset: s descriptor) not].
	tv free.
	^answer]

{ #category : #marshalling }
Ws2_32DLL >> WSAAddressToStringW: aSOCKADDR_IN
dwAddressLength: length
lpProtocolInfo: anWSAPROTOCOL_INFO
lpszAddressString: buffer
lpdwAddressStringLength: size [
	<long: WSAAddressToStringW>
	^self invalidCall

"
INT WSAAPI WSAAddressToString(
  _In_     LPSOCKADDR         lpsaAddress,
  _In_     DWORD              dwAddressLength,
  _In_opt_ LPWSAPROTOCOL_INFO lpProtocolInfo,
  _Inout_  LPTSTR             lpszAddressString,
  _Inout_  LPDWORD            lpdwAddressStringLength
);
"]

{ #category : #asynchronous }
Ws2_32DLL >> WSAAsyncGetHostByAddr: hWnd
wMsg: wMsg
addr: addr
len: len
type: type
buf: buf
buflen: buflen [
	<pointer: WSAAsyncGetHostByAddr>
	^self invalidCall

"
HANDLE WSAAsyncGetHostByAddr(
  _In_        HWND         hWnd,
  _In_        unsigned int wMsg,
  _In_  const char         *addr,
  _In_        int          len,
  _In_        int          type,
  _Out_       char         *buf,
  _In_        int          buflen
);
"]

{ #category : #asynchronous }
Ws2_32DLL >> WSAAsyncGetHostByName: hWnd
wMsg: wMsg
name: name
buf: buf
buflen: buflen [
	<pointer: WSAAsyncGetHostByName>
	^self invalidCall

"
HANDLE WSAAsyncGetHostByName(
  _In_        HWND         hWnd,
  _In_        unsigned int wMsg,
  _In_  const char         *name,
  _Out_       char         *buf,
  _In_        int          buflen
);
"]

{ #category : #asynchronous }
Ws2_32DLL >> WSAAsyncGetProtoByName: hWnd
wMsg: wMsg
name: name
buf: buf
buflen: buflen [
	<pointer: WSAAsyncGetProtoByName>
	^self invalidCall

"
HANDLE WSAAsyncGetProtoByName(
  _In_        HWND         hWnd,
  _In_        unsigned int wMsg,
  _In_  const char         *name,
  _Out_       char         *buf,
  _Out_       int          buflen
);
"]

{ #category : #asynchronous }
Ws2_32DLL >> WSAAsyncGetProtoByNumber: hWnd
wMsg: wMsg
number: number
buf: buf
buflen: buflen [
	<pointer: WSAAsyncGetProtoByNumber>
	^self invalidCall

"
HANDLE WSAAsyncGetProtoByNumber(
  _In_  HWND         hWnd,
  _In_  unsigned int wMsg,
  _In_  int          number,
  _Out_ char         *buf,
  _In_  int          buflen
);
"]

{ #category : #asynchronous }
Ws2_32DLL >> WSAAsyncGetServByName: hWnd
wMsg: wMsg
name: name
proto: proto
buf: buf
buflen: buflen [
	<pointer: WSAAsyncGetServByName>
	^self invalidCall

"
HANDLE WSAAsyncGetServByName(
  _In_        HWND         hWnd,
  _In_        unsigned int wMsg,
  _In_  const char         *name,
  _In_  const char         *proto,
  _Out_       char         *buf,
  _In_        int          buflen
);
"]

{ #category : #asynchronous }
Ws2_32DLL >> WSAAsyncGetServByPort: hWnd
wMsg: wMsg
port: port
proto: proto
buf: buf
buflen: buflen [
	<pointer: WSAAsyncGetServByPort>
	^self invalidCall

"
HANDLE WSAAsyncGetServByPort(
  _In_        HWND         hWnd,
  _In_        unsigned int wMsg,
  _In_        int          port,
  _In_  const char         *proto,
  _Out_       char         *buf,
  _In_        int          buflen
);
"]

{ #category : #asynchronous }
Ws2_32DLL >> WSAAsyncSelect: s
hWnd: hWnd
wMsg: wMsg
lEvent: lEvent [
	<long: WSAAsyncSelect>
	^self invalidCall

"
int WSAAsyncSelect(
  _In_ SOCKET       s,
  _In_ HWND         hWnd,
  _In_ unsigned int wMsg,
  _In_ long         lEvent
);
"]

{ #category : #'startup/shutdown' }
Ws2_32DLL >> WSACleanup [
	<long: WSACleanup>
	^self invalidCall

"
int WSACleanup(void);
"]

{ #category : #errors }
Ws2_32DLL >> WSAGetLastError [
	<long: WSAGetLastError>
	^self invalidCall

"
int WSAGetLastError(void);
"]

{ #category : #'read/write' }
Ws2_32DLL >> WSARecv: s
lpBuffers: buffers
dwBufferCount: anInteger
lpNumberOfBytesRecvd: rcvd
lpFlags: flags
lpOverlapped: overlapped
lpCompletionRoutine: address [
	<long: WSARecv>
	"
int WSARecv(
  _In_    SOCKET                             s,
  _Inout_ LPWSABUF                           lpBuffers,
  _In_    DWORD                              dwBufferCount,
  _Out_   LPDWORD                            lpNumberOfBytesRecvd,
  _Inout_ LPDWORD                            lpFlags,
  _In_    LPWSAOVERLAPPED                    lpOverlapped,
  _In_    LPWSAOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
);
"]

{ #category : #errors }
Ws2_32DLL >> WSASetLastError: iError [
	<ulong: WSASetLastError>
	^self invalidCall

"
void WSASetLastError(
  _In_ int iError
);
"]

{ #category : #'startup/shutdown' }
Ws2_32DLL >> WSAStartup: wVersionRequired lpWSAData: lpWSAData [
	<long: WSAStartup>
	^self invalidCall

"
int WSAStartup(
  _In_  WORD      wVersionRequested,
  _Out_ LPWSADATA lpWSAData
);
"]

{ #category : #marshalling }
Ws2_32DLL >> WSAStringToAddressW: aString
addressFamily: anInteger
lpProtocolInfo: anWSAPROTOCOL_INFO
lpAddress: aSOCKADDR
lpAddressLength: size [
	<long: WSAStringToAddressW>
	^self invalidCall

"
INT WSAAPI WSAStringToAddress(
  _In_     LPTSTR             AddressString,
  _In_     INT                AddressFamily,
  _In_opt_ LPWSAPROTOCOL_INFO lpProtocolInfo,
  _Out_    LPSOCKADDR         lpAddress,
  _Inout_  LPINT              lpAddressLength
);
"]

