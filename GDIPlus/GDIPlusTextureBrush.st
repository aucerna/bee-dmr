"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusTextureBrush,
	#superclass : #GDIPlusBrush,
	#category : #GDIPlus
}

{ #category : #'instance creation' }
GDIPlusTextureBrush class >> fromImage: gdipImage wrapMode: wrapMode [
	| pointer status |
	pointer := ExternalPointer external.
	status := self dll
		GdipCreateTexture: gdipImage asParameter
		wrapmode: wrapMode asParameter
		texture: pointer asParameter.
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

