"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GdiPlusStructure,
	#superclass : #WindowsStructure,
	#category : #GDIPlus
}

{ #category : #accessing }
GdiPlusStructure >> realAtOffset: anInteger [
	| bytes |
	bytes := self bytesAtOffset: anInteger count: 4.
	^ExternalFloat fromBytes: bytes]

{ #category : #accessing }
GdiPlusStructure >> realAtOffset: anInteger put: aFloat [
	| real |
	real := ExternalFloat from: aFloat.
	self bytesAtOffset: anInteger put: real asParameter]

