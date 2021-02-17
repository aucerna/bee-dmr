"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BitmapHeaderStructure,
	#superclass : #WindowsStructure,
	#category : #GDI
}

{ #category : #output }
BitmapHeaderStructure >> bitCount [
	^self subclassResponsibility]

{ #category : #input }
BitmapHeaderStructure >> bitCount: anInteger [
	self subclassResponsibility]

{ #category : #input }
BitmapHeaderStructure >> bitfields [
	self compression: BI_BITFIELDS]

{ #category : #output }
BitmapHeaderStructure >> calculatedImageSize [
	^self bitCount * self width + 31 // 32 * 4 * self height]

{ #category : #output }
BitmapHeaderStructure >> clrImportant [
	^self subclassResponsibility]

{ #category : #input }
BitmapHeaderStructure >> clrImportant: anInteger [
	self subclassResponsibility]

{ #category : #output }
BitmapHeaderStructure >> clrUsed [
	^self subclassResponsibility]

{ #category : #input }
BitmapHeaderStructure >> clrUsed: anInteger [
	self subclassResponsibility]

{ #category : #private }
BitmapHeaderStructure >> colorTableSize [
	| bits max |
	bits := self bitCount.
	max := GDIBitmap maxColorTableDepth.
	bits < max ifTrue: [^(1 bitShift: bits) * 4].
	bits = max ifTrue: [^12].
	^0]

{ #category : #output }
BitmapHeaderStructure >> compression [
	^self subclassResponsibility]

{ #category : #input }
BitmapHeaderStructure >> compression: anInteger [
	self subclassResponsibility]

{ #category : #input }
BitmapHeaderStructure >> fromInfo: aBITMAPINFO [
	self
		width: aBITMAPINFO width
		height: aBITMAPINFO height
		planes: aBITMAPINFO planes
		bitCount: aBITMAPINFO bitCount]

{ #category : #input }
BitmapHeaderStructure >> fromStream: aStream [
	self
		size: aStream nextULong;
		width: aStream nextULong;
		height: aStream nextULong;
		planes: aStream nextUShort;
		bitCount: aStream nextUShort;
		compression: aStream nextULong;
		sizeImage: aStream nextULong;
		xPelsPerMeter: aStream nextULong;
		yPelsPerMeter: aStream nextULong;
		clrUsed: aStream nextULong;
		clrImportant: aStream nextULong]

{ #category : #output }
BitmapHeaderStructure >> height [
	^self subclassResponsibility]

{ #category : #input }
BitmapHeaderStructure >> height: anInteger [
	self subclassResponsibility]

{ #category : #output }
BitmapHeaderStructure >> imageSize [
	| size |
	size := self sizeImage.
	^size = 0 ifTrue: [self calculatedImageSize] ifFalse: [size]]

{ #category : #initialization }
BitmapHeaderStructure >> initialize: anInteger [
	super initialize: anInteger.
	self size: anInteger]

{ #category : #input }
BitmapHeaderStructure >> jpeg [
	self compression: BI_JPEG]

{ #category : #output }
BitmapHeaderStructure >> planes [
	^self subclassResponsibility]

{ #category : #input }
BitmapHeaderStructure >> planes: anInteger [
	self subclassResponsibility]

{ #category : #input }
BitmapHeaderStructure >> png [
	self compression: BI_PNG]

{ #category : #input }
BitmapHeaderStructure >> rle4 [
	self compression: BI_RLE4]

{ #category : #input }
BitmapHeaderStructure >> rle8 [
	self compression: BI_RLE8]

{ #category : #output }
BitmapHeaderStructure >> size [
	^self subclassResponsibility]

{ #category : #input }
BitmapHeaderStructure >> size: anInteger [
	self subclassResponsibility]

{ #category : #output }
BitmapHeaderStructure >> sizeImage [
	^self subclassResponsibility]

{ #category : #input }
BitmapHeaderStructure >> sizeImage: anInteger [
	self biSizeImage: anInteger]

{ #category : #private }
BitmapHeaderStructure >> StringFormatter [
	]

{ #category : #input }
BitmapHeaderStructure >> uncompressed [
	self compression: BI_RGB]

{ #category : #output }
BitmapHeaderStructure >> width [
	^self subclassResponsibility]

{ #category : #input }
BitmapHeaderStructure >> width: anInteger [
	self subclassResponsibility]

{ #category : #input }
BitmapHeaderStructure >> width: w
height: h
planes: planes
bitCount: bitCount [
	self
		biWidth: w;
		biHeight: h;
		biPlanes: planes;
		biBitCount: bitCount.
	bitCount = GDIBitmap maxColorTableDepth
		ifTrue: [self bitfields; biClrUsed: 3]]

{ #category : #output }
BitmapHeaderStructure >> xPelsPerMeter [
	^self subclassResponsibility]

{ #category : #input }
BitmapHeaderStructure >> xPelsPerMeter: anInteger [
	self subclassResponsibility]

{ #category : #output }
BitmapHeaderStructure >> yPelsPerMeter [
	^self subclassResponsibility]

{ #category : #input }
BitmapHeaderStructure >> yPelsPerMeter: anInteger [
	self subclassResponsibility]

