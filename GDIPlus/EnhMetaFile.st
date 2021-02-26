"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #EnhMetaFile }

{ #category : '*GDIPlus' }
EnhMetaFile >> asGDIPlusMetafile [
	^GDIPlusMetafile fromEmf: self]

