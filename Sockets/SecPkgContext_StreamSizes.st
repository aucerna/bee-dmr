"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SecPkgContext_StreamSizes,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #sockets
}

{ #category : #accessing }
SecPkgContext_StreamSizes class >> def [
	^<def>
	typedef struct _SecPkgContext_StreamSizes {
		ULONG cbHeader;
		ULONG cbTrailer;
		ULONG cbMaximumMessage;
		ULONG cBuffers;
		ULONG cbBlockSize;
	} SecPkgContext_StreamSizes, *PSecPkgContext_StreamSizes;
	</def>]

{ #category : #accessing }
SecPkgContext_StreamSizes class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
SecPkgContext_StreamSizes >> cbBlockSize [
	^self uLongAtOffset: cbBlockSize]

{ #category : #accessing }
SecPkgContext_StreamSizes >> cbBlockSize: anInteger [
	self uLongAtOffset: cbBlockSize put: anInteger]

{ #category : #accessing }
SecPkgContext_StreamSizes >> cbHeader [
	^self uLongAtOffset: cbHeader]

{ #category : #accessing }
SecPkgContext_StreamSizes >> cbHeader: anInteger [
	self uLongAtOffset: cbHeader put: anInteger]

{ #category : #accessing }
SecPkgContext_StreamSizes >> cbMaximumMessage [
	^self uLongAtOffset: cbMaximumMessage]

{ #category : #accessing }
SecPkgContext_StreamSizes >> cbMaximumMessage: anInteger [
	self uLongAtOffset: cbMaximumMessage put: anInteger]

{ #category : #accessing }
SecPkgContext_StreamSizes >> cbTrailer [
	^self uLongAtOffset: cbTrailer]

{ #category : #accessing }
SecPkgContext_StreamSizes >> cbTrailer: anInteger [
	self uLongAtOffset: cbTrailer put: anInteger]

{ #category : #accessing }
SecPkgContext_StreamSizes >> cBuffers [
	^self uLongAtOffset: cBuffers]

{ #category : #accessing }
SecPkgContext_StreamSizes >> cBuffers: anInteger [
	self uLongAtOffset: cBuffers put: anInteger]

{ #category : #output }
SecPkgContext_StreamSizes >> maxLength [
	^self cbHeader + self cbMaximumMessage + self cbTrailer]

