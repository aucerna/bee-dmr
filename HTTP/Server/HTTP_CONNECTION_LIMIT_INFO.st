"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_CONNECTION_LIMIT_INFO,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_CONNECTION_LIMIT_INFO class >> aspects [
	^#(#Flags
		#MaxConnections)]

{ #category : #private }
HTTP_CONNECTION_LIMIT_INFO class >> def [
	^<def>
	typedef struct {
		HTTP_PROPERTY_FLAGS Flags;
		ULONG               MaxConnections;
	} HTTP_CONNECTION_LIMIT_INFO, *PHTTP_CONNECTION_LIMIT_INFO;
	</def>]

{ #category : #accessing }
HTTP_CONNECTION_LIMIT_INFO class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
HTTP_CONNECTION_LIMIT_INFO >> Flags [
	^self structureAtOffset: Flags ofClass: HTTP_PROPERTY_FLAGS]

{ #category : #accessing }
HTTP_CONNECTION_LIMIT_INFO >> Flags: aHTTP_PROPERTY_FLAGS [
	self bytesAtOffset: Flags put: aHTTP_PROPERTY_FLAGS asParameter]

{ #category : #accessing }
HTTP_CONNECTION_LIMIT_INFO >> initialize: anInteger [
	super initialize: anInteger.
	self Flags: HTTP_PROPERTY_FLAGS present]

{ #category : #accessing }
HTTP_CONNECTION_LIMIT_INFO >> MaxConnections [
	^self uLongAtOffset: MaxConnections]

{ #category : #accessing }
HTTP_CONNECTION_LIMIT_INFO >> MaxConnections: anInteger [
	self uLongAtOffset: MaxConnections put: anInteger]

