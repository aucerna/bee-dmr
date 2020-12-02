"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #SmalltalkSession }

{ #category : '*HTML' }
SmalltalkSession class >> htmlJustBound [
	Compiler registerParser: HtmlElement forPragma: '<html>']

