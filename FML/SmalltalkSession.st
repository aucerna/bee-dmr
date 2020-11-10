"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #SmalltalkSession }

{ #category : '*FML' }
SmalltalkSession class >> fmlJustBound [
	Compiler registerParser: FmlParser forPragma: '<fml>']

