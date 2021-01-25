"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #Socket,
	#superclass : #Object,
	#instVars : [
		'descriptor',
		'family',
		'type',
		'protocol',
		'host',
		'port',
		'blocking',
		'binary',
		'daemon',
		'state',
		'address',
		'events',
		'ssl'
	],
	#classVars : [
		'LogEvents'
	],
	#category : #sockets
}

{ #category : #events }
Socket class >> availableEvents [
	^super availableEvents
		add: #socketError:;
		add: #readyToRead;
		add: #readyToWrite;
		add: #outOfBandData;
		add: #readyToAccept;
		add: #connectionCompleted;
		add: #shuttingDown;
		add: #qualityChanged;
		add: #groupQualityChanged;
		add: #routingChanged;
		add: #addressListChanged;
		yourself]

{ #category : #services }
Socket class >> connectedTo: aString port: anInteger [
	"
	Socket open: 'fe80::71cf:1e7e:442d:5799%11' port: 62408
	"
	| socket |
	socket := self open: aString port: anInteger.
	socket connect.
	^socket]

{ #category : #services }
Socket class >> currentClass [
	^LogEvents == true ifTrue: [LoggedSocket] ifFalse: [Socket]]

{ #category : #services }
Socket class >> hostName [
	^SOCKADDR resolveIP: '::1']

{ #category : #initialization }
Socket class >> initializeConstants [
	"
	Socket2 initializeConstants
	"
	WindowsConstants at: 'SOMAXCONN' put: 128.
	self
		initializeProtoConstants;
		initializeErrorConstants;
		initializeShutdownConstants]

{ #category : #initialization }
Socket class >> initializeErrorConstants [
	"
	Socket2 initializeErrorConstants
	"
	WindowsConstants
		at: 'WSA_INVALID_HANDLE'
		put: 16r6
		"Specified event object handle is invalid.

An application attempts to use an event object, but the specified handle is not valid. Note that this error is returned by the operating system, so the error number may change in future releases of Windows.";
		at: 'WSA_NOT_ENOUGH_MEMORY'
		put: 16r8
		"Insufficient memory available.

An application used a Windows Sockets function that directly maps to a Windows function. The Windows function is indicating a lack of required memory resources. Note that this error is returned by the operating system, so the error number may change in future releases of Windows.";
		at: 'WSA_INVALID_PARAMETER'
		put: 16r57
		"One or more parameters are invalid.

An application used a Windows Sockets function which directly maps to a Windows function. The Windows function is indicating a problem with one or more parameters. Note that this error is returned by the operating system, so the error number may change in future releases of Windows.";
		at: 'WSA_OPERATION_ABORTED'
		put: 16r3E3
		"Overlapped operation aborted.

An overlapped operation was canceled due to the closure of the socket, or the execution of the SIO_FLUSH command in WSAIoctl. Note that this error is returned by the operating system, so the error number may change in future releases of Windows.";
		at: 'WSA_IO_INCOMPLETE'
		put: 16r3E4
		"Overlapped I/O event object not in signaled state.

The application has tried to determine the status of an overlapped operation which is not yet completed. Applications that use WSAGetOverlappedResult (with the fWait flag set to FALSE) in a polling mode to determine when an overlapped operation has completed, get this error code until the operation is complete. Note that this error is returned by the operating system, so the error number may change in future releases of Windows.";
		at: 'WSA_IO_PENDING'
		put: 16r3E5
		"Overlapped operations will complete later. 


The application has initiated an overlapped operation that cannot be completed immediately. A completion indication will be given later when the operation has been completed. Note that this error is returned by the operating system, so the error number may change in future releases of Windows.";
		at: 'WSAEINTR'
		put: 16r2714
		"Interrupted function call.

A blocking operation was interrupted by a call to WSACancelBlockingCall.";
		at: 'WSAEBADF'
		put: 16r2719
		"File handle is not valid.

The file handle supplied is not valid.";
		at: 'WSAEACCES'
		put: 16r271D
		"Permission denied.

An attempt was made to access a socket in a way forbidden by its access permissions. An example is using a broadcast address for sendto without broadcast permission being set using setsockopt(SO_BROADCAST). 

Another possible reason for the WSAEACCES error is that when the bind function is called (on Windows NT 4.0 with SP4 and later), another application, service, or kernel mode driver is bound to the same address with exclusive access. Such exclusive access is a new feature of Windows NT 4.0 with SP4 and later, and is implemented by using the SO_EXCLUSIVEADDRUSE option.";
		at: 'WSAEFAULT'
		put: 16r271E
		"Bad address.

The system detected an invalid pointer address in attempting to use a pointer argument of a call. This error occurs if an application passes an invalid pointer value, or if the length of the buffer is too small. For instance, if the length of an argument, which is a sockaddr structure, is smaller than the sizeof(sockaddr).";
		at: 'WSAEINVAL'
		put: 16r2726
		"Invalid argument.

Some invalid argument was supplied (for example, specifying an invalid level to the setsockopt function). In some instances, it also refers to the current state of the socket-for instance, calling accept on a socket that is not listening.";
		at: 'WSAEMFILE'
		put: 16r2728
		"Too many open files.

Too many open sockets. Each implementation may have a maximum number of socket handles available, either globally, per process, or per thread.";
		at: 'WSAEWOULDBLOCK'
		put: 16r2733
		"Resource temporarily unavailable.

This error is returned from operations on nonblocking sockets that cannot be completed immediately, for example recv when no data is queued to be read from the socket. It is a nonfatal error, and the operation should be retried later. It is normal for WSAEWOULDBLOCK to be reported as the result from calling connect on a nonblocking SOCK_STREAM socket, since some time must elapse for the connection to be established.";
		at: 'WSAEINPROGRESS'
		put: 16r2734
		"Operation now in progress.

A blocking operation is currently executing. Windows Sockets only allows a single blocking operation-per- task or thread-to be outstanding, and if any other function call is made (whether or not it references that or any other socket) the function fails with the WSAEINPROGRESS error.";
		at: 'WSAEALREADY'
		put: 16r2735
		"Operation already in progress.

An operation was attempted on a nonblocking socket with an operation already in progress-that is, calling connect a second time on a nonblocking socket that is already connecting, or canceling an asynchronous request (WSAAsyncGetXbyY) that has already been canceled or completed.";
		at: 'WSAENOTSOCK'
		put: 16r2736
		"Socket operation on nonsocket.

An operation was attempted on something that is not a socket. Either the socket handle parameter did not reference a valid socket, or for select, a member of an fd_set was not valid.";
		at: 'WSAEDESTADDRREQ'
		put: 16r2737
		"Destination address required.

A required address was omitted from an operation on a socket. For example, this error is returned if sendto is called with the remote address of ADDR_ANY.";
		at: 'WSAEMSGSIZE'
		put: 16r2738
		"Message too long.

A message sent on a datagram socket was larger than the internal message buffer or some other network limit, or the buffer used to receive a datagram was smaller than the datagram itself.";
		at: 'WSAEPROTOTYPE'
		put: 16r2739
		"Protocol wrong type for socket.

A protocol was specified in the socket function call that does not support the semantics of the socket type requested. For example, the ARPA Internet UDP protocol cannot be specified with a socket type of SOCK_STREAM.";
		at: 'WSAENOPROTOOPT'
		put: 16r273A
		"Bad protocol option.

An unknown, invalid or unsupported option or level was specified in a getsockopt or setsockopt call.";
		at: 'WSAEPROTONOSUPPORT'
		put: 16r273B
		"Protocol not supported.

The requested protocol has not been configured into the system, or no implementation for it exists. For example, a socket call requests a SOCK_DGRAM socket, but specifies a stream protocol.";
		at: 'WSAESOCKTNOSUPPORT'
		put: 16r273C
		"Socket type not supported.

The support for the specified socket type does not exist in this address family. For example, the optional type SOCK_RAW might be selected in a socket call, and the implementation does not support SOCK_RAW sockets at all.";
		at: 'WSAEOPNOTSUPP'
		put: 16r273D
		"Operation not supported.

The attempted operation is not supported for the type of object referenced. Usually this occurs when a socket descriptor to a socket that cannot support this operation is trying to accept a connection on a datagram socket.";
		at: 'WSAEPFNOSUPPORT'
		put: 16r273E
		"Protocol family not supported.

The protocol family has not been configured into the system or no implementation for it exists. This message has a slightly different meaning from WSAEAFNOSUPPORT. However, it is interchangeable in most cases, and all Windows Sockets functions that return one of these messages also specify WSAEAFNOSUPPORT.";
		at: 'WSAEAFNOSUPPORT'
		put: 16r273F
		"Address family not supported by protocol family.

An address incompatible with the requested protocol was used. All sockets are created with an associated address family (that is, AF_INET for Internet Protocols) and a generic protocol type (that is, SOCK_STREAM). This error is returned if an incorrect protocol is explicitly requested in the socket call, or if an address of the wrong family is used for a socket, for example, in sendto.";
		at: 'WSAEADDRINUSE'
		put: 16r2740
		"Address already in use.

Typically, only one usage of each socket address (protocol/IP address/port) is permitted. This error occurs if an application attempts to bind a socket to an IP address/port that has already been used for an existing socket, or a socket that was not closed properly, or one that is still in the process of closing. For server applications that need to bind multiple sockets to the same port number, consider using setsockopt (SO_REUSEADDR). Client applications usually need not call bind at all-connect chooses an unused port automatically. When bind is called with a wildcard address (involving ADDR_ANY), a WSAEADDRINUSE error could be delayed until the specific address is committed. This could happen with a call to another function later, including connect, listen, WSAConnect, or WSAJoinLeaf.";
		at: 'WSAEADDRNOTAVAIL'
		put: 16r2741
		"Cannot assign requested address.

The requested address is not valid in its context. This normally results from an attempt to bind to an address that is not valid for the local computer. This can also result from connect, sendto, WSAConnect, WSAJoinLeaf, or WSASendTo when the remote address or port is not valid for a remote computer (for example, address or port 0).";
		at: 'WSAENETDOWN'
		put: 16r2742
		"Network is down.

A socket operation encountered a dead network. This could indicate a serious failure of the network system (that is, the protocol stack that the Windows Sockets DLL runs over), the network interface, or the local network itself.";
		at: 'WSAENETUNREACH'
		put: 16r2743
		"Network is unreachable.

A socket operation was attempted to an unreachable network. This usually means the local software knows no route to reach the remote host.";
		at: 'WSAENETRESET'
		put: 16r2744
		"Network dropped connection on reset.

The connection has been broken due to keep-alive activity detecting a failure while the operation was in progress. It can also be returned by setsockopt if an attempt is made to set SO_KEEPALIVE on a connection that has already failed.";
		at: 'WSAECONNABORTED'
		put: 16r2745
		"Software caused connection abort.

An established connection was aborted by the software in your host computer, possibly due to a data transmission time-out or protocol error.";
		at: 'WSAECONNRESET'
		put: 16r2746
		"Connection reset by peer.

 An existing connection was forcibly closed by the remote host. This normally results if the peer application on the remote host is suddenly stopped, the host is rebooted, the host or remote network interface is disabled, or the remote host uses a hard close (see setsockopt for more information on the SO_LINGER option on the remote socket). This error may also result if a connection was broken due to keep-alive activity detecting a failure while one or more operations are in progress. Operations that were in progress fail with WSAENETRESET. Subsequent operations fail with WSAECONNRESET.";
		at: 'WSAENOBUFS'
		put: 16r2747
		"No buffer space available.

An operation on a socket could not be performed because the system lacked sufficient buffer space or because a queue was full.";
		at: 'WSAEISCONN'
		put: 16r2748
		"Socket is already connected.

A connect request was made on an already-connected socket. Some implementations also return this error if sendto is called on a connected SOCK_DGRAM socket (for SOCK_STREAM sockets, the to parameter in sendto is ignored) although other implementations treat this as a legal occurrence.";
		at: 'WSAENOTCONN'
		put: 16r2749
		"Socket is not connected.

A request to send or receive data was disallowed because the socket is not connected and (when sending on a datagram socket using sendto) no address was supplied. Any other type of operation might also return this error-for example, setsockopt setting SO_KEEPALIVE if the connection has been reset.";
		at: 'WSAESHUTDOWN'
		put: 16r274A
		"Cannot send after socket shutdown.

A request to send or receive data was disallowed because the socket had already been shut down in that direction with a previous shutdown call. By calling shutdown a partial close of a socket is requested, which is a signal that sending or receiving, or both have been discontinued.";
		at: 'WSAETOOMANYREFS'
		put: 16r274B
		"Too many references.

Too many references to some kernel object.";
		at: 'WSAETIMEDOUT'
		put: 16r274C
		"Connection timed out.

A connection attempt failed because the connected party did not properly respond after a period of time, or the established connection failed because the connected host has failed to respond.";
		at: 'WSAECONNREFUSED'
		put: 16r274D
		"Connection refused.

No connection could be made because the target computer actively refused it. This usually results from trying to connect to a service that is inactive on the foreign host-that is, one with no server application running.";
		at: 'WSAELOOP'
		put: 16r274E
		"Cannot translate name.

Cannot translate a name.";
		at: 'WSAENAMETOOLONG'
		put: 16r274F
		"Name too long.

A name component or a name was too long.";
		at: 'WSAEHOSTDOWN'
		put: 16r2750
		"Host is down.

A socket operation failed because the destination host is down. A socket operation encountered a dead host. Networking activity on the local host has not been initiated. These conditions are more likely to be indicated by the error WSAETIMEDOUT.";
		at: 'WSAEHOSTUNREACH'
		put: 16r2751
		"No route to host.

A socket operation was attempted to an unreachable host. See WSAENETUNREACH.";
		at: 'WSAENOTEMPTY'
		put: 16r2752
		"Directory not empty.

Cannot remove a directory that is not empty.";
		at: 'WSAEPROCLIM'
		put: 16r2753
		"Too many processes.

A Windows Sockets implementation may have a limit on the number of applications that can use it simultaneously. WSAStartup may fail with this error if the limit has been reached.";
		at: 'WSAEUSERS'
		put: 16r2754
		"User quota exceeded.

Ran out of user quota.";
		at: 'WSAEDQUOT'
		put: 16r2755
		"Disk quota exceeded.

Ran out of disk quota.";
		at: 'WSAESTALE'
		put: 16r2756
		"Stale file handle reference.

The file handle reference is no longer available.";
		at: 'WSAEREMOTE'
		put: 16r2757
		"Item is remote.

The item is not available locally.";
		at: 'WSASYSNOTREADY'
		put: 16r276B
		"Network subsystem is unavailable.

This error is returned by WSAStartup if the Windows Sockets implementation cannot function at this time because the underlying system it uses to provide network services is currently unavailable. Users should check:
That the appropriate Windows Sockets DLL file is in the current path.
That they are not trying to use more than one Windows Sockets implementation simultaneously. If there is more than one Winsock DLL on your system, be sure the first one in the path is appropriate for the network subsystem currently loaded.
The Windows Sockets implementation documentation to be sure all necessary components are currently installed and configured correctly.";
		at: 'WSAVERNOTSUPPORTED'
		put: 16r276C
		"Winsock.dll version out of range.

The current Windows Sockets implementation does not support the Windows Sockets specification version requested by the application. Check that no old Windows Sockets DLL files are being accessed.";
		at: 'WSANOTINITIALISED'
		put: 16r276D
		"Successful WSAStartup not yet performed.

Either the application has not called WSAStartup or WSAStartup failed. The application may be accessing a socket that the current active task does not own (that is, trying to share a socket between tasks), or WSACleanup has been called too many times.";
		at: 'WSAEDISCON'
		put: 16r2775
		"Graceful shutdown in progress.

Returned by WSARecv and WSARecvFrom to indicate that the remote party has initiated a graceful shutdown sequence.";
		at: 'WSAENOMORE'
		put: 16r2776
		"No more results.

No more results can be returned by the WSALookupServiceNext function.";
		at: 'WSAECANCELLED'
		put: 16r2777
		"Call has been canceled.

A call to the WSALookupServiceEnd function was made while this call was still processing. The call has been canceled.";
		at: 'WSAEINVALIDPROCTABLE'
		put: 16r2778
		"Procedure call table is invalid.

The service provider procedure call table is invalid. A service provider returned a bogus procedure table to Ws2_32.dll. This is usually caused by one or more of the function pointers being NULL.";
		at: 'WSAEINVALIDPROVIDER'
		put: 16r2779
		"Service provider is invalid.

The requested service provider is invalid. This error is returned by the WSCGetProviderInfo and WSCGetProviderInfo32 functions if the protocol entry specified could not be found. This error is also returned if the service provider returned a version number other than 2.0.";
		at: 'WSAEPROVIDERFAILEDINIT'
		put: 16r277A
		"Service provider failed to initialize.

The requested service provider could not be loaded or initialized. This error is returned if either a service provider's DLL could not be loaded (LoadLibrary failed) or the provider's WSPStartup or NSPStartup function failed.";
		at: 'WSASYSCALLFAILURE'
		put: 16r277B
		"System call failure.

A system call that should never fail has failed. This is a generic error code, returned under various conditions. 

Returned when a system call that should never fail does fail. For example, if a call to WaitForMultipleEvents fails or one of the registry functions fails trying to manipulate the protocol/namespace catalogs.

Returned when a provider does not return SUCCESS and does not provide an extended error code. Can indicate a service provider implementation error.";
		at: 'WSASERVICE_NOT_FOUND'
		put: 16r277C
		"Service not found.

No such service is known. The service cannot be found in the specified name space.";
		at: 'WSATYPE_NOT_FOUND'
		put: 16r277D
		"Class type not found.

The specified class was not found.";
		at: 'WSA_E_NO_MORE'
		put: 16r277E
		"No more results.

No more results can be returned by the WSALookupServiceNext function.";
		at: 'WSA_E_CANCELLED'
		put: 16r277F
		"Call was canceled.

A call to the WSALookupServiceEnd function was made while this call was still processing. The call has been canceled.";
		at: 'WSAEREFUSED'
		put: 16r2780
		"Database query was refused.

A database query failed because it was actively refused.";
		at: 'WSAHOST_NOT_FOUND'
		put: 16r2AF9
		"Host not found.

No such host is known. The name is not an official host name or alias, or it cannot be found in the database(s) being queried. This error may also be returned for protocol and service queries, and means that the specified name could not be found in the relevant database.";
		at: 'WSATRY_AGAIN'
		put: 16r2AFA
		"Nonauthoritative host not found.

This is usually a temporary error during host name resolution and means that the local server did not receive a response from an authoritative server. A retry at some time later may be successful.";
		at: 'WSANO_RECOVERY'
		put: 16r2AFB
		"This is a nonrecoverable error.

This indicates that some sort of nonrecoverable error occurred during a database lookup. This may be because the database files (for example, BSD-compatible HOSTS, SERVICES, or PROTOCOLS files) could not be found, or a DNS request was returned by the server with a severe error.";
		at: 'WSANO_DATA'
		put: 16r2AFC
		"Valid name, no data record of requested type.

The requested name is valid and was found in the database, but it does not have the correct associated data being resolved for. The usual example for this is a host name-to-address translation attempt (using gethostbyname or WSAAsyncGetHostByName) which uses the DNS (Domain Name Server). An MX record is returned but no A record-indicating the host itself exists, but is not directly reachable.";
		at: 'WSA_QOS_RECEIVERS'
		put: 16r2AFD
		"QoS receivers.

At least one QoS reserve has arrived.";
		at: 'WSA_QOS_SENDERS'
		put: 16r2AFE
		"QoS senders.

At least one QoS send path has arrived.";
		at: 'WSA_QOS_NO_SENDERS'
		put: 16r2AFF
		"No QoS senders.

There are no QoS senders.";
		at: 'WSA_QOS_NO_RECEIVERS'
		put: 16r2B00
		"QoS no receivers.

There are no QoS receivers.";
		at: 'WSA_QOS_REQUEST_CONFIRMED'
		put: 16r2B01
		"QoS request confirmed.

The QoS reserve request has been confirmed.";
		at: 'WSA_QOS_ADMISSION_FAILURE'
		put: 16r2B02
		"QoS admission error.

A QoS error occurred due to lack of resources.";
		at: 'WSA_QOS_POLICY_FAILURE'
		put: 16r2B03
		"QoS policy failure.

The QoS request was rejected because the policy system couldn't allocate the requested resource within the existing policy.";
		at: 'WSA_QOS_BAD_STYLE'
		put: 16r2B04
		"QoS bad style.

An unknown or conflicting QoS style was encountered.";
		at: 'WSA_QOS_BAD_OBJECT'
		put: 16r2B05
		"QoS bad object.

A problem was encountered with some part of the filterspec or the provider-specific buffer in general.";
		at: 'WSA_QOS_TRAFFIC_CTRL_ERROR'
		put: 16r2B06
		"QoS traffic control error.

An error with the underlying traffic control (TC) API as the generic QoS request was converted for local enforcement by the TC API. This could be due to an out of memory error or to an internal QoS provider error.";
		at: 'WSA_QOS_GENERIC_ERROR'
		put: 16r2B07
		"QoS generic error.

A general QoS error.";
		at: 'WSA_QOS_ESERVICETYPE'
		put: 16r2B08
		"QoS service type error.

An invalid or unrecognized service type was found in the QoS flowspec.";
		at: 'WSA_QOS_EFLOWSPEC'
		put: 16r2B09
		"QoS flowspec error.

An invalid or inconsistent flowspec was found in the QOS structure.";
		at: 'WSA_QOS_EPROVSPECBUF'
		put: 16r2B0A
		"Invalid QoS provider buffer.

An invalid QoS provider-specific buffer.";
		at: 'WSA_QOS_EFILTERSTYLE'
		put: 16r2B0B
		"Invalid QoS filter style.

An invalid QoS filter style was used.";
		at: 'WSA_QOS_EFILTERTYPE'
		put: 16r2B0C
		"Invalid QoS filter type.

An invalid QoS filter type was used.";
		at: 'WSA_QOS_EFILTERCOUNT'
		put: 16r2B0D
		"Incorrect QoS filter count.

An incorrect number of QoS FILTERSPECs were specified in the FLOWDESCRIPTOR.";
		at: 'WSA_QOS_EOBJLENGTH'
		put: 16r2B0E
		"Invalid QoS object length.

An object with an invalid ObjectLength field was specified in the QoS provider-specific buffer.";
		at: 'WSA_QOS_EFLOWCOUNT'
		put: 16r2B0F
		"Incorrect QoS flow count.

An incorrect number of flow descriptors was specified in the QoS structure.";
		at: 'WSA_QOS_EUNKOWNPSOBJ'
		put: 16r2B10
		"Unrecognized QoS object.

An unrecognized object was found in the QoS provider-specific buffer.";
		at: 'WSA_QOS_EPOLICYOBJ'
		put: 16r2B11
		"Invalid QoS policy object.

An invalid policy object was found in the QoS provider-specific buffer.";
		at: 'WSA_QOS_EFLOWDESC'
		put: 16r2B12
		"Invalid QoS flow descriptor.

An invalid QoS flow descriptor was found in the flow descriptor list.";
		at: 'WSA_QOS_EPSFLOWSPEC'
		put: 16r2B13
		"Invalid QoS provider-specific flowspec.

An invalid or inconsistent flowspec was found in the QoS provider-specific buffer.";
		at: 'WSA_QOS_EPSFILTERSPEC'
		put: 16r2B14
		"Invalid QoS provider-specific filterspec.

An invalid FILTERSPEC was found in the QoS provider-specific buffer.";
		at: 'WSA_QOS_ESDMODEOBJ'
		put: 16r2B15
		"Invalid QoS shape discard mode object.

An invalid shape discard mode object was found in the QoS provider-specific buffer.";
		at: 'WSA_QOS_ESHAPERATEOBJ'
		put: 16r2B16
		"Invalid QoS shaping rate object.

An invalid shaping rate object was found in the QoS provider-specific buffer.";
		at: 'WSA_QOS_RESERVED_PETYPE'
		put: 16r2B17
		"Reserved policy QoS element type.

A reserved policy element was found in the QoS provider-specific buffer."]

{ #category : #initialization }
Socket class >> initializeProtoConstants [
	"
	Socket2 initializeProtoConstants
	"
	WindowsConstants
		at: 'IPPROTO_ICMP'
		put: 1
"The Internet Control Message Protocol (ICMP). This is a possible value when the af parameter is AF_UNSPEC, AF_INET, or AF_INET6 and the type parameter is SOCK_RAW or unspecified. This protocol value is supported on Windows XP and later.";
		at: 'IPPROTO_IGMP'
		put: 2
"The Internet Group Management Protocol (IGMP). This is a possible value when the af parameter is AF_UNSPEC, AF_INET, or AF_INET6 and the type parameter is SOCK_RAW or unspecified. This protocol value is supported on Windows XP and later.";
		at: 'BTHPROTO_RFCOMM'
		put: 3
"The Bluetooth Radio Frequency Communications (Bluetooth RFCOMM) protocol. This is a possible value when the af parameter is AF_BTH and the type parameter is SOCK_STREAM. This protocol value is supported on Windows XP with SP2 or later.";
		at: 'IPPROTO_TCP'
		put: 6
"The Transmission Control Protocol (TCP). This is a possible value when the af parameter is AF_INET or AF_INET6 and the type parameter is SOCK_STREAM.";
		at: 'IPPROTO_UDP'
		put: 17
"The User Datagram Protocol (UDP). This is a possible value when the af parameter is AF_INET or AF_INET6 and the type parameter is SOCK_DGRAM.";
		at: 'IPPROTO_ICMPV6'
		put: 58
"The Internet Control Message Protocol Version 6 (ICMPv6). This is a possible value when the af parameter is AF_UNSPEC, AF_INET, or AF_INET6 and the type parameter is SOCK_RAW or unspecified. This protocol value is supported on Windows XP and later.";
		at: 'IPPROTO_RM'
		put: 113
"The PGM protocol for reliable multicast. This is a possible value when the af parameter is AF_INET and the type parameter is SOCK_RDM. On the Windows SDK released for Windows Vista and later, this protocol is also called IPPROTO_PGM. This protocol value is only supported if the Reliable Multicast Protocol is installed."]

{ #category : #initialization }
Socket class >> initializeShutdownConstants [
	"
	Socket2 initializeShutdownConstants
	"
	WindowsConstants
		at: 'SD_RECEIVE' put: 0 "Shutdown receive operations.";
		at: 'SD_SEND' put: 1 "Shutdown send operations.";
		at: 'SD_BOTH'
		put: 2 "Shutdown both send and receive operations."]

{ #category : #'instance creation' }
Socket class >> localOnPort: anInteger [
	^self newLocal port: anInteger]

{ #category : #services }
Socket class >> logEvents: aBoolean [
	LogEvents = aBoolean ifTrue: [^self].
	LogEvents := aBoolean.
	LogEvents ifTrue: [SocketEvent enableEventLogging]]

{ #category : #'instance creation' }
Socket class >> new [
	| cls |
	cls := self == Socket ifTrue: [self currentClass] ifFalse: [self].
	^cls basicNew initialize]

{ #category : #'instance creation' }
Socket class >> newDaemon [
	^self newLocal beDaemon]

{ #category : #'instance creation' }
Socket class >> newLocal [
	^self new]

{ #category : #'instance creation' }
Socket class >> open: aString port: anInteger [
	"
	Socket open: 'mail.dm.uba.ar' port: 995
	"
	^self new host: aString; port: anInteger; open]

{ #category : #services }
Socket class >> send: data to: host on: port [
	| socket |
	socket := self connectedTo: host port: port.
	^[| buffer count |
		socket write: data.
		buffer := String new: 64.
		count := socket readInto: buffer.
		buffer copyFrom: 1 to: count]
		ensure: [socket close]]

{ #category : #defaults }
Socket class >> standardTimeout [
	^45 seconds]

{ #category : #connection }
Socket >> accept [
	| class address s |
	class := family = AF_INET ifTrue: [SOCKADDR_IN] ifFalse: [SOCKADDR_IN6].
	address := class new.
	s := self accept: address.
	s = SOCKET_ERROR ifTrue: [^nil].
	^self class new
		fromAddress: address descriptor: s;
		type: type;
		protocol: protocol;
		host: host;
		binary: binary;
		blocking: blocking]

{ #category : #connection }
Socket >> accept: aSOCKADDR [
	| addr length |
	aSOCKADDR isNil
		ifTrue: [^Ws2_32DLL current accept: self asParameter addr: 0 addrlen: 0].
	addr := aSOCKADDR externalCopy.
	length := ExternalInt32 fromInteger: aSOCKADDR sizeInBytes.
	length := length externalCopy.
	^[| return code |
		[
			return := Ws2_32DLL current
				accept: self asParameter
				addr: addr asParameter
				addrlen: length asParameter.
			code := Ws2_32DLL current getLastError] evaluateAtomically.
		return = SOCKET_ERROR ifTrue: [self socketError: code].
		aSOCKADDR fillFrom: addr contents.
		return]
		ensure: [
			addr free.
			length free]]

{ #category : #private }
Socket >> addressInfo [
	^ADDRINFOW fromSocket: self]

{ #category : #converting }
Socket >> asParameter [
	^descriptor]

{ #category : #private }
Socket >> basicClose [
	| dll return code d |
	descriptor isNil ifTrue: [^self].
	d := descriptor.
	descriptor := nil.
	dll := Ws2_32DLL current.
	[
		return := dll closesocket: d.
		code := dll getLastError] evaluateAtomically.
	state := #closed.
	return = SOCKET_ERROR ifTrue: [self socketError: code]]

{ #category : #accessing }
Socket >> beBinary [
	self binary: true]

{ #category : #blocking }
Socket >> beBlocking [
	| zero |
	SocketEvent unregister: self.
	zero := ExternalInt32 fromInteger: false asParameter.
	self command: FIONBIO with: zero.
	blocking := true]

{ #category : #accessing }
Socket >> beDaemon [
	daemon := true]

{ #category : #accessing }
Socket >> binary: aBoolean [
	binary := aBoolean]

{ #category : #converting }
Socket >> binaryReadStream [
	^self propertyAt: #binaryReadStream ifAbsentPut: [self readStream beBinary]]

{ #category : #converting }
Socket >> binaryWriteStream [
	^self
		propertyAt: #binaryWriteStream
		ifAbsentPut: [self writeStream beBinary]]

{ #category : #connection }
Socket >> bind [
	self bind: self sockaddr.
	port := self getPort]

{ #category : #private }
Socket >> bind: aSOCKADDR [
	| return addr |
	addr := aSOCKADDR externalCopy.
	^[| code |
		[
			return := Ws2_32DLL current
				bind: self asParameter
				name: addr asParameter
				namelen: aSOCKADDR sizeInBytes.
			code := Ws2_32DLL current getLastError] evaluateAtomically.
		return = SOCKET_ERROR ifTrue: [self socketError: code].
		state := #bound.
		return]
		ensure: [addr free]]

{ #category : #blocking }
Socket >> blocking: aBoolean [
	aBoolean ifTrue: [self beBlocking] ifFalse: [self nonBlocking]]

{ #category : #private }
Socket >> bytesToRead [
	| long |
	long := ExternalInt32 new.
	self command: FIONREAD with: long.
	^long asInteger]

{ #category : #'open/close' }
Socket >> close [
	descriptor isNil ifTrue: [^self].
	blocking ifFalse: [SocketEvent unregister: self].
	ssl notNil ifTrue: [
		ssl disconnectFromServer.
		ssl := nil].
	self basicClose.
	self shuttingDown: false; release; ignoreFinalization]

{ #category : #private }
Socket >> command: cmd with: data [
	| return buffer |
	buffer := data externalCopy.
	[| code |
		[
			return := Ws2_32DLL current
				ioctlsocket: self asParameter
				cmd: cmd
				argp: buffer asParameter.
			code := Ws2_32DLL current getLastError] evaluateAtomically.
		return = SOCKET_ERROR ifTrue: [self socketError: code].
		data fillFrom: buffer contents]
		ensure: [buffer free]]

{ #category : #connection }
Socket >> connect [
	| code |
	self
		when: #connectionCompleted do: [self removeAllActionsFor: self];
		when: #socketError: do: [:e | 
			self log: (SocketError descriptionFor: e) asString.
			code isNil ifTrue: [code := e].
			address := address next.
			address isNil
				ifTrue: [
					self removeAllActionsFor: self.
					SocketError signalOSCode: code]
				ifFalse: [self performDeferred: #retryConnectionWith: with: address]].
	self connect: address sockaddr.
	^self isConnected]

{ #category : #private }
Socket >> connect: aSOCKADDR [
	| return addr |
	addr := aSOCKADDR externalCopy.
	[| code |
		[
			return := Ws2_32DLL current
				connect: self asParameter
				name: addr asParameter
				namelen: addr sizeInBytes.
			code := Ws2_32DLL current getLastError] evaluateAtomically.
		return = SOCKET_ERROR
			ifTrue: [
				code = WSAEWOULDBLOCK
					ifTrue: [return := 0]
					ifFalse: [self socketError: code]]
			ifFalse: [self justConnected]]
		ensure: [addr free].
	^return = 0]

{ #category : #connection }
Socket >> connectTo: aString port: anInteger [
	^self
		host: aString;
		port: anInteger;
		open;
		connect]

{ #category : #accessing }
Socket >> descriptor [
	^descriptor]

{ #category : #events }
Socket >> dispatchShuttingDown [
	self isShuttingDown ifFalse: [self triggerEvent: #shuttingDown; shutdown].
	self close]

{ #category : #events }
Socket >> enabledEvents [
	^events]

{ #category : #events }
Socket >> enableEvents: aCollection [
	blocking := false.
	events isNil ifTrue: [events := Set new].
	events addAll: aCollection.
	SocketEvent register: self]

{ #category : #accessing }
Socket >> eol: aString [
	self readStream eol: aString.
	self writeStream eol: aString]

{ #category : #accessing }
Socket >> errorClass [
	^SocketError]

{ #category : #accessing }
Socket >> family [
	^family]

{ #category : #accessing }
Socket >> family: anInteger [
	family := anInteger]

{ #category : #finalization }
Socket >> finalize [
	[self release; close] on: SocketError do: []]

{ #category : #accessing }
Socket >> fromAddress: aSOCKADDR descriptor: aNumber [
	descriptor := aNumber.
	family := aSOCKADDR family.
	port := aSOCKADDR port.
	state := #open]

{ #category : #inquiries }
Socket >> getPort [
	^self getSOCKADDR port]

{ #category : #inquiries }
Socket >> getSOCKADDR [
	| class addr length |
	class := family = AF_INET ifTrue: [SOCKADDR_IN] ifFalse: [SOCKADDR_IN6].
	addr := class new externalCopy.
	length := class sizeInBytes asExternalInt32 externalCopy.
	^[| return code |
		[
			return := Ws2_32DLL current
				getsockname: descriptor
				name: addr asParameter
				namelen: length asParameter.
			code := Ws2_32DLL current getLastError] evaluateAtomically.
		return = SOCKET_ERROR ifTrue: [self socketError: code].
		class fromMemory: addr contents]
		ensure: [
			addr free.
			length free]]

{ #category : #events }
Socket >> handleEvent: aSocketEvent [
	| selector |
	selector := aSocketEvent selector.
	blocking ifFalse: [
		selector == #connectionCompleted ifTrue: [self justConnected].
		selector == #shuttingDown
			ifTrue: [self dispatchShuttingDown]
			ifFalse: [self triggerEvent: selector]]]

{ #category : #testing }
Socket >> hasPendingData [
	self isOpen ifFalse: [^false].
	^self isDataAvailable or: [self readStream hasPendingData]]

{ #category : #accessing }
Socket >> host [
	^host]

{ #category : #accessing }
Socket >> host: aString [
	host := aString]

{ #category : #inquiries }
Socket >> hostName [
	^host]

{ #category : #initialization }
Socket >> initialize [
	super initialize.
	self requireFinalization.
	family := AF_UNSPEC.
	type := SOCK_STREAM.
	protocol := IPPROTO_TCP.
	blocking := true.
	binary := daemon := false.
	state := #closed]

{ #category : #testing }
Socket >> isAsynchronous [
	^blocking not]

{ #category : #testing }
Socket >> isBinary [
	^binary]

{ #category : #testing }
Socket >> isBlocking [
	^blocking]

{ #category : #testing }
Socket >> isConnected [
	^state == #connected]

{ #category : #testing }
Socket >> isDaemon [
	^daemon]

{ #category : #testing }
Socket >> isDataAvailable [
	^self bytesToRead > 0]

{ #category : #testing }
Socket >> isOpen [
	^descriptor notNil]

{ #category : #'open/close' }
Socket >> isShuttingDown [
	^self propertyAt: #shutdown ifAbsent: false]

{ #category : #private }
Socket >> justConnected [
	state == #connected ifTrue: [^self].
	state := #connected.
	host := self peerName.
	self triggerEvent: #connectionCompleted]

{ #category : #connection }
Socket >> listen [
	self listen: SOMAXCONN]

{ #category : #connection }
Socket >> listen: anInteger [
	| return code |
	[
		return := Ws2_32DLL current listen: self asParameter backlog: anInteger.
		code := Ws2_32DLL current getLastError] evaluateAtomically.
	return = SOCKET_ERROR ifTrue: [self socketError: code].
	state := #listening.
	^return]

{ #category : #blocking }
Socket >> nonBlocking [
	| one |
	one := ExternalInt32 fromInteger: true asParameter.
	self command: FIONBIO with: one.
	blocking := false.
	self enableEvents: self requiredEvents]

{ #category : #'open/close' }
Socket >> open [
	self ASSERT: descriptor isNil.
	address := ADDRINFOW fromSocket: self.
	self openWith: address]

{ #category : #'open/close' }
Socket >> openWith: anADDRINFOW [
	| return code address |
	address := anADDRINFOW.
	[
		return := Ws2_32DLL current
			socket: address ai_family
			type: address ai_socktype
			protocol: address ai_protocol.
		code := Ws2_32DLL current getLastError] evaluateAtomically.
	return = SOCKET_ERROR ifTrue: [self socketError: code].
	descriptor := return.
	family := anADDRINFOW ai_family.
	type := anADDRINFOW ai_socktype.
	protocol := anADDRINFOW ai_protocol.
	state := #open.
	blocking ifFalse: [self nonBlocking]]

{ #category : #'read/write' }
Socket >> peek: anInteger [
	| class data |
	class := binary ifTrue: [ByteArray] ifFalse: [String].
	data := class new: anInteger.
	self readInto: data startingAt: 1 length: anInteger flags: MSG_PEEK.
	^data]

{ #category : #private }
Socket >> peerAddress [
	| copy length |
	copy := SOCKADDR_IN6 new externalCopy.
	length := copy sizeInBytes asExternalInt32 externalCopy.
	^[| return class code |
		[
			return := Ws2_32DLL current
				getpeername: self asParameter
				name: copy asParameter
				namelen: length asParameter.
			code := Ws2_32DLL current getLastError] evaluateAtomically.
		return = SOCKET_ERROR ifTrue: [self socketError: code].
		class := length asInteger = SOCKADDR_IN sizeInBytes
			ifTrue: [SOCKADDR_IN]
			ifFalse: [SOCKADDR_IN6].
		class fromMemory: copy contents]
		ensure: [
			copy free.
			length free]]

{ #category : #inquiries }
Socket >> peerName [
	^self peerAddress resolve]

{ #category : #accessing }
Socket >> port [
	^port]

{ #category : #accessing }
Socket >> port: anInteger [
	port := anInteger]

{ #category : #printing }
Socket >> printOn: aStream [
	aStream
		nextPutAll: 'Socket ';
		nextPutAll: descriptor asString;
		nextPutAll: ' (';
		nextPutAll: state storeString;
		nextPutAll: ' - port: ';
		nextPutAll: port asString;
		nextPut: $)]

{ #category : #accessing }
Socket >> protocol [
	^protocol]

{ #category : #accessing }
Socket >> protocol: anInteger [
	protocol := anInteger]

{ #category : #'read/write' }
Socket >> read [
	| class buffer n count stream decrypted |
	n := self bytesToRead.
	n = 0 ifTrue: [^#[]].
	buffer := n externalBytes.
	stream := buffer writeStream.
	^[
		[
			count := self readInto: buffer startingAt: stream position + 1.
			ssl notNil ifTrue: [
				stream position: stream position + count.
				decrypted isNil ifTrue: [decrypted := (ByteArray new: n) writeStream].
				ssl decrypt: stream on: decrypted]]
			repeatUntil: [self shouldContinueReading not].
		decrypted notNil ifTrue: [^decrypted contents].
		class := binary ifTrue: [ByteArray] ifFalse: [String].
		(class new: count) replaceFrom: 1 to: count with: buffer startingAt: 1]
		ensure: [buffer free]]

{ #category : #'read/write' }
Socket >> readInto: data [
	^self readInto: data length: data length]

{ #category : #private }
Socket >> readInto: data length: length [
	^self readInto: data length: length flags: 0]

{ #category : #private }
Socket >> readInto: data length: length flags: flags [
	^self
		readInto: data
		startingAt: 1
		length: length
		flags: flags]

{ #category : #private }
Socket >> readInto: data startingAt: anInteger [
	| index n |
	index := anInteger.
	[
		n := self bytesToRead min: data length - index + 1.
		n > 0]
		whileTrue: [| r |
			r := self readInto: data startingAt: index length: n flags: 0.
			index := index + r].
	^index - anInteger]

{ #category : #private }
Socket >> readInto: data
startingAt: anInteger
length: length
flags: flags [
	| memory return offset |
	memory := data isExternalMemory
		ifTrue: [data]
		ifFalse: [length externalBytes].
	offset := data isExternalMemory ifTrue: [anInteger - 1] ifFalse: [0].
	return := self receiveInBuffer: memory + offset length: length flags: flags.
	data == memory ifFalse: [
		data
			replaceFrom: anInteger
			to: return + anInteger - 1
			with: memory
			startingAt: 1.
		memory free].
	^return]

{ #category : #converting }
Socket >> readStream [
	^self propertyAt: #readStream ifAbsentPut: [SocketReadStream on: self]]

{ #category : #private }
Socket >> receiveInBuffer: anExternalMemory length: anInteger flags: flags [
	| return code |
	[
		return := Ws2_32DLL current
			recv: self asParameter
			buf: anExternalMemory asParameter
			len: anInteger
			flags: flags.
		code := return = SOCKET_ERROR ifTrue: [Ws2_32DLL current getLastError]] evaluateAtomically.
	code notNil ifTrue: [
		code = WSAEWOULDBLOCK ifTrue: [return := 0].
		self socketError: code].
	^return]

{ #category : #finalization }
Socket >> release [
	blocking ifFalse: [SocketEvent unregister: self].
	^super release]

{ #category : #events }
Socket >> requiredEvents [
	^daemon
		ifTrue: [{FD_ACCEPT. FD_CLOSE}]
		ifFalse: [{FD_READ. FD_WRITE. FD_CLOSE. FD_CONNECT}]]

{ #category : #connection }
Socket >> retryConnectionWith: anADDRINFO [
	self basicClose; openWith: anADDRINFO; connect: anADDRINFO sockaddr]

{ #category : #private }
Socket >> sendBuffer: data length: length flags: flags [
	| return code |
	[
		return := Ws2_32DLL current
			send: self asParameter
			buf: data asParameter
			len: length
			flags: flags.
		code := return = SOCKET_ERROR ifTrue: [Ws2_32DLL current getLastError]] evaluateAtomically.
	code notNil ifTrue: [
		code = WSAEWOULDBLOCK ifTrue: [return := 0].
		self socketError: code].
	^return]

{ #category : #testing }
Socket >> shouldContinueReading [
	^ssl notNil and: [ssl shouldContinueReading]]

{ #category : #'open/close' }
Socket >> shutdown [
	| dll trials error |
	self isShuttingDown ifTrue: [^self close].
	self shuttingDown: true.
	dll := Ws2_32DLL current.
	trials := 50.
	[| return |
		return := dll shutdown: descriptor how: SD_SEND.
		return = SOCKET_ERROR ifFalse: [^self].
		error := dll getLastError.
		error = WSAEINPROGRESS and: [trials > 0]]
		whileTrue: [
			(Delay forMilliseconds: 100) wait.
			trials := trials - 1].
	self close; socketError: error]

{ #category : #'open/close' }
Socket >> shuttingDown: aBoolean [
	aBoolean
		ifTrue: [self propertyAt: #shutdown put: true]
		ifFalse: [self removeProperty: #shutdown ifAbsent: nil]]

{ #category : #private }
Socket >> sockaddr [
	^self addressInfo sockaddr]

{ #category : #errors }
Socket >> socketError [
	^self socketError: Ws2_32DLL current getLastError]

{ #category : #errors }
Socket >> socketError: code [
	code = WSAEWOULDBLOCK ifTrue: [^self].
	code = WSAECONNABORTED ifTrue: [^self close].
	^self
		triggerEvent: #socketError:
		with: code
		defaultHandler: [SocketError signalOSCode: code]]

{ #category : #connection }
Socket >> sslAccept [
	ssl := SSL acceptOn: self]

{ #category : #connection }
Socket >> sslAcceptTarget: aString [
	ssl := SSL acceptOn: self target: aString]

{ #category : #connection }
Socket >> sslConnectTo: aString [
	ssl := SSL startOn: self target: aString.
	self isConnected ifTrue: [
		self readStream bufferSize: ssl maxBufferLength.
		self writeStream bufferSize: ssl maxBufferLength]]

{ #category : #accessing }
Socket >> tcp [
	type := SOCK_STREAM.
	protocol := IPPROTO_TCP]

{ #category : #accessing }
Socket >> timeout: aDuration [
	self readStream timeout: aDuration]

{ #category : #accessing }
Socket >> type [
	^type]

{ #category : #accessing }
Socket >> type: anInteger [
	type := anInteger]

{ #category : #accessing }
Socket >> udp [
	type := SOCK_DGRAM.
	protocol := IPPROTO_UDP]

{ #category : #accessing }
Socket >> useIPV4 [
	family := AF_INET]

{ #category : #accessing }
Socket >> useIPV6 [
	family := AF_INET6]

{ #category : #'read/write' }
Socket >> waitForDataFor: aDuration [
	self isDataAvailable ifTrue: [^self].
	self
		waitForDataFor: aDuration
		ifClosed: [self error: 'Socket closed']
		ifTimedOut: [Timeout signal]]

{ #category : #'read/write' }
Socket >> waitForDataFor: aDuration ifClosed: aBlock ifTimedOut: anotherBlock [
	| timeout |
	timeout := aDuration milliseconds + Duration millisecondClockValue.
	[| in |
		self isDataAvailable ifTrue: [^self].
		self isOpen ifFalse: [^aBlock value].
		in := Duration millisecondClockValue < timeout.
		Delay wait: 10.
		in] whileTrue.
	^anotherBlock value]

{ #category : #'read/write' }
Socket >> write: data [
	| buffer |
	buffer := ssl notNil
		ifTrue: [
			self ASSERT: data size <= ssl maxBufferLength.
			ssl encrypt: data asByteArray]
		ifFalse: [data].
	^self write: buffer length: buffer size]

{ #category : #private }
Socket >> write: data length: length [
	| sent buffer |
	buffer := data asByteArray externalCopy.
	[sent := self sendBuffer: buffer length: length flags: 0]
		ensure: [buffer free].
	(ssl notNil and: [sent < length]) ifTrue: [self error: 'Incomplete writing'].
	^sent]

{ #category : #converting }
Socket >> writeStream [
	^self propertyAt: #writeStream ifAbsentPut: [SocketWriteStream on: self]]

