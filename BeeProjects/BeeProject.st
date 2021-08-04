"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #BeeProject, 
	#superclass : #BeeModule, 
	#instVars : [
		'spec', 
		'exclusions', 
		'overridden'
	], 
	#classVars : [
		'Current'
	], 
	#category : #BeeProjects
}

{#category : #inspecting}
BeeProject class >> aspects [
	^#(#prerequisites)]

{#category : #accessing}
BeeProject class >> current [
	^Current ifNil: [Current := self new name: 'Default']]

{#category : #accessing}
BeeProject class >> current: aBeeProject [
	Current := aBeeProject]

{#category : #accessing}
BeeProject class >> hasDefaultProject [
	^Current notNil]

{#category : #'adding / removing'}
BeeProject >> addClass: aClass [
	| methods |
	self classes add: aClass.
	BeeModule class: aClass addedTo: self.
	methods := spec methods.
	self extensions do: [:m | | id |
		m classBinding instanceClass == aClass ifTrue: [
			id := m signature.
			methods remove: id ifAbsent: [].
			overridden removeKey: id ifAbsent: nil]].
	spec methods: methods]

{#category : #'adding / removing'}
BeeProject >> addClassDefinition: aClassDefinition [
	self addClass: aClassDefinition resolveClass instanceClass.]

{#category : #'adding / removing'}
BeeProject >> addGlobal: aSymbol [
	spec addGlobalNamed: aSymbol]

{#category : #services}
BeeProject >> addIssuesTo: issues
using: serializer
index: index
within: collection
base: base [
	serializer dump: self livingObjects on: #[] writeStream.
	serializer objectShapes & self externalMethodsClasses do: [:class | | projects |
		projects := self class projectsForClass: class.
		(projects notEmpty and: [
			projects
				noneSatisfy: [:p | (base includes: p name asLowercase)
					or: [(collection indexOf: p) <= index]]])
			ifTrue: [issues add: class -> projects]].
	self classes do: [:class | | projects |
		projects := self class projectsForClass: class superclass.
		(projects notEmpty and: [
			projects
				noneSatisfy: [:one | (base includes: one name asLowercase)
					or: [(collection indexOf: one) <= index]]])
			ifTrue: [issues add: class -> projects]]]

{#category : #'adding / removing'}
BeeProject >> addMethod: aCompiledMethod [
	| m |
	m := aCompiledMethod isString
		ifTrue: [aCompiledMethod]
		ifFalse: [aCompiledMethod signature].
	self methods add: m]

{#category : #'adding / removing'}
BeeProject >> addMethodDefinition: aMethodDefinition [
	| class |
	class := aMethodDefinition resolveClass.
	class isNil ifTrue: [^self].
	self disableCode: [
		(self wasOverridden: aMethodDefinition selector in: class)
			ifTrue: [overridden removeKey: aMethodDefinition signature]].
	(self includesClass: class)
		ifTrue: [self removeExclusion: aMethodDefinition signature]
		ifFalse: [self methods add: aMethodDefinition signature]]

{#category : #'adding / removing'}
BeeProject >> addOverridden: aCompiledMethod [
	| class |
	class := aCompiledMethod classBinding ifNil: [^self].
	self overriddenVersions
		at: aCompiledMethod signature
		put: aCompiledMethod asOverridden.
	(self includesClass: class)
		ifTrue: [self removeExclusion: aCompiledMethod signature]]

{#category : #'adding / removing'}
BeeProject >> addPoolDictionary: aSymbol [
	self changes addPoolDictionary: aSymbol]

{#category : #'adding / removing'}
BeeProject >> addPoolVariable: anObject [
	spec addPoolVariable: anObject]

{#category : #'adding / removing'}
BeeProject >> addPrerequisite: aString [
	spec addPrerequisite: aString]

{#category : #'adding / removing'}
BeeProject >> addVariableNamed: aString inPoolNamed: globalSymbol [
	self addPoolVariable: {globalSymbol. aString}]

{#category : #queries}
BeeProject >> allCurrentMethods [
	| methods |
	methods := Set new.
	methods addAll: self currentCompiledMethods.
	self classes do: [:cls | 
		methods
			addAll: cls methodDictionary values;
			addAll: cls class methodDictionary values].
	exclusions notNil
		ifTrue: [methods
			removeAllSuchThat: [:m | exclusions includes: m signature]].
	^methods]

{#category : #queries}
BeeProject >> allMethods [
	| methods |
	methods := Set new.
	self classes do: [:cls | 
		methods
			addAll: (cls methodDictionary values collect: #signature);
			addAll: (cls class methodDictionary values collect: #signature)].
	methods addAll: self methods.
	exclusions notNil ifTrue: [methods removeAll: exclusions ifAbsent: nil].
	^methods
		collect: [:s | self compiledMethodFromSignature: s]
		thenSelect: [:cm | cm notNil]]

{#category : #queries}
BeeProject >> allMethodsDo: aBlock [
	self classes do: [:cls | 
		cls methodDictionary do: [:m | 
			(exclusions isNil orNot: [exclusions includes: m signature])
				ifTrue: [aBlock evaluateWith: m]]].
	^self extensions do: aBlock]

{#category : #queries}
BeeProject >> allPrerequisites [
	| prerequisites |
	prerequisites := self prerequisites collect: #asLowercase.
	prerequisites copy do: [:n | 
		(BeeModule named: n) ifNotNil: [:p | 
			p allPrerequisites
				do: [:s | (prerequisites includes: s)
					ifFalse: [prerequisites add: s before: n]]]].
	^prerequisites]

{#category : #'composite compatibility'}
BeeProject >> allSimpleProjects [
	^{self}]

{#category : #accessing}
BeeProject >> annotations [
	^nil]

{#category : #'file in/out'}
BeeProject >> basicFileOutOn: aStream [
	self fileOutSettingsOn: aStream.
	super basicFileOutOn: aStream.
	self
		fileOutPoolVariablesOn: aStream;
		fileOutGlobalsOn: aStream;
		fileOutClassesOn: aStream;
		fileOutExtensionsOn: aStream;
		fileOutExclusionsOn: aStream;
		fileOutInitializationsOn: aStream]

{#category : #'file in/out'}
BeeProject >> buildCodeSegment [
	self updateOverriddenVersions.
	super buildCodeSegment.
	self saveProjectWithVersion: self version]

{#category : #'file in/out'}
BeeProject >> buildCodeSegmentOn: aCodeSegmentBuilder [
	self removeObsoleteMethods.
	super buildCodeSegmentOn: aCodeSegmentBuilder.
	self isDevelopmentOnly ifTrue: [aCodeSegmentBuilder tagAsDevelopmentOnly].
	self storesNativeCode ifTrue: [aCodeSegmentBuilder storeNativeCode]]

{#category : #'composite compatibility'}
BeeProject >> buildProjectLibraries [
	self buildCodeSegment]

{#category : #accessing}
BeeProject >> changes [
	changes isNil ifTrue: [self initializeChanges].
	^changes]

{#category : #accessing}
BeeProject >> changes: aProjectChanges [
	changes := aProjectChanges]

{#category : #accessing}
BeeProject >> class: oldName wasRenamedTo: newName [
	]

{#category : #accessing}
BeeProject >> classDefinitionFor: className [
	| def class |
	def := ClassDefinition new.
	class := self classes detect: [:c | c name = className] ifNone: nil.
	class notNil ifTrue: [def class: class; project: self] ifFalse: [
		class := Smalltalk at: className asSymbol ifAbsent: nil.
		class isNil ifTrue: [def className: className] ifFalse: [def class: class]].
	^def]

{#category : #accessing}
BeeProject >> classes [
	^spec classes]

{#category : #accessing}
BeeProject >> classes: aClassCollection [
	spec classes: aClassCollection]

{#category : #'composite compatibility'}
BeeProject >> clusterFor: dummy [
	^nil]

{#category : #services}
BeeProject >> compileAll [
	self allMethods select: #isCurrentVersion thenDo: [:cm | cm recompile].
	self recompileOverridden]

{#category : #utils}
BeeProject >> compressChanges [
	self changes compressChanges]

{#category : #utils}
BeeProject >> compressChangesUntil: aDate [
	self changes compressChangesUntil: aDate]

{#category : #overwrite}
BeeProject >> conflictingMethods [
	overridden ifNil: [^OrderedCollection new].
	^overridden asOrderedCollection]

{#category : #accessing}
BeeProject >> description [
	^spec description]

{#category : #accessing}
BeeProject >> description: aString [
	spec description: aString]

{#category : #accessing}
BeeProject >> developmentOnly: aBoolean [
	spec settingAt: 'developmentOnly' put: aBoolean]

{#category : #accessing}
BeeProject >> excludedMethods [
	exclusions isNil ifTrue: [self initializeExclusions].
	^exclusions]

{#category : #'adding / removing'}
BeeProject >> excludeMethod: signature [
	| m |
	m := (signature isString or: [signature isAssociation])
		ifTrue: [signature]
		ifFalse: [signature signature].
	self excludedMethods add: m]

{#category : #'file in/out'}
BeeProject >> fileOutExclusionsOn: aStream [
	exclusions size = 0 ifTrue: [^self].
	aStream
		cr;
		nextChunkPut: '"**** Exclusions ****"';
		cr;
		cr.
	exclusions asArray
		sortBy: #printString;
		do: [:s | 
			self fileOutExclusion: s on: aStream.
			aStream cr]]

{#category : #'file in/out'}
BeeProject >> fileOutSurrogate [
	^self copy release]

{#category : #'adding / removing'}
BeeProject >> forgetOverriddenVersion: aCompiledMethod [
	overridden isNil
		ifFalse: [overridden removeKey: aCompiledMethod signature ifAbsent: nil]]

{#category : #'composite compatibility'}
BeeProject >> forgetProject: dummy [
	]

{#category : #accessing}
BeeProject >> globals [
	^spec globals]

{#category : #accessing}
BeeProject >> globals: aCollectionOfSymbols [
	spec globals: aCollectionOfSymbols]

{#category : #testing}
BeeProject >> hasBeenModified [
	| classes upper |
	self changes currentChanges notEmpty ifTrue: [^true].
	classes := self methods collect: [:assoc | assoc key] in: Set new.
	upper := self classes collect: #superclass in: Set new.
	upper removeAllSuchThat: [:c | c isNil or: [c project = self]].
	classes addAll: upper.
	^classes anySatisfy: [:c | c project wasModifiedClassShape: c]]

{#category : #testing}
BeeProject >> hasOverriddenVersions [
	^overridden isEmptyOrNil not]

{#category : #'composite compatibility'}
BeeProject >> includes: dummy [
	^false]

{#category : #initialization}
BeeProject >> initialize [
	spec := BeeModuleSpec new.
	spec useGlobalNames.
	super initialize]

{#category : #initialization}
BeeProject >> initializeExclusions [
	exclusions := Set new]

{#category : #testing}
BeeProject >> isDevelopmentOnly [
	^self settingAt: 'developmentOnly']

{#category : #testing}
BeeProject >> isEmpty [
	^spec isEmpty]

{#category : #overwrite}
BeeProject >> kernelUpdate [
	| original signatures additions |
	original := CompiledMethod allSubinstances select: [:cm | cm isInKernel].
	signatures := original collect: [:cm | cm signature].
	additions := self allCurrentMethods
		select: [:cm | (signatures includes: cm signature) not].
	additions do: [:cm | self excludeMethod: cm].
	original
		select: [:cm | | current |
			current := cm currentVersion.
			current notNil
				and: [cm !== current]
				and: [cm bytecodes != current bytecodes
					or: [cm literals != current literals]]]
		thenDo: [:cm | self overridden: cm]]

{#category : #accessing}
BeeProject >> lastChange [
	^changes currentChanges last]

{#category : #accessing}
BeeProject >> lastChangePerformance [
	| current classes class |
	current := changes currentChanges.
	current isEmpty ifFalse: [^current last lastPerformance].
	classes := self methods collect: [:assoc | assoc key].
	class := classes asSet detect: [:c | c project wasModifiedClassShape: c].
	^class project lastChangePerformance]

{#category : #accessing}
BeeProject >> loadAction [
	^spec loadAction]

{#category : #accessing}
BeeProject >> loadAction: action [
	spec loadAction: action]

{#category : #accessing}
BeeProject >> loadActionSequence [
	^spec loadActionSequence]

{#category : #accessing}
BeeProject >> localPrerequisites [
	^self prerequisites]

{#category : #'adding / removing'}
BeeProject >> mergeWith: otherProject [
	| classes methods |
	spec mergeWith: otherProject.
	classes := spec classes.
	methods := spec methods.
	otherProject methods do: [:m | | cm |
		cm := CompiledMethod fromSignature: m.
		(classes includes: cm classBinding instanceClass)
			ifTrue: [self removeExclusion: m]
			ifFalse: [methods add: m]].
	self excludedMethods addAll: otherProject excludedMethods.
	self overriddenVersions
		removeAllSuchThat: [:m | otherProject includesMethod: m];
		addAll: otherProject overriddenVersions]

{#category : #'adding / removing'}
BeeProject >> methodRemoved: methodSignature [
	(self classes includes: methodSignature key instanceClass)
		ifTrue: [self removeExclusion: methodSignature].
	self removeMethod: methodSignature]

{#category : #accessing}
BeeProject >> methods [
	^spec methods]

{#category : #queries}
BeeProject >> methodsOf: aClass [
	| methods |
	(self includesClass: aClass) ifFalse: [
		^self methods
			collect: [:s | | cm |
				cm := CompiledMethod fromSignature: s.
				cm classBinding == aClass
					ifTrue: [self compiledMethodFor: cm selector in: aClass]]
			thenSelect: [:cm | cm notNil]].
	methods := aClass methodDictionary values collect: #signature.
	exclusions notNil ifTrue: [methods removeAll: exclusions ifAbsent: nil].
	^methods
		collect: [:s | self compiledMethodFromSignature: s]
		thenSelect: [:cm | cm notNil]]

{#category : #overwrite}
BeeProject >> overridden: aCompiledMethod [
	self overriddenVersions
		at: aCompiledMethod signature
		ifAbsentPut: [aCompiledMethod asOverridden]]

{#category : #overwrite}
BeeProject >> overriddenVersions [
	^overridden ifNil: [overridden := Dictionary new]]

{#category : #'composite compatibility'}
BeeProject >> parts [
	^#()]

{#category : #enumerating}
BeeProject >> partsDo: aBlock [
]

{#category : #accessing}
BeeProject >> poolVariables [
	^spec poolVariables]

{#category : #copying}
BeeProject >> postCopy [
	super postCopy.
	spec := spec copy.
	exclusions := exclusions copy.
	overridden := overridden copy]

{#category : #'file in/out'}
BeeProject >> postInstall [
	| old methods |
	old := self methods.
	methods := Set new: self methods size.
	old
		do: [:m | (m isKindOf: ChangeRecord)
			ifTrue: [m perform]
			ifFalse: [methods add: m]].
	spec methods: methods.
	self updateDefinitions.
	(self propertyAt: #fromFileout) ifNotNil: [:fn | | cs |
		spec loadAction notNil ifTrue: [spec loadAction perform].
		cs := Changeset fromPath: fn.
		cs isFullyLoaded ifFalse: [cs rejectUpToDate browse].
		self removeProperty: #fromFileout]]

{#category : #accessing}
BeeProject >> prerequisites [
	^spec prerequisites]

{#category : #'file in/out'}
BeeProject >> readFromFile [
	| fn |
	fn := self filename withExtension: self class projectFileOutFileExtension.
	self readFromPath: fn]

{#category : #'file in/out'}
BeeProject >> readFromImageSegment: bsl [
	self
		version: bsl version;
		fullName: bsl filename;
		description: bsl description.
	bsl settings ifNotNil: [:s | spec settings: s copy].
	bsl classes do: [:class | spec addClass: class].
	bsl extensions do: [:m | spec addMethod: m signature].
	self
		loadAction: (bsl loadAction
			ifNotNil: [:action | action asActionSequence compressed]);
		unloadAction: (bsl unloadAction
			ifNotNil: [:action | action asActionSequence compressed]).
	bsl metadata poolVariables do: [:p | self addPoolVariable: p].
	bsl metadata globals do: [:p | self addGlobal: p asSymbol].
	bsl metadata prerequisites do: [:s | self addPrerequisite: s].
	self updateOverriddenFrom: bsl; computeUnresolved]

{#category : #'file in/out'}
BeeProject >> readFromPath: aFilename [
	| file |
	file := aFilename asFilename asFile readStream.
	self ASSERT: file nextLine trimBlanks unquoted = self class name.
	[self readFrom: file] ensure: [file close]]

{#category : #services}
BeeProject >> recompileOverridden [
	overridden isEmptyOrNil ifTrue: [^self].
	overridden do: [:cm | | change result |
		change := OverriddenMethodDefinition fromCompiledMethod: cm in: self.
		result := change basicPerform.
		result setSameSourceAs: cm]]

{#category : #'file in/out'}
BeeProject >> release [
	overridden := nil.]

{#category : #'adding / removing'}
BeeProject >> removeClass: aClass [
	self classes remove: aClass ifAbsent: [].
	BeeModule class: aClass forgottenFrom: self.
	overridden isNil ifTrue: [^self].
	overridden asArray
		select: [:m | m classBinding instanceClass == aClass]
		thenDo: [:m | overridden removeKey: m signature]]

{#category : #'adding / removing'}
BeeProject >> removeExclusion: methodSignature [
	self ASSERT: methodSignature isAssociation.
	self excludedMethods remove: methodSignature ifAbsent: nil]

{#category : #'adding / removing'}
BeeProject >> removeGlobal: anObject [
	self globals remove: anObject]

{#category : #'adding / removing'}
BeeProject >> removeMethod: methodSignature [
	| cm |
	self methods remove: methodSignature ifAbsent: [].
	cm := CompiledMethod fromSignature: methodSignature.
	(cm notNil and: [self classes includes: cm classBinding instanceClass])
		ifTrue: [self excludeMethod: methodSignature].
	overridden isNil
		ifFalse: [overridden removeKey: methodSignature ifAbsent: nil]]

{#category : #utils}
BeeProject >> removeObsoleteExtensions [
	spec removeObsoleteExtensions]

{#category : #utils}
BeeProject >> removeObsoleteMethods [
	| cm methods |
	methods := self methods select: [:m | 
		cm := CompiledMethod fromSignature: m.
		cm isNil
			ifTrue: [overridden notNil and: [overridden includesKey: m]]
			ifFalse: [(self includesClass: m key) not]].
	spec methods: methods]

{#category : #'adding / removing'}
BeeProject >> removePrerequisite: aString [
	spec removePrerequisite: aString]

{#category : #utils}
BeeProject >> renameClass: oldName to: newName in: methodString [
	^spec renameClass: oldName to: newName in: methodString]

{#category : #services}
BeeProject >> renameExclusionsOf: aSymbol to: anotherSymbol [
	exclusions isNil ifTrue: [^self].
	exclusions do: [:s | s value == aSymbol ifTrue: [s value: anotherSymbol]]]

{#category : #utils}
BeeProject >> renameSelector: aSymbol as: anotherSymbol [
	| all implementors tree source new senders |
	aSymbol == anotherSymbol ifTrue: [^self].
	self ASSERT: aSymbol arity = anotherSymbol arity.
	all := (self allCurrentMethods
		select: [:cm | self includesCompiledMethod: cm])
		& self overriddenVersions asOrderedCollection.
	implementors := all select: [:cm | cm selector == aSymbol].
	new := implementors collect: [:cm | | m |
		tree := cm parseTree.
		tree selectorNode value: anotherSymbol.
		source := tree format.
		m := (cm isCurrentVersion
			orNot: [cm classBinding includesSelector: anotherSymbol])
			ifTrue: [self changes
				compile: source
				in: cm classBinding
				category: cm category]
			ifFalse: [self updateOverriddenMethod: cm withSource: source].
		all remove: cm.
		m].
	self renameExclusionsOf: aSymbol to: anotherSymbol.
	senders := all & new select: [:cm | cm isSenderOf: aSymbol].
	senders do: [:cm | 
		tree := cm parseTree.
		tree replaceSelector: aSymbol with: anotherSymbol.
		source := tree format.
		cm isCurrentVersion
			ifTrue: [self changes compile: source notifying: nil in: cm classBinding]
			ifFalse: [self updateOverriddenMethod: cm withSource: source]].
	implementors do: [:cm | 
		cm isCurrentVersion
			ifTrue: [self changes removeSelector: aSymbol from: cm classBinding]
			ifFalse: [self changes forgetMethod: cm]].
	^senders & new]

{#category : #services}
BeeProject >> renameVariable: v to: aString in: aCompiledMethod [
	| ast var code change |
	ast := aCompiledMethod parseTree.
	var := ast variableNamed: v.
	var isNil ifTrue: [^self].
	code := aCompiledMethod sourceCode.
	var sourceIntervals
		reverseDo: [:s | code := code replace: v at: s start with: aString].
	change := aCompiledMethod asChange sourceCode: code; project: self.
	change perform]

{#category : #services}
BeeProject >> repairExclusions [
	| classes |
	exclusions isNil ifTrue: [^self].
	classes := spec classes.
	exclusions removeAllSuchThat: [:s | | cm |
		cm := CompiledMethod fromSignature: s.
		cm isNil orNot: [classes includes: cm classBinding instanceClass]]]

{#category : #'file in/out'}
BeeProject >> repairHistory [
	changes repairHistory.
	self buildCodeSegment]

{#category : #services}
BeeProject >> replaceClassName: aSymbol with: aString [
	(exclusions ifNil: [#()]) & spec extensions do: [:m | 
		m key isSpecies
			ifFalse: [m key token = aSymbol asString ifTrue: [m key token: aString]]]]

{#category : #services}
BeeProject >> replaceClassName: aSymbol with: aString in: aCollection [
	spec replaceClassName: aSymbol with: aString in: aCollection]

{#category : #services}
BeeProject >> setAnnotationsTo: aMethodDefinition [
	]

{#category : #accessing}
BeeProject >> settingAt: aSymbol [
	^spec settingAt: aSymbol]

{#category : #testing}
BeeProject >> settingAt: key put: value [
	spec settingAt: key put: value]

{#category : #accessing}
BeeProject >> settings [
	^spec settings]

{#category : #accessing}
BeeProject >> sharedPools [
	^self globals
		select: [:g | (Smalltalk at: g ifAbsent: nil) class == PoolDictionary]]

{#category : #enumerating}
BeeProject >> simpleProjectsDo: aBlock [
	aBlock value: self]

{#category : #accessing}
BeeProject >> spec [
	^spec]

{#category : #accessing}
BeeProject >> storeNativeCode: aBoolean [
	spec settingAt: 'storeNativeCode' put: aBoolean]

{#category : #overwrite}
BeeProject >> storeOverriddenMethod: aCompiledMethod [
	| m |
	m := aCompiledMethod asOverridden project: self.
	self overriddenVersions at: aCompiledMethod signature put: m]

{#category : #testing}
BeeProject >> storesNativeCode [
	^self settingAt: 'storeNativeCode']

{#category : #accessing}
BeeProject >> tagAsDevelopmentOnly [
	self settingAt: 'developmentOnly' put: true]

{#category : #accessing}
BeeProject >> unloadAction [
	^spec unloadAction]

{#category : #accessing}
BeeProject >> unloadAction: action [
	spec unloadAction: action]

{#category : #accessing}
BeeProject >> unloadActionSequence [
	^spec unloadActionSequence]

{#category : #accessing}
BeeProject >> updateClasses [
	self classes rehash]

{#category : #accessing}
BeeProject >> updateDefinitions [
	spec bindDefinitions.
	exclusions notNil ifTrue: [
		exclusions := exclusions
			collect: [:s | s isString
				ifTrue: [CompiledMethod signatureFrom: s]
				ifFalse: [s]]]]

{#category : #overwrite}
BeeProject >> updateOverriddenFrom: sll [
	self isKernelProject ifTrue: [^self kernelUpdate].
	self allCurrentMethods do: [:m | | current |
		current := sll compiledMethodFor: m.
		current isNil
			ifTrue: [self excludeMethod: m]
			ifFalse: [current == m currentVersion ifFalse: [self overridden: current]]]]

{#category : #overwrite}
BeeProject >> updateOverriddenMethod: cm withSource: source [
	^changes recompileOverriddenMethod: cm withSource: source]

{#category : #overwrite}
BeeProject >> updateOverriddenVersions [
	overridden isNil ifTrue: [^self].
	overridden values
		select: [:cm | | current |
			current := cm currentVersion.
			current isNil or: [current equals: cm]]
		thenDo: [:cm | overridden removeKey: cm signature ifAbsent: nil]]

{#category : #accessing}
BeeProject >> version [
	^spec version]

{#category : #accessing}
BeeProject >> version: aString [
	spec version: aString]

{#category : #testing}
BeeProject >> wasModifiedClassShape: aClass [
	^self changes wasModifiedClassShape: aClass]

{#category : #testing}
BeeProject >> wasOverridden [
	^self conflictingMethods notEmpty]

{#category : #testing}
BeeProject >> wasOverridden: aClass [
	^(self methodsOverriddenIn: aClass) notEmpty]

{#category : #testing}
BeeProject >> wasOverridden: aSymbol in: aClass [
	^overridden notNil and: [overridden includesKey: aClass -> aSymbol]]

