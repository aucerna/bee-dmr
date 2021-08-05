"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #MethodSpec}

{#category : '*CodeSpecs\\Porting'}
MethodSpec >> beeDefinition [
	^MethodDefinition new
		selector: selector;
		className: class name;
		category: category;
		sourceCode: source;
		projectName: module name]

