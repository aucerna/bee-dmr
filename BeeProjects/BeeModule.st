"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #BeeModule, 
	#superclass : #Object, 
	#instVars : [
		'name', 
		'filename', 
		'changes', 
		'unresolved'
	], 
	#classVars : [
		'Classes', 
		'LoadedProjects', 
		'ProjectsDirectory'
	], 
	#category : #BeeProjects
}

{#category : #events}
BeeModule class >> aboutToRemoveClass: aClass [
	Classes removeKey: aClass ifAbsent: nil]

{#category : #accessing}
BeeModule class >> addProject: aBeeModule [
	self systemCluster add: aBeeModule.
	^LoadedProjects at: aBeeModule name put: aBeeModule]

{#category : #accessing}
BeeModule class >> allProjects [
	^LoadedProjects asOrderedCollection]

{#category : #accessing}
BeeModule class >> allSimpleProjects [
	^self allProjects reject: [:project | project isCluster]]

{#category : #accessing}
BeeModule class >> class: aClass addedTo: aBeeProject [
	Classes at: aClass put: aBeeProject ifPresent: [:p | | projects |
		projects := p isCollection ifTrue: [p] ifFalse: [Set with: p].
		projects add: aBeeProject.
		Classes at: aClass put: projects]]

{#category : #accessing}
BeeModule class >> class: aClass forgottenFrom: aBeeProject [
	| projects |
	projects := Classes at: aClass ifAbsent: [^self].
	(projects == aBeeProject or: [projects size <= 1])
		ifTrue: [Classes removeKey: aClass]
		ifFalse: [projects remove: aBeeProject ifAbsent: nil]]

{#category : #queries}
BeeModule class >> clusters [
	^LoadedProjects select: [:p | p isCluster]]

{#category : #accessing}
BeeModule class >> default [
	^BeeProject current]

{#category : #accessing}
BeeModule class >> defaultDirectory [
	^ProjectsDirectory]

{#category : #accessing}
BeeModule class >> dmrProject [
	^nil]

{#category : #queries}
BeeModule class >> emptyProjects [
	^BeeModule allSimpleProjects select: [:p | p isEmpty]]

{#category : #utils}
BeeModule class >> extensions [
	^#('stp' 'ch' 'st' 'cls' 'mth')]

{#category : #accessing}
BeeModule class >> forgetProject: aBeeModule [
	aBeeModule isCluster
		ifFalse: [aBeeModule classes
			do: [:cls | self class: cls forgottenFrom: aBeeModule]].
	LoadedProjects removeKey: aBeeModule name ifAbsent: nil.
	self clusters do: [:c | c remove: aBeeModule]]

{#category : #'instance creation'}
BeeModule class >> fromFileOutFile: aFilename [
	| stream project |
	stream := aFilename asFile readStream.
	[| cls |
		cls := Smalltalk at: stream nextLine trimBlanks unquoted asSymbol.
		project := cls new.
		project fullName: aFilename.
		project readFrom: stream]
		ensure: [stream close].
	^project]

{#category : #'instance creation'}
BeeModule class >> fromImageSegment: bsl [
	^BeeProject new readFromImageSegment: bsl]

{#category : #'instance creation'}
BeeModule class >> getProject: aFilename [
	| string |
	string := aFilename asFilename fileNameOnly.
	^LoadedProjects at: string ifAbsent: [
		LoadedProjects
			detect: [:p | p name equalsCaseInsensitive: string]
			ifNone: [self loadProject: aFilename]]]

{#category : #testing}
BeeModule class >> hasDefaultProject [
	^BeeProject hasDefaultProject]

{#category : #initialization}
BeeModule class >> initialize [
	LoadedProjects := Dictionary new.
	Classes := WeakIdentityDictionary new new.
	ProjectsDirectory := '\.lib' asFilename]

{#category : #testing}
BeeModule class >> isLoadedProject: aFilename [
	| fn |
	fn := aFilename asFilename fileNameOnly.
	^(self named: fn) notNil]

{#category : #initialization}
BeeModule class >> justBound [
	SmalltalkSession current
		when: #segmentLoaded: send: #segmentLoaded: to: self;
		when: #segmentUnloaded: send: #segmentUnloaded: to: self.
	self computeClassProjects.
	self performDeferred: #loadAll]

{#category : #accessing}
BeeModule class >> lastChangesForClass: aClass [
	^self systemCluster lastChangesForClass: aClass]

{#category : #queries}
BeeModule class >> modifiedProjects [
	| modified |
	modified := OrderedCollection new.
	self systemCluster
		simpleProjectsDo: [:p | p hasBeenModified ifTrue: [modified add: p]].
	^modified]

{#category : #accessing}
BeeModule class >> named: aString [
	| string |
	string := aString asFilename fileNameOnly.
	^LoadedProjects at: string ifAbsent: [
		LoadedProjects
			detect: [:one | one name equalsCaseInsensitive: string]
			ifNone: nil]]

{#category : #'instance creation'}
BeeModule class >> new [
	^super new initialize]

{#category : #'system project'}
BeeModule class >> newCluster: aString [
	^BeeCluster new name: aString]

{#category : #'system project'}
BeeModule class >> newProject: aString [
	^BeeProject new name: aString]

{#category : #accessing}
BeeModule class >> projectFileOutFileExtension [
	^'.stp']

{#category : #resolving}
BeeModule class >> projectsFor: selector class: aClass [
	| cm projects |
	aClass isNil ifTrue: [^#()].
	cm := selector notNil ifTrue: [aClass >> selector].
	projects := cm isNil ifTrue: [aClass projects] ifFalse: [cm projects].
	projects remove: BeeModule default ifAbsent: nil.
	^projects sort]

{#category : #queries}
BeeModule class >> projectsForClass: aClass [
	| cls projects |
	cls := aClass instanceClass.
	projects := Classes at: aClass instanceClass ifAbsentPut: [| set |
		set := self allSimpleProjects
			select: [:p | p includesClass: cls]
			in: Set new.
		set size = 1 ifTrue: [set anyone] ifFalse: [set]].
	^projects isCollection ifTrue: [projects] ifFalse: [{projects}]]

{#category : #queries}
BeeModule class >> projectsIncluding: anObject [
	| all |
	all := LoadedProjects asSet.
	BeeProject hasDefaultProject ifTrue: [all := all && self default].
	^anObject isSpecies
		ifTrue: [all
			select: [:p | p isCluster not and: [p includesClass: anObject]]]
		ifFalse: [
			anObject isCompiledMethod
				ifTrue: [all
					select: [:p | p isCluster not and: [p includesMethod: anObject]]]
				ifFalse: [#()]]]

{#category : #queries}
BeeModule class >> projectsIncludingCompiledMethod: aCompiledMethod [
	^LoadedProjects
		select: [:p | p isCluster not
			and: [p includesCompiledMethod: aCompiledMethod]]]

{#category : #utils}
BeeModule class >> projectsResembling: aString [
	| names similar |
	names := LoadedProjects keys.
	similar := aString similarStringsIn: names.
	^similar collect: [:n | self named: n]]

{#category : #utils}
BeeModule class >> promptFileName [
	^self promptFileName: '*.stp']

{#category : #utils}
BeeModule class >> promptFileName: fileSpec [
	^FileDialog new
		title: 'Open Project File';
		fileSpec: fileSpec;
		shareAware;
		addFilter: '*.stp' description: 'Smalltalk Project File out (*.stp)';
		addFilter: '*.ch' description: 'Smalltalk Project changes (*.ch)';
		open;
		file]

{#category : #'system project'}
BeeModule class >> promptFilenames: aString [
	^FileDialog new
		title: 'Open changeset file';
		multipleSelect;
		shareAware;
		addFilter: '*.bsc' description: 'Library Sources (*.bsc)';
		addFilter: '*.ch' description: 'Changesets (*.ch)';
		addFilter: '*.cls' description: 'Classes (*.cls)';
		addFilter: '*.stp' description: 'Project fileouts (*.stp)';
		addFilter: '*.st' description: 'Scripts (*.st)';
		addFilter: '*.mth' description: 'Methods (*.mth)';
		addFilter: '*.log' description: 'Log files (*.log)';
		fileSpec: aString;
		open;
		files]

{#category : #resolving}
BeeModule class >> resolveClass: aString [
	^Smalltalk classNamed: aString]

{#category : #queries}
BeeModule class >> rootClusters [
	| clusters reject |
	clusters := self clusters asSet.
	reject := Set new.
	clusters
		do: [:cluster | cluster parts
			select: [:p | p isCluster]
			thenDo: [:p | reject add: p]].
	clusters removeAll: reject.
	^clusters]

{#category : #events}
BeeModule class >> segmentLoaded: aCodeImageSegment [
	| previous projects project |
	project := aCodeImageSegment project.
	aCodeImageSegment classes do: [:cls | self class: cls addedTo: project].
	previous := aCodeImageSegment overriddenMethods ifNil: [Dictionary new].
	projects := BeeModule allSimpleProjects remove: project; yourself.
	aCodeImageSegment extensions do: [:cm | | prev |
		prev := previous at: cm ifAbsent: nil.
		projects do: [:p | 
			prev isNil
				ifTrue: [(p includesClass: cm classBinding) ifTrue: [p excludeMethod: cm]]
				ifFalse: [(cm isCurrentVersion and: [p includesMethod: cm])
					ifTrue: [p overridden: prev]]]]]

{#category : #events}
BeeModule class >> segmentUnloaded: aCodeImageSegment [
	self allSimpleProjects do: [:p | p updateOverriddenVersions]]

{#category : #accessing}
BeeModule class >> simpleProjectsDo: aBlock [
	^LoadedProjects reject: [:project | project isCluster] thenDo: aBlock]

{#category : #accessing}
BeeModule class >> systemCluster [
	^BeeCluster systemCluster]

{#category : #accessing}
BeeModule class >> systemProject [
	^self default]

{#category : #inquiries}
BeeModule class >> versionOf: prjFilename [
	| tree node fn |
	fn := prjFilename asFilename.
	fn fileExists ifFalse: [^nil].
	tree := Compiler parse: fn asFile contents readStream nextChunk.
	node := tree statements first messages
		detect: [:m | m selector value == #version:].
	^node arguments anyone value]

{#category : #'instance creation'}
BeeModule class >> withName: aString [
	^(self getProject: aString) ifNil: [self newProject: aString]]

{#category : #comparing}
BeeModule >> <= aBeeModule [
	^self == BeeModule default or: [name <= aBeeModule name]]

{#category : #'file in/out'}
BeeModule >> aboutToSaveLibrary: aClass [
	(aClass respondsTo: #aboutToSaveLibrary) ifFalse: [^self].
	aClass aboutToSaveLibrary]

{#category : #'file in/out'}
BeeModule >> aboutToSaveLibrary: aClass on: aCodeSegmentBuilder [
	aClass aboutToSaveLibrary: self on: aCodeSegmentBuilder]

{#category : #utils}
BeeModule >> addChangesFromFile [
	| fn file changeset |
	fn := self class promptFileName.
	fn fileExists ifFalse: [^self].
	file := fn asFile readStream.
	[changeset := ProjectChanges new project: self; fileInFrom: file]
		ensure: [file close].
	changeset currentChanges do: [:c | changes addChange: c]]

{#category : #utils}
BeeModule >> addChangesFromSqueakFile [
	| fn file ch |
	fn := FileDialog new
		title: 'Open Project changes';
		fileSpec: '*.cs';
		hideReadonly;
		shareAware;
		addFilter: '*.cs' description: 'Squeak Changes';
		fileMustExist;
		open;
		file.
	fn isNil ifTrue: [^self].
	file := fn asFile readStream.
	[ch := ProjectChanges new project: self; fileInFromSqueak: file]
		ensure: [file close].
	(ch isCollection ifTrue: [ch] ifFalse: [ch currentChanges])
		do: [:c | changes addChange: c]]

{#category : #'file in/out'}
BeeModule >> addClass: class to: builder excluding: exclusions [
	| rejected metaclass metaRejected overriden metaOverriden selectors |
	self aboutToSaveLibrary: class on: builder.
	rejected := exclusions
		select: [:each | each classBinding == class]
		thenCollect: [:each | each selector].
	metaclass := class class.
	metaRejected := exclusions
		select: [:each | each classBinding == metaclass]
		thenCollect: [:each | each selector].
	overriden := (self methodsOverriddenIn: class) asOrderedCollection.
	metaOverriden := (self methodsOverriddenIn: class class) asOrderedCollection.
	overriden isEmpty & metaOverriden isEmpty & rejected isEmpty
		& metaRejected isEmpty
		ifTrue: [builder add: class]
		ifFalse: [
			selectors := class selectors
				removeAll: rejected;
				removeAll: (overriden collect: #selector);
				yourself.
			builder addClass: class withMethods: selectors.
			selectors := class class selectors
				removeAll: metaRejected;
				removeAll: (metaOverriden collect: #selector);
				yourself.
			builder addClass: class class withMethods: selectors].
	overriden do: [:m | builder addMethod: m].
	metaOverriden do: [:m | builder addMethod: m]]

{#category : #queries}
BeeModule >> allMethods [
	| methods |
	methods := Set new.
	self simpleProjectsDo: [:project | methods addAll: project allMethods].
	^methods asArray]

{#category : #'file in/out'}
BeeModule >> basicFileOutOn: aStream [
	]

{#category : #utils}
BeeModule >> browse [
	Smalltalk browsingTools browseProject: self]

{#category : #accessing}
BeeModule >> bslDirectory [
	^self directory]

{#category : #'file in/out'}
BeeModule >> buildCodeSegment [
	| existing |
	existing := true.
	KernelLibrary getComputerName = SmalltalkSession current serverName
		ifTrue: [
			existing := 'saving.sl' asFilename exists.
			existing ifFalse: ['saving.sl' asFilename createFile]].
	[| builder |
		CursorPointer execute showWhile: [| folder |
			self validate.
			changes notNil ifTrue: [changes saveChanges].
			changes release.
			folder := self bslDirectory asDirectory.
			folder exists ifFalse: [folder create].
			builder := self builderClass newNamed: folder \ self fileName.
			self buildCodeSegmentOn: builder.
			builder save.
			self version: builder libraryVersion]]
		ensure: [existing ifFalse: ['saving.sl' asFilename removeFile]]]

{#category : #'file in/out'}
BeeModule >> buildCodeSegmentOn: aCodeSegmentBuilder [
	| exclusions |
	aCodeSegmentBuilder description: self description.
	exclusions := self excludedCompiledMethods asSet.
	self classes
		do: [:class | self
			addClass: class
			to: aCodeSegmentBuilder
			excluding: exclusions].
	self poolVariables do: [:o | 
		aCodeSegmentBuilder
			addPoolVariable: ((Smalltalk at: o first) at: o last)
			named: o last
			in: o first].
	self extensions do: [:cm | aCodeSegmentBuilder addMethod: cm].
	self globals do: [:g | aCodeSegmentBuilder addGlobalNamed: g].
	self loadActionSequence notNil
		ifTrue: [aCodeSegmentBuilder loadAction: self loadActionSequence].
	self unloadActionSequence notNil
		ifTrue: [aCodeSegmentBuilder unloadAction: self unloadActionSequence].
	self allPrerequisites do: [:libName | aCodeSegmentBuilder require: libName]]

{#category : #utils}
BeeModule >> buildTestSuite [
	| suite extensions |
	suite := TestSuite named: self name asString.
	self testClasses
		do: [:class | suite addTest: class buildSuiteFromSelectors].
	extensions := self testExtensions
		collect: [:m | m classBinding selector: m selector].
	suite addTests: extensions.
	^suite]

{#category : #changes}
BeeModule >> changesDo: aBlock [
	changes notNil ifTrue: [changes currentChanges do: aBlock]]

{#category : #utils}
BeeModule >> checkBehaviorStructures [
	self classes select: [:cl | cl needsReinstallation] thenDo: [:cl | 
		self halt.
		self changes reinstallClass: cl class.
		self changes reinstallClass: cl.
		(cl printString , ' has been recompiled') print]]

{#category : #utils}
BeeModule >> checkCompiledMethods [
	| compiler check |
	check := [:cm | | m |
		m := compiler compileMethod: cm sourceCode.
		(m notNil and: [m bytecodes = cm bytecodes])
			ifFalse: [Warning signal: 'Error in method: ' , cm printString]].
	self classes do: [:cl | 
		compiler := Compiler forClass: cl.
		cl methodDictionary do: check].
	self extensions do: [:cm | 
		compiler := Compiler forClass: cm classBinding.
		check value: cm]]

{#category : #queries}
BeeModule >> clusters [
	^self class clusters
		select: [:cluster | cluster !== self and: [cluster parts includes: self]]]

{#category : #accessing}
BeeModule >> compiledMethodFor: selector in: aClass [
	| signature |
	signature := aClass -> selector.
	^self compiledMethodFromSignature: signature]

{#category : #overwrite}
BeeModule >> compiledMethodFromSignature: anAssociation [
	^(self includesMethodWithSignature: anAssociation) ifTrue: [
		self overriddenVersions
			at: anAssociation
			ifAbsent: [anAssociation key >> anAssociation value]]]

{#category : #private}
BeeModule >> computeUnresolved [
	unresolved := OrderedCollection new.
	self
		allMethodsDo: [:m | unresolved
			addAll: (m select: [:slot | slot class == KnownObjectReference])]]

{#category : #accessing}
BeeModule >> currentCompiledMethods [
	^(self methods asOrderedCollection
		collect: [:m | CompiledMethod fromSignature: m])
		reject: [:m | m isNil]]

{#category : #services}
BeeModule >> dependencies [
	| dependencies |
	dependencies := Dictionary new.
	self allMethods do: [:m | 
		m referencedClasses & m classBinding withAllSuperclasses
			reject: [:c | self includesClass: c]
			thenDo: [:c | (dependencies
				at: c imageSegment
				ifAbsentPut: OrderedCollection new)
				add: m]].
	^dependencies]

{#category : #accessing}
BeeModule >> directory [
	^filename = filename entityName asFilename
		ifTrue: [self class defaultDirectory]
		ifFalse: [filename parentPath]]

{#category : #accessing}
BeeModule >> excludedCompiledMethods [
	^(self excludedMethods asOrderedCollection
		collect: [:m | CompiledMethod fromSignature: m])
		reject: [:m | m isNil]]

{#category : #accessing}
BeeModule >> excludedMethods [
	^#()]

{#category : #accessing}
BeeModule >> excludeMethod: signature [
	]

{#category : #queries}
BeeModule >> extendedClasses [
	^self externalMethodsClasses
		collect: #instanceClass
		thenSelect: #notNil
		in: Set new]

{#category : #accessing}
BeeModule >> extensions [
	^self methods asOrderedCollection
		collect: [:m | self compiledMethodFromSignature: m]
		thenSelect: [:m | m notNil]]

{#category : #accessing}
BeeModule >> externalMethodsClasses [
	^(self currentCompiledMethods collect: [:cm | cm classBinding]) asSet]

{#category : #accessing}
BeeModule >> externalMethodsIn: aClass [
	^self currentCompiledMethods
		select: [:cm | cm classBinding instanceClass == aClass]]

{#category : #accessing}
BeeModule >> filename [
	^self directory \ filename entityName]

{#category : #accessing}
BeeModule >> fileName [
	filename ifNil: [^name].
	^filename withoutExtension entityName]

{#category : #accessing}
BeeModule >> fileName: aFilename [
	filename := aFilename asFilename]

{#category : #accessing}
BeeModule >> filename: aFilename [
	filename := aFilename asFilename]

{#category : #'file in/out'}
BeeModule >> fileOut: aClass on: aStream [
	| remaining |
	remaining := aClass selectors.
	aClass isCategorized ifTrue: [
		aClass categories copy sort
			collect: [:category | (aClass organization selectorsFor: category)
				ifNil: #()]
			thenDo: [:selectors | 
				selectors asSortedCollection
					collect: [:selector | self compiledMethodFor: selector in: aClass]
					thenDo: [:cm | 
						cm notNil ifTrue: [
							remaining remove: cm selector ifAbsent: nil.
							self fileOutMethodDefinition: cm on: aStream.
							aStream cr]]]].
	remaining asSortedCollection
		collect: [:selector | self compiledMethodFor: selector in: aClass]
		thenDo: [:cm | 
			cm notNil ifTrue: [
				self fileOutMethodDefinition: cm on: aStream.
				aStream cr]]]

{#category : #'file in/out'}
BeeModule >> fileOutAssociationsOf: aDictionary on: aStream [
	| keys |
	keys := aDictionary keys asArray sortBy: #storeString.
	keys do: [:key | | value literal |
		value := aDictionary at: key.
		literal := value literalString ifNil: ['nil'].
		aStream
			crtab;
			nextPutAll: 'at: ';
			nextUTF8Put: key storeString;
			nextPutAll: ' put: ';
			nextUTF8Put: literal;
			nextPutAll: ';']]

{#category : #'file in/out'}
BeeModule >> fileOutClassesOn: aStream [
	| classes |
	aStream nextChunkPut: '"**** Class definitions ****"'; cr; cr.
	classes := self classes asArray sortBy: #name.
	classes reject: [:cls | classes includes: cls superclass] thenDo: [:cls | 
		cls withAllSubclasses do: [:c | 
			(classes includes: c) ifTrue: [
				self fileOutClassDefinition: c on: aStream.
				aStream cr]]].
	classes do: [:cls | 
		self
			fileOut: cls class on: aStream;
			fileOut: cls on: aStream].
	aStream cr]

{#category : #'file in/out'}
BeeModule >> fileOutExtensionsOn: aStream [
	aStream cr; nextChunkPut: '"**** Extensions ****"'; cr.
	self removeObsoleteMethods.
	(self extensions sortBy: #printString) do: [:cm | 
		self fileOutMethodDefinition: cm on: aStream.
		aStream cr]]

{#category : #'file in/out'}
BeeModule >> fileOutGlobalsOn: aStream [
	| globals |
	globals := self globals asArray sort.
	globals isEmpty ifTrue: [^self].
	aStream nextChunkPut: '"**** Global definitions ****"'; cr; cr.
	globals do: [:s | 
		self fileOutGlobal: s on: aStream.
		aStream cr].
	aStream cr]

{#category : #'file in/out'}
BeeModule >> fileOutInitializationsOn: aStream [
	aStream
		cr;
		nextPutAll: '"**** Initializing ****"';
		cr;
		cr.
	self classes asArray
		sortBy: #name;
		select: [:cls | cls class selectors includes: #initialize]
		thenDo: [:cls | aStream
			nextUTF8Put: cls name;
			nextPutAll: ' initialize !';
			cr]]

{#category : #'file in/out'}
BeeModule >> fileOutOn: aStream [
	self
		writeDefinitionOn: aStream;
		fileOutPrerequisitesOn: aStream;
		basicFileOutOn: aStream;
		fileOutLoadActionsOn: aStream;
		fileOutUnloadActionsOn: aStream]

{#category : #'file in/out'}
BeeModule >> fileOutPool: aPoolDictionary named: aString on: aStream [
	aStream cr; nextUTF8Put: aString.
	aPoolDictionary isConstant
		ifTrue: [aStream crtab; nextPutAll: 'beConstantPool;'].
	self fileOutAssociationsOf: aPoolDictionary on: aStream.
	aStream
		crtab;
		nextPutAll: 'yourself!';
		cr;
		cr]

{#category : #utils}
BeeModule >> find: aString [
	| methods |
	methods := Set new.
	self classes do: [:cls | | references |
		references := cls referencesToString: aString.
		methods addAll: references].
	self extensions
		select: [:cm | cm referencesString: aString]
		thenDo: [:cm | methods add: cm].
	methods := methods reject: [:cm | cm isDoit].
	Smalltalk browsingTools browseMethods: methods referencing: aString]

{#category : #utils}
BeeModule >> findString: aString [
	| methods |
	methods := Set new.
	self classes
		do: [:cls | methods addAll: (cls referencesToSubstring: aString)].
	self extensions
		do: [:cm | (cm referencesSubstring: aString) ifTrue: [methods add: cm]].
	methods := methods reject: [:cm | cm isDoit].
	Smalltalk browsingTools browseMethods: methods referencing: aString]

{#category : #accessing}
BeeModule >> fullName: aFilename [
	filename := aFilename asFilename.
	self renameTo: filename withoutExtension entityName]

{#category : #testing}
BeeModule >> hasUnresolvedReferences [
	unresolved := unresolved
		reject: [:ref | (ref isKindOf: ExternalReference) not
			or: [ref isAlreadySolved]].
	^unresolved notEmpty]

{#category : #accessing}
BeeModule >> implementorsOf: selector [
	| methods species sorted rejected |
	methods := Dictionary new.
	species := Set new.
	rejected := self excludedMethods.
	self classes do: [:cls | 
		{cls. cls class} do: [:c | 
			c methodDictionary at: selector ifPresent: [:cm | 
				(rejected includes: cm signature) ifFalse: [
					species add: c instanceClass.
					methods at: cm classBinding put: cm]]]].
	self methods select: [:s | s value == selector] thenDo: [:s | | cm cl |
		cm := self compiledMethodFromSignature: s.
		cm notNil ifTrue: [
			cl := cm classBinding.
			species add: cl instanceClass.
			methods at: cl put: cm]].
	species := species asArray
		sortUsing: [:cls | cls allSuperclasses reversed phrase: #name].
	sorted := OrderedCollection new.
	species do: [:cls | 
		methods at: cls class ifPresent: [:cm | sorted add: cm].
		methods at: cls ifPresent: [:cm | sorted add: cm]].
	^sorted]

{#category : #testing}
BeeModule >> includesClass: aClass [
	^self classes
		includes: (aClass isSpecies
			ifTrue: [aClass instanceClass]
			ifFalse: [aClass])]

{#category : #testing}
BeeModule >> includesClass: aClass selector: aSymbol [
	| signature |
	signature := aClass -> aSymbol.
	^(aClass isClass and: [self includesClass: aClass])
		ifTrue: [(aClass >> aSymbol) notNil
			andNot: [self excludedMethods includes: signature]]
		ifFalse: [self methods includes: signature]]

{#category : #testing}
BeeModule >> includesCompiledMethod: compiledMethod [
	| cm |
	(self includesMethod: compiledMethod) ifFalse: [^false].
	cm := (self
		wasOverridden: compiledMethod selector
		in: compiledMethod classBinding)
		ifTrue: [self overriddenVersions at: compiledMethod signature].
	^cm isNil
		ifTrue: [compiledMethod isCurrentVersion]
		ifFalse: [cm == compiledMethod]]

{#category : #testing}
BeeModule >> includesMethod: aCompiledMethod [
	^(self includesClass: aCompiledMethod classBinding)
		ifTrue: [(self excludedMethods includes: aCompiledMethod signature) not]
		ifFalse: [self methods includes: aCompiledMethod signature]]

{#category : #testing}
BeeModule >> includesMethodWithSignature: anAssociation [
	^(self includesClass: anAssociation key)
		ifTrue: [(self excludedMethods includes: anAssociation) not]
		ifFalse: [self methods includes: anAssociation]]

{#category : #testing}
BeeModule >> includesObject: anObject [
	| g |
	^(self classes anySatisfy: [:one | one classVariables includes: anObject])
		or: [
			g := Smalltalk nameOfGlobal: anObject.
			g notNil and: [self globals includes: g]]]

{#category : #testing}
BeeModule >> includesProject: aBeeModule [
	self == aBeeModule ifTrue: [^true].
	(self includes: aBeeModule) ifTrue: [^true].
	^self parts anySatisfy: [:p | p includesProject: aBeeModule]]

{#category : #testing}
BeeModule >> includesSelector: selector class: aClass [
	^self includesMethodWithSignature: aClass -> selector]

{#category : #initialization}
BeeModule >> initialize [
	self description: ''.
	unresolved := #()]

{#category : #initialization}
BeeModule >> initializeChanges [
	changes := OrderedCollection new]

{#category : #testing}
BeeModule >> isCluster [
	^false]

{#category : #testing}
BeeModule >> isDefaultProject [
	^self == self class default]

{#category : #testing}
BeeModule >> isDevelopmentOnly [
	^false]

{#category : #utils}
BeeModule >> listMethodsOn: aStream [
	"
	self project listMethodsOn: Transcript
	"
	(self classes asArray sortBy: #name) do: [:cls | cls listMethodsOn: aStream]]

{#category : #accessing}
BeeModule >> livingObjects [
	| alive |
	alive := OrderedCollection new.
	alive answerTo: #map:to: evaluating: [:o :s | alive replace: o with: s].
	self classes do: [:class | 
		self aboutToSaveLibrary: class.
		alive addAll: class classVariables; addAll: class instClassVars.
		self aboutToSaveLibrary: class on: alive].
	alive addAll: (self globals collect: [:g | Smalltalk at: g ifAbsent: nil]).
	^alive]

{#category : #changes}
BeeModule >> localChanges [
	^changes isNil ifTrue: [#()] ifFalse: [changes currentChanges]]

{#category : #accessing}
BeeModule >> messageFromString: aString [
	| index class selector |
	aString isMessage ifTrue: [^aString].
	index := aString indexOf: $>.
	index = 0 ifTrue: [^nil].
	class := Smalltalk
		at: (aString copyFrom: 1 to: index - 1) asSymbol
		ifAbsent: [^nil].
	selector := (aString copyFrom: index + 2 to: aString size) asSymbol.
	^Message receiver: class selector: selector]

{#category : #accessing}
BeeModule >> methodsOverriddenIn: aClass [
	^self hasOverriddenVersions
		ifTrue: [self overriddenVersions select: [:m | m classBinding == aClass]]
		ifFalse: [#()]]

{#category : #utils}
BeeModule >> moveDownClassVar: varName of: aClass to: targetClass [
	ClassVarMoveDown move: varName from: aClass to: targetClass]

{#category : #utils}
BeeModule >> moveDownInstVar: varName of: aClass to: targetClass [
	InstVarMoveDown move: varName from: aClass to: targetClass]

{#category : #utils}
BeeModule >> moveDownInstVar: varName of: aClass toAll: aCollection [
	InstVarMoveDown move: varName from: aClass toAll: aCollection]

{#category : #utils}
BeeModule >> moveUpClassVar: aString of: aClass [
	ClassVarMoveUp move: aString from: aClass]

{#category : #utils}
BeeModule >> moveUpInstVar: varName of: aClass [
	InstVarMoveUp moveUp: varName from: aClass]

{#category : #accessing}
BeeModule >> name [
	^name]

{#category : #accessing}
BeeModule >> name: aString [
	| s |
	filename isNil ifTrue: [filename := aString asFilename].
	s := aString asFilename entityName asFilename.
	s hasExtension ifTrue: [
		self class extensions
			do: [:ext | (s hasExtension: ext) ifTrue: [s := s withoutExtension]]].
	self renameTo: s asString]

{#category : #testing}
BeeModule >> needsReinstallation: aClass [
	aClass hasClassBehavior ifFalse: [^true].
	aClass superclass isNil ifTrue: [^false].
	aClass instSize - aClass instVarNames size = aClass superclass instSize
		ifFalse: [^true].
	aClass class instSize - aClass class instVarNames size
		= aClass class superclass instSize
		ifFalse: [^true].
	^aClass installer shouldRecomputeBehavior]

{#category : #accessing}
BeeModule >> newVersion [
	^self version isNumber
		ifTrue: [self version + 1]
		ifFalse: [Timestamp current iso8601]]

{#category : #copying}
BeeModule >> postCopy [
	super postCopy.
	changes := changes copy]

{#category : #printing}
BeeModule >> printOn: aStream [
	aStream nextPutAll: self name]

{#category : #utils}
BeeModule >> readClassesFrom: aStream [
	| answer line symbol cls meta |
	answer := IdentitySet new.
	[aStream atEnd] whileFalse: [
		[
			line := aStream nextLine.
			line isEmpty] whileTrue.
		meta := line endsWith: ' class'.
		symbol := Symbol findInterned: (line upTo: $ ).
		cls := (symbol notNil and: [Smalltalk includesKey: symbol])
			ifTrue: [Smalltalk at: symbol].
		cls notNil ifTrue: [meta ifTrue: [cls := cls class]].
		answer add: cls instanceClass.
		line := aStream skipSeparators; nextLine.
		[
			line := aStream nextLine trimBlanks.
			line isEmpty] whileFalse].
	^answer]

{#category : #utils}
BeeModule >> readCompiledMethodsFrom: aStream [
	| answer line symbol cls selector cm meta |
	answer := IdentitySet new.
	[aStream atEnd] whileFalse: [
		[
			line := aStream nextLine.
			line isEmpty] whileTrue.
		meta := line endsWith: ' class'.
		symbol := Symbol findInterned: (line upTo: $ ).
		cls := (symbol notNil and: [Smalltalk includesKey: symbol])
			ifTrue: [Smalltalk at: symbol].
		cls notNil ifTrue: [meta ifTrue: [cls := cls class]].
		line := aStream skipSeparators; nextLine.
		[
			cls notNil ifTrue: [
				selector := Symbol findInterned: line.
				selector notNil ifTrue: [
					cm := cls compiledMethodAt: selector.
					cm notNil ifTrue: [answer add: cm]]].
			line := aStream nextLine trimBlanks.
			line isEmpty] whileFalse].
	^answer]

{#category : #accessing}
BeeModule >> referenceString [
	^'(' , self class name , ' getProject: ' , name storeString , ')']

{#category : #utils}
BeeModule >> rejectMethodsListedIn: aStream [
	| reject methods exClasses |
	exClasses := self readClassesFrom: aStream.
	aStream reset.
	reject := self readCompiledMethodsFrom: aStream.
	methods := IdentitySet new.
	self classes copy removeAll: exClasses; inspect.
	self classes do: [:cls | 
		methods addAll: cls methodDictionary values.
		methods addAll: cls class methodDictionary values].
	reject do: [:cm | methods remove: cm].
	^methods]

{#category : #accessing}
BeeModule >> rejectsSelector: selector class: aClass [
	^self excludedMethods includes: aClass -> selector]

{#category : #accessing}
BeeModule >> rename: aString [
	self name: aString]

{#category : #utils}
BeeModule >> renameClassVar: aString of: aClass to: anotherString [
	ClassVarRename on: aClass from: aString to: anotherString]

{#category : #private}
BeeModule >> renameFiles [
	| directory names current |
	directory := filename parentPath asDirectory.
	current := filename withoutExtension entityName.
	current asFilename != name asFilename ifTrue: [
		names := directory fileNamesMatching: current , '.*'.
		names
			do: [:n | directory \ n renameFileTo: name , '.' , n asFilename extension].
		filename := directory \ name withExtension: filename extension]]

{#category : #utils}
BeeModule >> renameInstVar: varName of: aClass to: aString [
	InstVarRename on: aClass from: varName to: aString]

{#category : #accessing}
BeeModule >> renameTo: aString [
	name = aString ifTrue: [^self].
	name notNil ifTrue: [self class forgetProject: self].
	name := aString.
	self class addProject: self.
	self renameFiles]

{#category : #services}
BeeModule >> repairExclusions [
	self allSimpleProjects do: #repairExclusions]

{#category : #accessing}
BeeModule >> resolveClass: aString [
	^aString notNil ifTrue: [Smalltalk classNamed: aString]]

{#category : #'file in/out'}
BeeModule >> saveProject [
	self saveProjectWithVersion: self newVersion]

{#category : #'file in/out'}
BeeModule >> saveProjectWithVersion: v [
	| fn file |
	self version: v.
	CursorPointer execute showWhile: [
		changes notNil ifTrue: [changes saveChanges].
		changes release.
		fn := self directory asFilename \ self fileName
			withExtension: self class projectFileOutFileExtension.
		file := fn newFile.
		[self fileOutOn: file] ensure: [file close].
		SourceStore current
			log: '"*** saved project ' , self directory asString
				, self fileName asString
				, ' on: '
				, Timestamp current printString
				, ' ***"']]

{#category : #accessing}
BeeModule >> sendersOf: selector [
	| stream |
	stream := #() writeStream.
	CursorPointer showBusyWhile: [
		self allMethods
			select: [:cm | cm sends: selector]
			thenDo: [:cm | stream nextPut: cm]].
	^stream contents sortBy: #printString]

{#category : #utils}
BeeModule >> testClasses [
	| sorted |
	sorted := self classes asOrderedCollection sortBy: #name.
	^sorted
		select: [:class | (class inheritsFrom: TestCase) andNot: [class isAbstract]]]

{#category : #utils}
BeeModule >> testDeclarations [
	| classes methods |
	classes := self testClasses collect: #name.
	methods := self testExtensions
		collect: [:cm | cm classBinding name , ' -> ' , cm selector storeString].
	^classes , methods]

{#category : #utils}
BeeModule >> testExtensions [
	^self extensions select: [:m | 
		(m classBinding inheritsFrom: TestCase)
			and: [TestCase isTestSelector: m selector]]]

{#category : #testing}
BeeModule >> unresolvedReferences [
	^unresolved]

{#category : #'file in/out'}
BeeModule >> updateDefinitions [
	self subclassResponsibility]

{#category : #queries}
BeeModule >> usedPools [
	| pools |
	pools := Set new.
	self classes do: [:class | 
		class sharedPools
			reject: [:d | self globals includes: d]
			thenDo: [:d | pools add: d]].
	^pools]

{#category : #utils}
BeeModule >> validate [
	self checkBehaviorStructures.
	self allMethods
		select: [:m | m isCurrentVersion and: [m referencesUnresolvedExternal]]
		thenDo: [:m | 
			m recompile.
			m currentVersion referencesUnresolvedExternal
				ifTrue: [self ASSERT: false]]]

{#category : #'file in/out'}
BeeModule >> writeDefinitionOn: aStream [
	aStream
		nextPutAll: self class name doubleQuoted;
		cr;
		nextPutAll: 'self';
		crtab;
		nextPutAll: 'name: ';
		nextUTF8Put: self name storeString;
		nextPut: $;;
		crtab;
		nextPutAll: 'version: ';
		nextPutAll: self version storeString;
		nextPut: $;;
		crtab;
		nextPutAll: 'description: ';
		nextUTF8Put: self description storeString;
		nextPut: $;;
		crtab;
		nextPutAll: 'yourself.!';
		cr;
		cr]

