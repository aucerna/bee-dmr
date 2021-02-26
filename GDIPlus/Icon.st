"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Icon }

{ #category : '*GDIPlus' }
Icon >> asGDIPlusBitmap [
	^GDIPlusBitmap fromHIcon: handle]

