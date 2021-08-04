"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #OverriddenMethod}

{#category : '*BeeProjects'}
OverriddenMethod >> getProject [
	BeeModule
		simpleProjectsDo: [:p | (p overriddenVersions
			at: self signature
			ifAbsent: nil)
			== self
			ifTrue: [^p]].
	self ASSERT: false.
	^nil]

{#category : '*BeeProjects'}
OverriddenMethod >> project [
	^self propertyAt: #project ifAbsentPut: [self getProject]]

{#category : '*BeeProjects'}
OverriddenMethod >> project: aBeeProject [
	self propertyAt: #project put: aBeeProject]

{#category : '*BeeProjects'}
OverriddenMethod >> recompile [
	| method |
	method := super recompile.
	self project storeOverriddenMethod: method]

