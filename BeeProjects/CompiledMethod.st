"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #CompiledMethod}

{#category : '*BeeProjects'}
CompiledMethod >> annotations [
	| ts v filename s |
	s := self sourceReference.
	^String streamContents: [:strm | 
		ts := s timestamp.
		ts := ts isNil ifTrue: [ts printString] ifFalse: [ts prettyPrint].
		strm
			nextPutAll: ts;
			nextPutAll: ' by ';
			nextPutAll: s author printString.
		v := s informationAt: #applicationVersion.
		v notNil ifTrue: [
			strm
				space;
				nextPut: $(;
				nextPutAll: v printString;
				nextPut: $)].
		filename := s informationAt: #changesFileName.
		filename notNil
			ifTrue: [strm nextPutAll: ' from file '; nextPutAll: filename].
		strm
			nextPutAll: ' - [';
			nextPutAll: self project name;
			nextPut: $]]]

{#category : '*BeeProjects'}
CompiledMethod >> project [
	| projects n project |
	projects := self projects.
	self projects size = 1 ifTrue: [^projects first].
	self imageSegment notNil ifTrue: [
		n := self imageSegment name.
		project := BeeModule getProject: n.
		(project notNil and: [project includesMethod: self]) ifTrue: [^project]].
	projects := projects
		select: [:p | (p compiledMethodFor: selector in: class) == self].
	projects size = 1 ifTrue: [^projects first].
	^BeeModule systemProject]

{#category : '*BeeProjects'}
CompiledMethod >> projects [
	^(BeeModule projectsIncluding: self) asOrderedCollection]

{#category : '*BeeProjects'}
CompiledMethod >> renameVariable: var to: aString [
	| s |
	s := self signature.
	self projects do: [:p | | cm |
		cm := p compiledMethodFromSignature: s.
		cm notNil ifTrue: [p renameVariable: var to: aString in: cm]]]

