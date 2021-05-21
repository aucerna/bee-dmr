"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #SmalltalkSession }

{ #category : '*ProjectChanges' }
SmalltalkSession class >> projectChangesJustBound [
	BeeModule allProjects do: [:p | p initializeChanges]]

