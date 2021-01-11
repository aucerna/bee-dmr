"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_BANDWIDTH_LIMIT_INFO,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_BANDWIDTH_LIMIT_INFO class >> aspects [
	^#(#Flags
		#MaxBandwidth)]

{ #category : #private }
HTTP_BANDWIDTH_LIMIT_INFO class >> def [
	^<def>
	typedef struct {
		HTTP_PROPERTY_FLAGS Flags;
		ULONG               MaxBandwidth;
	} HTTP_BANDWIDTH_LIMIT_INFO, *PHTTP_BANDWIDTH_LIMIT_INFO;
	</def>]

{ #category : #accessing }
HTTP_BANDWIDTH_LIMIT_INFO class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
HTTP_BANDWIDTH_LIMIT_INFO >> Flags [
	^self structureAtOffset: Flags ofClass: HTTP_PROPERTY_FLAGS]

{ #category : #accessing }
HTTP_BANDWIDTH_LIMIT_INFO >> Flags: aHTTP_PROPERTY_FLAGS [
	self bytesAtOffset: Flags put: aHTTP_PROPERTY_FLAGS asParameter]

{ #category : #initialization }
HTTP_BANDWIDTH_LIMIT_INFO >> initialize: anInteger [
	super initialize: anInteger.
	self Flags: HTTP_PROPERTY_FLAGS present]

{ #category : #accessing }
HTTP_BANDWIDTH_LIMIT_INFO >> MaxBandwidth [
	^self uLongAtOffset: MaxBandwidth]

{ #category : #accessing }
HTTP_BANDWIDTH_LIMIT_INFO >> MaxBandwidth: anInteger [
	self uLongAtOffset: MaxBandwidth put: anInteger]

