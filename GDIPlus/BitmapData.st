"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BitmapData,
	#superclass : #GdiPlusStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDIPlus
}

{ #category : #accessing }
BitmapData class >> def [
	^<def>
	typedef struct BitmapData {
		UINT Width;
		UINT Height;
		INT Stride;
		PixelFormat PixelFormat;
		void *Scan0;
		UINT_PTR Reserved;
	} BitmapData;
	</def>]

{ #category : #private }
BitmapData class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 32;
		at: 'Width' put: 0;
		at: 'Height' put: 4;
		at: 'Stride' put: 8;
		at: 'PixelFormat' put: 12;
		at: 'Scan0' put: 16;
		at: 'Reserved' put: 24;
		yourself]

{ #category : #accessing }
BitmapData class >> sizeInBytes [
	^sizeInBytes]

{ #category : #private }
BitmapData class >> typedefTable [
	^GDIPlusDLL typedefTable]

{ #category : #copying }
BitmapData >> copyFrom: aBitmapData [
	| stride1 stride2 stride source destination offset2 offset1 |
	stride1 := self Stride.
	stride2 := aBitmapData Stride.
	stride := stride1 abs min: stride2 abs.
	source := MemoryBuffer atMemory: aBitmapData Scan0.
	destination := MemoryBuffer atMemory: self Scan0.
	offset1 := offset2 := 0.
	(self Height min: aBitmapData Height) timesRepeat: [| bytes |
		bytes := source bytesAtOffset: offset2 count: stride.
		destination bytesAtOffset: offset1 put: bytes.
		offset2 := offset2 + stride2.
		offset1 := offset1 + stride1]]

{ #category : #output }
BitmapData >> getBytes [
	| buffer |
	buffer := MemoryBuffer atMemory: self Scan0.
	^buffer bytesAtOffset: Width count: self stride * self height]

{ #category : #output }
BitmapData >> getMask [
	| stride data offset byte threshold bytes |
	threshold := 170 " 33% ".
	stride := self stride.
	bytes := #[] writeStream.
	data := MemoryBuffer atMemory: self Scan0.
	0 to: self height - 1 do: [:row | 
		byte := 0.
		3 to: stride abs - 1 by: 4 do: [:col | 
			offset := row * stride + col.
			col > 3 & (col \\ 32 = 3) ifTrue: [
				bytes nextPut: byte.
				byte := 0].
			byte := byte bitShift: 1.
			(data byteAtOffset: offset) > threshold ifTrue: [byte := byte + 1]].
		bytes nextPut: byte].
	^bytes contents]

{ #category : #testing }
BitmapData >> hasAlphaInformation [
	| stride data offset |
	stride := self stride.
	data := MemoryBuffer atMemory: self Scan0.
	0 to: self height - 1 do: [:row | 
		3 to: stride abs - 1 by: 4 do: [:col | 
			offset := row * stride + col.
			(data byteAtOffset: offset) = 0 ifFalse: [^true]]].
	^false]

{ #category : #output }
BitmapData >> height [
	^self Height]

{ #category : #accessing }
BitmapData >> Height [
	^self uLongAtOffset: Height]

{ #category : #accessing }
BitmapData >> Height: anInteger [
	self uLongAtOffset: Height put: anInteger]

{ #category : #input }
BitmapData >> height: anInteger [
	self Height: anInteger]

{ #category : #output }
BitmapData >> pixelFormat [
	^self PixelFormat]

{ #category : #accessing }
BitmapData >> PixelFormat [
	^self uLongAtOffset: PixelFormat]

{ #category : #accessing }
BitmapData >> PixelFormat: anInteger [
	self uLongAtOffset: PixelFormat put: anInteger]

{ #category : #input }
BitmapData >> pixelFormat: anInteger [
	self PixelFormat: anInteger]

{ #category : #accessing }
BitmapData >> Reserved [
	^self pointerAtOffset: Reserved]

{ #category : #accessing }
BitmapData >> Reserved: zero [
	self pointerAtOffset: Reserved put: zero]

{ #category : #accessing }
BitmapData >> Scan0 [
	^self addressAtOffset: Scan0]

{ #category : #accessing }
BitmapData >> Scan0: anExternalMemory [
	^self addressAtOffset: Scan0 put: anExternalMemory]

{ #category : #accessing }
BitmapData >> Stride [
	^self longAtOffset: Stride]

{ #category : #output }
BitmapData >> stride [
	^self Stride]

{ #category : #accessing }
BitmapData >> Stride: anInteger [
	self longAtOffset: Stride put: anInteger]

{ #category : #input }
BitmapData >> stride: anInteger [
	self Stride: anInteger]

{ #category : #output }
BitmapData >> width [
	^self Width]

{ #category : #accessing }
BitmapData >> Width [
	^self uLongAtOffset: Width]

{ #category : #input }
BitmapData >> width: anInteger [
	self Width: anInteger]

{ #category : #accessing }
BitmapData >> Width: anInteger [
	self uLongAtOffset: Width put: anInteger]

