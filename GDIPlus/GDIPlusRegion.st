"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusRegion,
	#superclass : #GDIPlusObject,
	#category : #GDIPlus
}

{ #category : #'instance creation' }
GDIPlusRegion class >> fromPath: aGDIPlusGraphicsPath [
	| pointer status |
	pointer := ExternalPointer external.
	status := self dll
		GdipCreateRegionPath: aGDIPlusGraphicsPath asParameter
		region: pointer asParameter.
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusRegion class >> fromRectangle: aRectangle [
	| pointer status rect |
	pointer := ExternalPointer external.
	rect := RectF external from: aRectangle.
	status := self dll
		GdipCreateRegionRect: rect asParameter
		region: pointer asParameter.
	self checkStatus: status.
	rect free.
	^self fromHandle: pointer]

{ #category : #'instance creation' }
GDIPlusRegion class >> new [
	| pointer status |
	pointer := ExternalPointer external.
	status := self dll GdipCreateRegion: pointer asParameter.
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

{ #category : #private }
GDIPlusRegion >> basicRelease [
	status := self dll GdipDeleteRegion: self asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusRegion >> combinePath: aGDIPlusGraphicsPath mode: combineMode [
	status := self dll
		GdipCombineRegionPath: self asParameter
		path: aGDIPlusGraphicsPath asParameter
		combineMode: combineMode.
	self checkStatus]

{ #category : #accessing }
GDIPlusRegion >> combineRectangle: aRectangle mode: combineMode [
	| rect |
	rect := RectF external from: aRectangle.
	status := self dll
		GdipCombineRegionRectI: self asParameter
		rect: rect asParameter
		combineMode: combineMode.
	rect free.
	self checkStatus]

{ #category : #accessing }
GDIPlusRegion >> combineRegion: aRegion mode: combineMode [
	status := self dll
		GdipCombineRegionRegion: self asParameter
		region2: aRegion asParameter
		combineMode: combineMode.
	self checkStatus]

{ #category : #accessing }
GDIPlusRegion >> complementPath: aPath [
	self combinePath: aPath mode: CombineModeComplement]

{ #category : #accessing }
GDIPlusRegion >> complementRegion: aRegion [
	self combineRegion: aRegion mode: CombineModeComplement]

{ #category : #accessing }
GDIPlusRegion >> intersectRegion: aRegion [
	self combineRegion: aRegion mode: CombineModeIntersect]

{ #category : #testing }
GDIPlusRegion >> isVisible: aPoint [
	^self isVisible: aPoint graphics: nil]

{ #category : #testing }
GDIPlusRegion >> isVisible: aPoint graphics: aGDIPlusGraphics [
	| result |
	result := ExternalInt32 external.
	status := self dll
		GdipIsVisibleRegionPointI: self asParameter
		x: aPoint x
		y: aPoint y
		graphics: aGDIPlusGraphics asParameter
		result: result asParameter.
	self checkStatus.
	^result makeLocal asBoolean]

{ #category : #accessing }
GDIPlusRegion >> makeEmpty [
	status := self dll GdipSetEmpty: self asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusRegion >> makeInfinite [
	status := self dll GdipSetInfinite: self asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusRegion >> rectangle: aRectangle [
	self combineRectangle: aRectangle mode: CombineModeReplace]

{ #category : #accessing }
GDIPlusRegion >> unionRegion: aRegion [
	self combineRegion: aRegion mode: CombineModeUnion]

{ #category : #accessing }
GDIPlusRegion >> xorRegion: aRegion [
	self combineRegion: aRegion mode: CombineModeXor]

