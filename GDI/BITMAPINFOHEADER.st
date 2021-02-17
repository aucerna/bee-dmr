"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BITMAPINFOHEADER,
	#superclass : #BitmapHeaderStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
BITMAPINFOHEADER class >> classForSize: n [
	^BitmapHeaderStructure allSubclasses
		detect: [:cls | cls !== BITMAPINFO and: [cls sizeInBytes = n]]]

{ #category : #accessing }
BITMAPINFOHEADER class >> def [
	^<def>
	typedef struct tagBITMAPINFOHEADER {
		DWORD biSize;
		LONG  biWidth;
		LONG  biHeight;
		WORD  biPlanes;
		WORD  biBitCount;
		DWORD biCompression;
		DWORD biSizeImage;
		LONG  biXPelsPerMeter;
		LONG  biYPelsPerMeter;
		DWORD biClrUsed;
		DWORD biClrImportant;
	} BITMAPINFOHEADER, *PBITMAPINFOHEADER;
	</def>]

{ #category : #'instance creation' }
BITMAPINFOHEADER class >> fromInfo: aBITMAPINFO [
	| class |
	class := self classForSize: aBITMAPINFO size.
	^class new fromInfo: aBITMAPINFO]

{ #category : #'instance creation' }
BITMAPINFOHEADER class >> fromStream: aStream [
	| pos size class |
	pos := aStream position.
	size := aStream nextULong.
	aStream position: pos.
	class := self classForSize: size.
	^class new fromStream: aStream]

{ #category : #accessing }
BITMAPINFOHEADER class >> sizeInBytes [
	^sizeInBytes]

{ #category : #'instance creation' }
BITMAPINFOHEADER class >> width: w height: h bitCount: bitCount [
	^self
		width: w
		height: h
		planes: 1
		bitCount: bitCount]

{ #category : #'instance creation' }
BITMAPINFOHEADER class >> width: w
height: h
planes: planes
bitCount: bitCount [
	^self new
		width: w
		height: h
		planes: planes
		bitCount: bitCount]

{ #category : #accessing }
BITMAPINFOHEADER >> biBitCount [
	^self uShortAtOffset: biBitCount]

{ #category : #accessing }
BITMAPINFOHEADER >> biBitCount: anInteger [
	self uShortAtOffset: biBitCount put: anInteger]

{ #category : #accessing }
BITMAPINFOHEADER >> biClrImportant [
	^self uLongAtOffset: biClrImportant]

{ #category : #accessing }
BITMAPINFOHEADER >> biClrImportant: anInteger [
	self uLongAtOffset: biClrImportant put: anInteger]

{ #category : #accessing }
BITMAPINFOHEADER >> biClrUsed [
	^self uLongAtOffset: biClrUsed]

{ #category : #accessing }
BITMAPINFOHEADER >> biClrUsed: anInteger [
	self uLongAtOffset: biClrUsed put: anInteger]

{ #category : #accessing }
BITMAPINFOHEADER >> biCompression [
	^self uLongAtOffset: biCompression]

{ #category : #accessing }
BITMAPINFOHEADER >> biCompression: anInteger [
	self uLongAtOffset: biCompression put: anInteger]

{ #category : #accessing }
BITMAPINFOHEADER >> biHeight [
	^self longAtOffset: biHeight]

{ #category : #accessing }
BITMAPINFOHEADER >> biHeight: anInteger [
	self longAtOffset: biHeight put: anInteger]

{ #category : #accessing }
BITMAPINFOHEADER >> biPlanes [
	^self uShortAtOffset: biPlanes]

{ #category : #accessing }
BITMAPINFOHEADER >> biPlanes: anInteger [
	self uShortAtOffset: biPlanes put: anInteger]

{ #category : #accessing }
BITMAPINFOHEADER >> biSize [
	^self uLongAtOffset: biSize]

{ #category : #accessing }
BITMAPINFOHEADER >> biSize: anInteger [
	self uLongAtOffset: biSize put: anInteger]

{ #category : #accessing }
BITMAPINFOHEADER >> biSizeImage [
	^self uLongAtOffset: biSizeImage]

{ #category : #accessing }
BITMAPINFOHEADER >> biSizeImage: anInteger [
	self uLongAtOffset: biSizeImage put: anInteger]

{ #category : #output }
BITMAPINFOHEADER >> bitCount [
	^self biBitCount]

{ #category : #input }
BITMAPINFOHEADER >> bitCount: anInteger [
	self biBitCount: anInteger]

{ #category : #accessing }
BITMAPINFOHEADER >> biWidth [
	^self longAtOffset: biWidth]

{ #category : #accessing }
BITMAPINFOHEADER >> biWidth: anInteger [
	self longAtOffset: biWidth put: anInteger]

{ #category : #accessing }
BITMAPINFOHEADER >> biXPelsPerMeter [
	^self longAtOffset: biXPelsPerMeter]

{ #category : #accessing }
BITMAPINFOHEADER >> biXPelsPerMeter: anInteger [
	self longAtOffset: biXPelsPerMeter put: anInteger]

{ #category : #accessing }
BITMAPINFOHEADER >> biYPelsPerMeter [
	^self longAtOffset: biYPelsPerMeter]

{ #category : #accessing }
BITMAPINFOHEADER >> biYPelsPerMeter: anInteger [
	self longAtOffset: biYPelsPerMeter put: anInteger]

{ #category : #output }
BITMAPINFOHEADER >> clrImportant [
	^self biClrImportant]

{ #category : #input }
BITMAPINFOHEADER >> clrImportant: anInteger [
	self biClrImportant: anInteger]

{ #category : #output }
BITMAPINFOHEADER >> clrUsed [
	^self biClrUsed]

{ #category : #input }
BITMAPINFOHEADER >> clrUsed: anInteger [
	self biClrUsed: anInteger]

{ #category : #output }
BITMAPINFOHEADER >> compression [
	^self biCompression]

{ #category : #input }
BITMAPINFOHEADER >> compression: anInteger [
	self biCompression: anInteger]

{ #category : #output }
BITMAPINFOHEADER >> height [
	^self biHeight]

{ #category : #input }
BITMAPINFOHEADER >> height: anInteger [
	self biHeight: anInteger]

{ #category : #output }
BITMAPINFOHEADER >> planes [
	^self biPlanes]

{ #category : #input }
BITMAPINFOHEADER >> planes: anInteger [
	self biPlanes: anInteger]

{ #category : #output }
BITMAPINFOHEADER >> size [
	^self biSize]

{ #category : #input }
BITMAPINFOHEADER >> size: anInteger [
	self biSize: anInteger]

{ #category : #output }
BITMAPINFOHEADER >> sizeImage [
	^self biSizeImage]

{ #category : #input }
BITMAPINFOHEADER >> sizeImage: anInteger [
	self biSizeImage: anInteger]

{ #category : #output }
BITMAPINFOHEADER >> width [
	^self biWidth]

{ #category : #input }
BITMAPINFOHEADER >> width: anInteger [
	self biWidth: anInteger]

{ #category : #output }
BITMAPINFOHEADER >> xPelsPerMeter [
	^self biXPelsPerMeter]

{ #category : #input }
BITMAPINFOHEADER >> xPelsPerMeter: anInteger [
	self biXPelsPerMeter: anInteger]

{ #category : #output }
BITMAPINFOHEADER >> yPelsPerMeter [
	^self biYPelsPerMeter]

{ #category : #input }
BITMAPINFOHEADER >> yPelsPerMeter: anInteger [
	self biYPelsPerMeter: anInteger]

