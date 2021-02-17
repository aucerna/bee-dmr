"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BITMAPFILEHEADER,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
BITMAPFILEHEADER class >> alignment [
	"
	see `#include <pshpack2.h>`	in WinGDI.h
	"
	^2]

{ #category : #accessing }
BITMAPFILEHEADER class >> def [
	^<def>
	typedef struct tagBITMAPFILEHEADER {
		WORD  bfType;
		DWORD bfSize;
		WORD  bfReserved1;
		WORD  bfReserved2;
		DWORD bfOffBits;
	} BITMAPFILEHEADER, *PBITMAPFILEHEADER;
	</def>]

{ #category : #'instance creation' }
BITMAPFILEHEADER class >> fromStream: aStream [
	^self new fromStream: aStream]

{ #category : #accessing }
BITMAPFILEHEADER class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
BITMAPFILEHEADER >> bfOffBits [
	^self uLongAtOffset: bfOffBits]

{ #category : #accessing }
BITMAPFILEHEADER >> bfOffBits: anInteger [
	self uLongAtOffset: bfOffBits put: anInteger]

{ #category : #accessing }
BITMAPFILEHEADER >> bfReserved1 [
	^self uShortAtOffset: bfReserved1]

{ #category : #accessing }
BITMAPFILEHEADER >> bfReserved1: anInteger [
	self uShortAtOffset: bfReserved1 put: anInteger]

{ #category : #accessing }
BITMAPFILEHEADER >> bfReserved2 [
	^self uShortAtOffset: bfReserved2]

{ #category : #accessing }
BITMAPFILEHEADER >> bfReserved2: anInteger [
	self uShortAtOffset: bfReserved2 put: anInteger]

{ #category : #accessing }
BITMAPFILEHEADER >> bfSize [
	^self uLongAtOffset: bfSize]

{ #category : #accessing }
BITMAPFILEHEADER >> bfSize: anInteger [
	self uLongAtOffset: bfSize put: anInteger]

{ #category : #accessing }
BITMAPFILEHEADER >> bfType [
	| bytes |
	bytes := self bytesAtOffset: bfType count: 2.
	self ASSERT: bytes asString = 'BM'.
	^bytes]

{ #category : #accessing }
BITMAPFILEHEADER >> bfType: aByteArray [
	self ASSERT: aByteArray = 'BM' asByteArray.
	self bytesAtOffset: bfType put: aByteArray]

{ #category : #private }
BITMAPFILEHEADER >> fromStream: aStream [
	self
		bfType: (aStream next: 2) asByteArray;
		bfSize: aStream nextULong.
	aStream nextUShort; nextUShort.
	self offBits: aStream nextULong]

{ #category : #initialization }
BITMAPFILEHEADER >> initialize: anInteger [
	super initialize: anInteger.
	self
		bfType: 'BM' asByteArray;
		bfReserved1: 0;
		bfReserved2: 0]

{ #category : #output }
BITMAPFILEHEADER >> offBits [
	^self bfOffBits]

{ #category : #input }
BITMAPFILEHEADER >> offBits: anInteger [
	self uLongAtOffset: bfOffBits put: anInteger]

{ #category : #output }
BITMAPFILEHEADER >> type [
	^self bfType asString]

