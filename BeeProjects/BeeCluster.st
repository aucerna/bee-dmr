"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #BeeCluster, 
	#superclass : #BeeModule, 
	#instVars : [
		'parts', 
		'description', 
		'version', 
		'loadAction', 
		'unloadAction', 
		'prerequisites'
	], 
	#classVars : [
		'SystemCluster'
	], 
	#category : #BeeProjects
}

{#category : #accessing}
BeeCluster class >> systemCluster [
	SystemCluster isNil ifTrue: [
		SystemCluster := self basicNew initialize.
		SystemCluster name: 'System Cluster'].
	^SystemCluster]

{#category : #'adding / removing'}
BeeCluster >> add: beeModule [
	| p |
	p := beeModule isString
		ifTrue: [BeeModule getPreInstalledProject: beeModule]
		ifFalse: [beeModule].
	^self add: p before: nil]

{#category : #'adding / removing'}
BeeCluster >> add: aBeeModule before: nextProject [
	self == aBeeModule ifTrue: [^self].
	(self includesProject: aBeeModule) ifTrue: [self forgetProject: aBeeModule].
	nextProject isNil
		ifTrue: [parts add: aBeeModule]
		ifFalse: [parts add: aBeeModule before: nextProject].
	self isSystemCluster ifFalse: [SystemCluster forget: aBeeModule].
	aBeeModule partsDo: [:p | self forget: p]]

{#category : #changes}
BeeCluster >> addChange: changeRecord [
	changes addChange: changeRecord]

{#category : #'adding / removing'}
BeeCluster >> addClass: aClass [
	self selectPart ifNotNil: [:p | p changes addClass: aClass]]

{#category : #'adding / removing'}
BeeCluster >> addMethod: aCompiledMethod [
	self selectPart ifNotNil: [:p | p changes addMethod: aCompiledMethod]]

{#category : #'adding / removing'}
BeeCluster >> addNewCluster: aBeeCluster [
	| module |
	module := aBeeCluster isString
		ifTrue: [BeeCluster new name: aBeeCluster]
		ifFalse: [aBeeCluster].
	^self add: module before: nil]

{#category : #'adding / removing'}
BeeCluster >> addNewProject: aBeeProject [
	| part |
	part := aBeeProject isString
		ifTrue: [BeeProject new name: aBeeProject]
		ifFalse: [aBeeProject].
	^self add: part before: nil]

{#category : #'adding / removing'}
BeeCluster >> addPoolDictionary: aSymbol [
	self selectPart ifNotNil: [:p | p addPoolDictionary: aSymbol]]

{#category : #'adding / removing'}
BeeCluster >> addPoolVariable: anObject [
	self ASSERT: false.
	self selectPart ifNotNil: [:p | p addPoolVariable: anObject]]

{#category : #accessing}
BeeCluster >> addPrerequisite: aFilename [
	prerequisites isNil ifTrue: [self initializePrerequisites].
	prerequisites add: aFilename.
	(aFilename asFilename hasExtension: 'bnd')
		ifTrue: [SmalltalkSession current loadSegments: aFilename]
		ifFalse: [
			(SmalltalkSession current isBound: aFilename)
				ifFalse: [SmalltalkSession current load: aFilename]]]

{#category : #changes}
BeeCluster >> addProject: aBeeModule [
	changes addProject: aBeeModule]

{#category : #accessing}
BeeCluster >> addProject: aBeeModule before: anotherBeeModule [
	self clusters do: [:c | c forgetProject: aBeeModule].
	changes addProject: aBeeModule before: anotherBeeModule]

{#category : #changes}
BeeCluster >> allChanges [
	| merged |
	merged := changes allChanges.
	parts do: [:p | merged := merged merge: p changes allChanges].
	^merged]

{#category : #accessing}
BeeCluster >> allInnerClusters [
	^parts gather: [:p | 
		p isCluster
			ifTrue: [Array with: p withAll: p allInnerClusters]
			ifFalse: [#()]]]

{#category : #enumerating}
BeeCluster >> allMethodsDo: aBlock [
	self simpleProjectsDo: [:p | p allMethodsDo: aBlock]]

{#category : #accessing}
BeeCluster >> allPrerequisites [
	| all |
	all := OrderedCollection new.
	prerequisites notNil ifTrue: [
		prerequisites
			collect: #asLowercase
			thenDo: [:s | (all includes: s) ifFalse: [all add: s]]].
	self partsDo: [:p | 
		p localPrerequisites
			collect: #asLowercase
			thenDo: [:s | (all includes: s) ifFalse: [all add: s]]].
	all copy do: [:n | 
		(BeeModule named: n) ifNotNil: [:p | 
			p localPrerequisites
				collect: #asLowercase
				thenDo: [:s | (all includes: s) ifFalse: [all add: s before: n]]]].
	^all]

{#category : #utils}
BeeCluster >> allSimpleProjects [
	^parts composeAll: [:p | p allSimpleProjects]]

{#category : #accessing}
BeeCluster >> bslDirectory [
	^super bslDirectory \ 'clusters\']

{#category : #saving}
BeeCluster >> buildBNDFile: oneLibrary [
	oneLibrary ifTrue: [self buildSingleBND] ifFalse: [self buildMultipleBND]]

{#category : #saving}
BeeCluster >> buildCodeSegment [
	super buildCodeSegment.
	self buildBNDFile: true]

{#category : #saving}
BeeCluster >> buildMultipleBND [
	| fn file all |
	fn := self filename withExtension: '.bnd'.
	file := fn newFile.
	all := self localPrerequisites
		collect: #asLowercase
		in: OrderedCollection new.
	[
		all
			reject: [:req | self includesProject: (BeeModule named: req)]
			thenDo: [:req | 
				(req asFilename hasExtension: 'bnd') ifTrue: [file nextPut: $@].
				file nextUTF8Put: req; cr].
		parts do: [:p | 
			p isCluster ifTrue: [file nextPut: $@] ifFalse: [
				p allPrerequisites
					reject: [:req | (all includes: req)
						or: [self includesProject: (BeeModule named: req)]]
					thenDo: [:req | 
						all add: req.
						(req asFilename hasExtension: 'bnd') ifTrue: [file nextPut: $@].
						file nextUTF8Put: req; cr]].
			file nextUTF8Put: p name.
			p isCluster ifTrue: [
				file nextPutAll: '.bnd'.
				p buildMultipleBND].
			file cr]]
		ensure: [file close]]

{#category : #saving}
BeeCluster >> buildProjectLibraries [
	| selection |
	selection := self chooseProjects.
	selection isNil ifTrue: [^self].
	self buildProjectLibraries: selection]

{#category : #saving}
BeeCluster >> buildProjectLibraries: projects [
	projects do: [:project | project buildCodeSegment].
	changes currentChanges notEmpty ifTrue: [self saveProject]]

{#category : #saving}
BeeCluster >> buildSingleBND [
	| fn file |
	fn := self bslDirectory asFilename \ self fileName withExtension: '.bnd'.
	file := fn newFile.
	[
		self allPrerequisites
			reject: [:req | parts
				anySatisfy: [:p | p name equalsCaseInsensitive: req]]
			thenDo: [:req | 
				(req asFilename hasExtension: 'bnd') ifTrue: [file nextPut: $@].
				file nextUTF8Put: req; cr].
		file nextUTF8Put: self name]
		ensure: [file close]]

{#category : #accessing}
BeeCluster >> changes [
	^self]

{#category : #changes}
BeeCluster >> changesDo: aBlock [
	parts do: [:part | part changesDo: aBlock]]

{#category : #changes}
BeeCluster >> changesStartingAt: aDate [
	| commands |
	commands := changes changesStartingAt: aDate.
	parts
		do: [:p | commands := commands
			mergeWith: (p changes changesStartingAt: aDate)].
	^commands]

{#category : #utils}
BeeCluster >> check [
	| issues |
	self validate.
	issues := Dictionary new.
	self checkDuplicatedClassesOn: issues; checkIssuesOn: issues.
	^issues]

{#category : #utils}
BeeCluster >> checkDuplicatedClassesOn: aDictionary [
	| all projects |
	all := self allSimpleProjects.
	self classes do: [:c | 
		projects := c projects select: [:p | all includes: p].
		projects size > 1 ifTrue: [aDictionary at: c put: projects]]]

{#category : #utils}
BeeCluster >> checkIssuesOn: aDictionary [
	| serializer projects base |
	serializer := Smalltalk serializer
		context: #buildingLibrary;
		messageHandler: [:a :b | ].
	projects := self allSimpleProjects asArray.
	base := 'base.bnd' asFilename asFile contents lines
		collect: [:line | | fn |
			fn := line readStream upTo: $;; reset; upTo: $@.
			fn trimBlanks asLowercase]
		thenSelect: #notEmpty.
	projects withIndexDo: [:project :index | | issues |
		issues := aDictionary at: project ifAbsentPut: [OrderedCollection new].
		project
			addIssuesTo: issues
			using: serializer
			index: index
			within: projects
			base: base]]

{#category : #accessing}
BeeCluster >> classes [
	^(self allSimpleProjects composeAll: [:p | p classes]) asSet]

{#category : #changes}
BeeCluster >> classify: selector in: aClass under: category [
	| project |
	project := self projectFor: selector in: aClass.
	^project changes classify: selector in: aClass under: category]

{#category : #'composite accessing'}
BeeCluster >> clusterFor: aBeeModule [
	(parts includes: aBeeModule) ifTrue: [^self].
	parts do: [:part | | cluster |
		cluster := part clusterFor: aBeeModule.
		cluster notNil ifTrue: [^cluster]].
	^nil]

{#category : #changes}
BeeCluster >> compile: aString in: aClass category: aSymbol [
	| selector project |
	selector := Compiler parseSelector: aString.
	project := self projectFor: selector in: aClass.
	^project changes compile: aString in: aClass category: aSymbol]

{#category : #changes}
BeeCluster >> compile: aString notifying: textPane in: aClass [
	| selector project |
	selector := Compiler new parseSelector: aString.
	project := self projectFor: selector in: aClass.
	^project changes compile: aString notifying: textPane in: aClass]

{#category : #changes}
BeeCluster >> compile: aString
notifying: textPane
in: aClass
category: aSymbol [
	| selector project |
	selector := Compiler new parseSelector: aString.
	project := self projectFor: selector in: aClass.
	^project changes
		compile: aString
		notifying: textPane
		in: aClass
		category: aSymbol]

{#category : #utils}
BeeCluster >> compiledMethodFromSignature: anAssociation [
	| answer |
	^(self includesMethodWithSignature: anAssociation) ifTrue: [
		parts reverseDo: [:each | 
			(answer := each compiledMethodFromSignature: anAssociation) notNil
				ifTrue: [^answer]].
		self removeObsoleteMethods.
		^nil]]

{#category : #changes}
BeeCluster >> compressChangesUntil: aDate [
	parts do: [:p | p compressChangesUntil: aDate]]

{#category : #private}
BeeCluster >> computeUnresolved [
	parts do: #computeUnresolved.
	unresolved := parts gather: #unresolvedReferences in: Set new]

{#category : #accessing}
BeeCluster >> conflictingMethods [
	^parts inject: Set new into: [:result :p | result addAll: p conflictingMethods; yourself]]

{#category : #changes}
BeeCluster >> currentChanges [
	| answer set |
	answer := changes currentChanges.
	set := IdentitySet new.
	self partsDo: [:p | 
		(set includes: p) ifFalse: [
			answer := answer merge: p localChanges.
			set add: p]].
	^answer]

{#category : #changes}
BeeCluster >> defineClass: definitionString notifying: textPane [
	| project class |
	class := [(Compiler parse: definitionString) statements first arguments first]
		on: Error
		do: [].
	class := Smalltalk at: class value ifAbsent: [].
	class isNil ifTrue: [
		class := [(Compiler parse: definitionString) statements first receiver]
			on: Error
			do: []].
	project := class isNil
		ifTrue: [self class default]
		ifFalse: [self projectFor: nil in: class].
	^project changes defineClass: definitionString notifying: textPane]

{#category : #changes}
BeeCluster >> defineClassWithInstaller: classInstaller [
	| project |
	project := self projectFor: nil in: (Smalltalk at: classInstaller className).
	^project changes defineClassWithInstaller: classInstaller]

{#category : #changes}
BeeCluster >> defineCompiledMethod: method sourceCode: sourceCode [
	| project |
	project := self projectFor: method selector in: method classBinding.
	project changes defineCompiledMethod: method sourceCode: sourceCode]

{#category : #accessing}
BeeCluster >> description [
	^description]

{#category : #accessing}
BeeCluster >> description: aString [
	description := aString]

{#category : #accessing}
BeeCluster >> excludedMethods [
	| m projects |
	m := parts composeAll: [:p | p excludedMethods].
	projects := self allSimpleProjects.
	^m select: [:s | | cm |
		cm := CompiledMethod fromSignature: s.
		cm isNil or: [(cm projects intersection: projects) isEmpty]]]

{#category : #saving}
BeeCluster >> fileOutOn: aStream [
	super fileOutOn: aStream.
	aStream cr.
	parts do: [:p | | change |
		change := ProjectAddition new.
		change
			childProject: p name;
			project: self;
			fileOutOn: aStream completeHeader: false.
		aStream cr].
	aStream cr]

{#category : #'adding / removing'}
BeeCluster >> forget: aBeeModule [
	parts remove: aBeeModule ifAbsent: [^self].
	aBeeModule clusters isEmpty ifTrue: [SystemCluster add: aBeeModule]]

{#category : #changes}
BeeCluster >> forgetClass: aClass [
	| project |
	project := self projectFor: nil in: aClass.
	^project changes forgetClass: aClass]

{#category : #'composite accessing'}
BeeCluster >> forgetProject: aBeeModule [
	(parts includes: aBeeModule)
		ifTrue: [changes forgetProject: aBeeModule]
		ifFalse: [parts do: [:cluster | cluster forgetProject: aBeeModule]]]

{#category : #accessing}
BeeCluster >> globals [
	| answer |
	answer := Set new.
	parts do: [:p | answer addAll: p globals].
	^answer]

{#category : #testing}
BeeCluster >> hasBeenModified [
	^self hasChanges or: [parts anySatisfy: #hasBeenModified]]

{#category : #testing}
BeeCluster >> hasChanges [
	^changes currentChanges notEmpty]

{#category : #testing}
BeeCluster >> hasModifiedSelectorsInAnyOf: classCollection [
	self
		simpleProjectsDo: [:p | (p changes
			hasModifiedSelectorsInAnyOf: classCollection)
			ifTrue: [^true]].
	^false]

{#category : #testing}
BeeCluster >> hasOverriddenVersions [
	^parts anySatisfy: [:p | p hasOverriddenVersions]]

{#category : #testing}
BeeCluster >> includes: aBeeModule [
	^parts includes: aBeeModule]

{#category : #changes}
BeeCluster >> includesChange: changeRecord [
	^changes includesChange: changeRecord]

{#category : #testing}
BeeCluster >> includesClass: aClass [
	| c |
	c := aClass isSpecies ifTrue: [aClass instanceClass] ifFalse: [aClass].
	^parts anySatisfy: [:sp | sp includesClass: c]]

{#category : #testing}
BeeCluster >> includesMethod: aCompiledMethod [
	^parts anySatisfy: [:p | p includesMethod: aCompiledMethod]]

{#category : #testing}
BeeCluster >> includesMethodWithSignature: aString [
	^parts anySatisfy: [:p | p includesMethodWithSignature: aString]]

{#category : #initialization}
BeeCluster >> initialize [
	super initialize.
	self initializeParts]

{#category : #initialization}
BeeCluster >> initializeParts [
	parts := OrderedCollection new]

{#category : #initialization}
BeeCluster >> initializePrerequisites [
	prerequisites := OrderedCollection new]

{#category : #testing}
BeeCluster >> isCluster [
	^true]

{#category : #testing}
BeeCluster >> isSystemCluster [
	^self == self class systemCluster]

{#category : #reading}
BeeCluster >> load [
	self postInstall.]

{#category : #accessing}
BeeCluster >> loadAction [
	^loadAction]

{#category : #accessing}
BeeCluster >> loadAction: action [
	loadAction := action]

{#category : #accessing}
BeeCluster >> loadActionSequence [
	| actions |
	actions := OrderedCollection new.
	parts
		do: [:p | p loadActionSequence ifNotNil: [:b | actions addAll: b asArray]].
	loadAction notNil ifTrue: [actions add: loadAction].
	^ActionSequence withAll: actions]

{#category : #accessing}
BeeCluster >> localPrerequisites [
	^prerequisites ifNil: #()]

{#category : #accessing}
BeeCluster >> methods [
	^(self allSimpleProjects composeAll: [:p | p methods]) asSet]

{#category : #saving}
BeeCluster >> modifiedClusters [
	| all |
	all := Array with: self withAll: self allInnerClusters.
	^all asSet asArray sort select: #hasChanges]

{#category : #saving}
BeeCluster >> modifiedProjects [
	^self allSimpleProjects asSet asArray sort select: #hasBeenModified]

{#category : #inquiries}
BeeCluster >> modifiedSelectorsIn: aClass [
	^self modifiedSelectorsInAnyOf: {aClass}]

{#category : #inquiries}
BeeCluster >> modifiedSelectorsInAnyOf: classCollection [
	| modified |
	modified := IdentitySet new.
	self
		simpleProjectsDo: [:p | modified
			addAll: (p changes modifiedSelectorsInAnyOf: classCollection)].
	^modified]

{#category : #accessing}
BeeCluster >> moveProject: module1 before: module2 [
	parts
		remove: module1;
		add: module1 before: module2]

{#category : #accessing}
BeeCluster >> name: aString [
	super name: aString.
	changes isNil ifTrue: [self initializeChanges]]

{#category : #changes}
BeeCluster >> newCluster: aString [
	^changes newCluster: aString]

{#category : #changes}
BeeCluster >> newProject: aString [
	^changes newProject: aString]

{#category : #accessing}
BeeCluster >> overriddenVersions [
	| answer |
	answer := Dictionary new.
	parts
		do: [:p | p hasOverriddenVersions
			ifTrue: [answer addAll: p overriddenVersions]].
	^answer
		select: [:cm | (self compiledMethodFromSignature: cm signature)
			~~ cm currentVersion]]

{#category : #accessing}
BeeCluster >> parts [
	^parts]

{#category : #enumerating}
BeeCluster >> partsDo: aBlock [
	parts do: [:p |
		aBlock value: p.
		p partsDo: aBlock]]

{#category : #accessing}
BeeCluster >> poolVariables [
	| variables |
	variables := Set new.
	parts do: [:p | variables addAll: p poolVariables].
	^variables]

{#category : #copying}
BeeCluster >> postCopy [
	super postCopy.
	prerequisites := prerequisites copy]

{#category : #reading}
BeeCluster >> postInstall [
	parts do: [:p | p postInstall].
	self updateDefinitions]

{#category : #accessing}
BeeCluster >> precondition: aString [
	self addPrerequisite: aString]

{#category : #reading}
BeeCluster >> preInstall [
]

{#category : #accessing}
BeeCluster >> prerequisites [
	^prerequisites ifNil: #()]

{#category : #changes}
BeeCluster >> project [
	^self]

{#category : #filein/out}
BeeCluster >> readFrom: aStream [
	Compiler evaluate: aStream nextChunk for: self.
	ProjectChanges fileInFrom: aStream for: self.
	self initializeChanges]

{#category : #changes}
BeeCluster >> reinstallClass: aClass [
	| project |
	project := self projectFor: nil in: aClass.
	^project changes reinstallClass: aClass]

{#category : #testing}
BeeCluster >> rejectsSelector: selector class: aClass [
	| cm |
	(parts anySatisfy: [:p | p rejectsSelector: selector class: aClass])
		ifFalse: [^false].
	cm := aClass >> selector.
	^(cm projects intersection: self allSimpleProjects) isEmpty]

{#category : #accessing}
BeeCluster >> remove: aBeeModule [
	parts remove: aBeeModule ifAbsent: nil]

{#category : #changes}
BeeCluster >> removeCategory: categorySymbol in: aClass [
	| project |
	project := self projectFor: nil in: aClass.
	^project changes removeCategory: categorySymbol in: aClass]

{#category : #'adding / removing'}
BeeCluster >> removeClass: aClass [
	| project |
	project := self projectFor: nil in: aClass.
	^project changes removeClass: aClass]

{#category : #utils}
BeeCluster >> removeObsoleteMethods [
	parts do: #removeObsoleteMethods]

{#category : #accessing}
BeeCluster >> removePrerequisite: aString [
	prerequisites remove: aString ifAbsent: []]

{#category : #changes}
BeeCluster >> removeSelector: selector from: aClass [
	| project |
	project := self projectFor: selector in: aClass.
	^project changes removeSelector: selector from: aClass]

{#category : #changes}
BeeCluster >> renameCategory: category inClass: aClass to: newName [
	| project |
	project := self projectFor: nil in: aClass.
	^project changes renameCategory: category inClass: aClass to: newName]

{#category : #changes}
BeeCluster >> renameProject: smalltalkProject to: newName [
	changes renameProject: smalltalkProject to: newName]

{#category : #changes}
BeeCluster >> renameSelector: aSymbol as: anotherSymbol [
	aSymbol == anotherSymbol ifTrue: [^self].
	self allSimpleProjects
		do: [:p | p changes renameSelector: aSymbol as: anotherSymbol]]

{#category : #saving}
BeeCluster >> saveAll [
	self saveProject.
	parts do: [:each | each saveProject]]

{#category : #'file in/out'}
BeeCluster >> saveProject [
	super saveProject.
	self buildBNDFile: false]

{#category : #enumerating}
BeeCluster >> simpleProjectsDo: aBlock [
	parts do: [:cluster | cluster simpleProjectsDo: aBlock]]

{#category : #accessing}
BeeCluster >> smalltalkExpressions [
	| answer |
	answer := Set new.
	parts do: [:p | answer addAll: p smalltalkExpressions].
	self ASSERT: answer isEmpty.
	^answer]

{#category : #accessing}
BeeCluster >> unload [
	BeeModule forgetProject: self.
	parts reverseDo: [:p | p unload]]

{#category : #accessing}
BeeCluster >> unload: project [
	parts remove: project.
	project unload]

{#category : #accessing}
BeeCluster >> unloadAction [
	^unloadAction]

{#category : #accessing}
BeeCluster >> unloadAction: action [
	unloadAction := action]

{#category : #accessing}
BeeCluster >> unloadActionSequence [
	| actions |
	actions := OrderedCollection new.
	parts
		do: [:p | p unloadActionSequence
			ifNotNil: [:b | actions addAll: b asArray]].
	unloadAction notNil ifTrue: [actions add: unloadAction].
	^ActionSequence withAll: actions]

{#category : #accessing}
BeeCluster >> updateDefinitions [
	loadAction notNil
		ifTrue: [loadAction := self messageFromString: loadAction].
	unloadAction notNil
		ifTrue: [unloadAction := self messageFromString: unloadAction].
	loadAction evaluate]

{#category : #accessing}
BeeCluster >> version [
	version isNil ifTrue: [version := Timestamp current iso8601].
	^version]

{#category : #accessing}
BeeCluster >> version: anObject [
	version := anObject]

{#category : #testing}
BeeCluster >> wasModifiedCategory: category in: aClass [
	^parts
		anySatisfy: [:p | p changes wasModifiedCategory: category in: aClass]]

{#category : #testing}
BeeCluster >> wasModifiedClass: aClass [
	^parts anySatisfy: [:p | p changes wasModifiedClass: aClass]]

{#category : #testing}
BeeCluster >> wasModifiedSelector: aSymbol in: aClass [
	^parts anySatisfy: [:p | 
		(p includesSelector: aSymbol class: aClass)
			and: [p changes wasModifiedSelector: aSymbol in: aClass]]]

{#category : #testing}
BeeCluster >> wasOverridden [
	^parts anySatisfy: #wasOverridden]

{#category : #testing}
BeeCluster >> wasOverridden: aClass [
	^parts anySatisfy: [:p | p wasOverridden: aClass]]

{#category : #testing}
BeeCluster >> wasOverridden: aSymbol in: aClass [
	^parts anySatisfy: [:p | p wasOverridden: aSymbol in: aClass]]

