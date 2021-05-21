"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ProjectChangesTest,
	#superclass : #TestCase,
	#instVars : [
		'project',
		'changes',
		'project2'
	],
	#category : #ProjectChanges
}

{ #category : #running }
ProjectChangesTest >> runCase [
	(self class >> testSelector includes: #ignoreChangeLog)
		ifTrue: [SourceManager current ignoreChangesWhile: [super runCase]]
		ifFalse: [super runCase]]

{ #category : #running }
ProjectChangesTest >> setUp [
	project := BeeProject new fullName: Directory scratchDir \ testSelector.
	changes := project changes]

{ #category : #running }
ProjectChangesTest >> tearDown [
	changes currentChanges removeAll.
	project2 notNil ifTrue: [project2 unloadAndRemove].
	project2 := nil.
	project notNil ifTrue: [project unloadAndRemove].
	project := changes := nil]

{ #category : #'changes to globals' }
ProjectChangesTest >> testAddAndRenameGlobals [
	| global renamed |
	#ignoreChangeLog.
	global := 'SomeGlobalForTesting' asSymbol.
	renamed := 'RenamedGlobalForTesting' asSymbol.
	[| userChanges |
		project changes addGlobal: global.
		self
			assert: (Smalltalk associationAt: global) notNil;
			assert: (project globals includes: global);
			assert: project changes currentChanges size = 1.
		project changes
			compile: 'm1 ^SomeGlobalForTesting + 1' in: self class;
			compile: 'm2 SomeGlobalForTesting := 0' in: self class.
		project changes renameGlobal: global to: renamed.
		self
			deny: (Smalltalk includesKey: global);
			deny: (project globals includes: global);
			assert: (Smalltalk associationAt: renamed) notNil;
			assert: (project globals includes: renamed);
			assert: project changes currentChanges size = 6.
		userChanges := project changes currentChanges select: #isUserChange.
		project changes forgetGlobal: renamed.
		Smalltalk removeKey: renamed.
		userChanges do: [:c | c perform].
		self
			assert: (Smalltalk associationAt: renamed) notNil;
			assert: (project globals includes: renamed)]
		ensure: [
			Smalltalk
				removeKey: global ifAbsent: nil;
				removeKey: renamed ifAbsent: nil]]

{ #category : #'class changes' }
ProjectChangesTest >> testCategoryMove [
	| class p move s |
	class := Class new name: 'Blah'.
	class
		buildBehavior;
		compile: 's1' classified: #a;
		compile: 's2' classified: #b.
	p := BeeProject new name: 'p'.
	p answerTo: #resolveClass: with: class.
	class answerTo: #project with: p.
	p changes moveCategory: #b inClass: class to: #a.
	self
		assert: (class selectorsInCategory: #a) size equals: 2;
		assert: (class selectorsInCategory: #b) size equals: 0;
		assert: class categories asArray equals: #(#a).
	s := '' writeStream.
	p changes saveOn: s.
	changes := Changeset fromStream: s readStream.
	self
		assert: changes size = 1;
		assert: (move := changes currentChanges anyone) class == CategoryMove.
	self
		assert: move category equals: #b;
		assert: move destination equals: #a.
	class
		classify: #s1 under: #b;
		classify: #s2 under: #b.
	changes do: [:ch | ch perform].
	self
		assert: (class selectorsInCategory: #a) size equals: 2;
		assert: (class selectorsInCategory: #b) size equals: 0;
		assert: class categories asArray equals: #(#a).
	p unload]

{ #category : #'class changes' }
ProjectChangesTest >> testClassChangeLink [
	| cls history |
	#ignoreChangeLog.
	cls := project changes
		defineClass: 'Object subclass: ''TestingClassChangeLink'''.
	project changes compile: 'm' in: cls.
	project changes
		defineClass: 'Object
	subclass: #TestingClassChangeLink
	instanceVariableNames: ''ivar''
	classVariableNames: ''''
	poolDictionaries: '''''.
	history := project changes historyOfClass: cls.
	self
		assert: history size equals: 2;
		deny: (history second sourceCode includesString: 'ivar').
	project buildCodeSegment.
	history := project changes historyOfClass: cls.
	self
		assert: history size equals: 2;
		assert: (history first sourceCode includesString: 'ivar');
		deny: (history second sourceCode includesString: 'ivar').
	project unload.
	project := BeeProject getProject: (project filename withExtension: 'bsl').
	cls := Smalltalk classNamed: #TestingClassChangeLink.
	history := project changes historyOfClass: cls.
	self
		assert: history size equals: 2;
		assert: (history first sourceCode includesString: 'ivar');
		deny: (history second sourceCode includesString: 'ivar').
	project2 := BeeProject new fullName: Directory scratchDir \ 'project2'.
	project2 changes addClass: cls.
	project2 changes
		defineClass: 'Object
	subclass: #TestingClassChangeLink
	instanceVariableNames: ''ivar ivar2''
	classVariableNames: ''''
	poolDictionaries: '''''.
	history := project2 changes historyOfClass: cls.
	self
		assert: history size equals: 4;
		assert: (history first sourceCode includesString: 'ivar2');
		assert: history second class == ClassAddition;
		deny: (history second sourceCode includesString: 'ivar2');
		deny: (history last sourceCode includesString: 'ivar')]

{ #category : #renaming }
ProjectChangesTest >> testClassChanges [
	| cls classChanges |
	#ignoreChangeLog.
	cls := project changes
		defineClass: 'Object subclass: ''TestingClassChanges'''.
	project changes compile: 'm' in: cls class.
	classChanges := project changes changesOfClass: cls.
	self
		assert: classChanges size equals: 2;
		assert: classChanges currentChanges last class == MethodDefinition]

{ #category : #'class changes' }
ProjectChangesTest >> testClassInstVarChanges [
	| cls meta |
	#ignoreChangeLog.
	cls := project changes
		defineClass: 'Object subclass: ''TestingClassInstVarChanges'''.
	meta := cls class.
	project changes addInstVar: 'first' to: meta.
	project changes addInstVar: 'last' to: meta.
	self
		assert: cls instVarNames = #();
		assert: meta instVarNames = #('first' 'last').
	project changes renameInstVar: 'first' of: meta to: 'one'.
	self assert: meta instVarNames = #('one' 'last').
	project changes insertInstVar: 'two' to: meta before: 'last'.
	self assert: meta instVarNames = #('one' 'two' 'last').
	project changes removeInstVar: 'last' from: meta.
	self
		assert: cls instVarNames = #();
		assert: meta instVarNames = #('one' 'two')]

{ #category : #clusters }
ProjectChangesTest >> testClusterCreation [
	| system c |
	system := BeeCluster systemCluster.
	system ignoreChangesWhile: [
		c := system changes newCluster: 'TestingNewCluster'.
		[self assert: (system parts count: [:module | module == c]) equals: 1]
			ensure: [c unload]]]

{ #category : #'project changes' }
ProjectChangesTest >> testDescription [
	| ch change strm |
	#ignoreChangeLog.
	self assert: project description = ''.
	changes description: 'This is a description'.
	self assert: project description = 'This is a description'.
	self assert: changes currentChanges size = 1.
	change := changes currentChanges first.
	change fileOutOn: (strm := '' writeStream).
	project unload.
	project := BeeProject new fullName: project filename.
	self assert: project description = ''.
	change := (Changeset fromStream: strm readStream) currentChanges first.
	ch := change currentVersionInProject.
	self
		assert: (change sourceCode includesString: 'This is a description');
		deny: (ch sourceCode includesString: 'This is a description').
	change project: project; perform.
	self assert: project description = 'This is a description']

{ #category : #renaming }
ProjectChangesTest >> testGlobalRename [
	| cls classChanges pool cls2 m m2 |
	#ignoreChangeLog.
	pool := project changes addPoolDictionary: 'TestingPool' asSymbol.
	cls := project changes
		defineClass: 'Object subclass: ''TestingGlobalRename'' poolDictionaries:  ''TestingPool'''.
	m := project changes compile: 'm ^TestingPool size' in: cls.
	project2 := BeeProject new fullName: Directory scratchDir \ 'project2'.
	cls2 := project2 changes
		defineClass: 'Object subclass: ''TestingGlobalRename2'' poolDictionaries:  ''TestingPool'''.
	m2 := project2 changes compile: 'm2 ^TestingPool at: ''any''' in: cls2.
	project changes
		renameGlobal: 'TestingPool' asSymbol
		to: 'RenamedTestingPool' asSymbol.
	self
		assert: (Smalltalk includesKey: 'RenamedTestingPool' asSymbol);
		deny: (Smalltalk includesKey: 'TestingPool' asSymbol);
		assert: cls sharedPools equals: {'RenamedTestingPool' asSymbol};
		assert: cls2 sharedPools equals: {'RenamedTestingPool' asSymbol};
		assert: (m currentVersion sourceCode includesString: 'RenamedTestingPool');
		assert: (m2 currentVersion sourceCode includesString: 'RenamedTestingPool').
	classChanges := project changes changesOfClass: cls.
	self
		assert: (classChanges currentChanges count: #isClassDefinition)
		equals: 2;
		assert: (classChanges currentChanges count: #isMethodDefinition)
		equals: 2;
		assert: (project changes historyOfClass: cls) size equals: 2.
	project2 buildCodeSegment.
	cls2 := m2 := nil.
	project2 unload.
	project2 := BeeProject getProject: (project2 filename withExtension: 'bsl').
	self
		assert: (project2 changes
			historyOfClass: (Smalltalk at: #TestingGlobalRename2))
			size
		equals: 2]

{ #category : #history }
ProjectChangesTest >> testHistoryFileInPrevious [
	| cm h cls |
	#ignoreChangeLog.
	cls := project changes
		defineClass: 'Object subclass: ''TestingMethodHistory'''.
	cm := project changes compile: 'm1' in: cls.
	cm := project changes compile: 'm1 ^1' in: cls.
	h := project changes historyOf: cm.
	self
		assert: h size = 2;
		assert: h last sourceCode = 'm1'.
	h last perform.
	h := project changes historyOf: cm.
	self
		assert: h size = 3;
		assert: h first = h last]

{ #category : #history }
ProjectChangesTest >> testHistoryMethodAddition1 [
	| cm h cls |
	#ignoreChangeLog.
	cls := project changes
		defineClass: 'Object subclass: ''TestingMethodHistory'''.
	cm := project changes compile: 'm1' in: cls.
	cm := project changes compile: 'm1 ^1' in: cls.
	project2 := BeeProject new fullName: Directory scratchDir \ 'project2'.
	project2 changes addMethod: cm.
	h := project2 changes historyOf: cm.
	self
		assert: h size > 1;
		assert: h last sourceCode = 'm1']

{ #category : #history }
ProjectChangesTest >> testHistoryMethodAddition2 [
	| cm h cls |
	#ignoreChangeLog.
	cls := project changes
		defineClass: 'Object subclass: ''TestingMethodHistory'''.
	cm := project changes compile: 'm1' in: cls.
	cm := project changes compile: 'm1 ^1' in: cls.
	project buildCodeSegment.
	project2 := BeeProject new fullName: Directory scratchDir \ 'project2'.
	project2 changes addMethod: cm.
	h := project2 changes historyOf: cm.
	self
		assert: h size = 3;
		assert: h last sourceCode = 'm1';
		assert: h first class == MethodAddition]

{ #category : #history }
ProjectChangesTest >> testHistoryMethodAddition3 [
	| cm h cls |
	#ignoreChangeLog.
	cls := project changes
		defineClass: 'Object subclass: ''TestingMethodHistory'''.
	cm := project changes compile: 'm1' in: cls.
	cm := project changes compile: 'm1 ^1' in: cls.
	project buildCodeSegment.
	project2 := BeeProject new fullName: Directory scratchDir \ 'project2'.
	project2 changes addMethod: cm.
	project2 buildCodeSegment.
	h := project changes historyOf: cm.
	self
		assert: h size equals: 2;
		assert: (h conform: [:c | c project == project]);
		assert: h first sourceCode equals: 'm1 ^1';
		assert: h last sourceCode equals: 'm1']

{ #category : #history }
ProjectChangesTest >> testHistoryMethodAddition4 [
	| cm h cls |
	#ignoreChangeLog.
	cls := project changes
		defineClass: 'Object subclass: ''TestingMethodHistory'''.
	cm := project changes compile: 'm1' in: cls.
	cm := project changes compile: 'm1 ^1' in: cls.
	project buildCodeSegment.
	project2 := BeeProject new fullName: Directory scratchDir \ 'project2'.
	project2 changes addMethod: cm.
	project2 buildCodeSegment.
	cm := project changes compile: 'm1 ^2' in: cls.
	project buildCodeSegment.
	h := project changes historyOf: cm.
	self
		assert: h size equals: 3;
		assert: (h conform: [:c | c project == project]);
		assert: h first sourceCode equals: 'm1 ^2';
		assert: h last sourceCode equals: 'm1']

{ #category : #history }
ProjectChangesTest >> testHistoryMethodAddition5 [
	| cm h cls |
	#ignoreChangeLog.
	cls := project changes
		defineClass: 'Object subclass: ''TestingMethodHistory'''.
	cm := project changes compile: 'm1' in: cls.
	cm := project changes compile: 'm1 ^1' in: cls.
	project buildCodeSegment.
	project2 := BeeProject new fullName: Directory scratchDir \ 'project2'.
	project2 changes addMethod: cm.
	cm := project2 changes compile: 'm1 ^2' in: cls.
	project2 buildCodeSegment.
	h := project changes historyOf: cm.
	self
		assert: h size equals: 2;
		assert: (h conform: [:c | c project == project]);
		assert: h first sourceCode equals: 'm1 ^1'.
	h := project2 changes historyOf: cm.
	self
		assert: h size equals: 4;
		assert: h first project equals: project2;
		assert: h second project equals: project2;
		assert: h third project equals: project;
		assert: h last project equals: project]

{ #category : #history }
ProjectChangesTest >> testHistoryMethodAddition6 [
	| cm h cls |
	#ignoreChangeLog.
	cls := project changes
		defineClass: 'Object subclass: ''TestingMethodHistory'''.
	cm := project changes compile: 'm1' in: cls.
	cm := project changes compile: 'm1 ^1' in: cls.
	project buildCodeSegment.
	project2 := BeeProject new fullName: Directory scratchDir \ 'project2'.
	project2 changes addMethod: cm.
	cm := project changes compile: 'm1 ^2' in: cls.
	project2 buildCodeSegment.
	h := project changes historyOf: cm.
	self
		assert: h size equals: 3;
		assert: (h conform: [:c | c project == project]);
		assert: h first sourceCode equals: 'm1 ^2'.
	h := project2 changes historyOf: cm.
	self
		assert: h size equals: 3;
		assert: h first project equals: project2;
		assert: h second project equals: project;
		assert: h third project equals: project]

{ #category : #history }
ProjectChangesTest >> testHistoryMethodAddition7 [
	| cm h cls |
	#ignoreChangeLog.
	cls := project changes
		defineClass: 'Object subclass: ''TestingMethodHistory'''.
	cm := project changes compile: 'm1' in: cls.
	cm := project changes compile: 'm1 ^1' in: cls.
	project buildCodeSegment.
	project2 := BeeProject new fullName: Directory scratchDir \ 'project2'.
	project2 changes addMethod: cm.
	project2 buildCodeSegment.
	cm := project changes compile: 'm1 ^2' in: cls.
	h := project changes historyOf: cm.
	self
		assert: h size equals: 3;
		assert: (h conform: [:c | c project == project]);
		assert: h first sourceCode equals: 'm1 ^2'.
	h := project2 changes historyOf: cm.
	self
		assert: h size equals: 3;
		assert: h first project equals: project2;
		assert: h second project equals: project;
		assert: h third project equals: project]

{ #category : #history }
ProjectChangesTest >> testHistoryMethodAddition8 [
	| cm h cls |
	#ignoreChangeLog.
	cls := project changes
		defineClass: 'Object subclass: ''TestingMethodHistory'''.
	cm := project changes compile: 'm1' in: cls.
	cm := project changes compile: 'm1 ^1' in: cls.
	project buildCodeSegment.
	project2 := BeeProject new fullName: Directory scratchDir \ 'project2.bsl'.
	project2 changes addMethod: cm.
	project2 buildCodeSegment.
	cm := project changes compile: 'm1 ^2' in: cls.
	project buildCodeSegment.
	cls := nil.
	project unload.
	project2 unload.
	project := BeeProject getProject: (project filename withExtension: 'bsl').
	project2 := BeeProject getProject: project2 filename.
	cm := (Smalltalk at: #TestingMethodHistory) >> #m1.
	h := project changes historyOf: cm.
	self
		assert: h size equals: 3;
		assert: (h conform: [:c | c project == project]);
		assert: h first sourceCode equals: 'm1 ^2'.
	h := project2 changes historyOf: cm.
	self
		assert: h size equals: 3;
		assert: h first project equals: project2;
		assert: h second project equals: project;
		assert: h third project equals: project]

{ #category : #history }
ProjectChangesTest >> testHistoryMethodAddition9 [
	| cm h cls |
	#ignoreChangeLog.
	cls := project changes
		defineClass: 'Object subclass: ''TestingMethodHistory'''.
	cm := project changes compile: 'm1' in: cls.
	project buildCodeSegment.
	cm := project changes compile: 'm1 ^1' in: cls.
	project2 := BeeProject new fullName: Directory scratchDir \ 'project2.bsl'.
	project2 changes addMethod: cm.
	cm := project2 changes compile: 'm1 ^2' in: cls.
	h := project2 changes historyOf: cm.
	self
		assert: h size equals: 4;
		assert: h last project == project;
		assert: h first project == project2.
	project2 buildCodeSegment.
	project buildCodeSegment.
	cls := nil.
	project unload.
	project2 unload.
	project := BeeProject getProject: (project filename withExtension: 'bsl').
	project2 := BeeProject getProject: project2 filename.
	cm := (Smalltalk at: #TestingMethodHistory) >> #m1.
	h := project2 changes historyOf: cm.
	self
		assert: h size = 4;
		assert: h last project == project;
		assert: h first project == project2]

{ #category : #'class changes' }
ProjectChangesTest >> testInstVarChanges [
	| h cls ivars |
	#ignoreChangeLog.
	cls := project changes
		defineClass: 'Object subclass: ''TestingInstVarChanges'''.
	project changes addInstVar: 'first' to: cls.
	project changes addInstVar: 'last' to: cls.
	self assert: cls instVarNames = #('first' 'last').
	project buildCodeSegment.
	h := project changes historyOfClass: (Smalltalk at: #TestingInstVarChanges).
	self
		assert: h size = 3;
		assert: h last class == ClassDefinition;
		assert: h first definition = cls definitionString.
	project changes renameInstVar: 'first' of: cls to: 'one'.
	self assert: cls instVarNames = #('one' 'last').
	project changes insertInstVar: 'two' to: cls before: 'last'.
	self assert: cls instVarNames = #('one' 'two' 'last').
	project changes removeInstVar: 'last' from: cls.
	self assert: cls instVarNames = #('one' 'two').
	project buildCodeSegment.
	h := project changes historyOfClass: (Smalltalk at: #TestingInstVarChanges).
	ivars := h asArray collect: [:c | | args |
		args := (Compiler parse: c definition) statements first arguments.
		args size > 1 ifTrue: [args second value] ifFalse: ''].
	self
		assert: ivars size = 6;
		assert: ivars
			= #('one two' 'one two last' 'one last' 'first last' 'first' '')]

{ #category : #'class changes' }
ProjectChangesTest >> testInstVarMovingChanges [
	| h cls1 cls2 |
	#ignoreChangeLog.
	cls1 := project changes
		defineClass: 'Object subclass: ''TestingInstVarChanges'''.
	project2 := BeeProject new fullName: Directory scratchDir \ 'project2'.
	cls2 := project2 changes
		defineClass: 'TestingInstVarChanges subclass: ''TestingInstVarChanges2'''.
	project changes addInstVar: 'first' to: cls1.
	self assert: project2 hasChanged.
	project2 buildCodeSegment.
	h := project2 changes historyOfClass: (Smalltalk
		at: #TestingInstVarChanges2).
	self assert: h size = 1.
	self deny: project2 hasChanged.
	project changes moveDownInstVar: 'first' of: cls1 to: cls2.
	self
		assert: project2 hasChanged;
		assert: cls1 instVarNames = #();
		assert: cls2 instVarNames = #('first').
	h := project2 changes historyOfClass: (Smalltalk
		at: #TestingInstVarChanges2).
	self
		assert: h size = 2;
		assert: h first definition = cls2 definitionString]

{ #category : #logging }
ProjectChangesTest >> testNewPoolDictionary [
	| global |
	#ignoreChangeLog.
	global := #AnyPoolDictionary.
	project changes addPoolDictionary: global.
	self
		assert: (Smalltalk at: global) class == PoolDictionary;
		assert: project changes currentChanges size = 1.
	project removeGlobal: global.
	self deny: (project globals includes: global).
	Smalltalk removeKey: global.
	project changes currentChanges last perform.
	self assert: (project globals includes: global)]

{ #category : #renaming }
ProjectChangesTest >> testProjectRename [
	| system c |
	system := BeeCluster systemCluster.
	system ignoreChangesWhile: [
		[| p |
			c := system changes newCluster: 'TestingModules'.
			p := c changes newProject: 'BadName'.
			p changes renameProject: p to: 'GoodName'.
			self
				deny: (system parts includes: p);
				assert: (c parts includes: p);
				assert: p name equals: 'GoodName';
				assert: p filename entityName equals: 'GoodName']
			ensure: [c unload]]]

{ #category : #renaming }
ProjectChangesTest >> testProjectRename2 [
	| cm cls |
	#ignoreChangeLog.
	cls := changes defineClass: 'Object subclass: ''TestingProjectRename'''.
	changes compile: 'm ^self printString' in: cls.
	project buildCodeSegment.
	cls := nil.
	project unload.
	project := BeeProject getProject: (project filename withExtension: 'bsl').
	project rename: 'RenamedProject'.
	cm := (Smalltalk at: #TestingProjectRename) >> #m.
	self assert: cm source equals: 'm ^self printString']

{ #category : #renaming }
ProjectChangesTest >> testSelectorRenameHistory [
	| h cls |
	#ignoreChangeLog.
	cls := project changes
		defineClass: 'Object subclass: ''TestingSelectorRenameHistory'''.
	project changes compile: 'm1' in: cls.
	project changes compile: 'm2 ^self m1' in: cls.
	project changes renameSelector: #m1 as: #mRenamed.
	h := project changes
		historyOf: (Smalltalk at: #TestingSelectorRenameHistory) >> #mRenamed.
	self
		assert: h size equals: 2;
		assert: h first sourceCode equals: 'mRenamed';
		assert: h last sourceCode equals: 'm1'.
	h := project changes
		historyOf: (Smalltalk at: #TestingSelectorRenameHistory) >> #m2.
	self
		assert: h size equals: 2;
		assert: (h first sourceCode endsWith: '^self mRenamed');
		assert: (h last sourceCode endsWith: '^self m1').
	project buildCodeSegment.
	project unload.
	project := BeeProject getProject: (project filename withExtension: 'bsl').
	h := project changes
		historyOf: (Smalltalk at: #TestingSelectorRenameHistory) >> #mRenamed.
	self
		assert: h size equals: 2;
		assert: h first sourceCode equals: 'mRenamed';
		assert: h last sourceCode equals: 'm1'.
	h := project changes
		historyOf: (Smalltalk at: #TestingSelectorRenameHistory) >> #m2.
	self
		assert: h size equals: 2;
		assert: (h first sourceCode endsWith: '^self mRenamed');
		assert: (h last sourceCode endsWith: '^self m1')]

{ #category : #tests }
ProjectChangesTest >> testTP37062a [
	SourceManager current ignoreChangesWhile: [
		changes
			defineClass: 'Object
	subclass: #XYZ
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
			notifying: nil.
		[
			self
				assert: changes currentChanges size = 1;
				assert: (changes wasModifiedClass: (Smalltalk at: #XYZ)).
			changes renameClass: (Smalltalk at: #XYZ) to: 'XYZRenamed'.
			self
				assert: changes currentChanges size = 2;
				assert: (changes wasModifiedClass: (Smalltalk at: #XYZRenamed)).
			changes renameClass: (Smalltalk at: #XYZRenamed) to: 'XYZ'.
			self
				assert: changes currentChanges size = 3;
				assert: (changes wasModifiedClass: (Smalltalk at: #XYZ))]
			ensure: [
				#(#XYZ #XYZRenamed)
					do: [:s | Smalltalk at: s ifPresent: [:c | c removeFromSystem]]]]]

{ #category : #tests }
ProjectChangesTest >> testTP37062b [
	SourceManager current ignoreChangesWhile: [
		changes
			defineClass: 'Object
	subclass: #XYZ
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
			notifying: nil.
		changes currentChanges removeAll.
		self
			assert: changes currentChanges size = 0;
			deny: (changes wasModifiedClass: (Smalltalk at: #XYZ)).
		changes renameClass: (Smalltalk at: #XYZ) to: 'XYZRenamed'.
		self
			assert: changes currentChanges size = 1;
			assert: (changes wasModifiedClass: (Smalltalk at: #XYZRenamed)).
		changes renameClass: (Smalltalk at: #XYZRenamed) to: 'XYZ'.
		self
			assert: changes currentChanges size = 2;
			assert: (changes wasModifiedClass: (Smalltalk at: #XYZ))]]

{ #category : #tests }
ProjectChangesTest >> testTP37062c [
	SourceManager current ignoreChangesWhile: [
		changes
			defineClass: 'Object
	subclass: #XYZ
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
			notifying: nil.
		[
			changes compile: 'foo ^1' in: (Smalltalk at: #XYZ).
			self
				assert: changes currentChanges size = 2;
				assert: (changes wasModifiedClass: (Smalltalk at: #XYZ));
				assert: (changes
					wasModifiedSelector: 'foo' asSymbol
					in: (Smalltalk at: #XYZ)).
			changes renameSelector: 'foo' asSymbol as: 'bar' asSymbol.
			self
				assert: changes currentChanges size = 4;
				assert: (changes currentChanges count: #isUserChange) equals: 3;
				assert: (changes
					wasModifiedSelector: 'bar' asSymbol
					in: (Smalltalk at: #XYZ));
				assert: (changes wasModifiedClass: (Smalltalk at: #XYZ)).
			changes renameSelector: 'bar' asSymbol as: 'foo' asSymbol.
			self
				assert: changes currentChanges size = 6;
				assert: (changes currentChanges count: #isUserChange) equals: 4;
				assert: (changes
					wasModifiedSelector: 'foo' asSymbol
					in: (Smalltalk at: #XYZ));
				assert: (changes wasModifiedClass: (Smalltalk at: #XYZ))]
			ensure: [Smalltalk at: #XYZ ifPresent: [:c | c removeFromSystem]]]]

{ #category : #tests }
ProjectChangesTest >> testTP37062e [
	SourceManager current ignoreChangesWhile: [
		changes
			defineClass: 'Object
	subclass: #XYZ
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
			notifying: nil.
		[
			changes compile: 'foo ^1' in: (Smalltalk at: #XYZ).
			changes currentChanges removeAll.
			self
				assert: changes currentChanges size = 0;
				deny: (changes wasModifiedClass: (Smalltalk at: #XYZ));
				deny: (changes
					wasModifiedSelector: 'foo' asSymbol
					in: (Smalltalk at: #XYZ)).
			changes renameSelector: 'foo' asSymbol as: 'bar' asSymbol.
			self
				assert: changes currentChanges size = 2;
				assert: (changes currentChanges count: #isUserChange) equals: 1;
				assert: (changes
					wasModifiedSelector: 'bar' asSymbol
					in: (Smalltalk at: #XYZ));
				assert: (changes wasModifiedClass: (Smalltalk at: #XYZ))]
			ensure: [Smalltalk at: #XYZ ifPresent: [:c | c removeFromSystem]]]]

{ #category : #tests }
ProjectChangesTest >> testTP37062f [
	SourceManager current ignoreChangesWhile: [
		changes
			defineClass: 'Object
	subclass: #XYZ
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
			notifying: nil;
			compile: 'foo ^self bar' in: (Smalltalk at: #XYZ);
			compile: 'bar ^1' in: (Smalltalk at: #XYZ).
		[
			changes currentChanges removeAll.
			self
				assert: changes currentChanges size = 0;
				deny: (changes wasModifiedClass: (Smalltalk at: #XYZ));
				deny: (changes
					wasModifiedSelector: 'foo' asSymbol
					in: (Smalltalk at: #XYZ));
				deny: (changes wasModifiedSelector: #bar in: (Smalltalk at: #XYZ)).
			changes renameSelector: 'bar' asSymbol as: #baz.
			self
				assert: changes currentChanges size = 3;
				assert: (changes currentChanges count: #isUserChange) equals: 1;
				assert: (changes
					wasModifiedSelector: 'foo' asSymbol
					in: (Smalltalk at: #XYZ));
				deny: (changes
					wasModifiedSelector: 'bar' asSymbol
					in: (Smalltalk at: #XYZ));
				assert: (changes wasModifiedSelector: #baz in: (Smalltalk at: #XYZ));
				assert: (changes wasModifiedClass: (Smalltalk at: #XYZ))]
			ensure: [Smalltalk at: #XYZ ifPresent: [:c | c removeFromSystem]]]]

{ #category : #tests }
ProjectChangesTest >> testTP37062g [
	#knownIssue.
	SourceManager current ignoreChangesWhile: [
		changes
			defineClass: 'Object
	subclass: #XYZ
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
			notifying: nil;
			compile: 'foo ^self bar' in: (Smalltalk at: #XYZ).
		[
			changes currentChanges removeAll.
			changes renameSelector: #bar as: #baz.
			self assert: (changes wasModifiedClass: (Smalltalk at: #XYZ))]
			ensure: [Smalltalk at: #XYZ ifPresent: [:c | c removeFromSystem]]]]

{ #category : #tests }
ProjectChangesTest >> testTP37062h [
	#knownIssue.
	SourceManager current ignoreChangesWhile: [
		changes
			defineClass: 'Object
	subclass: #XYZ
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
			notifying: nil;
			defineClass: 'Object
	subclass: #IJK
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
			notifying: nil;
			compile: 'foo ^self bar' in: (Smalltalk at: #XYZ);
			compile: 'bar ^1' in: (Smalltalk at: #IJK).
		changes currentChanges removeAll.
		self
			assert: changes currentChanges size = 0;
			deny: (changes wasModifiedClass: (Smalltalk at: #XYZ));
			deny: (changes wasModifiedClass: (Smalltalk at: #IJK));
			deny: (changes wasModifiedSelector: 'foo' asSymbol in: (Smalltalk
				at: #XYZ));
			deny: (changes wasModifiedSelector: 'bar' asSymbol in: (Smalltalk
				at: #IJK)).
		changes renameSelector: 'bar' asSymbol as: #baz.
		self
			assert: changes currentChanges size = 1;
			assert: (changes
				wasModifiedSelector: 'foo' asSymbol
				in: (Smalltalk at: #XYZ));
			deny: (changes wasModifiedSelector: 'bar' asSymbol in: (Smalltalk
				at: #IJK));
			assert: (changes wasModifiedSelector: #baz in: (Smalltalk at: #XYZ));
			assert: (changes wasModifiedClass: (Smalltalk at: #XYZ));
			assert: (changes wasModifiedClass: (Smalltalk at: #IJK))]]

{ #category : #tests }
ProjectChangesTest >> testTP37062i [
	| cluster |
	SourceManager current ignoreChangesWhile: [
		cluster := BeeCluster new.
		cluster add: project.
		changes
			defineClass: 'Object
	subclass: #XYZ
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
			notifying: nil;
			compile: 'foo ^self bar' in: (Smalltalk at: #XYZ).
		[
			changes currentChanges removeAll.
			changes renameSelector: #bar as: #bar.
			changes renameSelector: #bar as: #baz.
			changes renameSelector: #baz as: #qux.
			changes renameSelector: #qux as: #bar.
			self
				assert: (changes wasModifiedSelector: #bar in: (Smalltalk at: #XYZ));
				assert: (cluster wasModifiedSelector: #bar in: (Smalltalk at: #XYZ))]
			ensure: [Smalltalk at: #XYZ ifPresent: [:c | c removeFromSystem]]]]

{ #category : #tests }
ProjectChangesTest >> testTP37062j [
	#knownIssue.
	SourceManager current ignoreChangesWhile: [
		changes
			defineClass: 'Object
	subclass: #XYZ
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
			notifying: nil.
		changes currentChanges removeAll.
		changes compile: 'foo ^self bar' in: (Smalltalk at: #XYZ).
		self assert: (changes wasModifiedSelector: #bar in: (Smalltalk at: #XYZ)).
		changes renameClass: (Smalltalk at: #XYZ) to: #IJK.
		self assert: (changes wasModifiedSelector: #bar in: (Smalltalk at: #IJK)).
		changes renameClass: (Smalltalk at: #IJK) to: #LMN.
		self assert: (changes wasModifiedSelector: #bar in: (Smalltalk at: #LMN))]]

{ #category : #tests }
ProjectChangesTest >> testTP37062k [
	SourceManager current ignoreChangesWhile: [
		changes
			defineClass: 'Object
	subclass: #XYZ
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
			notifying: nil.
		[
			changes currentChanges removeAll.
			changes compile: 'foo ^self bar' in: (Smalltalk at: #XYZ).
			self
				assert: (changes
					wasModifiedSelector: 'foo' asSymbol
					in: (Smalltalk at: #XYZ)).
			changes renameSelector: 'foo' asSymbol as: 'bar' asSymbol.
			changes renameClass: (Smalltalk at: #XYZ) to: #IJK.
			self
				assert: (changes
					wasModifiedSelector: 'bar' asSymbol
					in: (Smalltalk at: #IJK)).
			changes renameClass: (Smalltalk at: #IJK) to: #LMN.
			changes renameSelector: 'bar' asSymbol as: #baz.
			self assert: (changes wasModifiedSelector: #baz in: (Smalltalk at: #LMN))]
			ensure: [
				#(#YXY #IJK #LMN)
					do: [:s | Smalltalk at: s ifPresent: [:c | c removeFromSystem]]]]]

{ #category : #tests }
ProjectChangesTest >> testTP45127 [
	#ignoreChangeLog.
	changes
		defineClass: 'Object
	subclass: #TP45127
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
		notifying: nil.
	[| d cls |
		cls := Smalltalk at: #TP45127.
		changes currentChanges removeAll.
		changes compile: 'foo ^super foo' in: cls.
		changes renameSelector: 'foo' asSymbol as: 'bar' asSymbol.
		d := MethodDecorator on: cls >> #bar.
		self
			assert: d allVersions size = 1;
			deny: (d project wasOverridden: cls);
			assert: (d isSenderOf: #bar)]
		ensure: [Smalltalk at: #TP45127 ifPresent: [:c | c removeFromSystem]]]

{ #category : #tests }
ProjectChangesTest >> testTP52894 [
	| skernel change |
	skernel := Object project.
	skernel ignoreChangesWhile: [| p |
		p := self class project.
		p ignoreChangesWhile: [
			change := skernel changes
				methodDefinitionClass: Object
				sourceCode: 'TP52894'.
			[| addition cm |
				cm := change perform.
				self assert: cm project = skernel.
				addition := MethodAddition fromCompiledMethod: cm in: self class project.
				addition perform.
				skernel changes forgetMethod: cm.
				self assert: (skernel excludedMethods includes: cm signature).
				skernel renameSelector: cm selector as: #TP52894_B.
				p renameSelector: cm selector as: #TP52894_B.
				self
					assert: (skernel excludedMethods
						includes: (Object >> #TP52894_B) signature)]
				ensure: [
					skernel changes
						removeSelector: #TP52894_B from: Object;
						removeSelector: #TP52894_B from: Object.
					p changes
						removeSelector: #TP52894_B from: Object;
						removeSelector: #TP52894_B from: Object]]]]

