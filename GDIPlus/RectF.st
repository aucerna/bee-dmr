"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RectF,
	#superclass : #GdiPlusStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDIPlus
}

{ #category : #accessing }
RectF class >> def [
	^<def>
		typedef struct RectF {
			FLOAT left; // 0
			FLOAT top; // 4
			FLOAT right; // 8
			FLOAT bottom; // 12
		} RectF; // sizeInBytes = 16
	</def>]

{ #category : #'instance creation' }
RectF class >> from: aRectangle [
	^self new from: aRectangle]

{ #category : #'instance creation' }
RectF class >> fromRectangle: aRectangle [
	^self from: aRectangle]

{ #category : #accessing }
RectF class >> sizeInBytes [
	^sizeInBytes]

{ #category : #converting }
RectF >> asRectangle [
	^self left @ self top extent: self width @ self height]

{ #category : #accessing }
RectF >> bottom [
	^self realAtOffset: bottom ofClass: ExternalFloat]

{ #category : #accessing }
RectF >> bottom: anInteger [
	self realAtOffset: bottom put: anInteger]

{ #category : #accessing }
RectF >> from: aRectangle [
	self
		left: aRectangle left;
		top: aRectangle top;
		width: aRectangle width;
		height: aRectangle height]

{ #category : #accessing }
RectF >> height [
	^(self realAtOffset: bottom) asFloat]

{ #category : #accessing }
RectF >> height: aFloat [
	^self realAtOffset: bottom put: aFloat]

{ #category : #accessing }
RectF >> left [
	^(self realAtOffset: left) asFloat]

{ #category : #accessing }
RectF >> left: aFloat [
	^self realAtOffset: left put: aFloat]

{ #category : #printing }
RectF >> printOn: aStream [
	aStream
		nextPutAll: self class name , ' { ' , self asRectangle printString , ' } ']

{ #category : #accessing }
RectF >> right [
	^self realAtOffset: right ofClass: ExternalFloat]

{ #category : #accessing }
RectF >> right: anInteger [
	self realAtOffset: right put: anInteger]

{ #category : #accessing }
RectF >> top [
	^(self realAtOffset: top) asFloat]

{ #category : #accessing }
RectF >> top: aFloat [
	^self realAtOffset: top put: aFloat]

{ #category : #accessing }
RectF >> width [
	^(self realAtOffset: right) asFloat]

{ #category : #accessing }
RectF >> width: aFloat [
	^self realAtOffset: right put: aFloat]

