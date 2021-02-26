"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #GDIBitmap }

{ #category : '*GDIPlus' }
GDIBitmap >> asGDIPlusBitmap [
	^GDIPlusBitmap named: name ifAbsent: [
		self hasAlphaChannel
			ifTrue: [GDIPlusBitmap fromAlphaBitmap: self]
			ifFalse: [GDIPlusBitmap fromHBitmap: handle]]]

