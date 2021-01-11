"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SOCKADDR_STORAGE,
	#superclass : #SOCKADDR,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
SOCKADDR_STORAGE class >> aspects [
	^#(#ss_family
		#__ss_pad1
		#__ss_align
		#__ss_pad2)]

{ #category : #private }
SOCKADDR_STORAGE class >> def [
	^<def>
	typedef struct sockaddr_storage {
		short ss_family;
		char __ss_pad1[_SS_PAD1SIZE];
		__int64 __ss_align;
		char __ss_pad2[_SS_PAD2SIZE];
	} SOCKADDR_STORAGE, *PSOCKADDR_STORAGE;
	</def>]

{ #category : #initialization }
SOCKADDR_STORAGE class >> initializeConstants [
	self initializePaddingConstants]

{ #category : #initialization }
SOCKADDR_STORAGE class >> initializePaddingConstants [
	WinConstants
		at: '_SS_PAD1SIZE' put: 6;
		at: '_SS_PAD2SIZE' put: 112]

{ #category : #accessing }
SOCKADDR_STORAGE class >> sizeInBytes [
	^sizeInBytes]

{ #category : #private }
SOCKADDR_STORAGE class >> typedefTable [
	^#(
			('__int64' #large)
		)]

{ #category : #accessing }
SOCKADDR_STORAGE >> __ss_align [
	^self structureAtOffset: __ss_align ofClass: LARGE_INTEGER]

{ #category : #accessing }
SOCKADDR_STORAGE >> __ss_align: aLARGE_INTEGER [
	self bytesAtOffset: __ss_align put: aLARGE_INTEGER asParameter]

{ #category : #accessing }
SOCKADDR_STORAGE >> __ss_pad1 [
	^self byteAtOffset: __ss_pad1]

{ #category : #accessing }
SOCKADDR_STORAGE >> __ss_pad1: anInteger [
	self byteAtOffset: __ss_pad1 put: anInteger]

{ #category : #accessing }
SOCKADDR_STORAGE >> __ss_pad2 [
	^self byteAtOffset: __ss_pad2]

{ #category : #accessing }
SOCKADDR_STORAGE >> __ss_pad2: anInteger [
	self byteAtOffset: __ss_pad2 put: anInteger]

{ #category : #accessing }
SOCKADDR_STORAGE >> ss_family [
	^self shortAtOffset: ss_family]

{ #category : #accessing }
SOCKADDR_STORAGE >> ss_family: anInteger [
	self shortAtOffset: ss_family put: anInteger]

