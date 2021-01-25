"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SecHandle,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #sockets
}

{ #category : #private }
SecHandle class >> def [
	^<def>
	typedef struct _SecHandle {
		ULONG_PTR       dwLower;
		ULONG_PTR       dwUpper;
	} SecHandle, * PSecHandle;
	</def>]

{ #category : #accessing }
SecHandle class >> offsets64 [
^PoolDictionary new
		at: 'dwUpper' put: 8;
		at: 'sizeInBytes' put: 16;
		at: 'dwLower' put: 0;
		yourself]

{ #category : #accessing }
SecHandle class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
SecHandle >> dwLower [
	^self pointerAtOffset: dwLower]

{ #category : #accessing }
SecHandle >> dwLower: anInteger [
	self pointerAtOffset: dwLower put: anInteger]

{ #category : #accessing }
SecHandle >> dwUpper [
	^self pointerAtOffset: dwUpper]

{ #category : #accessing }
SecHandle >> dwUpper: anInteger [
	self pointerAtOffset: dwUpper put: anInteger]

