"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #SmalltalkSession }

{ #category : '*XML' }
SmalltalkSession class >> petitXmlJustLoaded [
	Compiler registerParser: PPXmlParser forPragma: '<xml>']

