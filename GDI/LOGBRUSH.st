"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #LOGBRUSH,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
LOGBRUSH class >> def [
	^<def>
	typedef struct tagLOGBRUSH {
		UINT      lbStyle;
		COLORREF  lbColor;
		ULONG_PTR lbHatch;
	} LOGBRUSH, *PLOGBRUSH;
	</def>]

{ #category : #accessing }
LOGBRUSH class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 16;
		at: 'lbStyle' put: 0;
		at: 'lbColor' put: 4;
		at: 'lbHatch' put: 8;
		yourself]

{ #category : #accessing }
LOGBRUSH class >> sizeInBytes [
	^sizeInBytes]

{ #category : #output }
LOGBRUSH >> color [
	^self lbColor asColor]

{ #category : #input }
LOGBRUSH >> color: aColor [
	| color data |
	color := aColor isInteger
		ifTrue: [RGBColor fromInteger: aColor]
		ifFalse: [aColor].
	data := COLORREF fromColor: color.
	self lbColor: data]

{ #category : #output }
LOGBRUSH >> hatch [
	^self lbHatch]

{ #category : #input }
LOGBRUSH >> hatch: anInteger [
	self lbHatch: anInteger]

{ #category : #accessing }
LOGBRUSH >> lbColor [
	| data |
	data := self bytesAtOffset: lbColor count: COLORREF sizeInBytes.
	^COLORREF usingBytes: data]

{ #category : #accessing }
LOGBRUSH >> lbColor: aCOLORREF [
	self bytesAtOffset: lbColor put: aCOLORREF contents]

{ #category : #accessing }
LOGBRUSH >> lbHatch [
	^self pointerAtOffset: lbHatch]

{ #category : #accessing }
LOGBRUSH >> lbHatch: anInteger [
	self pointerAtOffset: lbHatch put: anInteger]

{ #category : #accessing }
LOGBRUSH >> lbStyle [
	^self uLongAtOffset: lbStyle]

{ #category : #accessing }
LOGBRUSH >> lbStyle: anInteger [
	self uLongAtOffset: lbStyle put: anInteger]

{ #category : #output }
LOGBRUSH >> style [
	^self lbStyle]

{ #category : #input }
LOGBRUSH >> style: anInteger [
	self lbStyle: anInteger]

