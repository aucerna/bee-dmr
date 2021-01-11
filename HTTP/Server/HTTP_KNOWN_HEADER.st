"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_KNOWN_HEADER,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_KNOWN_HEADER class >> aspects [
	^#(#rawValue)]

{ #category : #accessing }
HTTP_KNOWN_HEADER class >> def [
	^<def>
	typedef struct _HTTP_KNOWN_HEADER {
		USHORT RawValueLength;
		PCSTR  pRawValue;
	} HTTP_KNOWN_HEADER, *PHTTP_KNOWN_HEADER;
	</def>]

{ #category : #private }
HTTP_KNOWN_HEADER class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 16;
		at: 'RawValueLength' put: 0;
		at: 'pRawValue' put: 8;
		yourself]

{ #category : #accessing }
HTTP_KNOWN_HEADER class >> sizeInBytes [
	^sizeInBytes]

{ #category : #'instance creation' }
HTTP_KNOWN_HEADER class >> with: aString [
	^self new value: aString]

{ #category : #testing }
HTTP_KNOWN_HEADER >> hasData [
	^self RawValueLength != 0]

{ #category : #accessing }
HTTP_KNOWN_HEADER >> pRawValue [
	^self addressAtOffset: pRawValue]

{ #category : #accessing }
HTTP_KNOWN_HEADER >> pRawValue: anExternalMemory [
	self addressAtOffset: pRawValue register: anExternalMemory]

{ #category : #printing }
HTTP_KNOWN_HEADER >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		space;
		nextPutAll: self rawValue storeString]

{ #category : #output }
HTTP_KNOWN_HEADER >> rawValue [
	| memory |
	memory := self pRawValue.
	^memory isValid
		ifTrue: [String fromMemory: memory length: self RawValueLength]]

{ #category : #accessing }
HTTP_KNOWN_HEADER >> RawValueLength [
	^self uShortAtOffset: RawValueLength]

{ #category : #accessing }
HTTP_KNOWN_HEADER >> RawValueLength: anInteger [
	self uShortAtOffset: RawValueLength put: anInteger]

{ #category : #input }
HTTP_KNOWN_HEADER >> value: aString [
	self
		pRawValue: aString ansiz externalCopy;
		RawValueLength: aString ansiz size - 1]

{ #category : #input }
HTTP_KNOWN_HEADER >> valueLength: anInteger [
	self RawValueLength: anInteger]

