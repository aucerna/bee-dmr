"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusCachedBitmap,
	#superclass : #GDIPlusObject,
	#instVars : [
		'bounds'
	],
	#category : #GDIPlus
}

{ #category : #'instance creation' }
GDIPlusCachedBitmap class >> fromBitmap: aGDIPlusBitmap graphics: aGDIPlusGraphics [
	| pointer status bitmap |
	pointer := ExternalPointer external.
	status := self dll
		GdipCreateCachedBitmap: aGDIPlusBitmap asParameter
		graphics: aGDIPlusGraphics asParameter
		cachedBitmap: pointer asParameter.
	self checkStatus: status.
	bitmap := self fromHandle: pointer makeLocal.
	bitmap bounds: aGDIPlusBitmap bounds.
	^bitmap]

{ #category : #converting }
GDIPlusCachedBitmap >> asGDIPlusBitmap [
	^self]

{ #category : #private }
GDIPlusCachedBitmap >> basicRelease [
	status := self dll GdipDeleteCachedBitmap: self asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusCachedBitmap >> bounds [
	^bounds]

{ #category : #private }
GDIPlusCachedBitmap >> bounds: aRectangle [
	bounds := aRectangle]

{ #category : #accessing }
GDIPlusCachedBitmap >> extent [
	^self bounds extent]

{ #category : #testing }
GDIPlusCachedBitmap >> isCachedBitmap [
	^true]

