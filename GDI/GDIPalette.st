"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPalette,
	#superclass : #GDILogicalObject,
	#instVars : [
		'logPalette'
	],
	#category : #GDI
}

{ #category : #initialization }
GDIPalette class >> default [
	^self stockObject: DEFAULT_PALETTE]

{ #category : #'instance creation' }
GDIPalette class >> fromStruct: aLOGPALETTE [
	^self new fromStruct: aLOGPALETTE]

{ #category : #accessing }
GDIPalette class >> structClass [
	^LOGPALETTE]

{ #category : #accessing }
GDIPalette class >> threshold [
	^16]

{ #category : #private }
GDIPalette >> create [
	| ulong struct |
	stockObject notNil ifTrue: [^self class stockObject: stockObject].
	struct := logPalette externalCopy.
	ulong := GDILibrary CreatePalette: struct asParameter.
	ulong = 0 ifTrue: [^self winError].
	struct free.
	^ulong]

{ #category : #private }
GDIPalette >> fromStruct: aLOGPALETTE [
	logPalette := aLOGPALETTE.
	handle isNil ifTrue: [self createObject]]

{ #category : #inquiries }
GDIPalette >> indexOf: aCOLORREF [
	| index |
	index := GDILibrary
		GetNearestPaletteIndex: self asParameter
		color: aCOLORREF asParameter.
	index = CLR_INVALID ifTrue: [^self winError].
	^16r1000000 | index]

