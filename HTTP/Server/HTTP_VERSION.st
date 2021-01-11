"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_VERSION,
	#superclass : #HttpVersion,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_VERSION class >> aspects [
	^#(#MajorVersion #MinorVersion)]

{ #category : #accessing }
HTTP_VERSION class >> def [
	^<def>
	typedef struct _HTTP_VERSION {
		USHORT MajorVersion;
		USHORT MinorVersion;
	} HTTP_VERSION, *PHTTP_VERSION;
	</def>]

{ #category : #accessing }
HTTP_VERSION class >> sizeInBytes [
	^sizeInBytes]

{ #category : #input }
HTTP_VERSION >> major: anInteger [
	self MajorVersion: anInteger]

{ #category : #accessing }
HTTP_VERSION >> MajorVersion [
	^self uShortAtOffset: MajorVersion]

{ #category : #accessing }
HTTP_VERSION >> MajorVersion: anInteger [
	self uShortAtOffset: MajorVersion put: anInteger]

{ #category : #input }
HTTP_VERSION >> minor: anInteger [
	self MinorVersion: anInteger]

{ #category : #accessing }
HTTP_VERSION >> MinorVersion [
	^self uShortAtOffset: MinorVersion]

{ #category : #accessing }
HTTP_VERSION >> MinorVersion: anInteger [
	self uShortAtOffset: MinorVersion put: anInteger]

{ #category : #printing }
HTTP_VERSION >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		space;
		nextPutAll: self MajorVersion asString;
		nextPut: $.;
		nextPutAll: self MinorVersion asString]

