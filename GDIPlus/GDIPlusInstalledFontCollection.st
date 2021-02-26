"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusInstalledFontCollection,
	#superclass : #GDIPlusFontCollection,
	#category : #GDIPlus
}

{ #category : #'instance creation' }
GDIPlusInstalledFontCollection class >> newInstalledFontCollection [
	| handle status |
	handle := ExternalPointer external.
	status := self dll GdipNewInstalledFontCollection: handle asParameter.
	self checkStatus: status.
	^self fromHandle: handle makeLocal]

