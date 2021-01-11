"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_BYTE_RANGE,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_BYTE_RANGE class >> aspects [
	^#(#StartingOffset #Length)]

{ #category : #accessing }
HTTP_BYTE_RANGE class >> def [
	^<def>
	typedef struct _HTTP_BYTE_RANGE {
		ULARGE_INTEGER StartingOffset;
		ULARGE_INTEGER Length;
	} HTTP_BYTE_RANGE, *PHTTP_BYTE_RANGE;
	</def>]

{ #category : #accessing }
HTTP_BYTE_RANGE class >> sizeInBytes [
	^sizeInBytes]

{ #category : #private }
HTTP_BYTE_RANGE class >> typedefTable [
	^HttpApiDLL typedefTable]

{ #category : #accessing }
HTTP_BYTE_RANGE >> Length [
	^self uLargeAtOffset: Length]

{ #category : #accessing }
HTTP_BYTE_RANGE >> Length: anInteger [
	self structureAtOffset: Length put: anInteger]

{ #category : #accessing }
HTTP_BYTE_RANGE >> StartingOffset [
	^self uLargeAtOffset: StartingOffset]

{ #category : #accessing }
HTTP_BYTE_RANGE >> StartingOffset: anInteger [
	self structureAtOffset: StartingOffset put: anInteger]

