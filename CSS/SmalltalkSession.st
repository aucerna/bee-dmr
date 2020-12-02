"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #SmalltalkSession }

{ #category : '*CSS' }
SmalltalkSession class >> csslJustBound [
	Compiler registerParser: CssStyleSheet forPragma: '<css>']

