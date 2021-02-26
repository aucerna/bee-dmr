"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ColorPalette,
	#superclass : #GdiPlusStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDIPlus
}

{ #category : #accessing }
ColorPalette class >> def [
	^<def>
	typedef struct {
		UINT Flags;
		UINT Count;
		ARGB Entries[1];
	} ColorPalette;
	</def>]

{ #category : #accessing }
ColorPalette class >> sizeInBytes [
	^sizeInBytes]

{ #category : #'instance creation' }
ColorPalette class >> withColors: aCollection [
	| palette |
	palette := self new: aCollection size * ARGB sizeInBytes + self sizeInBytes.
	^palette entries: aCollection]

{ #category : #accessing }
ColorPalette >> Count [
	^self uLongAtOffset: Count]

{ #category : #output }
ColorPalette >> count [
	^self Count]

{ #category : #accessing }
ColorPalette >> Count: anInteger [
	self uLongAtOffset: Count put: anInteger]

{ #category : #input }
ColorPalette >> count: anInteger [
	self Count: anInteger]

{ #category : #accessing }
ColorPalette >> Entries [
	| n bytes |
	n := self Count.
	bytes := self bytesAtOffset: Entries count: n.
	^BufferArray new
		contents: bytes;
		count: n;
		type: ARGB]

{ #category : #output }
ColorPalette >> entries [
	^self Entries collect: #asColor]

{ #category : #input }
ColorPalette >> entries: aCollection [
	| buffer |
	buffer := BufferArray on: aCollection type: ARGB.
	self Entries: buffer; Count: aCollection size]

{ #category : #accessing }
ColorPalette >> Entries: aBufferArray [
	self bytesAtOffset: Entries put: aBufferArray contents]

{ #category : #output }
ColorPalette >> flags [
	^self Flags]

{ #category : #accessing }
ColorPalette >> Flags [
	^self uLongAtOffset: Flags]

{ #category : #input }
ColorPalette >> flags: anInteger [
	self Flags: anInteger]

{ #category : #accessing }
ColorPalette >> Flags: anInteger [
	self uLongAtOffset: Flags put: anInteger]

{ #category : #accessing }
ColorPalette >> sizeInBytes [
	^Entries + (self Count * ARGB sizeInBytes)]

