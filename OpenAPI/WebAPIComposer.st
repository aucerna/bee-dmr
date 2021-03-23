"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #WebAPIComposer }

{ #category : '*OpenAPI' }
WebAPIComposer >> documentation [
	^OpenAPI.Writer documentForAPI: self]

