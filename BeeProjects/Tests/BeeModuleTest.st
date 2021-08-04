"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #BeeModuleTest, 
	#superclass : #TestCase, 
	#category : #Tests
}

{#category : #unclassified}
BeeModuleTest >> foo [
]

{#category : #tools}
BeeModuleTest >> method [
	| a |
	a := 1.
	self msg: a keyword: 0.
	^a]

{#category : #all}
BeeModuleTest >> testAddProjectBefore [
	| project1 project2 cluster change |
	self
		precondition: (BeeModule named: 'project1') isNil;
		precondition: (BeeModule named: 'project2') isNil;
		precondition: (BeeModule named: 'cluster') isNil.
	project1 := BeeModule newProject: 'project1'.
	project2 := BeeModule newProject: 'project2'.
	cluster := BeeModule newCluster: 'cluster'.
	cluster add: project2.
	cluster addProject: project1 before: project2.
	[
		self
			assert: (cluster parts indexOf: project1) = 1;
			assert: (cluster parts indexOf: project2) = 2.
		change := cluster currentChanges anyone.
		cluster forgetProject: project1.
		self assert: (cluster parts indexOf: project1) = 0.
		change perform.
		self assert: (cluster parts indexOf: project1) = 1]
		ensure: [
			BeeModule
				forgetProject: project1;
				forgetProject: project2;
				forgetProject: cluster]]

{#category : #all}
BeeModuleTest >> testClusterFor [
	| project cluster1 cluster2 cluster3 |
	self
		precondition: (BeeModule named: 'project') isNil;
		precondition: (BeeModule named: 'cluster1') isNil;
		precondition: (BeeModule named: 'cluster2') isNil;
		precondition: (BeeModule named: 'cluster3') isNil.
	project := BeeModule newProject: 'project'.
	cluster1 := BeeModule newCluster: 'cluster1'.
	cluster2 := BeeModule newCluster: 'cluster2'.
	cluster3 := BeeModule newCluster: 'cluster3'.
	cluster1 add: project.
	cluster2 add: cluster1.
	cluster3 add: cluster2.
	[
		self
			assert: (cluster2 clusterFor: project) == cluster1;
			assert: (cluster3 clusterFor: project) == cluster1]
		ensure: [
			BeeModule
				forgetProject: project;
				forgetProject: cluster1;
				forgetProject: cluster2;
				forgetProject: cluster3]]

{#category : #all}
BeeModuleTest >> testCompiledMethods [
	| p1 p2 barp1 barp2 |
	p1 := BeeProject new name: 'p1'.
	p2 := BeeProject new name: 'p2'.
	barp1 := MethodDefinition new
		projectChanges: p1 changes;
		className: 'Object';
		sourceCode: 'bar ^1';
		perform.
	barp2 := MethodDefinition new
		projectChanges: p2 changes;
		className: 'Object';
		sourceCode: 'bar ^2';
		perform.
	self assert: p1 wasOverridden.
	self assert: (p1 extensions includes: barp1).
	self assert: (p2 extensions includes: Object >> #bar).
	self assert: p1 extensions size = 1]

{#category : #all}
BeeModuleTest >> testDefaultProject [
	| change |
	change := ClassChange new projectChanges: 'A STRING'; className: 'Point'.
	self
		assert: change defaultProject = Point project;
		assert: change projectName = 'A STRING']

{#category : #all}
BeeModuleTest >> testDotInProjectName [
	| project1 project2 |
	self precondition: (BeeModule named: '.project') isNil.
	self precondition: (BeeModule named: 'XXX.System.Xml') isNil.
	project1 := BeeModule newProject: '.project'.
	project2 := BeeModule newProject: 'XXX.System.Xml'.
	[
		self
			assert: project1 name = '.project';
			assert: project2 name = 'XXX.System.Xml']
		ensure: [BeeModule forgetProject: project1; forgetProject: project2]]

{#category : #all}
BeeModuleTest >> testEmptyPool [
	| p dir |
	dir := Directory scratchDir.
	self assert: (BeeProject named: 'TP56524') isNil.
	p := BeeProject new fullName: dir \ 'TP56524'.
	Smalltalk at: #PoolTP56524 put: PoolDictionary new.
	SourceStore current ignoreChangesWhile: [
		p changes ignoreLoggingWhile: [
			[
				p description: 'testing projects'; developmentOnly: true.
				p addPoolDictionary: #PoolTP56524.
				p saveProject.
				p unload.
				self assert: (BeeProject named: 'TP56524') isNil.
				p := BeeModule loadProject: dir \ 'TP56524.stp']
				ensure: [p unload]]]]

{#category : #all}
BeeModuleTest >> testLastChangesForClass_01 [
	| p current changes last |
	p := self class project.
	current := p changes.
	changes := ProjectChanges new project: p.
	[
		p changes: changes.
		changes compile: 'foo ^ 1' in: self class.
		changes compile: 'foo ^ 2' in: self class.
		last := p lastChangesForClass: self class.
		self
			assert: last size == 1;
			assert: last anyone isMethodDefinition;
			assert: last anyone sourceCode = 'foo ^ 2']
		ensure: [
			changes removeSelector: ('fo' , 'o') asSymbol from: self class.
			changes removeSelector: #bar from: self class.
			p changes: current]]

{#category : #all}
BeeModuleTest >> testLastChangesForClass_02 [
	| p current changes last |
	p := self class project.
	current := p changes.
	changes := ProjectChanges new project: p.
	[
		p changes: changes.
		changes compile: 'foo ^ 1' in: self class.
		changes renameSelector: ('fo' , 'o') asSymbol as: #bar.
		last := p lastChangesForClass: self class.
		self
			assert: last size == 1;
			assert: last anyone isMethodDefinition;
			assert: (last anyone sourceCode beginsWith: 'bar')]
		ensure: [
			changes removeSelector: ('ba' , 'r') asSymbol from: self class.
			p changes: current]]

{#category : #all}
BeeModuleTest >> testLastChangesForClass_03 [
	| p current changes last |
	p := self class project.
	current := p changes.
	changes := ProjectChanges new project: p.
	[
		p changes: changes.
		changes compile: 'foo ^ 1' in: self class.
		changes compile: 'baz ^ 2' in: self class.
		last := p lastChangesForClass: self class.
		self
			assert: last size == 2;
			assert: last first isMethodDefinition;
			assert: last second isMethodDefinition]
		ensure: [
			changes removeSelector: ('fo' , 'o') asSymbol from: self class.
			changes removeSelector: ('ba' , 'z') asSymbol from: self class.
			p changes: current]]

{#category : #all}
BeeModuleTest >> testLastChangesForClass_04 [
	| p current changes last |
	p := self class project.
	current := p changes.
	changes := ProjectChanges new project: p.
	[
		p changes: changes.
		changes compile: 'foo ^ 1' in: self class.
		changes removeSelector: ('fo' , 'o') asSymbol from: self class.
		last := p lastChangesForClass: self class.
		self assert: last isEmpty]
		ensure: [
			changes removeSelector: ('fo' , 'o') asSymbol from: self class.
			p changes: current]]

{#category : #all}
BeeModuleTest >> testLastChangesForClass_05 [
	| p current changes last |
	p := self class project.
	current := p changes.
	changes := ProjectChanges new project: p.
	[
		p changes: changes.
		changes
			defineClass: 'Object
	subclass: #QUX
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
			notifying: nil.
		last := p lastChangesForClass: (Smalltalk at: #QUX).
		self assert: last size == 1.
		self assert: last anyone isClassDefinition]
		ensure: [
			changes removeClass: (Smalltalk at: #QUX).
			p changes: current]]

{#category : #all}
BeeModuleTest >> testLastChangesForClass_06 [
	| p current changes last |
	p := self class project.
	current := p changes.
	changes := ProjectChanges new project: p.
	[
		p changes: changes.
		changes
			defineClass: 'Object
	subclass: #QUX
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
			notifying: nil.
		changes currentChanges removeAll.
		changes renameClass: (Smalltalk at: #QUX) to: #UAZ.
		last := p lastChangesForClass: (Smalltalk at: #UAZ).
		self assert: last size == 1.
		self assert: last anyone isClassDefinition]
		ensure: [
			changes removeClass: (Smalltalk at: #UAZ).
			p changes: current]]

{#category : #all}
BeeModuleTest >> testOverwrittenAfterShapeChange [
	| p name p1 |
	#testTP54152.
	p := self class project.
	name := self class name.
	TestCase
		subclass: self class symbol
		instanceVariableNames: 'qqq'
		classVariableNames: ''
		poolDictionaries: ''.
	p1 := BeeProject new name: 'p1'.
	[| m m1 n |
		m := MethodDefinition new
			projectChanges: p changes;
			className: name;
			sourceCode: 'TP54152 ^qqq + 1';
			perform.
		m1 := MethodDefinition new
			projectChanges: p1 changes;
			className: name;
			sourceCode: 'TP54152 ^2';
			perform.
		self
			assert: p wasOverridden;
			assert: (p wasOverridden: #TP54152 in: self class);
			assert: (p1 extensions includes: m1);
			assert: (p1 extensions includes: self class >> #TP54152).
		[
			TestCase
				subclass: self class symbol
				instanceVariableNames: ''
				classVariableNames: ''
				poolDictionaries: '']
			on: RecompilationFailure
			do: [:e | e resume].
		self
			deny: (p1 extensions includes: m1);
			assert: (p1 extensions includes: self class >> #TP54152).
		n := p overriddenVersions at: self class -> #TP54152.
		self
			assert: n needsRecompilation
			description: 'Methods referencing wrong instVars should be marked';
			deny: n == m]
		ensure: [| cm |
			cm := self class >> #TP54152.
			cm notNil
				ifTrue: [p changes removeSelector: cm selector from: self class].
			BeeModule forgetProject: p1.
			(self class instVarNames includes: 'qqq') ifTrue: [
				TestCase
					subclass: self class symbol
					instanceVariableNames: ''
					classVariableNames: ''
					poolDictionaries: '']]]

{#category : #all}
BeeModuleTest >> testProjectsIncluding [
	| cm default projects |
	default := BeeModule default.
	cm := self class >> #testProjectsIncluding.
	default addMethod: cm.
	[
		projects := BeeModule projectsIncluding: cm.
		self assert: (projects includes: default).
		default addClass: self class.
		projects := BeeModule projectsForClass: self class.
		self assert: (projects includes: default)]
		ensure: [default changes forgetMethod: cm; forgetClass: self class]]

{#category : #all}
BeeModuleTest >> testReadLocalPool [
	| project |
	project := BeeProject new name: testSelector.
	[| stp |
		project changes
			defineClass: 'Object
	subclass: #ClassWithLocalPool
	instanceVariableNames: ''''
	classVariableNames: ''LocalPool''
	poolDictionaries: '''''
			notifying: nil;
			notifyCompilationErrorsTo: nil;
			compile: 'initialize
LocalPool := PoolDictionary new.
LocalPool at: #Constant put: -1.'
			in: (Smalltalk at: #ClassWithLocalPool) class.
		(Smalltalk at: #ClassWithLocalPool) initialize.
		project changes
			compile: 'constant ^Constant'
			in: (Smalltalk at: #ClassWithLocalPool).
		self
			assert: (Smalltalk at: #ClassWithLocalPool) new constant = -1;
			deny: (Smalltalk includesKey: #LocalPool).
		stp := String streamContents: [:s | project fileOutOn: s].
		Smalltalk collectGarbage.
		(Smalltalk at: #ClassWithLocalPool) removeFromSystem.
		BeeProject new readFrom: stp readStream.
		self
			assert: (Smalltalk at: #ClassWithLocalPool) new constant = -1;
			deny: (Smalltalk includesKey: #LocalPool)]
		ensure: [
			Smalltalk collectGarbage.
			(Smalltalk at: #ClassWithLocalPool) removeFromSystem]]

{#category : #all}
BeeModuleTest >> testRenameSelector [
	| p cm current changes |
	p := self class project.
	current := p changes.
	changes := ProjectChanges new project: p.
	[
		p changes: changes.
		cm := self class >> #method.
		self precondition: (cm includes: #msg:keyword:).
		p renameSelector: #msg:keyword: as: #msg:keyword:.
		self assert: (self class >> #method includes: #msg:keyword:).
		p renameSelector: #msg:keyword: as: #msg:keyword:]
		ensure: [p changes: current]]

{#category : #all}
BeeModuleTest >> testTP34874 [
	| p cm current changes |
	p := self class project.
	current := p changes.
	changes := ProjectChanges new project: p.
	[
		p changes: changes.
		cm := self class >> 'foo' asSymbol.
		cm isNil ifTrue: [cm := self class compile: 'foo'].
		p renameSelector: 'foo' asSymbol as: 'foo' asSymbol.
		self assert: self class >> 'foo' asSymbol == cm]
		ensure: [p changes: current]]

{#category : #all}
BeeModuleTest >> testTP37794_01 [
	| project changes classname category selector var pool |
	project := BeeProject new.
	project name: 'TP37794'.
	project
		classes: {ExceptionSet. Association};
		addVariableNamed: 'AF_CTRL' inPoolNamed: 'WinConstants';
		addVariableNamed: 'AF_ALT' inPoolNamed: 'WinConstants'.
	changes := (Changeset
		fromStream: (String streamContents: [:s | project fileOutOn: s]) readStream)
		currentChanges.
	pool := '' asSymbol.
	changes select: [:ch | ch class == PoolVariableAddition] thenDo: [:ch | 
		ch globalName != pool ifTrue: [
			var := ''.
			self assert: pool < ch globalName.
			pool := ch globalName].
		ch variableName != var ifTrue: [
			self assert: var < ch variableName.
			var := ch variableName]].
	classname := category := selector := ''.
	changes select: [:ch | ch isClassDefinition] thenDo: [:ch | 
		ch className != classname ifTrue: [
			self assert: classname < ch className.
			classname := ch className]].
	classname := ''.
	category := selector := #''.
	changes select: [:ch | ch isMethodDefinition] thenDo: [:ch | 
		ch className != classname
			ifTrue: [
				self
					assert: (ch className > classname
						or: [ch className , ' class' = classname]).
				classname := ch className.
				category := selector := #'']
			ifFalse: [
				ch category != category
					ifTrue: [
						self assert: (ch category isNil or: [category < ch category]).
						category := ch category.
						selector := #'']
					ifFalse: [
						self assert: selector < ch selector.
						selector := ch selector]]]]

{#category : #all}
BeeModuleTest >> testTP38155 [
	| random projects |
	random := self random.
	projects := random sample: 3 from: BeeProject allProjects.
	projects do: [:project | | methods |
		methods := random sample: 50 from: project allMethods.
		methods do: [:cm | | fileout change |
			fileout := String
				streamContents: [:strm | project fileOutMethodDefinition: cm on: strm].
			change := ChangeRecord readFrom: fileout readStream.
			self
				assert: change project = project;
				assert: change author = cm author;
				assert: (cm category == #unclassified
					or: [change category = cm category]);
				assert: change sourceCode = cm sourceCode]]]

{#category : #all}
BeeModuleTest >> testTP47856 [
	| project fileout changes |
	project := BeeModule named: 'bdev'.
	fileout := String streamContents: [:s | project fileOutOn: s].
	changes := Changeset fromStream: fileout readStream.
	changes currentChanges
		do: [:c | (c isKindOf: ProjectChange)
			ifTrue: [self assert: c project == project]]]

{#category : #all}
BeeModuleTest >> testTP49473 [
	| def original p |
	p := BeeProject new name: 'TestTP49473'.
	def := ClassDefinition new.
	def
		className: 'TestTP49473';
		project: p;
		definition: 'Object
	subclass: #TestTP49473
	instanceVariableNames: ''i1 i2''
	classVariableNames: ''E C''
	poolDictionaries: ''WinConstants CharacterConstants'''.
	def perform.
	[
		original := (Smalltalk at: #TestTP49473) definitionString.
		def definition lines with: original lines withIndexDo: [:l1 :l2 :i | 
			i > 3
				ifTrue: [self deny: l1 trimBlanks = l2 trimBlanks]
				ifFalse: [self assert: l1 trimBlanks = l2 trimBlanks]].
		self deny: def changesSomething.
		def project: self class project.
		self assert: def changesSomething]
		ensure: [p unload]]

{#category : #all}
BeeModuleTest >> testTP49473b [
	| def |
	def := ClassDefinition new.
	def
		className: 'SmalltalkSession';
		definition: (SmalltalkSession definitionString
			replaceAll: 'instanceVariableNames: '''
			with: 'instanceVariableNames: ''newvar ');
		project: SmalltalkSession project.
	self
		assert: def changesSomething
		description: 'Adding an instvar CHANGES something']

{#category : #all}
BeeModuleTest >> testTP49473c [
	| def |
	def := ClassDefinition new.
	def
		className: 'SmalltalkSession';
		definition: (SmalltalkSession definitionString
			replaceAll: 'Object'
			with: 'Collection');
		project: SmalltalkSession project.
	self
		assert: def changesSomething
		description: 'Change the superrclass CHANGES something']

{#category : #all}
BeeModuleTest >> testTP56524 [
	| p dir |
	dir := Directory scratchDir.
	self
		precondition: (Smalltalk includesKey: #TP56524Class) not;
		assert: (BeeProject named: 'TP56524') isNil.
	p := BeeProject new fullName: dir \ 'TP56524'.
	(Smalltalk at: #PoolTP56524 put: PoolDictionary new)
		at: '{one[]}' put: 1;
		at: '{two[]}' put: 2.
	SourceStore current ignoreChangesWhile: [
		p changes ignoreLoggingWhile: [
			[| cls |
				p description: 'testing projects'; developmentOnly: true.
				p addPoolDictionary: #PoolTP56524.
				cls := Object subclass: 'TP56524Class'.
				cls addSharedPool: #PoolTP56524.
				cls class
					compile: 'configureCompiler: aCompiler
					aCompiler optionAt: #squeakBraces put: false'.
				cls compile: 'm ^{one[]} + {two[]}'.
				p addClass: cls.
				p saveProject.
				p unload.
				self assert: (Smalltalk includesKey: #PoolTP56524) not.
				p := BeeModule loadProject: dir \ 'TP56524.stp'.
				self
					deny: p hasUnresolvedReferences;
					assert: (Smalltalk includesKey: #PoolTP56524);
					assert: (Smalltalk at: #TP56524Class) new m = 3]
				ensure: [p unload]]]]

{#category : #all}
BeeModuleTest >> testUndeclaredFileOutFileIn [
	| p user dir unresolved m1 m2 m3 |
	dir := Directory scratchDir.
	self assert: (BeeProject named: 'TP54215') isNil.
	p := BeeProject new fullName: dir \ 'TP54215'.
	[
		p description: 'testing projects'; developmentOnly: true.
		unresolved := Object subclass: 'UnresolvedC54215'.
		user := Object subclass: 'UnresolvedUser54215'.
		m1 := user compile: 'm1 ^UnresolvedC54215 size'.
		m2 := user compile: 'm2 ^54215'.
		m3 := self class compile: 'm3 ^54215'.
		p
			addClass: user;
			addMethod: m3;
			excludeMethod: m2.
		p saveProject.
		self assert: (dir filesMatching: 'TP54215.*') size = 1.
		user delete.
		unresolved delete.
		p unload.
		p := BeeModule loadProject: dir \ 'TP54215.stp'.
		self
			assert: p description = 'testing projects';
			assert: p isDevelopmentOnly;
			assert: (user := Smalltalk at: #UnresolvedUser54215) isClass;
			assert: (p includesClass: user);
			assert: (p includesMethod: user >> #m1);
			assert: (p includesMethod: self class >> #m3);
			deny: (user methodDictionary includesKey: #m2);
			deny: (p includesClass: user selector: #m2);
			assert: p hasUnresolvedReferences]
		ensure: [p unload]]

{#category : #all}
BeeModuleTest >> testUnload1 [
	"
	TP46819
	"
	| p filename |
	self precondition: (BeeModule named: 'testUnload1') isNil.
	p := BeeModule newProject: 'testUnload1'.
	[
		p changes
			defineClass: 'Object
		subclass: #XtestUnload1
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: '''''
			notifying: nil.
		p changes compile: 'testUnload1' in: (Smalltalk
			at: 'XtestUnload1' asSymbol).
		p changes compile: 'testUnload1' in: Object.
		self
			assert: (Smalltalk includesKey: 'XtestUnload1' asSymbol);
			assert: ((Smalltalk at: 'XtestUnload1' asSymbol) methodDictionary
				includesKey: 'testUnload1' asSymbol);
			assert: (Object methodDictionary includesKey: 'testUnload1' asSymbol).
		p buildCodeSegment.
		filename := p filename.
		p unload.
		p := nil.
		self
			deny: (Smalltalk includesKey: 'XtestUnload1' asSymbol);
			deny: (Object methodDictionary includesKey: 'testUnload1' asSymbol).
		p := BeeModule getProject: 'testUnload1'.
		self assert: p notNil.
		self
			assert: (Smalltalk includesKey: 'XtestUnload1' asSymbol);
			assert: ((Smalltalk at: 'XtestUnload1' asSymbol) methodDictionary
				includesKey: 'testUnload1' asSymbol);
			assert: (Object methodDictionary includesKey: 'testUnload1' asSymbol).
		p unload.
		p := nil.
		self
			deny: (Smalltalk includesKey: 'XtestUnload1' asSymbol);
			deny: (Object methodDictionary includesKey: 'testUnload1' asSymbol)]
		ensure: [| f |
			filename notNil ifTrue: [
				#(bsl bsc ch stp) do: [:extension | 
					f := filename withExtension: extension.
					f exists ifTrue: [f asFile remove]]].
			p notNil ifTrue: [BeeModule forgetProject: p]]]

