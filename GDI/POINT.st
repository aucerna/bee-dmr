"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #POINT,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
POINT class >> def [
	^<def>
	typedef struct tagPOINT {
		LONG x;
		LONG y;
	} POINT, *PPOINT;
	</def>]

{ #category : #'instance creation' }
POINT class >> from: aPoint [
	^self new from: aPoint]

{ #category : #'instance creation' }
POINT class >> fromInteger: anInteger [
	^self new fromInteger: anInteger]

{ #category : #'instance creation' }
POINT class >> fromPoint: aPoint [
	^self from: aPoint]

{ #category : #accessing }
POINT class >> sizeInBytes [
	^sizeInBytes]

{ #category : #converting }
POINT >> asInteger [
	^ExternalInt32 new
		shortAtOffset: 0 put: self x;
		shortAtOffset: 2 put: self y;
		asInteger]

{ #category : #converting }
POINT >> asPoint [
	^self x @ self y]

{ #category : #private }
POINT >> from: aPoint [
	self x: aPoint x; y: aPoint y]

{ #category : #private }
POINT >> fromInteger: anInteger [
	| long a b |
	long := ExternalInt32 fromInteger: anInteger.
	a := long shortAtOffset: x.
	b := long shortAtOffset: 2.
	self x: a; y: b]

{ #category : #private }
POINT >> fromPoint: aPoint [
	self from: aPoint]

{ #category : #printing }
POINT >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		nextPutAll: ' {';
		nextPutAll: self asPoint printString;
		nextPut: $}]

{ #category : #accessing }
POINT >> x [
	^self longAtOffset: x]

{ #category : #accessing }
POINT >> x: anInteger [
	self longAtOffset: x put: anInteger]

{ #category : #accessing }
POINT >> y [
	^self longAtOffset: y]

{ #category : #accessing }
POINT >> y: anInteger [
	self longAtOffset: y put: anInteger]

