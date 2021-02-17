"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BITMAPV5HEADER,
	#superclass : #BitmapHeaderStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
BITMAPV5HEADER class >> def [
	^<def>
	typedef struct {
		DWORD        bV5Size;
		LONG         bV5Width;
		LONG         bV5Height;
		WORD         bV5Planes;
		WORD         bV5BitCount;
		DWORD        bV5Compression;
		DWORD        bV5SizeImage;
		LONG         bV5XPelsPerMeter;
		LONG         bV5YPelsPerMeter;
		DWORD        bV5ClrUsed;
		DWORD        bV5ClrImportant;
		DWORD        bV5RedMask;
		DWORD        bV5GreenMask;
		DWORD        bV5BlueMask;
		DWORD        bV5AlphaMask;
		DWORD        bV5CSType;
		CIEXYZTRIPLE bV5Endpoints;
		DWORD        bV5GammaRed;
		DWORD        bV5GammaGreen;
		DWORD        bV5GammaBlue;
		DWORD        bV5Intent;
		DWORD        bV5ProfileData;
		DWORD        bV5ProfileSize;
		DWORD        bV5Reserved;
	} BITMAPV5HEADER, *PBITMAPV5HEADER;
	</def>]

{ #category : #accessing }
BITMAPV5HEADER class >> sizeInBytes [
	^sizeInBytes]

{ #category : #output }
BITMAPV5HEADER >> bitCount [
	^self bV5BitCount]

{ #category : #input }
BITMAPV5HEADER >> bitCount: anInteger [
	self bV5BitCount: anInteger]

{ #category : #accessing }
BITMAPV5HEADER >> bV5AlphaMask [
	^self uLongAtOffset: bV5AlphaMask]

{ #category : #accessing }
BITMAPV5HEADER >> bV5AlphaMask: anInteger [
	self uLongAtOffset: bV5AlphaMask put: anInteger]

{ #category : #accessing }
BITMAPV5HEADER >> bV5BitCount [
	^self uShortAtOffset: bV5BitCount]

{ #category : #accessing }
BITMAPV5HEADER >> bV5BitCount: anInteger [
	self uShortAtOffset: bV5BitCount put: anInteger]

{ #category : #accessing }
BITMAPV5HEADER >> bV5BlueMask [
	^self uLongAtOffset: bV5BlueMask]

{ #category : #accessing }
BITMAPV5HEADER >> bV5BlueMask: anInteger [
	self uLongAtOffset: bV5BlueMask put: anInteger]

{ #category : #accessing }
BITMAPV5HEADER >> bV5ClrImportant [
	^self uLongAtOffset: bV5ClrImportant]

{ #category : #accessing }
BITMAPV5HEADER >> bV5ClrImportant: anInteger [
	self uLongAtOffset: bV5ClrImportant put: anInteger]

{ #category : #accessing }
BITMAPV5HEADER >> bV5ClrUsed [
	^self uLongAtOffset: bV5ClrUsed]

{ #category : #accessing }
BITMAPV5HEADER >> bV5ClrUsed: anInteger [
	self uLongAtOffset: bV5ClrUsed put: anInteger]

{ #category : #accessing }
BITMAPV5HEADER >> bV5Compression [
	^self uLongAtOffset: bV5Compression]

{ #category : #accessing }
BITMAPV5HEADER >> bV5Compression: anInteger [
	self uLongAtOffset: bV5Compression put: anInteger]

{ #category : #accessing }
BITMAPV5HEADER >> bV5CSType [
	^self uLongAtOffset: bV5CSType]

{ #category : #accessing }
BITMAPV5HEADER >> bV5CSType: anInteger [
	self uLongAtOffset: bV5CSType put: anInteger]

{ #category : #accessing }
BITMAPV5HEADER >> bV5Endpoints [
	^self structureAtOffset: bV5Endpoints ofClass: CIEXYZTRIPLE]

{ #category : #accessing }
BITMAPV5HEADER >> bV5Endpoints: aCIEXYZTRIPLE [
	self bytesAtOffset: bV5Endpoints put: aCIEXYZTRIPLE asParameter]

{ #category : #accessing }
BITMAPV5HEADER >> bV5GammaBlue [
	^self uLongAtOffset: bV5GammaBlue]

{ #category : #accessing }
BITMAPV5HEADER >> bV5GammaBlue: anInteger [
	self uLongAtOffset: bV5GammaBlue put: anInteger]

{ #category : #accessing }
BITMAPV5HEADER >> bV5GammaGreen [
	^self uLongAtOffset: bV5GammaGreen]

{ #category : #accessing }
BITMAPV5HEADER >> bV5GammaGreen: anInteger [
	self uLongAtOffset: bV5GammaGreen put: anInteger]

{ #category : #accessing }
BITMAPV5HEADER >> bV5GammaRed [
	^self uLongAtOffset: bV5GammaRed]

{ #category : #accessing }
BITMAPV5HEADER >> bV5GammaRed: anInteger [
	self uLongAtOffset: bV5GammaRed put: anInteger]

{ #category : #accessing }
BITMAPV5HEADER >> bV5GreenMask [
	^self uLongAtOffset: bV5GreenMask]

{ #category : #accessing }
BITMAPV5HEADER >> bV5GreenMask: anInteger [
	self uLongAtOffset: bV5GreenMask put: anInteger]

{ #category : #accessing }
BITMAPV5HEADER >> bV5Height [
	^self longAtOffset: bV5Height]

{ #category : #accessing }
BITMAPV5HEADER >> bV5Height: anInteger [
	self longAtOffset: bV5Height put: anInteger]

{ #category : #accessing }
BITMAPV5HEADER >> bV5Intent [
	^self uLongAtOffset: bV5Intent]

{ #category : #accessing }
BITMAPV5HEADER >> bV5Intent: anInteger [
	self uLongAtOffset: bV5Intent put: anInteger]

{ #category : #accessing }
BITMAPV5HEADER >> bV5Planes [
	^self uShortAtOffset: bV5Planes]

{ #category : #accessing }
BITMAPV5HEADER >> bV5Planes: anInteger [
	self uShortAtOffset: bV5Planes put: anInteger]

{ #category : #accessing }
BITMAPV5HEADER >> bV5ProfileData [
	^self uLongAtOffset: bV5ProfileData]

{ #category : #accessing }
BITMAPV5HEADER >> bV5ProfileData: anInteger [
	self uLongAtOffset: bV5ProfileData put: anInteger]

{ #category : #accessing }
BITMAPV5HEADER >> bV5ProfileSize [
	^self uLongAtOffset: bV5ProfileSize]

{ #category : #accessing }
BITMAPV5HEADER >> bV5ProfileSize: anInteger [
	self uLongAtOffset: bV5ProfileSize put: anInteger]

{ #category : #accessing }
BITMAPV5HEADER >> bV5RedMask [
	^self uLongAtOffset: bV5RedMask]

{ #category : #accessing }
BITMAPV5HEADER >> bV5RedMask: anInteger [
	self uLongAtOffset: bV5RedMask put: anInteger]

{ #category : #accessing }
BITMAPV5HEADER >> bV5Reserved [
	^self uLongAtOffset: bV5Reserved]

{ #category : #accessing }
BITMAPV5HEADER >> bV5Reserved: anInteger [
	self uLongAtOffset: bV5Reserved put: anInteger]

{ #category : #accessing }
BITMAPV5HEADER >> bV5Size [
	^self uLongAtOffset: bV5Size]

{ #category : #accessing }
BITMAPV5HEADER >> bV5Size: anInteger [
	self uLongAtOffset: bV5Size put: anInteger]

{ #category : #accessing }
BITMAPV5HEADER >> bV5SizeImage [
	^self uLongAtOffset: bV5SizeImage]

{ #category : #accessing }
BITMAPV5HEADER >> bV5SizeImage: anInteger [
	self uLongAtOffset: bV5SizeImage put: anInteger]

{ #category : #accessing }
BITMAPV5HEADER >> bV5Width [
	^self longAtOffset: bV5Width]

{ #category : #accessing }
BITMAPV5HEADER >> bV5Width: anInteger [
	self longAtOffset: bV5Width put: anInteger]

{ #category : #accessing }
BITMAPV5HEADER >> bV5XPelsPerMeter [
	^self longAtOffset: bV5XPelsPerMeter]

{ #category : #accessing }
BITMAPV5HEADER >> bV5XPelsPerMeter: anInteger [
	self longAtOffset: bV5XPelsPerMeter put: anInteger]

{ #category : #accessing }
BITMAPV5HEADER >> bV5YPelsPerMeter [
	^self longAtOffset: bV5YPelsPerMeter]

{ #category : #accessing }
BITMAPV5HEADER >> bV5YPelsPerMeter: anInteger [
	self longAtOffset: bV5YPelsPerMeter put: anInteger]

{ #category : #output }
BITMAPV5HEADER >> clrImportant [
	^self bV5ClrImportant]

{ #category : #input }
BITMAPV5HEADER >> clrImportant: anInteger [
	self bV5ClrImportant: anInteger]

{ #category : #output }
BITMAPV5HEADER >> clrUsed [
	^self bV5ClrUsed]

{ #category : #input }
BITMAPV5HEADER >> clrUsed: anInteger [
	self bV5ClrUsed: anInteger]

{ #category : #output }
BITMAPV5HEADER >> compression [
	^self bV5Compression]

{ #category : #input }
BITMAPV5HEADER >> compression: anInteger [
	self bV5Compression: anInteger]

{ #category : #input }
BITMAPV5HEADER >> fromStream: aStream [
	| struct |
	self
		bV5Size: aStream nextULong;
		bV5Width: aStream nextULong;
		bV5Height: aStream nextULong;
		bV5Planes: aStream nextUShort;
		bV5BitCount: aStream nextUShort;
		bV5Compression: aStream nextULong;
		bV5SizeImage: aStream nextULong;
		bV5XPelsPerMeter: aStream nextULong;
		bV5YPelsPerMeter: aStream nextULong;
		bV5ClrUsed: aStream nextULong;
		bV5ClrImportant: aStream nextULong;
		bV5RedMask: aStream nextULong;
		bV5GreenMask: aStream nextULong;
		bV5BlueMask: aStream nextULong;
		bV5AlphaMask: aStream nextULong;
		bV5CSType: aStream nextULong.
	struct := CIEXYZTRIPLE fromStream: aStream.
	self
		bV5Endpoints: struct;
		bV5GammaRed: aStream nextULong;
		bV5GammaGreen: aStream nextULong;
		bV5GammaBlue: aStream nextULong;
		bV5Intent: aStream nextULong;
		bV5ProfileData: aStream nextULong;
		bV5ProfileSize: aStream nextULong;
		bV5Reserved: aStream nextULong]

{ #category : #output }
BITMAPV5HEADER >> height [
	^self bV5Height]

{ #category : #input }
BITMAPV5HEADER >> height: anInteger [
	self bV5Height: anInteger]

{ #category : #output }
BITMAPV5HEADER >> planes [
	^self bV5Planes]

{ #category : #input }
BITMAPV5HEADER >> planes: anInteger [
	self bV5Planes: anInteger]

{ #category : #input }
BITMAPV5HEADER >> size: anInteger [
	self bV5Size: anInteger]

{ #category : #output }
BITMAPV5HEADER >> sizeImage [
	^self bV5SizeImage]

{ #category : #input }
BITMAPV5HEADER >> sizeImage: anInteger [
	self bV5SizeImage: anInteger]

{ #category : #output }
BITMAPV5HEADER >> width [
	^self bV5Width]

{ #category : #input }
BITMAPV5HEADER >> width: anInteger [
	self bV5Width: anInteger]

{ #category : #output }
BITMAPV5HEADER >> xPelsPerMeter [
	^self bV5XPelsPerMeter]

{ #category : #input }
BITMAPV5HEADER >> xPelsPerMeter: anInteger [
	self bV5XPelsPerMeter: anInteger]

{ #category : #output }
BITMAPV5HEADER >> yPelsPerMeter [
	^self bV5YPelsPerMeter]

{ #category : #input }
BITMAPV5HEADER >> yPelsPerMeter: anInteger [
	self bV5YPelsPerMeter: anInteger]

