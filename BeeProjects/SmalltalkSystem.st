"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #SmalltalkSystem}

{#category : '*BeeProjects'}
SmalltalkSystem >> overriddenMethodsSelect: selectBlock thenDo: aBlock [
	BeeModule simpleProjectsDo: [:project | 
		project hasOverriddenVersions
			ifTrue: [project overriddenVersions select: selectBlock thenDo: aBlock]]]

