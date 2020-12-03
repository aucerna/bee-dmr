"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #SmalltalkSession }

{ #category : '*JavaScript' }
SmalltalkSession class >> javascriptParserJustBound [
	Compiler registerParser: JSEParser forPragma: '<js>']

