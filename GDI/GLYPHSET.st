"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GLYPHSET,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
GLYPHSET class >> def [
	^<def>
	typedef struct tagGLYPHSET {
		DWORD   cbThis;
		DWORD   flAccel;
		DWORD   cGlyphsSupported;
		DWORD   cRanges;
		WCRANGE ranges[1];
	} GLYPHSET, *PGLYPHSET;
	</def>]

{ #category : #accessing }
GLYPHSET class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 20;
		at: 'cbThis' put: 0;
		at: 'flAccel' put: 4;
		at: 'cGlyphsSupported' put: 8;
		at: 'cRanges' put: 12;
		at: 'ranges' put: 16;
		yourself]

{ #category : #accessing }
GLYPHSET class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
GLYPHSET >> cbThis [
	^self uLongAtOffset: cbThis]

{ #category : #accessing }
GLYPHSET >> cbThis: anInteger [
	self uLongAtOffset: cbThis put: anInteger]

{ #category : #accessing }
GLYPHSET >> cGlyphsSupported [
	^self uLongAtOffset: cGlyphsSupported]

{ #category : #accessing }
GLYPHSET >> cRanges [
	^self uLongAtOffset: cRanges]

{ #category : #accessing }
GLYPHSET >> flAccel [
	^self uLongAtOffset: flAccel]

{ #category : #testing }
GLYPHSET >> includes: aCharacter [
	| integer |
	integer := aCharacter asInteger.
	self ranges do: [:range | (range includes: integer) ifTrue: [^true]].
	^false]

{ #category : #initialization }
GLYPHSET >> initialize: anInteger [
	super initialize: anInteger.
	self cbThis: anInteger]

{ #category : #accessing }
GLYPHSET >> ranges [
	| count data |
	count := self cRanges.
	data := self bytesAtOffset: ranges count: WCRANGE sizeInBytes * count.
	^BufferArray new
		type: WCRANGE;
		count: count;
		contents: data]

{ #category : #accessing }
GLYPHSET >> sizeInBytes [
	^WCRANGE sizeInBytes * self cRanges + ranges]

