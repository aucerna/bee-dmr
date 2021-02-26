"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GdiplusStartupInput,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDIPlus
}

{ #category : #accessing }
GdiplusStartupInput class >> def [
	^<def>
	typedef struct {
		UINT32         GdiplusVersion;
		DebugEventProc DebugEventCallback;
		BOOL           SuppressBackgroundThread;
		BOOL           SuppressExternalCodecs;
	} GdiplusStartupInput;
	</def>]

{ #category : #private }
GdiplusStartupInput class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 24;
		at: 'GdiplusVersion' put: 0;
		at: 'DebugEventCallback' put: 8;
		at: 'SuppressBackgroundThread' put: 16;
		at: 'SuppressExternalCodecs' put: 20;
		yourself]

{ #category : #accessing }
GdiplusStartupInput class >> sizeInBytes [
	^sizeInBytes]

{ #category : #private }
GdiplusStartupInput class >> typedefTable [
	^GDIPlusDLL typedefTable]

{ #category : #accessing }
GdiplusStartupInput >> DebugEventProc [
	^self callbackAtOffset: DebugEventCallback]

{ #category : #accessing }
GdiplusStartupInput >> DebugEventProc: aCallbackMethod [
	self callbackAtOffset: DebugEventCallback put: aCallbackMethod]

{ #category : #accessing }
GdiplusStartupInput >> GdiplusVersion [
	^self uLongAtOffset: GdiplusVersion]

{ #category : #accessing }
GdiplusStartupInput >> GdiplusVersion: anInteger [
	self uLongAtOffset: GdiplusVersion put: anInteger]

{ #category : #initialization }
GdiplusStartupInput >> initialize: anInteger [
	super initialize: anInteger.
	self GdiplusVersion: 1; SuppressBackgroundThread: false]

{ #category : #accessing }
GdiplusStartupInput >> SuppressBackgroundThread: aBoolean [
	self booleanAtOffset: SuppressBackgroundThread put: aBoolean]

{ #category : #accessing }
GdiplusStartupInput >> SuppressExternalCodecs: aBoolean [
	self booleanAtOffset: SuppressExternalCodecs put: aBoolean]

