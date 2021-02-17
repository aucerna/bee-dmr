"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SIZE,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
SIZE class >> def [
	^<def>
	typedef struct tagSIZE {
		LONG cx;
		LONG cy;
	} SIZE, *PSIZE;
	</def>]

{ #category : #'instance creation' }
SIZE class >> from: aPoint [
	^self new from: aPoint]

{ #category : #accessing }
SIZE class >> sizeInBytes [
	^sizeInBytes]

{ #category : #converting }
SIZE >> asPoint [
	^self width @ self height]

{ #category : #accessing }
SIZE >> cx [
	^self longAtOffset: cx]

{ #category : #accessing }
SIZE >> cx: anInteger [
	self longAtOffset: cx put: anInteger]

{ #category : #accessing }
SIZE >> cy [
	^self longAtOffset: cy]

{ #category : #accessing }
SIZE >> cy: anInteger [
	self longAtOffset: cy put: anInteger]

{ #category : #private }
SIZE >> from: aPoint [
	self width: aPoint x; height: aPoint y]

{ #category : #output }
SIZE >> height [
	^self cy]

{ #category : #input }
SIZE >> height: anInteger [
	self cy: anInteger]

{ #category : #output }
SIZE >> width [
	^self cx]

{ #category : #input }
SIZE >> width: anInteger [
	self cx: anInteger]

