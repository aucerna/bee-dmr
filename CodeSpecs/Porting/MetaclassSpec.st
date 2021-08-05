"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #MetaclassSpec}

{#category : '*CodeSpecs\\Porting'}
MetaclassSpec >> beeDefinition [
	| name definition project |
	name := self name.
	definition := name , ' instanceVariableNames: '
		, (' ' join: instanceVariables) storeString.
	project := BeeModule withName: module name.
	^ClassDefinition new
		className: name;
		project: project;
		definition: definition]

