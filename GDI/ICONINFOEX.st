"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ICONINFOEX,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
ICONINFOEX class >> def [
	^<def>
		typedef struct _ICONINFOEXW {
			DWORD cbSize; // 0
			BOOL fIcon; // 4
			DWORD xHotspot; // 8
			DWORD yHotspot; // 12
			HBITMAP hbmMask; // 16
			HBITMAP hbmColor; // 20
			WORD wResID; // 24
			WCHAR szModName[MAX_PATH]; // 26
			WCHAR szResName[MAX_PATH]; // 546
		} ICONINFOEXW; // sizeInBytes = 1068
	</def>]

{ #category : #private }
ICONINFOEX class >> offsets64 [
	^PoolDictionary new
		at: 'szResName' put: 554;
		at: 'xHotspot' put: 8;
		at: 'sizeInBytes' put: 1080;
		at: 'cbSize' put: 0;
		at: 'yHotspot' put: 12;
		at: 'hbmMask' put: 16;
		at: 'szModName' put: 34;
		at: 'hbmColor' put: 24;
		at: 'fIcon' put: 4;
		at: 'wResID' put: 32;
		yourself]

{ #category : #accessing }
ICONINFOEX class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
ICONINFOEX >> cbSize [
	^self uLongAtOffset: cbSize]

{ #category : #accessing }
ICONINFOEX >> cbSize: anInteger [
	self uLongAtOffset: cbSize put: anInteger]

{ #category : #output }
ICONINFOEX >> colorBitmap [
	^GDIBitmap fromHandle: self hbmColor]

{ #category : #accessing }
ICONINFOEX >> fIcon [
	^self booleanAtOffset: fIcon]

{ #category : #accessing }
ICONINFOEX >> fIcon: anInteger [
	self booleanAtOffset: fIcon put: anInteger]

{ #category : #output }
ICONINFOEX >> filename [
	| fn |
	self resourceName isNil ifTrue: [^nil].
	fn := self szModName.
	^fn size > 0 ifTrue: [fn asFilename]]

{ #category : #accessing }
ICONINFOEX >> hbmColor [
	^self pointerAtOffset: hbmColor]

{ #category : #accessing }
ICONINFOEX >> hbmColor: anInteger [
	self pointerAtOffset: hbmColor put: anInteger]

{ #category : #accessing }
ICONINFOEX >> hbmMask [
	^self pointerAtOffset: hbmMask]

{ #category : #accessing }
ICONINFOEX >> hbmMask: anInteger [
	self pointerAtOffset: hbmMask put: anInteger]

{ #category : #output }
ICONINFOEX >> id [
	^self wResID]

{ #category : #initialization }
ICONINFOEX >> initialize: anInteger [
	super initialize: anInteger.
	self cbSize: anInteger]

{ #category : #output }
ICONINFOEX >> maskBitmap [
	^GDIBitmap fromHandle: self hbmMask]

{ #category : #output }
ICONINFOEX >> resourceName [
	^self szResName]

{ #category : #marshalling }
ICONINFOEX >> stringAtOffset: offset count: n [
	| bytes string last |
	bytes := self bytesAtOffset: offset count: n.
	string := UTF16 current decode: bytes.
	string isEmpty ifTrue: [^nil].
	string := string reduced.
	last := string findLast: [:ch | ch asInteger != 0] ifAbsent: [^string].
	^string copyFrom: 1 to: last]

{ #category : #accessing }
ICONINFOEX >> szModName [
	^self stringAtOffset: szModName count: MAX_PATH * 2]

{ #category : #accessing }
ICONINFOEX >> szModName: aString [
	self byteAtOffset: szModName put: aString utf16]

{ #category : #accessing }
ICONINFOEX >> szResName [
	^self stringAtOffset: szResName count: MAX_PATH * 2]

{ #category : #accessing }
ICONINFOEX >> szResName: aString [
	self byteAtOffset: szResName put: aString utf16]

{ #category : #accessing }
ICONINFOEX >> wResID [
	^self uShortAtOffset: wResID]

{ #category : #accessing }
ICONINFOEX >> wResID: anInteger [
	self uShortAtOffset: wResID put: anInteger]

{ #category : #accessing }
ICONINFOEX >> xHotspot [
	^self uLongAtOffset: xHotspot]

{ #category : #accessing }
ICONINFOEX >> xHotspot: anInteger [
	self uLongAtOffset: xHotspot put: anInteger]

{ #category : #accessing }
ICONINFOEX >> yHotspot [
	^self uLongAtOffset: yHotspot]

{ #category : #accessing }
ICONINFOEX >> yHotspot: anInteger [
	self uLongAtOffset: yHotspot put: anInteger]

