"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #CharacterArray }

{ #category : '*GUIbase' }
CharacterArray >> copyToClipboard [
	Clipboard clear; putString: self
]

{ #category : '*GUIbase' }
CharacterArray >> unescaped [
	| reader writer |
	reader := self readStream.
	writer := self class new writeStream.
	[reader atEnd] whileFalse: [| integer char |
		char := reader next.
		char = $\
			ifTrue: [
				char := reader next.
				char = $\ ifTrue: [writer nextPut: char].
				integer := char asInteger.
				integer = $n asInteger ifTrue: [writer nextPut: Lf].
				integer = $t asInteger ifTrue: [writer tab].
				integer = $u asInteger ifTrue: [writer nextPut: $&]]
			ifFalse: [writer nextPut: char]].
	^writer contents]

