"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_BINDING_INFO,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_BINDING_INFO class >> aspects [
	^#(#Flags
		#RequestQueueHandle)]

{ #category : #accessing }
HTTP_BINDING_INFO class >> def [
	^<def>
	typedef struct {
		HTTP_PROPERTY_FLAGS Flags;
		HANDLE              RequestQueueHandle;
	} HTTP_BINDING_INFO, *PHTTP_BINDING_INFO;
	</def>]

{ #category : #private }
HTTP_BINDING_INFO class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 16;
		at: 'Flags' put: 0;
		at: 'RequestQueueHandle' put: 8;
		yourself]

{ #category : #accessing }
HTTP_BINDING_INFO class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
HTTP_BINDING_INFO >> Flags [
	| data |
	data := self bytesAtOffset: Flags count: HTTP_PROPERTY_FLAGS sizeInBytes.
	^HTTP_PROPERTY_FLAGS usingBytes: data]

{ #category : #accessing }
HTTP_BINDING_INFO >> Flags: anHTTP_PROPERTY_FLAGS [
	self bytesAtOffset: Flags put: anHTTP_PROPERTY_FLAGS contents]

{ #category : #accessing }
HTTP_BINDING_INFO >> RequestQueueHandle [
	^self pointerAtOffset: RequestQueueHandle]

{ #category : #accessing }
HTTP_BINDING_INFO >> RequestQueueHandle: anInteger [
	self pointerAtOffset: RequestQueueHandle put: anInteger]

