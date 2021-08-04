"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #Class}

{#category : '*BeeProjects'}
Class >> instClassVars [
	^(Object class instSize + 1 to: self class instSize) collect: [:i | self instVarAt: i]]

