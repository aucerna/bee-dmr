"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MONITORINFOEX,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #'instance creation' }
MONITORINFOEX class >> current [
	^self fromPoint: CursorPointer current position]

{ #category : #private }
MONITORINFOEX class >> def [
	^<def>
	typedef struct tagMONITORINFOEX {
		DWORD cbSize;
		RECT  rcMonitor;
		RECT  rcWork;
		DWORD dwFlags;
		TCHAR szDevice[CCHDEVICENAME];
	} MONITORINFOEX, *LPMONITORINFOEX;
	</def>]

{ #category : #'instance creation' }
MONITORINFOEX class >> fromHandle: anInteger [
	^self external fromHandle: anInteger; makeLocal]

{ #category : #'instance creation' }
MONITORINFOEX class >> fromPoint: aPoint [
	| handle |
	handle := UserDLL current monitorFromPoint: aPoint.
	^self fromHandle: handle]

{ #category : #'instance creation' }
MONITORINFOEX class >> fromWindow: aWindow [
	| handle |
	handle := UserDLL current monitorFromWindow: aWindow.
	^self fromHandle: handle]

{ #category : #accessing }
MONITORINFOEX class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
MONITORINFOEX >> cbSize [
	^self uLongAtOffset: cbSize]

{ #category : #accessing }
MONITORINFOEX >> cbSize: anInteger [
	self uLongAtOffset: cbSize put: anInteger]

{ #category : #output }
MONITORINFOEX >> device [
	^UTF16 current decode: self szDevice]

{ #category : #accessing }
MONITORINFOEX >> dwFlags [
	^self uLongAtOffset: dwFlags]

{ #category : #accessing }
MONITORINFOEX >> dwFlags: anInteger [
	self uLongAtOffset: dwFlags put: anInteger]

{ #category : #private }
MONITORINFOEX >> fromHandle: anInteger [
	| success |
	self ASSERT: self isInExternalMemory.
	success := UserDLL current
		GetMonitorInfo: anInteger asParameter
		lpmi: self asParameter.
	success ifFalse: [self winError]]

{ #category : #initialization }
MONITORINFOEX >> initialize: anInteger [
	super initialize: anInteger.
	self cbSize: self sizeInBytes]

{ #category : #output }
MONITORINFOEX >> monitorRectangle [
	^self rcMonitor asRectangle]

{ #category : #accessing }
MONITORINFOEX >> rcMonitor [
	^self structureAtOffset: rcMonitor ofClass: RECT]

{ #category : #accessing }
MONITORINFOEX >> rcMonitor: aRECT [
	self bytesAtOffset: rcMonitor put: aRECT asParameter]

{ #category : #accessing }
MONITORINFOEX >> rcWork [
	^self structureAtOffset: rcWork ofClass: RECT]

{ #category : #accessing }
MONITORINFOEX >> rcWork: aRECT [
	self bytesAtOffset: rcWork put: aRECT asParameter]

{ #category : #accessing }
MONITORINFOEX >> szDevice [
	^self bytesAtOffset: szDevice count: CCHDEVICENAME]

{ #category : #accessing }
MONITORINFOEX >> szDevice: aString [
	self ASSERT: aString size <= CCHDEVICENAME.
	self bytesAtOffset: szDevice put: aString utf16]

{ #category : #output }
MONITORINFOEX >> workingArea [
	^self rcWork asRectangle]

