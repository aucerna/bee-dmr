"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RECT,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
RECT class >> def [
	^<def>
	typedef struct _RECT {
		LONG left;
		LONG top;
		LONG right;
		LONG bottom;
	} RECT, *PRECT;
	</def>]

{ #category : #'instance creation' }
RECT class >> from: aRectangle [
	^self new from: aRectangle]

{ #category : #accessing }
RECT class >> sizeInBytes [
	^sizeInBytes]

{ #category : #converting }
RECT >> asRectangle [
	^self isValid
		ifTrue: [self left @ self top corner: self right @ self bottom]]

{ #category : #accessing }
RECT >> bottom [
	^self longAtOffset: bottom]

{ #category : #accessing }
RECT >> bottom: anInteger [
	self longAtOffset: bottom put: anInteger]

{ #category : #converting }
RECT >> from: aRectangle [
	^self
		left: aRectangle left;
		bottom: aRectangle bottom;
		right: aRectangle right;
		top: aRectangle top]

{ #category : #accessing }
RECT >> left [
	^self longAtOffset: left]

{ #category : #accessing }
RECT >> left: anInteger [
	self longAtOffset: left put: anInteger]

{ #category : #printing }
RECT >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		nextPutAll: ' (';
		nextPutAll: self asRectangle printString;
		nextPut: $)]

{ #category : #accessing }
RECT >> right [
	^self longAtOffset: right]

{ #category : #accessing }
RECT >> right: anInteger [
	self longAtOffset: right put: anInteger]

{ #category : #accessing }
RECT >> top [
	^self longAtOffset: top]

{ #category : #accessing }
RECT >> top: anInteger [
	self longAtOffset: top put: anInteger]

