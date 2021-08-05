"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #ClassSpec}

{#category : '*CodeSpecs\\Porting'}
ClassSpec >> beeDefinition [
	| definition project |
	definition := supername , ' subclass: #' , name
		, '
	instanceVariableNames: '
		, (' ' join: instanceVariables) storeString
		, '
	classVariableNames: '
		, (' ' join: classVariables) storeString
		, '
	poolDictionaries: '
		, (' ' join: sharedPools) storeString.
	project := BeeModule withName: module name.
	^ClassDefinition new
		className: name asString;
		project: project;
		definition: definition]

