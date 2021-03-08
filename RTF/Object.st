"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Object }

{ #category : '*RTF' }
Object >> asText [
	| text |
	text := Rtf new useCrOnly
		setFont: GDIFont defaultTextFont;
		setTabStops: (300 to: 9600 by: 300).
	self printTextOn: text.
	^text]

