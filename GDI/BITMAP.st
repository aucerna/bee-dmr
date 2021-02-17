"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BITMAP,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
BITMAP class >> def [
	^<def>
	typedef struct tagBITMAP {
		LONG   bmType;
		LONG   bmWidth;
		LONG   bmHeight;
		LONG   bmWidthBytes;
		WORD   bmPlanes;
		WORD   bmBitsPixel;
		LPVOID bmBits;
	} BITMAP, *PBITMAP;
</def>]

{ #category : #'instance creation' }
BITMAP class >> from: aBitmap [
	^self from: aBitmap extent: aBitmap extent]

{ #category : #'instance creation' }
BITMAP class >> from: aBitmap extent: aPoint [
	^self external
		handle: aBitmap asParameter width: aPoint x height: aPoint y;
		makeLocal]

{ #category : #accessing }
BITMAP class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 32;
		at: 'bmType' put: 0;
		at: 'bmWidth' put: 4;
		at: 'bmHeight' put: 8;
		at: 'bmWidthBytes' put: 12;
		at: 'bmPlanes' put: 16;
		at: 'bmBitsPixel' put: 18;
		at: 'bmBits' put: 24;
		yourself]

{ #category : #accessing }
BITMAP class >> sizeInBytes [
	^sizeInBytes]

{ #category : #outputs }
BITMAP >> asBitmap [
	^GDIBitmap width: self width height: self height bitCount: self bitCount]

{ #category : #outputs }
BITMAP >> bitCount [
	^self bmPlanes * self bmBitsPixel]

{ #category : #outputs }
BITMAP >> bitsPixel [
	^self bmBitsPixel]

{ #category : #inputs }
BITMAP >> bitsPixel: anInteger [
	self bmBitsPixel: anInteger]

{ #category : #accessing }
BITMAP >> bmBits [
	^self addressAtOffset: bmBits]

{ #category : #accessing }
BITMAP >> bmBitsPixel [
	^self uShortAtOffset: bmBitsPixel]

{ #category : #accessing }
BITMAP >> bmBitsPixel: anInteger [
	self uShortAtOffset: bmBitsPixel put: anInteger]

{ #category : #accessing }
BITMAP >> bmHeight [
	^self longAtOffset: bmHeight]

{ #category : #accessing }
BITMAP >> bmHeight: anInteger [
	self longAtOffset: bmHeight put: anInteger]

{ #category : #accessing }
BITMAP >> bmPlanes [
	^self uShortAtOffset: bmPlanes]

{ #category : #accessing }
BITMAP >> bmPlanes: anInteger [
	self uShortAtOffset: bmPlanes put: anInteger]

{ #category : #accessing }
BITMAP >> bmType [
	^self longAtOffset: bmType]

{ #category : #accessing }
BITMAP >> bmType: anInteger [
	self longAtOffset: bmType put: anInteger]

{ #category : #accessing }
BITMAP >> bmWidth [
	^self longAtOffset: bmWidth]

{ #category : #accessing }
BITMAP >> bmWidth: anInteger [
	self longAtOffset: bmWidth put: anInteger]

{ #category : #accessing }
BITMAP >> bmWidthBytes [
	^self longAtOffset: bmWidthBytes]

{ #category : #accessing }
BITMAP >> bmWidthBytes: anInteger [
	self ASSERT: anInteger \\ 2 = 0.
	self longAtOffset: bmWidthBytes put: anInteger]

{ #category : #outputs }
BITMAP >> byteWidth [
	^self bmWidthBytes]

{ #category : #inputs }
BITMAP >> byteWidth: anInteger [
	self bmWidthBytes: anInteger]

{ #category : #outputs }
BITMAP >> extent [
	^self bmWidth @ self bmHeight]

{ #category : #inputs }
BITMAP >> handle: handle width: width height: height [
	| return w h |
	return := GDILibrary
		GetObjectW: handle asParameter
		cbBuffer: self sizeInBytes
		lpvObject: self asParameter.
	return = 0 ifTrue: [^self winError].
	w := width = 0 ifTrue: [self width] ifFalse: [self width min: width].
	h := height = 0 ifTrue: [self height] ifFalse: [self height min: height].
	self width: w; height: h]

{ #category : #outputs }
BITMAP >> height [
	^self bmHeight]

{ #category : #inputs }
BITMAP >> height: anInteger [
	self bmHeight: anInteger]

{ #category : #outputs }
BITMAP >> planes [
	^self bmPlanes]

{ #category : #inputs }
BITMAP >> planes: anInteger [
	self bmPlanes: anInteger]

{ #category : #outputs }
BITMAP >> width [
	^self bmWidth]

{ #category : #inputs }
BITMAP >> width: anInteger [
	self bmWidth: anInteger]

