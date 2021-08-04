"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #Species}

{#category : '*BeeProjects'}
Species >> annotations [
	| complexity ts |
	^String streamContents: [:strm | 
		complexity := self complexity.
		strm
			nextPutAll: '[Complexity ';
			nextPutAll: (complexity ifNil: ['too high']) printString;
			nextPut: $];
			space;
			space.
		(organization respondsTo: #timestamp) ifTrue: [
			ts := organization timestamp ifNil: [''] ifNotNil: [:t | t prettyPrint].
			strm
				nextPutAll: ts;
				nextPutAll: ' by ';
				nextPutAll: (organization author ifNil: '')]]]

{#category : '*BeeProjects'}
Species >> category [
	^'']

{#category : '*BeeProjects'}
Species >> compileAll [
	self methodDictionary isEmpty ifTrue: [^self].
	Transcript cr; print: 'recompiling ' , self name.
	self selectors do: [:sel | self recompile: sel].
	self recompileOverridden]

{#category : '*BeeProjects'}
Species >> formatAllMethods [
	self methodDictionary
		do: [:cm | cm project changes compile: cm parseTree format in: self]]

{#category : '*BeeProjects'}
Species >> listMethodsOn: aStream [
	"
	Point listMethodsOn: Transcript
	"
	| selectors |
	selectors := self selectors.
	selectors notEmpty ifTrue: [
		aStream nextPutAll: self name; cr.
		selectors asSortedCollection do: [:sel | aStream tab; nextPutAll: sel; cr]].
	self isMetaclass ifTrue: [^self].
	self class selectors notEmpty ifTrue: [aStream cr].
	self class listMethodsOn: aStream.
	aStream cr]

{#category : '*BeeProjects'}
Species >> project [
	| projects |
	projects := self projects.
	projects size = 1 ifTrue: [^projects first].
	(projects isEmpty and: [self imageSegment notNil])
		ifTrue: [^BeeModule getProject: self imageSegment name].
	^BeeModule default]

{#category : '*BeeProjects'}
Species >> projects [
	^(BeeModule projectsForClass: self) asOrderedCollection]

{#category : '*BeeProjects'}
Species >> recompileOverridden [
	BeeModule allSimpleProjects
		do: [:p | (p methodsOverriddenIn: self) do: [:m | m recompile]]]

