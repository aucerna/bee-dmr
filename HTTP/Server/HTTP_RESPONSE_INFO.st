"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_RESPONSE_INFO,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_RESPONSE_INFO class >> aspects [
	^#(#type #info)]

{ #category : #accessing }
HTTP_RESPONSE_INFO class >> def [
	^<def>
	typedef struct {
		HTTP_RESPONSE_INFO_TYPE Type;
		ULONG                   Length;
		PVOID                   pInfo;
	} HTTP_RESPONSE_INFO, *PHTTP_RESPONSE_INFO;
	</def>]

{ #category : #initialization }
HTTP_RESPONSE_INFO class >> initializeConstants [
	self initializeTypeConstants]

{ #category : #initialization }
HTTP_RESPONSE_INFO class >> initializeTypeConstants [
	WinConstants
		at: 'HttpResponseInfoTypeMultipleKnownHeaders' put: 0;
		at: 'HttpResponseInfoTypeAuthenticationProperty' put: 1;
		at: 'HttpResponseInfoTypeQosProperty' put: 2;
		at: 'HttpResponseInfoTypeChannelBind' put: 3]

{ #category : #private }
HTTP_RESPONSE_INFO class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 16;
		at: 'Type' put: 0;
		at: 'Length' put: 4;
		at: 'pInfo' put: 8;
		yourself]

{ #category : #accessing }
HTTP_RESPONSE_INFO class >> sizeInBytes [
	^sizeInBytes]

{ #category : #output }
HTTP_RESPONSE_INFO >> info [
	| memory |
	memory := self pInfo.
	^memory isValid ifTrue: [String fromMemory: memory length: self Length]]

{ #category : #accessing }
HTTP_RESPONSE_INFO >> Length [
	^self uLongAtOffset: Length]

{ #category : #accessing }
HTTP_RESPONSE_INFO >> pInfo [
	^self addressAtOffset: pInfo]

{ #category : #accessing }
HTTP_RESPONSE_INFO >> Type [
	^self uLongAtOffset: Type]

{ #category : #output }
HTTP_RESPONSE_INFO >> type [
	| type |
	type := self Type.
	type = HttpResponseInfoTypeMultipleKnownHeaders
		ifTrue: [^'HttpResponseInfoTypeMultipleKnownHeaders'].
	type = HttpResponseInfoTypeAuthenticationProperty
		ifTrue: [^'HttpResponseInfoTypeAuthenticationProperty'].
	type = HttpResponseInfoTypeQosProperty
		ifTrue: [^'HttpResponseInfoTypeQosProperty'].
	type = HttpResponseInfoTypeChannelBind
		ifTrue: [^'HttpResponseInfoTypeChannelBind']]

