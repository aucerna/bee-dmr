"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #CharacterArray }

{ #category : '*RTF' }
CharacterArray >> formattedContents [
	| text |
	^self isRTFString ifTrue: [self] ifFalse: [
		text := Rtf new.
		text setFont: GDIFont defaultTextFont; append: self; formattedContents]]

{ #category : '*RTF' }
CharacterArray >> unformatted [
	| text |
	^self isRTFString
		ifTrue: [
			text := Rtf on: self.
			text plainContents]
		ifFalse: [self]
]

