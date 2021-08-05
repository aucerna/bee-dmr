"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #BeeProject}

{#category : '*CodeSpecs\\Porting'}
BeeProject >> asModuleSpec [
	^BeeModuleBuilder fromProject: self]

