"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ChangeHeaderSpecTest,
	#superclass : #TestCase,
	#category : #ProjectChanges
}

{ #category : #all }
ChangeHeaderSpecTest >> testAuthor [
	| spec cm change fileout |
	spec := ChangeHeaderSpec new.
	cm := self class >> #testTimestamp.
	change := MethodDefinition fromCompiledMethod: cm.
	fileout := String streamContents: [:strm | spec fileOut: change on: strm].
	self deny: (fileout includesString: 'author').
	spec add: #author.
	fileout := String streamContents: [:strm | spec fileOut: change on: strm].
	self
		assert: (fileout includesString: 'author: ');
		assert: (fileout includesString: change author printString);
		assert: (Compiler evaluate: fileout) class equals: change class]

{ #category : #fileouts }
ChangeHeaderSpecTest >> testBeeProjectFileout [
	SourceManager current ignoreChangesWhile: [| p |
		[| changelog changeset fileout |
			p := BeeCluster new name: 'TestingChangesCLuster'.
			p changes newProject: 'TestingChangesProject'.
			changeset := Changeset on: p localChanges.
			fileout := String streamContents: [:strm | changeset fileOutOn: strm].
			self
				assert: (fileout includesString: 'timestamp: ');
				assert: (fileout includesString: 'author: ');
				deny: (fileout includesString: 'lastPerformance: ');
				assert: (fileout includesString: 'project: ' , p name storeString).
			changelog := SourceCodeReader changelogReader readStream contents.
			self
				assert: (changelog includesString: 'timestamp: ');
				assert: (changelog includesString: 'author: ');
				deny: (changelog includesString: 'lastPerformance: ');
				assert: (changelog includesString: 'project: ' , p name storeString).
			fileout := String streamContents: [:strm | p fileOutOn: strm].
			self
				deny: (fileout includesString: 'timestamp: ');
				deny: (fileout includesString: 'author: ');
				deny: (fileout includesString: 'lastPerformance: ').
			fileout := String
				streamContents: [:strm | (p instVarNamed: 'changes') saveOn: strm].
			self
				assert: (fileout includesString: 'timestamp: ');
				assert: (fileout includesString: 'author: ');
				assert: (fileout includesString: 'lastPerformance: ');
				assert: (fileout includesString: 'project: ' , p name storeString)]
			ensure: [p unload]]]

{ #category : #all }
ChangeHeaderSpecTest >> testCategory [
	| spec cm change fileout |
	spec := ChangeHeaderSpec new.
	cm := self class >> #testTimestamp.
	change := MethodDefinition fromCompiledMethod: cm.
	fileout := String streamContents: [:strm | spec fileOut: change on: strm].
	self deny: (fileout includesString: 'category').
	spec add: #category.
	fileout := String streamContents: [:strm | spec fileOut: change on: strm].
	self
		assert: (fileout includesString: 'category: ');
		assert: (fileout includesString: change category printString);
		assert: (Compiler evaluate: fileout) class equals: change class]

{ #category : #fileouts }
ChangeHeaderSpecTest >> testClassChangeFileout [
	| cls fileout p |
	SourceManager current ignoreChangesWhile: [
		[| changelog changeset |
			p := BeeProject new name: 'testingChanges'.
			p changes
				defineClass: self class name , ' subclass: ''TestingClassChanges'''
				notifying: self.
			changeset := Changeset on: p localChanges.
			fileout := String streamContents: [:strm | changeset fileOutOn: strm].
			self
				assert: (fileout includesString: 'timestamp: ');
				assert: (fileout includesString: 'author: ');
				deny: (fileout includesString: 'prev: ');
				deny: (fileout includesString: 'lastPerformance: ');
				assert: (fileout includesString: 'project: ' , p name storeString).
			changelog := SourceCodeReader changelogReader readStream contents.
			self
				assert: (changelog includesString: 'timestamp: ');
				assert: (changelog includesString: 'author: ');
				assert: (changelog includesString: 'project: ');
				deny: (changelog includesString: 'lastPerformance: ');
				deny: (changelog includesString: 'prev').
			fileout := String streamContents: [:strm | p fileOutOn: strm].
			self
				assert: (fileout occurrencesOfSubstring: 'ClassDefinition') equals: 1;
				assert: (fileout occurrencesOfSubstring: 'timestamp: ') equals: 1;
				assert: (fileout occurrencesOfSubstring: 'author: ') equals: 1;
				assert: (fileout occurrencesOfSubstring: 'project: ') equals: 1;
				assert: (fileout occurrencesOfSubstring: 'lastPerformance: ')
				equals: 0;
				assert: (fileout occurrencesOfSubstring: 'prev: ') equals: 0.
			p buildCodeSegment.
			p unload.
			CodeImageSegment load: p name.
			cls := Smalltalk at: #TestingClassChanges.
			p := cls project.
			p changes
				defineClass: self class name
					, ' subclass: ''TestingClassChanges'' instanceVariableNames: ''a b'''
				notifying: self.
			self assert: cls changeLink notNil.
			changeset := Changeset on: p localChanges.
			fileout := String streamContents: [:strm | changeset fileOutOn: strm].
			self
				deny: (fileout includesString: 'lastPerformance:');
				deny: (fileout includesString: 'prev:').
			changelog := SourceCodeReader changelogReader readStream contents.
			self
				deny: (changelog includesString: 'lastPerformance:');
				deny: (changelog includesString: 'prev:').
			fileout := String streamContents: [:strm | p fileOutOn: strm].
			self
				deny: (fileout includesString: 'lastPerformance:');
				deny: (fileout includesString: 'prev:').
			fileout := String streamContents: [:strm | p changes saveOn: strm].
			self
				assert: (fileout includesString: 'lastPerformance:');
				assert: (fileout includesString: 'prev:').
			changeset := nil]
			ensure: [
				cls := nil.
				p unloadAndRemove]]]

{ #category : #all }
ChangeHeaderSpecTest >> testClassName [
	| spec cm change fileout |
	spec := ChangeHeaderSpec new.
	cm := self class >> #testTimestamp.
	change := MethodDefinition fromCompiledMethod: cm.
	fileout := String streamContents: [:strm | spec fileOut: change on: strm].
	self deny: (fileout includesString: 'className').
	spec add: #className.
	fileout := String streamContents: [:strm | spec fileOut: change on: strm].
	self
		assert: (fileout includesString: 'className: ');
		assert: (fileout includesString: change className printString);
		assert: (Compiler evaluate: fileout) class equals: change class]

{ #category : #all }
ChangeHeaderSpecTest >> testFileOutCompleteHeader [
	| cm change header everything record s |
	cm := self class >> #testTimestamp.
	change := MethodDefinition fromCompiledMethod: cm.
	header := String
		streamContents: [:strm | change completeHeaderSpec
			fileOut: change
			on: strm].
	everything := String streamContents: [:strm | 
		strm
			nextUTF8Put: '!';
			nextChunkPut: header;
			nextStChunkPut: change sourceCode].
	s := everything readStream.
	s nextChunk.
	record := Compiler evaluate: s nextChunk.
	record fileInFrom: s.
	self assert: record equals: change]

{ #category : #all }
ChangeHeaderSpecTest >> testInformation [
	| spec cm change fileout |
	spec := ChangeHeaderSpec new.
	cm := self class >> #testTimestamp.
	change := MethodDefinition fromCompiledMethod: cm.
	spec
		add: #timestamp;
		add: #author;
		add: #className;
		add: #selector;
		add: #category;
		addInformation.
	fileout := String streamContents: [:strm | spec fileOut: change on: strm].
	self
		assert: (Compiler evaluate: fileout) information
		equals: change information]

{ #category : #all }
ChangeHeaderSpecTest >> testLastPerformance [
	| spec cm change fileout |
	spec := ChangeHeaderSpec new.
	cm := ChangeHeaderSpec methodDictionary
		detect: [:m | m sourceReference changeLink notNil].
	change := cm asChange.
	fileout := String streamContents: [:strm | spec fileOut: change on: strm].
	self deny: (fileout includesString: 'lastPerformance').
	spec add: #lastPerformance.
	fileout := String streamContents: [:strm | spec fileOut: change on: strm].
	self
		assert: (fileout includesString: 'lastPerformance: ');
		assert: (fileout
			includesString: change lastPerformance iso8601 printString);
		assert: (Compiler evaluate: fileout) class equals: change class]

{ #category : #fileouts }
ChangeHeaderSpecTest >> testMethodChangeFileout [
	| cls fileout p changeset |
	SourceManager current ignoreChangesWhile: [
		[| changelog |
			cls := self class subclass: 'TestingClassChanges'.
			p := BeeProject new name: 'testingChanges'.
			p changes compile: 'm ^1' in: cls.
			changeset := Changeset on: p localChanges.
			fileout := String streamContents: [:strm | changeset fileOutOn: strm].
			self
				assert: (fileout includesString: 'timestamp: ');
				assert: (fileout includesString: 'author: ');
				deny: (fileout includesString: 'prev: ');
				deny: (fileout includesString: 'lastPerformance: ');
				assert: (fileout includesString: 'project: ' , p name storeString).
			p changes compile: 'm ^2' in: cls.
			changeset := Changeset on: p localChanges.
			changeset compressCurrentChanges.
			fileout := String streamContents: [:strm | changeset fileOutOn: strm].
			self
				deny: (fileout includesString: 'lastPerformance: ');
				deny: (fileout includesString: 'prev: ').
			changelog := SourceCodeReader changelogReader readStream contents.
			self
				assert: (changelog occurrencesOfSubstring: 'timestamp: ') equals: 2;
				assert: (changelog occurrencesOfSubstring: 'author: ') equals: 2;
				assert: (changelog occurrencesOfSubstring: 'project: ') equals: 2;
				assert: (changelog occurrencesOfSubstring: 'lastPerformance: ')
				equals: 0;
				assert: (changelog occurrencesOfSubstring: 'prev: ') equals: 0.
			fileout := String streamContents: [:strm | p fileOutOn: strm].
			self
				assert: (fileout occurrencesOfSubstring: 'MethodDefinition')
				equals: 1;
				assert: (fileout occurrencesOfSubstring: 'timestamp: ') equals: 1;
				assert: (fileout occurrencesOfSubstring: 'author: ') equals: 1;
				assert: (fileout occurrencesOfSubstring: 'project: ') equals: 1;
				assert: (fileout occurrencesOfSubstring: 'lastPerformance: ')
				equals: 0;
				assert: (fileout occurrencesOfSubstring: 'prev: ') equals: 0.
			p buildCodeSegment.
			p unload.
			CodeImageSegment load: p name.
			p := BeeModule named: p name.
			self assert: (cls >> #m) sourceReference changeLink notNil.
			p changes compile: 'm ^3' in: cls.
			changeset := Changeset on: p localChanges.
			fileout := String streamContents: [:strm | changeset fileOutOn: strm].
			self
				deny: (fileout includesString: 'lastPerformance: ');
				deny: (fileout includesString: 'prev: ').
			changelog := SourceCodeReader changelogReader readStream contents.
			self
				deny: (changelog includesString: 'lastPerformance: ');
				deny: (changelog includesString: 'prev: ').
			fileout := String streamContents: [:strm | p fileOutOn: strm].
			self
				deny: (fileout includesString: 'lastPerformance: ');
				deny: (fileout includesString: 'prev: ').
			fileout := String streamContents: [:strm | p changes saveOn: strm].
			self
				assert: (fileout includesString: 'lastPerformance: ');
				assert: (fileout includesString: 'prev: ')]
			ensure: [
				p unloadAndRemove.
				cls delete]]]

{ #category : #all }
ChangeHeaderSpecTest >> testPrev [
	| spec cm change fileout |
	spec := ChangeHeaderSpec new.
	cm := self class >> #testTimestamp.
	change := MethodDefinition fromCompiledMethod: cm.
	fileout := String streamContents: [:strm | spec fileOut: change on: strm].
	self deny: (fileout includesString: 'prev').
	spec add: #prev.
	change prev: 17.
	fileout := String streamContents: [:strm | spec fileOut: change on: strm].
	self
		assert: (fileout includesString: 'prev: 17');
		assert: (Compiler evaluate: fileout) class equals: change class]

{ #category : #all }
ChangeHeaderSpecTest >> testProject [
	| spec cm change fileout |
	spec := ChangeHeaderSpec new.
	cm := self class >> #testTimestamp.
	change := MethodDefinition fromCompiledMethod: cm.
	fileout := String streamContents: [:strm | spec fileOut: change on: strm].
	self deny: (fileout includesString: 'project').
	spec add: #project.
	fileout := String streamContents: [:strm | spec fileOut: change on: strm].
	self
		assert: (fileout includesString: 'project: ');
		assert: (fileout includesString: change projectName storeString);
		assert: (Compiler evaluate: fileout) class equals: change class]

{ #category : #fileouts }
ChangeHeaderSpecTest >> testProjectSettingFileout [
	| fileout p changeset |
	SourceManager current ignoreChangesWhile: [
		[| changelog |
			p := BeeProject new name: 'testingChanges'.
			p changes developmentOnly: true.
			changeset := Changeset on: p localChanges.
			fileout := String streamContents: [:strm | changeset fileOutOn: strm].
			self
				assert: (fileout includesString: 'ProjectSettingDefinition');
				assert: (fileout includesString: 'timestamp: ');
				assert: (fileout includesString: 'author: ');
				assert: (fileout includesString: 'project: ');
				deny: (fileout includesString: 'lastPerformance: ').
			changelog := SourceCodeReader changelogReader readStream contents.
			self
				assert: (changelog includesString: 'ProjectSettingDefinition');
				assert: (changelog includesString: 'timestamp: ');
				deny: (changelog includesString: 'lastPerformance: ').
			fileout := String streamContents: [:strm | p fileOutOn: strm].
			self
				assert: (fileout includesString: 'ProjectSettingDefinition');
				deny: (fileout includesString: 'timestamp: ');
				deny: (fileout includesString: 'author: ');
				assert: (fileout includesString: 'project: ');
				deny: (fileout includesString: 'lastPerformance: ').
			fileout := String streamContents: [:strm | p changes saveOn: strm].
			self
				assert: (fileout includesString: 'lastPerformance: ');
				assert: (fileout includesString: 'timestamp: ')]
			ensure: [p unloadAndRemove]]]

{ #category : #fileouts }
ChangeHeaderSpecTest >> testRenameSelectorFileout [
	| cls fileout p changeset |
	SourceManager current ignoreChangesWhile: [
		[| changelog |
			cls := self class subclass: 'TestingClassChanges'.
			p := BeeProject new name: 'testingChanges'.
			p changes
				compile: 'm ^1' in: cls;
				renameSelector: #m as: #renamed.
			changeset := Changeset on: (ProjectDecorator on: p) lastChanges.
			fileout := String streamContents: [:strm | changeset fileOutOn: strm].
			self
				assert: (fileout occurrencesOfSubstring: 'SelectorRename') equals: 1;
				assert: (fileout occurrencesOfSubstring: 'timestamp: ') equals: 2;
				assert: (fileout occurrencesOfSubstring: 'author: ') equals: 2;
				assert: (fileout occurrencesOfSubstring: 'project: ') equals: 2;
				assert: (fileout occurrencesOfSubstring: 'lastPerformance:')
				equals: 0.
			changelog := SourceCodeReader changelogReader readStream contents.
			self
				assert: (changelog occurrencesOfSubstring: 'SelectorRename')
				equals: 1;
				assert: (changelog occurrencesOfSubstring: 'timestamp: ') equals: 3;
				assert: (changelog occurrencesOfSubstring: 'lastPerformance: ')
				equals: 0]
			ensure: [
				p unloadAndRemove.
				cls delete]]]

{ #category : #all }
ChangeHeaderSpecTest >> testSelector [
	| spec cm change fileout |
	spec := ChangeHeaderSpec new.
	cm := self class >> #testTimestamp.
	change := MethodDefinition fromCompiledMethod: cm.
	fileout := String streamContents: [:strm | spec fileOut: change on: strm].
	self deny: (fileout includesString: 'selector').
	spec add: #selector.
	fileout := String streamContents: [:strm | spec fileOut: change on: strm].
	self
		assert: (fileout includesString: 'selector: ');
		assert: (fileout includesString: change selector printString);
		assert: (Compiler evaluate: fileout) class equals: change class]

{ #category : #all }
ChangeHeaderSpecTest >> testTimestamp [
	| spec cm change fileout |
	spec := ChangeHeaderSpec new.
	cm := self class >> #testTimestamp.
	change := MethodDefinition fromCompiledMethod: cm.
	fileout := String streamContents: [:strm | spec fileOut: change on: strm].
	self deny: (fileout includesString: 'timestamp').
	spec add: #timestamp.
	fileout := String streamContents: [:strm | spec fileOut: change on: strm].
	self
		assert: (fileout includesString: 'timestamp: ');
		assert: (fileout includesString: change timestamp iso8601 printString);
		assert: (Compiler evaluate: fileout) class equals: change class]

