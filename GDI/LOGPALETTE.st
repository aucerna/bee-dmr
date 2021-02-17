"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #LOGPALETTE,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
LOGPALETTE class >> def [
	^<def>
	typedef struct tagLOGPALETTE {
		WORD palVersion;
		WORD palNumEntries;
		PALETTEENTRY palPalEntry[1];
	} LOGPALETTE;
	</def>]

{ #category : #'instance creation' }
LOGPALETTE class >> fromColorTable: aByteArray [
	^self new fromColorTable: aByteArray]

{ #category : #accessing }
LOGPALETTE class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 8;
		at: 'palVersion' put: 0;
		at: 'palNumEntries' put: 2;
		at: 'palPalEntry' put: 4;
		yourself]

{ #category : #accessing }
LOGPALETTE class >> sizeInBytes [
	^sizeInBytes]

{ #category : #comparing }
LOGPALETTE >> = aLOGPALETTE [
	self class == aLOGPALETTE class ifFalse: [^false].
	^self contents = aLOGPALETTE contents]

{ #category : #output }
LOGPALETTE >> entries [
	^BufferArray new
		contents: self palPalEntry;
		asArrayOf: PALETTEENTRY count: self palNumEntries]

{ #category : #input }
LOGPALETTE >> entries: aCollection [
	| array |
	array := BufferArray on: aCollection type: PALETTEENTRY.
	self palPalEntry: array contents]

{ #category : #input }
LOGPALETTE >> fromColorTable: aByteArray [
	| array buffer |
	array := BufferArray new contents: aByteArray; asArrayOf: RGBQUAD.
	array := array collect: [:quad | PALETTEENTRY fromRGBQUAD: quad].
	buffer := BufferArray on: array type: PALETTEENTRY.
	self palNumEntries: array size; palPalEntry: buffer contents]

{ #category : #comparing }
LOGPALETTE >> hash [
	^self contents hash]

{ #category : #initialization }
LOGPALETTE >> initialize: anInteger [
	super initialize: anInteger.
	self palVersion: 16r300]

{ #category : #accessing }
LOGPALETTE >> palNumEntries [
	^self uShortAtOffset: palNumEntries]

{ #category : #accessing }
LOGPALETTE >> palNumEntries: anInteger [
	self uShortAtOffset: palNumEntries put: anInteger]

{ #category : #accessing }
LOGPALETTE >> palPalEntry [
	^self bytesAtOffset: palPalEntry count: self palNumEntries * PALETTEENTRY sizeInBytes]

{ #category : #accessing }
LOGPALETTE >> palPalEntry: data [
	| n |
	n := 4 + data sizeInBytes - contents size.
	n > 0 ifTrue: [contents := contents , (ByteArray new: n)].
	self bytesAtOffset: palPalEntry put: data]

{ #category : #accessing }
LOGPALETTE >> palVersion [
	^self uShortAtOffset: palVersion]

{ #category : #accessing }
LOGPALETTE >> palVersion: anInteger [
	self uShortAtOffset: palVersion put: anInteger]

{ #category : #accessing }
LOGPALETTE >> sizeInBytes [
	^self palNumEntries * PALETTEENTRY sizeInBytes + palPalEntry]

{ #category : #output }
LOGPALETTE >> version [
	^self palVersion]

{ #category : #input }
LOGPALETTE >> version: anInteger [
	self palVersion: anInteger]

