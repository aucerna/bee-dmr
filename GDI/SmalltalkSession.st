"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #SmalltalkSession }

{ #category : '*GDI' }
SmalltalkSession class >> startupGDI [
	GDIDLL startUp.
	GDIObject startUp]

