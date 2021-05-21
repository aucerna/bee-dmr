"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #OverriddenMethod }

{ #category : '*ProjectChanges' }
OverriddenMethod >> asChangeIn: aBeeProject [
	^OverriddenMethodDefinition fromCompiledMethod: self in: aBeeProject]

