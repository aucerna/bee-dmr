"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PointF,
	#superclass : #GdiPlusStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDIPlus
}

{ #category : #accessing }
PointF class >> def [
	^<def>
	typedef struct tagPOINTF {
		FLOAT x;
		FLOAT y;
	} POINTF, *LPPOINTF;
	</def>]

{ #category : #'instance creation' }
PointF class >> from: aPoint [
	^self new from: aPoint]

{ #category : #'instance creation' }
PointF class >> fromPoint: aPoint [
	^self from: aPoint]

{ #category : #accessing }
PointF class >> sizeInBytes [
	^sizeInBytes]

{ #category : #converting }
PointF >> asPoint [
	^self x @ self y]

{ #category : #accessing }
PointF >> from: aPoint [
	self x: aPoint x; y: aPoint y]

{ #category : #printing }
PointF >> printOn: aStream [
	aStream
		nextPutAll: self class name , ' { ' , self asPoint printString , ' } ']

{ #category : #accessing }
PointF >> x [
	^(self realAtOffset: x) asFloat]

{ #category : #accessing }
PointF >> x: aFloat [
	self realAtOffset: x put: aFloat]

{ #category : #accessing }
PointF >> y [
	^(self realAtOffset: y) asFloat]

{ #category : #accessing }
PointF >> y: aFloat [
	self realAtOffset: y put: aFloat]

