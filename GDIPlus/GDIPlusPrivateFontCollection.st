"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusPrivateFontCollection,
	#superclass : #GDIPlusFontCollection,
	#category : #GDIPlus
}

{ #category : #'instance creation' }
GDIPlusPrivateFontCollection class >> newPrivateFontCollection [
	| handle status |
	handle := ExternalPointer external.
	status := self dll GdipNewPrivateFontCollection: handle asParameter.
	self checkStatus: status.
	^self fromHandle: handle makeLocal]

{ #category : #adding }
GDIPlusPrivateFontCollection >> addFontFile: aString [
	| filename |
	filename := aString externalCopy.
	status := self dll
		GdipPrivateAddFontFile: self asParameter
		filename: filename asParameter.
	self checkStatus.
	filename free]

{ #category : #adding }
GDIPlusPrivateFontCollection >> addMemoryFont: aByteObject [
	status := self dll
		GdipPrivateAddMemoryFont: self asParameter
		memory: aByteObject asParameter
		length: aByteObject size.
	self checkStatus]

{ #category : #private }
GDIPlusPrivateFontCollection >> basicRelease [
	status := self dll GdipDeletePrivateFontCollection: self asParameter.
	self checkStatus]

