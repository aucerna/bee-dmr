"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusFontCollection,
	#superclass : #GDIPlusObject,
	#category : #GDIPlus
}

{ #category : #private }
GDIPlusFontCollection >> basicRelease [
	]

{ #category : #accessing }
GDIPlusFontCollection >> families [
	^self getFamilies: self familyCount]

{ #category : #accessing }
GDIPlusFontCollection >> familyCount [
	| count |
	count := ExternalInt32 external.
	status := self dll
		GdipGetFontCollectionFamilyCount: self asParameter
		numFound: count asParameter.
	self checkStatus.
	^count makeLocal asInteger]

{ #category : #private }
GDIPlusFontCollection >> getFamilies: sought [
	| handles count families |
	handles := BufferArray externalNew: sought of: ExternalPointer.
	count := ExternalInt32 external.
	status := self dll
		GdipGetFontCollectionFamilyList: self asParameter
		numSought: sought asParameter
		gpfamilies: handles asParameter
		numFound: count asParameter.
	self checkStatus.
	families := handles makeLocal copyFrom: 1 to: count makeInteger.
	^families collect: [:pointer | GDIPlusFontFamily fromHandle: pointer]]

