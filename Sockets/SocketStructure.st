"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SocketStructure,
	#superclass : #WindowsStructure,
	#category : #sockets
}

{ #category : #initialization }
SocketStructure class >> initializeConstants [
	"
	SocketStructure initializeConstants
	"
	self
		initializeInAddrConstants;
		initializeFioConstants;
		initializeFlags;
		initializeInetConstants;
		initializeSioConstants;
		initializeNIConstants]

{ #category : #initialization }
SocketStructure class >> initializeFioConstants [
	"
	SocketStructure initializeFioConstants
	"
	WindowsConstants
		at: 'FIONREAD' put: 16r4004667F;
		at: 'FIONBIO' put: 16r8004667E;
		at: 'FIOASYNC' put: 16r8004667D]

{ #category : #initialization }
SocketStructure class >> initializeFlags [
	"
	SocketStructure initializeFlags
	"
	WindowsConstants
		at: 'MSG_OOB' put: 16r1;
		at: 'MSG_PEEK' put: 16r2;
		at: 'MSG_DONTROUTE' put: 16r4;
		at: 'MSG_EOR' put: 16r8   "data completes record";
		at: 'MSG_EOF' put: 16r100 "data completes transaction"]

{ #category : #initialization }
SocketStructure class >> initializeInAddrConstants [
	"
	SocketStructure initializeInAddrConstants
	"
	WindowsConstants
		at: 'INADDR_ANY' put: 16r0;
		at: 'INADDR_LOOPBACK' put: 16r100007F;
		at: 'INADDR_BROADCAST' put: 16rFFFFFFFF;
		at: 'INADDR_NONE' put: 16rFFFFFFFF]

{ #category : #initialization }
SocketStructure class >> initializeInetConstants [
	"
	SocketStructure initializeInetConstants
	"
	WindowsConstants
		at: 'AF_INET' put: 2;
		at: 'PF_INET' put: 2]

{ #category : #initialization }
SocketStructure class >> initializeNIConstants [
	"
	SocketStructure initializeNIConstants
	"
	WindowsConstants
		at: 'NI_MAXSERV' put: 32;
		at: 'NI_MAXHOST' put: 1025;
		at: 'NI_DGRAM' put: 16r1;
		at: 'NI_NAMEREQD' put: 16r2;
		at: 'NI_NOFQDN' put: 16r4;
		at: 'NI_NUMERICHOST' put: 16r8;
		at: 'NI_NUMERICSCOPE' put: 16r10;
		at: 'NI_NUMERICSERV' put: 16r20]

{ #category : #initialization }
SocketStructure class >> initializeSioConstants [
	"
	SocketStructure initializeSioConstants
	"
	WindowsConstants
		at: 'SIOCADDRT' put: 16r8030720A;
		at: 'SIOCATMARK' put: 16r40047307;
		at: 'SIOCDARP' put: 16r804C6920;
		at: 'SIOCDELRT' put: 16r8030720B;
		at: 'SIOCGARP' put: 16rC04C6926;
		at: 'SIOCGHIWAT' put: 16r40047301;
		at: 'SIOCGIFADDR' put: 16rC0286921;
		at: 'SIOCGIFBRDADDR' put: 16rC0286923;
		at: 'SIOCGIFCONF' put: 16rC0086924;
		at: 'SIOCGIFDSTADDR' put: 16rC0286922;
		at: 'SIOCGIFFLAGS' put: 16rC0286911;
		at: 'SIOCGIFMETRIC' put: 16rC0286917;
		at: 'SIOCGIFNETMASK' put: 16rC0286925;
		at: 'SIOCGLOWAT' put: 16r40047303;
		at: 'SIOCSARP' put: 16r804C691E;
		at: 'SIOCSHIWAT' put: 16r80047300;
		at: 'SIOCSIFADDR' put: 16r8028690C;
		at: 'SIOCSIFBRDADDR' put: 16r80286913;
		at: 'SIOCSIFDSTADDR' put: 16r8028690E;
		at: 'SIOCSIFFLAGS' put: 16r80286910;
		at: 'SIOCSIFMETRIC' put: 16r80286918;
		at: 'SIOCSIFNETMASK' put: 16r80286916;
		at: 'SIOCSLOWAT' put: 16r80047302]

{ #category : #marshalling }
SocketStructure class >> networkFromLong: anInteger [
	^Ws2_32DLL current htonl: anInteger]

{ #category : #marshalling }
SocketStructure class >> networkFromShort: anInteger [
	^Ws2_32DLL current htons: anInteger]

{ #category : #errors }
SocketStructure class >> socketError [
	^SocketError signalOSCode: Ws2_32DLL current getLastError]

{ #category : #accessing }
SocketStructure class >> typedefTable [
	^Ws2_32DLL typedefTable]

