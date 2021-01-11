"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #String }

{ #category : '*HTTP' }
String >> asURL [
	^URL fromString: self trimBlanks]

