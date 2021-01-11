"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTPAPI_VERSION,
	#superclass : #HttpVersion,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTPAPI_VERSION class >> aspects [
	^#(#HttpApiMajorVersion
		#HttpApiMinorVersion)]

{ #category : #accessing }
HTTPAPI_VERSION class >> def [
	^<def>
	typedef struct _HTTPAPI_VERSION {
		USHORT HttpApiMajorVersion;
		USHORT HttpApiMinorVersion;
	} HTTPAPI_VERSION, *PHTTPAPI_VERSION;
	</def>]

{ #category : #accessing }
HTTPAPI_VERSION class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
HTTPAPI_VERSION >> HttpApiMajorVersion [
	^self uShortAtOffset: HttpApiMajorVersion]

{ #category : #accessing }
HTTPAPI_VERSION >> HttpApiMajorVersion: anInteger [
	self uShortAtOffset: HttpApiMajorVersion put: anInteger]

{ #category : #accessing }
HTTPAPI_VERSION >> HttpApiMinorVersion [
	^self uShortAtOffset: HttpApiMinorVersion]

{ #category : #accessing }
HTTPAPI_VERSION >> HttpApiMinorVersion: anInteger [
	self uShortAtOffset: HttpApiMinorVersion put: anInteger]

{ #category : #input }
HTTPAPI_VERSION >> major: anInteger [
	self HttpApiMajorVersion: anInteger]

{ #category : #input }
HTTPAPI_VERSION >> minor: anInteger [
	self HttpApiMinorVersion: anInteger]

