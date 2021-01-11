"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_REQUEST_INFO,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_REQUEST_INFO class >> aspects [
	^#(
		#InfoLength
		#InfoType
		#info)]

{ #category : #accessing }
HTTP_REQUEST_INFO class >> def [
	^<def>
	typedef struct {
		HTTP_REQUEST_INFO_TYPE InfoType;
		ULONG                  InfoLength;
		PVOID                  pInfo;
	} HTTP_REQUEST_INFO, *PHTTP_REQUEST_INFO;
	</def>]

{ #category : #private }
HTTP_REQUEST_INFO class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 16;
		at: 'InfoType' put: 0;
		at: 'InfoLength' put: 4;
		at: 'pInfo' put: 8;
		yourself]

{ #category : #accessing }
HTTP_REQUEST_INFO class >> sizeInBytes [
	^sizeInBytes]

{ #category : #output }
HTTP_REQUEST_INFO >> info [
	| memory |
	memory := self pInfo.
	^memory isValid
		ifTrue: [HTTP_REQUEST_AUTH_INFO atAddress: memory length: self InfoLength]]

{ #category : #input }
HTTP_REQUEST_INFO >> info: aHTTP_REQUEST_AUTH_INFO [
	self
		pInfo: aHTTP_REQUEST_AUTH_INFO externalCopy;
		InfoLength: aHTTP_REQUEST_AUTH_INFO sizeInBytes]

{ #category : #accessing }
HTTP_REQUEST_INFO >> InfoLength [
	^self uLongAtOffset: InfoLength]

{ #category : #accessing }
HTTP_REQUEST_INFO >> InfoLength: anInteger [
	self uLongAtOffset: InfoLength put: anInteger]

{ #category : #accessing }
HTTP_REQUEST_INFO >> InfoType [
	^self uLongAtOffset: InfoType]

{ #category : #accessing }
HTTP_REQUEST_INFO >> InfoType: zero [
	self uLongAtOffset: InfoType put: zero]

{ #category : #accessing }
HTTP_REQUEST_INFO >> pInfo [
	^self addressAtOffset: pInfo]

{ #category : #accessing }
HTTP_REQUEST_INFO >> pInfo: anExternalMemory [
	self addressAtOffset: pInfo register: anExternalMemory]

