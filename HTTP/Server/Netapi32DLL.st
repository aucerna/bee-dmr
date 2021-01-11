"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #Netapi32DLL,
	#superclass : #WindowsLibrary,
	#type : #bytes,
	#category : #'HTTP\Server'
}

{ #category : #initialization }
Netapi32DLL class >> initializeConstants [
	WinConstants
		at: 'MAX_PREFERRED_LENGTH' put: -1;
		at: 'ERROR_MORE_DATA' put: 234;
		at: 'ERROR_ACCESS_DENIED' put: 5;
		at: 'NERR_InvalidComputer' put: 2351;
		at: 'NERR_Success' put: 0;
		at: 'NERR_BufTooSmall' put: 2123]

{ #category : #accessing }
Netapi32DLL class >> moduleName [
	^'netapi32']

{ #category : #groups }
Netapi32DLL >> localGroupsOn: server [
	"
	Netapi32DLL current localGroupsOn: 'gauss'
	"
	| name buffer count total next result memory addresses groups |
	name := server externalCopy.
	buffer := ExternalPointer external.
	count := ExternalInt32 external.
	total := ExternalInt32 external.
	next := ExternalPointer external.
	result := self
		NetLocalGroupEnum: name asParameter
		level: 0
		bufptr: buffer asParameter
		prefmaxlen: MAX_PREFERRED_LENGTH asParameter
		entriesread: count asParameter
		totalentries: total asParameter
		resumehandle: next asParameter.
	memory := buffer pointedMemory.
	result = NERR_Success ifTrue: [
		addresses := BufferArray
			at: memory
			count: count asInteger
			type: ExternalPointer.
		groups := addresses localCopy asArray
			collect: [:p | WideString fromMemory: p pointedMemory]].
	self NetApiBufferFree: memory asParameter.
	name free.
	buffer free.
	count free.
	total free.
	next free.
	^groups]

{ #category : #groups }
Netapi32DLL >> NetApiBufferFree: Buffer [
	<ulong: NetApiBufferFree>
	^self invalidArgument

"
NET_API_STATUS NetApiBufferFree(
  _In_ LPVOID Buffer
);
"]

{ #category : #groups }
Netapi32DLL >> NetLocalGroupEnum: servername
level: integer
bufptr: buffer
prefmaxlen: max
entriesread: count
totalentries: total
resumehandle: next [
	<ulong: NetLocalGroupEnum>
	^self invalidArgument

"
NET_API_STATUS NetLocalGroupEnum(
  _In_    LPCWSTR    servername,
  _In_    DWORD      level,
  _Out_   LPBYTE     *bufptr,
  _In_    DWORD      prefmaxlen,
  _Out_   LPDWORD    entriesread,
  _Out_   LPDWORD    totalentries,
  _Inout_ PDWORD_PTR resumehandle
);
"]

