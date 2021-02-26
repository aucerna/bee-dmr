"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusMetafile,
	#superclass : #GDIPlusImage,
	#category : #GDIPlus
}

{ #category : #'instance creation' }
GDIPlusMetafile class >> fromEmf: anEnhMetafile [
	| pointer status |
	pointer := ExternalPointer external.
	status := self dll
		GdipCreateMetafileFromEmf: anEnhMetafile asParameter
		deleteEmf: false asParameter
		metafile: pointer asParameter.
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusMetafile class >> fromFile: aFilename [
	| file pointer status |
	file := aFilename asString externalCopy.
	pointer := ExternalPointer external.
	status := self dll
		GdipCreateMetafileFromFile: file asParameter
		metafile: pointer asParameter.
	self checkStatus: status.
	file free.
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusMetafile class >> fromWmf: aWinMetaFile [
	| pointer status |
	pointer := ExternalPointer external.
	status := self dll
		GdipCreateMetafileFromWmf: aWinMetaFile asParameter
		deleteWmf: false asParameter
		wmfPlaceableFileHeader: nil asParameter
		metafile: pointer asParameter.
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

{ #category : #converting }
GDIPlusMetafile >> asGDIPlusMetafile [
	^self]

