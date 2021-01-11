"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #URL_COMPONENTS,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Client'
}

{ #category : #accessing }
URL_COMPONENTS class >> def [
	^<def>
	typedef struct {
		DWORD           dwStructSize;
		LPTSTR          lpszScheme;
		DWORD           dwSchemeLength;
		INTERNET_SCHEME nScheme;
		LPTSTR          lpszHostName;
		DWORD           dwHostNameLength;
		INTERNET_PORT   nPort;
		LPTSTR          lpszUserName;
		DWORD           dwUserNameLength;
		LPTSTR          lpszPassword;
		DWORD           dwPasswordLength;
		LPTSTR          lpszUrlPath;
		DWORD           dwUrlPathLength;
		LPTSTR          lpszExtraInfo;
		DWORD           dwExtraInfoLength;
	} URL_COMPONENTS, *LPURL_COMPONENTS;
	</def>]

{ #category : #private }
URL_COMPONENTS class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 104;
		at: 'dwStructSize' put: 0;
		at: 'lpszScheme' put: 8;
		at: 'dwSchemeLength' put: 16;
		at: 'nScheme' put: 20;
		at: 'lpszHostName' put: 24;
		at: 'dwHostNameLength' put: 32;
		at: 'nPort' put: 36;
		at: 'lpszUserName' put: 40;
		at: 'dwUserNameLength' put: 48;
		at: 'lpszPassword' put: 56;
		at: 'dwPasswordLength' put: 64;
		at: 'lpszUrlPath' put: 72;
		at: 'dwUrlPathLength' put: 80;
		at: 'lpszExtraInfo' put: 88;
		at: 'dwExtraInfoLength' put: 96;
		yourself]

{ #category : #accessing }
URL_COMPONENTS class >> sizeInBytes [
	^sizeInBytes]

{ #category : #private }
URL_COMPONENTS class >> typedefTable [
	^WininetDLL typedefTable]

{ #category : #accessing }
URL_COMPONENTS >> dwExtraInfoLength [
	^self uLongAtOffset: dwExtraInfoLength]

{ #category : #accessing }
URL_COMPONENTS >> dwExtraInfoLength: anInteger [
	self uLongAtOffset: dwExtraInfoLength put: anInteger]

{ #category : #accessing }
URL_COMPONENTS >> dwHostNameLength [
	^self uLongAtOffset: dwHostNameLength]

{ #category : #accessing }
URL_COMPONENTS >> dwHostNameLength: anInteger [
	self uLongAtOffset: dwHostNameLength put: anInteger]

{ #category : #accessing }
URL_COMPONENTS >> dwPasswordLength [
	^self uLongAtOffset: dwPasswordLength]

{ #category : #accessing }
URL_COMPONENTS >> dwPasswordLength: anInteger [
	self uLongAtOffset: dwPasswordLength put: anInteger]

{ #category : #accessing }
URL_COMPONENTS >> dwSchemeLength [
	^self uLongAtOffset: dwSchemeLength]

{ #category : #accessing }
URL_COMPONENTS >> dwSchemeLength: anInteger [
	self uLongAtOffset: dwSchemeLength put: anInteger]

{ #category : #accessing }
URL_COMPONENTS >> dwStructSize [
	^self uLongAtOffset: dwStructSize]

{ #category : #accessing }
URL_COMPONENTS >> dwStructSize: anInteger [
	self uLongAtOffset: dwStructSize put: anInteger]

{ #category : #accessing }
URL_COMPONENTS >> dwUrlPathLength [
	^self uLongAtOffset: dwUrlPathLength]

{ #category : #accessing }
URL_COMPONENTS >> dwUrlPathLength: anInteger [
	self uLongAtOffset: dwUrlPathLength put: anInteger]

{ #category : #accessing }
URL_COMPONENTS >> dwUserNameLength [
	^self uLongAtOffset: dwUserNameLength]

{ #category : #accessing }
URL_COMPONENTS >> dwUserNameLength: anInteger [
	self uLongAtOffset: dwUserNameLength put: anInteger]

{ #category : #output }
URL_COMPONENTS >> extraInfo [
	^WideString fromMemory: self lpszExtraInfo length: self dwExtraInfoLength]

{ #category : #output }
URL_COMPONENTS >> hostName [
	^WideString fromMemory: self lpszHostName length: self dwHostNameLength]

{ #category : #initialization }
URL_COMPONENTS >> initialize: anInteger [
	super initialize: anInteger.
	self dwStructSize: anInteger.
	self initializeBuffers]

{ #category : #initialization }
URL_COMPONENTS >> initializeBuffers [
	| buffer n |
	buffer := WideString new: 256.
	n := buffer size.
	self
		lpszExtraInfo: buffer externalCopy;
		dwExtraInfoLength: n;
		lpszHostName: buffer externalCopy;
		dwHostNameLength: n;
		lpszPassword: buffer externalCopy;
		dwPasswordLength: n;
		lpszScheme: buffer externalCopy;
		dwSchemeLength: n;
		lpszUrlPath: buffer externalCopy;
		dwUrlPathLength: n;
		lpszUserName: buffer externalCopy;
		dwUserNameLength: n]

{ #category : #accessing }
URL_COMPONENTS >> lpszExtraInfo [
	^self addressAtOffset: lpszExtraInfo]

{ #category : #accessing }
URL_COMPONENTS >> lpszExtraInfo: anExternalMemory [
	self addressAtOffset: lpszExtraInfo register: anExternalMemory]

{ #category : #accessing }
URL_COMPONENTS >> lpszHostName [
	^self addressAtOffset: lpszHostName]

{ #category : #accessing }
URL_COMPONENTS >> lpszHostName: anExternalMemory [
	self addressAtOffset: lpszHostName register: anExternalMemory]

{ #category : #accessing }
URL_COMPONENTS >> lpszPassword [
	^self addressAtOffset: lpszPassword]

{ #category : #accessing }
URL_COMPONENTS >> lpszPassword: anExternalMemory [
	self addressAtOffset: lpszPassword register: anExternalMemory]

{ #category : #accessing }
URL_COMPONENTS >> lpszScheme [
	^self addressAtOffset: lpszScheme]

{ #category : #accessing }
URL_COMPONENTS >> lpszScheme: anExternalMemory [
	self addressAtOffset: lpszScheme register: anExternalMemory]

{ #category : #accessing }
URL_COMPONENTS >> lpszUrlPath [
	^self addressAtOffset: lpszUrlPath]

{ #category : #accessing }
URL_COMPONENTS >> lpszUrlPath: anExternalMemory [
	self addressAtOffset: lpszUrlPath register: anExternalMemory]

{ #category : #accessing }
URL_COMPONENTS >> lpszUserName [
	^self addressAtOffset: lpszUserName]

{ #category : #accessing }
URL_COMPONENTS >> lpszUserName: anExternalMemory [
	self addressAtOffset: lpszUserName register: anExternalMemory]

{ #category : #accessing }
URL_COMPONENTS >> nPort [
	^self uLongAtOffset: nPort]

{ #category : #accessing }
URL_COMPONENTS >> nPort: anInteger [
	self uLongAtOffset: nPort put: anInteger]

{ #category : #accessing }
URL_COMPONENTS >> nScheme [
	^self uLongAtOffset: nScheme]

{ #category : #accessing }
URL_COMPONENTS >> nScheme: anInteger [
	self uLongAtOffset: nScheme put: anInteger]

{ #category : #output }
URL_COMPONENTS >> password [
	^WideString fromMemory: self lpszPassword length: self dwPasswordLength]

{ #category : #output }
URL_COMPONENTS >> scheme [
	^WideString fromMemory: self lpszScheme length: self dwSchemeLength]

{ #category : #output }
URL_COMPONENTS >> urlPath [
	^WideString fromMemory: self lpszUrlPath length: self dwUrlPathLength]

{ #category : #output }
URL_COMPONENTS >> username [
	^WideString fromMemory: self lpszUserName length: self dwUserNameLength]

