"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ICONINFO,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
ICONINFO class >> def [
	^<def>
		typedef struct _ICONINFO {
			BOOL fIcon; // nil
			DWORD xHotspot; // nil
			DWORD yHotspot; // nil
			HBITMAP hbmMask; // nil
			HBITMAP hbmColor; // nil
		} ICONINFO; // sizeInBytes = nil
	</def>]

{ #category : #accessing }
ICONINFO class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 32;
		at: 'fIcon' put: 0;
		at: 'xHotspot' put: 4;
		at: 'yHotspot' put: 8;
		at: 'hbmMask' put: 16;
		at: 'hbmColor' put: 24;
		yourself]

{ #category : #accessing }
ICONINFO class >> sizeInBytes [
	^sizeInBytes]

{ #category : #output }
ICONINFO >> colorBitmap [
	^GDIBitmap fromHandle: self hbmColor]

{ #category : #input }
ICONINFO >> colorBitmap: aBitmap [
	self hbmColor: aBitmap asParameter]

{ #category : #input }
ICONINFO >> cursor: aBoolean [
	self fIcon: aBoolean not]

{ #category : #accessing }
ICONINFO >> fIcon [
	^self booleanAtOffset: fIcon]

{ #category : #accessing }
ICONINFO >> fIcon: aBoolean [
	self booleanAtOffset: fIcon put: aBoolean]

{ #category : #accessing }
ICONINFO >> hbmColor [
	^self pointerAtOffset: hbmColor]

{ #category : #accessing }
ICONINFO >> hbmColor: anInteger [
	self pointerAtOffset: hbmColor put: anInteger]

{ #category : #accessing }
ICONINFO >> hbmMask [
	^self pointerAtOffset: hbmMask]

{ #category : #accessing }
ICONINFO >> hbmMask: anInteger [
	self pointerAtOffset: hbmMask put: anInteger]

{ #category : #output }
ICONINFO >> hotspot [
	^self xHotspot @ self yHotspot]

{ #category : #input }
ICONINFO >> hotspot: aPoint [
	self xHotspot: aPoint x; yHotspot: aPoint y]

{ #category : #input }
ICONINFO >> mask: aBitmap [
	self hbmMask: aBitmap asParameter]

{ #category : #output }
ICONINFO >> maskBitmap [
	^GDIBitmap fromHandle: self hbmMask]

{ #category : #input }
ICONINFO >> maskBitmap: aBitmap [
	self hbmMask: aBitmap asParameter]

{ #category : #accessing }
ICONINFO >> xHotspot [
	^self uLongAtOffset: xHotspot]

{ #category : #accessing }
ICONINFO >> xHotspot: anInteger [
	self uLongAtOffset: xHotspot put: anInteger]

{ #category : #accessing }
ICONINFO >> yHotspot [
	^self uLongAtOffset: yHotspot]

{ #category : #accessing }
ICONINFO >> yHotspot: anInteger [
	self uLongAtOffset: yHotspot put: anInteger]

