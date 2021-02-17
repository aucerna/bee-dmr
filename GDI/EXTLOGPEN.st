"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #EXTLOGPEN,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #private }
EXTLOGPEN class >> def [
	^<def>
		typedef struct tagEXTLOGPEN {
			DWORD     elpPenStyle;
			DWORD     elpWidth;
			UINT      elpBrushStyle;
			COLORREF  elpColor;
			ULONG_PTR elpHatch;
			DWORD     elpNumEntries;
			DWORD     elpStyleEntry[1];
		} EXTLOGPEN, *PEXTLOGPEN;
	</def>]

{ #category : #accessing }
EXTLOGPEN class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 32;
		at: 'elpPenStyle' put: 0;
		at: 'elpWidth' put: 4;
		at: 'elpBrushStyle' put: 8;
		at: 'elpColor' put: 12;
		at: 'elpHatch' put: 16;
		at: 'elpNumEntries' put: 24;
		at: 'elpStyleEntry' put: 28;
		yourself]

{ #category : #accessing }
EXTLOGPEN class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
EXTLOGPEN >> elpBrushStyle [
	^self uLongAtOffset: elpBrushStyle]

{ #category : #accessing }
EXTLOGPEN >> elpBrushStyle: anInteger [
	self uLongAtOffset: elpBrushStyle put: anInteger]

{ #category : #accessing }
EXTLOGPEN >> elpColor [
	^self structureAtOffset: elpColor ofClass: COLORREF]

{ #category : #accessing }
EXTLOGPEN >> elpColor: aCOLORREF [
	self bytesAtOffset: elpColor put: aCOLORREF asParameter]

{ #category : #accessing }
EXTLOGPEN >> elpHatch [
	^self pointerAtOffset: elpHatch]

{ #category : #accessing }
EXTLOGPEN >> elpHatch: anInteger [
	self pointerAtOffset: elpHatch put: anInteger]

{ #category : #accessing }
EXTLOGPEN >> elpNumEntries [
	^self uLongAtOffset: elpNumEntries]

{ #category : #accessing }
EXTLOGPEN >> elpNumEntries: anInteger [
	self uLongAtOffset: elpNumEntries put: anInteger]

{ #category : #accessing }
EXTLOGPEN >> elpPenStyle [
	^self uLongAtOffset: elpPenStyle]

{ #category : #accessing }
EXTLOGPEN >> elpPenStyle: anInteger [
	self uLongAtOffset: elpPenStyle put: anInteger]

{ #category : #accessing }
EXTLOGPEN >> elpStyleEntry [
	^self uLongAtOffset: elpStyleEntry]

{ #category : #accessing }
EXTLOGPEN >> elpStyleEntry: anInteger [
	self uLongAtOffset: elpStyleEntry put: anInteger]

{ #category : #accessing }
EXTLOGPEN >> elpWidth [
	^self uLongAtOffset: elpWidth]

{ #category : #accessing }
EXTLOGPEN >> elpWidth: anInteger [
	self uLongAtOffset: elpWidth put: anInteger]

