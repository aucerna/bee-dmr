"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #SmalltalkSession }

{ #category : '*JSON' }
SmalltalkSession class >> jsonSupportJustBound [
	Compiler registerParser: JsonParser forPragma: '<json>']

