"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Collection }

{ #category : '*FML' }
Collection >> asFmlValue [
	^FmlArray on: self]

