"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_FLOWRATE_INFO,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_FLOWRATE_INFO class >> aspects [
	^#(#Flags
		#MaxBandwidth
		#MaxPeakBandwidth
		#BurstSize)]

{ #category : #private }
HTTP_FLOWRATE_INFO class >> def [
	^<def>
	typedef struct _HTTP_FLOWRATE_INFO {
		HTTP_PROPERTY_FLAGS  Flags;
		ULONG                MaxBandwidth;
		ULONG                MaxPeakBandwidth;
		ULONG                BurstSize;
	} HTTP_FLOWRATE_INFO, *PHTTP_FLOWRATE_INFO;
	</def>]

{ #category : #accessing }
HTTP_FLOWRATE_INFO class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
HTTP_FLOWRATE_INFO >> BurstSize [
	^self uLongAtOffset: BurstSize]

{ #category : #accessing }
HTTP_FLOWRATE_INFO >> BurstSize: anInteger [
	self uLongAtOffset: BurstSize put: anInteger]

{ #category : #accessing }
HTTP_FLOWRATE_INFO >> Flags [
	^self structureAtOffset: Flags ofClass: HTTP_PROPERTY_FLAGS]

{ #category : #accessing }
HTTP_FLOWRATE_INFO >> Flags: aHTTP_PROPERTY_FLAGS [
	self bytesAtOffset: Flags put: aHTTP_PROPERTY_FLAGS asParameter]

{ #category : #initialization }
HTTP_FLOWRATE_INFO >> initialize: anInteger [
	super initialize: anInteger.
	self Flags: HTTP_PROPERTY_FLAGS present]

{ #category : #accessing }
HTTP_FLOWRATE_INFO >> MaxBandwidth [
	^self uLongAtOffset: MaxBandwidth]

{ #category : #accessing }
HTTP_FLOWRATE_INFO >> MaxBandwidth: anInteger [
	self uLongAtOffset: MaxBandwidth put: anInteger]

{ #category : #accessing }
HTTP_FLOWRATE_INFO >> MaxPeakBandwidth [
	^self uLongAtOffset: MaxPeakBandwidth]

{ #category : #accessing }
HTTP_FLOWRATE_INFO >> MaxPeakBandwidth: anInteger [
	self uLongAtOffset: MaxPeakBandwidth put: anInteger]

