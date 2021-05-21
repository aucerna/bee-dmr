"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #MethodSourceCode }

{ #category : '*ProjectChanges' }
MethodSourceCode >> fillFrom: aMethodDefinition [
	timestamp := aMethodDefinition timestamp.
	author := aMethodDefinition author.
	self ASSERT: link isNil.
	link := aMethodDefinition prev.
	information := Dictionary new.
	aMethodDefinition setAnnotationsTo: self]

{ #category : '*ProjectChanges' }
MethodSourceCode >> getHeader [
	| change stream |
	stream := self sourceReader.
	stream ifNil: [
		self ASSERT: false.
		^nil].
	stream isString ifTrue: [^nil].
	change := [stream prevChunkAt: position] on: Error do: [:e | 
		e description print.
		e return: nil].
	change isNil ifTrue: [^nil].
	(change beginsWith: MethodDefinition name) ifFalse: [^nil].
	^change]

{ #category : '*ProjectChanges' }
MethodSourceCode >> readHeader [
	| change |
	change := self headerChange.
	change notNil ifTrue: [self fillFrom: change]]

{ #category : '*ProjectChanges' }
MethodSourceCode >> saveOn: aStream for: aCompiledMethod [
	^self saveOn: aStream for: aCompiledMethod project: nil]

{ #category : '*ProjectChanges' }
MethodSourceCode >> saveOn: aStream for: aCompiledMethod project: aBeeProject [
	| change pos |
	self needsReadHeader ifTrue: [self readHeader].
	change := MethodDefinition new.
	change
		timestamp: timestamp;
		author: author;
		prev: self linkSurrogate;
		className: aCompiledMethod classBinding name;
		category: aCompiledMethod category;
		selector: aCompiledMethod selector;
		sourceCode: self asString;
		instVarNamed: 'information' put: information.
	aBeeProject notNil ifTrue: [change project: aBeeProject].
	pos := change logChangeOn: aStream.
	self ASSERT: pos \\ 4 = 0.
	^pos]

{ #category : '*ProjectChanges' }
MethodSourceCode >> setAnnotationsTo: aMethodDefinition [
	self needsReadHeader ifTrue: [self readHeader].
	aMethodDefinition
		timestamp: timestamp;
		author: author;
		prev: link.
	information notNil ifTrue: [
		information
			keysAndValuesDo: [:k :v | aMethodDefinition informationAt: k put: v]]]

