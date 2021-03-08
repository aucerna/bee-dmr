"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #OsClipboard }

{ #category : '*RTF' }
OsClipboard >> printTextOn: rtf [
	| text |
	self hasRichText ifTrue: [
		text := Rtf on: self getRichText.
		rtf append: text.
		^self].
	self hasText ifTrue: [
		rtf append: self getString.
		^self].
	self formats printTextOn: rtf]

