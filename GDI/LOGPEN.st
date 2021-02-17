"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #LOGPEN,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
LOGPEN class >> def [
	^<def>
	typedef struct tagLOGPEN {
		UINT     lopnStyle;
		POINT    lopnWidth;
		COLORREF lopnColor;
	} LOGPEN, *PLOGPEN;
	</def>]

{ #category : #accessing }
LOGPEN class >> sizeInBytes [
	^sizeInBytes]

{ #category : #output }
LOGPEN >> color [
	^self lopnColor asColor]

{ #category : #input }
LOGPEN >> color: aColor [
	self lopnColor: aColor]

{ #category : #accessing }
LOGPEN >> lopnColor [
	| bytes |
	bytes := self bytesAtOffset: lopnColor count: COLORREF sizeInBytes.
	^COLORREF usingBytes: bytes]

{ #category : #accessing }
LOGPEN >> lopnColor: aColor [
	self colorAtOffset: lopnColor put: aColor]

{ #category : #accessing }
LOGPEN >> lopnStyle [
	^self uLongAtOffset: lopnStyle]

{ #category : #accessing }
LOGPEN >> lopnStyle: anInteger [
	self uLongAtOffset: lopnStyle put: anInteger]

{ #category : #accessing }
LOGPEN >> lopnWidth [
	^self pointAtOffset: lopnWidth]

{ #category : #accessing }
LOGPEN >> lopnWidth: aPoint [
	self pointAtOffset: lopnWidth put: aPoint]

{ #category : #output }
LOGPEN >> style [
	^self lopnStyle]

{ #category : #input }
LOGPEN >> style: anInteger [
	self lopnStyle: anInteger]

{ #category : #output }
LOGPEN >> width [
	^self lopnWidth x]

{ #category : #input }
LOGPEN >> width: anInteger [
	self lopnWidth: anInteger @ 0]

