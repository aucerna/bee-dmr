"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BITMAPV4HEADER,
	#superclass : #BitmapHeaderStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
BITMAPV4HEADER class >> def [
	^<def>
	typedef struct {
		DWORD        bV4Size;
		LONG         bV4Width;
		LONG         bV4Height;
		WORD         bV4Planes;
		WORD         bV4BitCount;
		DWORD        bV4V4Compression;
		DWORD        bV4SizeImage;
		LONG         bV4XPelsPerMeter;
		LONG         bV4YPelsPerMeter;
		DWORD        bV4ClrUsed;
		DWORD        bV4ClrImportant;
		DWORD        bV4RedMask;
		DWORD        bV4GreenMask;
		DWORD        bV4BlueMask;
		DWORD        bV4AlphaMask;
		DWORD        bV4CSType;
		CIEXYZTRIPLE bV4Endpoints;
		DWORD        bV4GammaRed;
		DWORD        bV4GammaGreen;
		DWORD        bV4GammaBlue;
	} BITMAPV4HEADER, *PBITMAPV4HEADER;
	</def>]

{ #category : #accessing }
BITMAPV4HEADER class >> sizeInBytes [
	^sizeInBytes]

{ #category : #output }
BITMAPV4HEADER >> bitCount [
	^self bV4BitCount]

{ #category : #input }
BITMAPV4HEADER >> bitCount: anInteger [
	self bV4BitCount: anInteger]

{ #category : #accessing }
BITMAPV4HEADER >> bV4AlphaMask [
	^self uLongAtOffset: bV4AlphaMask]

{ #category : #accessing }
BITMAPV4HEADER >> bV4AlphaMask: anInteger [
	self uLongAtOffset: bV4AlphaMask put: anInteger]

{ #category : #accessing }
BITMAPV4HEADER >> bV4BitCount [
	^self uShortAtOffset: bV4BitCount]

{ #category : #accessing }
BITMAPV4HEADER >> bV4BitCount: anInteger [
	self uShortAtOffset: bV4BitCount put: anInteger]

{ #category : #accessing }
BITMAPV4HEADER >> bV4BlueMask [
	^self uLongAtOffset: bV4BlueMask]

{ #category : #accessing }
BITMAPV4HEADER >> bV4BlueMask: anInteger [
	self uLongAtOffset: bV4BlueMask put: anInteger]

{ #category : #accessing }
BITMAPV4HEADER >> bV4ClrImportant [
	^self uLongAtOffset: bV4ClrImportant]

{ #category : #accessing }
BITMAPV4HEADER >> bV4ClrImportant: anInteger [
	self uLongAtOffset: bV4ClrImportant put: anInteger]

{ #category : #accessing }
BITMAPV4HEADER >> bV4ClrUsed [
	^self uLongAtOffset: bV4ClrUsed]

{ #category : #accessing }
BITMAPV4HEADER >> bV4ClrUsed: anInteger [
	self uLongAtOffset: bV4ClrUsed put: anInteger]

{ #category : #accessing }
BITMAPV4HEADER >> bV4CSType [
	^self uLongAtOffset: bV4CSType]

{ #category : #accessing }
BITMAPV4HEADER >> bV4CSType: anInteger [
	self uLongAtOffset: bV4CSType put: anInteger]

{ #category : #accessing }
BITMAPV4HEADER >> bV4Endpoints [
	^self structureAtOffset: bV4Endpoints ofClass: CIEXYZTRIPLE]

{ #category : #accessing }
BITMAPV4HEADER >> bV4Endpoints: aCIEXYZTRIPLE [
	self bytesAtOffset: bV4Endpoints put: aCIEXYZTRIPLE asParameter]

{ #category : #accessing }
BITMAPV4HEADER >> bV4GammaBlue [
	^self uLongAtOffset: bV4GammaBlue]

{ #category : #accessing }
BITMAPV4HEADER >> bV4GammaBlue: anInteger [
	self uLongAtOffset: bV4GammaBlue put: anInteger]

{ #category : #accessing }
BITMAPV4HEADER >> bV4GammaGreen [
	^self uLongAtOffset: bV4GammaGreen]

{ #category : #accessing }
BITMAPV4HEADER >> bV4GammaGreen: anInteger [
	self uLongAtOffset: bV4GammaGreen put: anInteger]

{ #category : #accessing }
BITMAPV4HEADER >> bV4GammaRed [
	^self uLongAtOffset: bV4GammaRed]

{ #category : #accessing }
BITMAPV4HEADER >> bV4GammaRed: anInteger [
	self uLongAtOffset: bV4GammaRed put: anInteger]

{ #category : #accessing }
BITMAPV4HEADER >> bV4GreenMask [
	^self uLongAtOffset: bV4GreenMask]

{ #category : #accessing }
BITMAPV4HEADER >> bV4GreenMask: anInteger [
	self uLongAtOffset: bV4GreenMask put: anInteger]

{ #category : #accessing }
BITMAPV4HEADER >> bV4Height [
	^self longAtOffset: bV4Height]

{ #category : #accessing }
BITMAPV4HEADER >> bV4Height: anInteger [
	self longAtOffset: bV4Height put: anInteger]

{ #category : #accessing }
BITMAPV4HEADER >> bV4Planes [
	^self uShortAtOffset: bV4Planes]

{ #category : #accessing }
BITMAPV4HEADER >> bV4Planes: anInteger [
	self uShortAtOffset: bV4Planes put: anInteger]

{ #category : #accessing }
BITMAPV4HEADER >> bV4RedMask [
	^self uLongAtOffset: bV4RedMask]

{ #category : #accessing }
BITMAPV4HEADER >> bV4RedMask: anInteger [
	self uLongAtOffset: bV4RedMask put: anInteger]

{ #category : #accessing }
BITMAPV4HEADER >> bV4Size [
	^self uLongAtOffset: bV4Size]

{ #category : #accessing }
BITMAPV4HEADER >> bV4Size: anInteger [
	self uLongAtOffset: bV4Size put: anInteger]

{ #category : #accessing }
BITMAPV4HEADER >> bV4SizeImage [
	^self uLongAtOffset: bV4SizeImage]

{ #category : #accessing }
BITMAPV4HEADER >> bV4SizeImage: anInteger [
	self uLongAtOffset: bV4SizeImage put: anInteger]

{ #category : #accessing }
BITMAPV4HEADER >> bV4V4Compression [
	^self uLongAtOffset: bV4V4Compression]

{ #category : #accessing }
BITMAPV4HEADER >> bV4V4Compression: anInteger [
	self uLongAtOffset: bV4V4Compression put: anInteger]

{ #category : #accessing }
BITMAPV4HEADER >> bV4Width [
	^self longAtOffset: bV4Width]

{ #category : #accessing }
BITMAPV4HEADER >> bV4Width: anInteger [
	self longAtOffset: bV4Width put: anInteger]

{ #category : #accessing }
BITMAPV4HEADER >> bV4XPelsPerMeter [
	^self longAtOffset: bV4XPelsPerMeter]

{ #category : #accessing }
BITMAPV4HEADER >> bV4XPelsPerMeter: anInteger [
	self longAtOffset: bV4XPelsPerMeter put: anInteger]

{ #category : #accessing }
BITMAPV4HEADER >> bV4YPelsPerMeter [
	^self longAtOffset: bV4YPelsPerMeter]

{ #category : #accessing }
BITMAPV4HEADER >> bV4YPelsPerMeter: anInteger [
	self longAtOffset: bV4YPelsPerMeter put: anInteger]

{ #category : #output }
BITMAPV4HEADER >> clrImportant [
	^self bV4ClrImportant]

{ #category : #input }
BITMAPV4HEADER >> clrImportant: anInteger [
	self bV4ClrImportant: anInteger]

{ #category : #output }
BITMAPV4HEADER >> clrUsed [
	^self bV4ClrUsed]

{ #category : #input }
BITMAPV4HEADER >> clrUsed: anInteger [
	self bV4ClrUsed: anInteger]

{ #category : #output }
BITMAPV4HEADER >> compression [
	^self bV4Compression]

{ #category : #input }
BITMAPV4HEADER >> compression: anInteger [
	self bV4Compression: anInteger]

{ #category : #input }
BITMAPV4HEADER >> fromStream: aStream [
	| struct |
	self
		bV4Size: aStream nextULong;
		bV4Width: aStream nextULong;
		bV4Height: aStream nextULong;
		bV4Planes: aStream nextUShort;
		bV4BitCount: aStream nextUShort;
		bV4V4Compression: aStream nextULong;
		bV4SizeImage: aStream nextULong;
		bV4XPelsPerMeter: aStream nextULong;
		bV4YPelsPerMeter: aStream nextULong;
		bV4ClrUsed: aStream nextULong;
		bV4ClrImportant: aStream nextULong;
		bV4RedMask: aStream nextULong;
		bV4GreenMask: aStream nextULong;
		bV4BlueMask: aStream nextULong;
		bV4AlphaMask: aStream nextULong;
		bV4CSType: aStream nextULong.
	struct := CIEXYZTRIPLE fromStream: aStream.
	self
		bV4Endpoints: struct;
		bV4GammaRed: aStream nextULong;
		bV4GammaGreen: aStream nextULong;
		bV4GammaBlue: aStream nextULong]

{ #category : #output }
BITMAPV4HEADER >> height [
	^self bV4Height]

{ #category : #input }
BITMAPV4HEADER >> height: anInteger [
	self bV4Height: anInteger]

{ #category : #output }
BITMAPV4HEADER >> planes [
	^self bV4Planes]

{ #category : #input }
BITMAPV4HEADER >> planes: anInteger [
	self bV4Planes: anInteger]

{ #category : #input }
BITMAPV4HEADER >> size: anInteger [
	self bV4Size: anInteger]

{ #category : #output }
BITMAPV4HEADER >> sizeImage [
	^self bV4SizeImage]

{ #category : #input }
BITMAPV4HEADER >> sizeImage: anInteger [
	self bV4SizeImage: anInteger]

{ #category : #output }
BITMAPV4HEADER >> width [
	^self bV4Width]

{ #category : #input }
BITMAPV4HEADER >> width: anInteger [
	self bV4Width: anInteger]

{ #category : #output }
BITMAPV4HEADER >> xPelsPerMeter [
	^self bV4XPelsPerMeter]

{ #category : #input }
BITMAPV4HEADER >> xPelsPerMeter: anInteger [
	self bV4XPelsPerMeter: anInteger]

{ #category : #output }
BITMAPV4HEADER >> yPelsPerMeter [
	^self bV4YPelsPerMeter]

{ #category : #input }
BITMAPV4HEADER >> yPelsPerMeter: anInteger [
	self bV4YPelsPerMeter: anInteger]

