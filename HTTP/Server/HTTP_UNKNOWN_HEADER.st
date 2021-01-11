"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_UNKNOWN_HEADER,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_UNKNOWN_HEADER class >> aspects [
	^#(#name #rawValue)]

{ #category : #accessing }
HTTP_UNKNOWN_HEADER class >> def [
	^<def>
	typedef struct _HTTP_UNKNOWN_HEADER {
		USHORT NameLength;
		USHORT RawValueLength;
		PCSTR  pName;
		PCSTR  pRawValue;
	} HTTP_UNKNOWN_HEADER, *PHTTP_UNKNOWN_HEADER;
	</def>]

{ #category : #'instance creation' }
HTTP_UNKNOWN_HEADER class >> name: aString value: aString2 [
	^self new name: aString; value: aString2]

{ #category : #private }
HTTP_UNKNOWN_HEADER class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 24;
		at: 'NameLength' put: 0;
		at: 'RawValueLength' put: 2;
		at: 'pName' put: 8;
		at: 'pRawValue' put: 16;
		yourself]

{ #category : #accessing }
HTTP_UNKNOWN_HEADER class >> sizeInBytes [
	^sizeInBytes]

{ #category : #output }
HTTP_UNKNOWN_HEADER >> name [
	^String fromMemory: self pName length: self NameLength]

{ #category : #input }
HTTP_UNKNOWN_HEADER >> name: aString [
	self pName: aString ansiz externalCopy; NameLength: aString size]

{ #category : #accessing }
HTTP_UNKNOWN_HEADER >> NameLength [
	^self uShortAtOffset: NameLength]

{ #category : #accessing }
HTTP_UNKNOWN_HEADER >> NameLength: anInteger [
	self uShortAtOffset: NameLength put: anInteger]

{ #category : #accessing }
HTTP_UNKNOWN_HEADER >> pName [
	^self addressAtOffset: pName]

{ #category : #accessing }
HTTP_UNKNOWN_HEADER >> pName: anExternalMemory [
	self addressAtOffset: pName register: anExternalMemory]

{ #category : #accessing }
HTTP_UNKNOWN_HEADER >> pRawValue [
	^self addressAtOffset: pRawValue]

{ #category : #accessing }
HTTP_UNKNOWN_HEADER >> pRawValue: anExternalMemory [
	self addressAtOffset: pRawValue register: anExternalMemory]

{ #category : #output }
HTTP_UNKNOWN_HEADER >> rawValue [
	^String fromMemory: self pRawValue length: self RawValueLength]

{ #category : #accessing }
HTTP_UNKNOWN_HEADER >> RawValueLength [
	^self uShortAtOffset: RawValueLength]

{ #category : #accessing }
HTTP_UNKNOWN_HEADER >> RawValueLength: anInteger [
	self uShortAtOffset: RawValueLength put: anInteger]

{ #category : #input }
HTTP_UNKNOWN_HEADER >> value: aString [
	self
		pRawValue: aString ansiz externalCopy;
		RawValueLength: aString ansiz size - 1]

