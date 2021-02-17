"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BITMAPINFO,
	#superclass : #BitmapHeaderStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
BITMAPINFO class >> def [
	^<def>
	typedef struct tagBITMAPINFO {
		BITMAPINFOHEADER bmiHeader;
		RGBQUAD          bmiColors[1];
	} BITMAPINFO, *PBITMAPINFO;
	</def>]

{ #category : #'instance creation' }
BITMAPINFO class >> fromStream: aStream [
	| header info |
	header := BITMAPINFOHEADER fromStream: aStream.
	info := self new: header sizeInBytes + header colorTableSize.
	^info bmiHeader: header; fromStream: aStream]

{ #category : #accessing }
BITMAPINFO class >> sizeInBytes [
	^sizeInBytes]

{ #category : #'instance creation' }
BITMAPINFO class >> width: w height: h bitCount: bitCount [
	^self width: w height: h planes: 1 bitCount: bitCount]

{ #category : #'instance creation' }
BITMAPINFO class >> width: w
height: h
planes: planes
bitCount: bitCount [
	| header struct |
	header := BITMAPINFOHEADER
		width: w
		height: h
		planes: planes
		bitCount: bitCount.
	struct := self new: header sizeInBytes + header colorTableSize.
	^struct bmiHeader: header; checkMaxDepth]

{ #category : #output }
BITMAPINFO >> bitCount [
	^self bmiHeader biBitCount]

{ #category : #input }
BITMAPINFO >> bitCount: anInteger [
	self bmiHeader: (self bmiHeader biBitCount: anInteger)]

{ #category : #accessing }
BITMAPINFO >> bmiColors [
	^self structureAtOffset: bmiColors ofClass: RGBQUAD]

{ #category : #accessing }
BITMAPINFO >> bmiColors: aRGBQUAD [
	self bytesAtOffset: bmiColors put: aRGBQUAD asParameter]

{ #category : #accessing }
BITMAPINFO >> bmiHeader [
	^self structureAtOffset: bmiHeader ofClass: BITMAPINFOHEADER]

{ #category : #accessing }
BITMAPINFO >> bmiHeader: aBITMAPINFOHEADER [
	self bytesAtOffset: bmiHeader put: aBITMAPINFOHEADER asParameter]

{ #category : #private }
BITMAPINFO >> checkMaxDepth [
	self bitCount = GDIBitmap maxColorTableDepth ifTrue: [
		self
			uLongAtOffset: bmiColors put: 16r7C00;
			uLongAtOffset: 44 put: 16r3E0;
			uLongAtOffset: 48 put: 16r1F]]

{ #category : #output }
BITMAPINFO >> clrImportant [
	^self bmiHeader biClrImportant]

{ #category : #input }
BITMAPINFO >> clrImportant: anInteger [
	self biClrImportant: anInteger]

{ #category : #output }
BITMAPINFO >> clrUsed [
	^self bmiHeader biClrUsed]

{ #category : #input }
BITMAPINFO >> clrUsed: anInteger [
	self bmiHeader: (self bmiHeader biClrUsed: anInteger)]

{ #category : #output }
BITMAPINFO >> colorTable [
	^self bmiColors]

{ #category : #input }
BITMAPINFO >> colorTable: anObject [
	self bmiColors: anObject]

{ #category : #output }
BITMAPINFO >> compression [
	^self bmiHeader biCompression]

{ #category : #input }
BITMAPINFO >> compression: anInteger [
	self bmiHeader: (self bmiHeader biCompression: anInteger)]

{ #category : #accessing }
BITMAPINFO >> extent [
	^self width @ self height]

{ #category : #input }
BITMAPINFO >> fromStream: aStream [
	| table |
	table := ByteArray new: self colorTableSize.
	aStream getBytesFor: table.
	self colorTable: table]

{ #category : #output }
BITMAPINFO >> height [
	^self bmiHeader biHeight]

{ #category : #input }
BITMAPINFO >> height: anInteger [
	self bmiHeader: (self bmiHeader biHeight: anInteger)]

{ #category : #output }
BITMAPINFO >> planes [
	^self bmiHeader biPlanes]

{ #category : #input }
BITMAPINFO >> planes: anInteger [
	self bmiHeader: (self bmiHeader biPlanes: anInteger)]

{ #category : #output }
BITMAPINFO >> size [
	^self bmiHeader biSize]

{ #category : #input }
BITMAPINFO >> size: anInteger [
	self bmiHeader: (self bmiHeader biSize: anInteger)]

{ #category : #output }
BITMAPINFO >> sizeImage [
	^self bmiHeader biSizeImage]

{ #category : #input }
BITMAPINFO >> sizeImage: anInteger [
	self bmiHeader: (self bmiHeader biSizeImage: anInteger)]

{ #category : #accessing }
BITMAPINFO >> sizeInBytes [
	^bmiColors + self colorTableSize]

{ #category : #output }
BITMAPINFO >> width [
	^self bmiHeader biWidth]

{ #category : #input }
BITMAPINFO >> width: anInteger [
	self bmiHeader: (self bmiHeader biWidth: anInteger)]

{ #category : #output }
BITMAPINFO >> xPelsPerMeter [
	^self bmiHeader biXPelsPerMeter]

{ #category : #input }
BITMAPINFO >> xPelsPerMeter: anInteger [
	self bmiHeader: (self bmiHeader biXPelsPerMeter: anInteger)]

{ #category : #output }
BITMAPINFO >> yPelsPerMeter [
	^self bmiHeader biYPelsPerMeter]

{ #category : #input }
BITMAPINFO >> yPelsPerMeter: anInteger [
	self bmiHeader: (self bmiHeader biYPelsPerMeter: anInteger)]

