"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #ModuleSpec}

{#category : '*CodeSpecs\\Porting'}
ModuleSpec >> beeDefinition [
	| changes sorted meta useful extmeta |
	sorted := self sortedClasses.
	meta := sorted collect: [:c | c metaclass].
	changes := OrderedCollection new.
	sorted collect: [:c | c beeDefinition] in: changes.
	useful := meta select: [:m | m instVarNames notEmpty].
	useful collect: [:m | m beeDefinition] in: changes.
	extmeta := extendedClasses collect: [:c | c metaclass].
	meta , sorted , extendedClasses , extmeta
		do: [:c | c methods collect: [:m | m beeDefinition] in: changes].
	^changes]

{#category : '*CodeSpecs\\Porting'}
ModuleSpec >> exportPseudoTonel: path [
	ModuleExporter new path: path; module: self; exportPseudoTonel]

