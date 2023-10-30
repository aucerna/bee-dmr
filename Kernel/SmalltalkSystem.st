"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #SmalltalkSystem,
	#superclass : #Object,
	#instVars : [
		'globals',
		'memory',
		'resources',
		'properties',
		'finalizer',
		'eventHandlers',
		'registeredEvents',
		'externals',
		'eventDispatcher',
		'nativizer',
		'session'
	],
	#classVars : [
		'Implementors',
		'Senders'
	],
	#category : #Kernel
}

{ #category : #accessing }
SmalltalkSystem >> add: anAssociation [
	self ASSERT: Smalltalk !== self.
	^globals add: anAssociation
]

{ #category : #accessing }
SmalltalkSystem >> associationAt: aSymbol [
	^globals associationAt: aSymbol
]

{ #category : #accessing }
SmalltalkSystem >> associationAt: aSymbol ifAbsent: aBlock [
	^globals associationAt: aSymbol ifAbsent: aBlock
]

{ #category : #accessing }
SmalltalkSystem >> associationClass [
	^globals associationClass
]

{ #category : #accessing }
SmalltalkSystem >> associationsDo: aBlock [
	globals associationsDo: aBlock
]

{ #category : #accessing }
SmalltalkSystem >> at: aSymbol [
	^globals at: aSymbol
]

{ #category : #accessing }
SmalltalkSystem >> at: aSymbol ifAbsent: aBlock [
	^globals at: aSymbol ifAbsent: aBlock
]

{ #category : #accessing }
SmalltalkSystem >> at: aSymbol ifAbsentPut: aBlock [
	^self at: aSymbol ifAbsent: [self at: aSymbol put: aBlock value]
]

{ #category : #accessing }
SmalltalkSystem >> at: aSymbol put: anObject [
	| key global |
	key := aSymbol asSymbol.
	global := globals at: key ifAbsent: nil.
	global isClass ifTrue: [
		anObject == global ifTrue: [^self].
		global symbol == key
			ifTrue: [^self error: 'Overriding classes is not allowed']].
	globals at: key put: anObject.
	self justDefined: aSymbol.
	^anObject
]

{ #category : #private }
SmalltalkSystem >> basicAdd: anAssociation [
	globals basicAdd: anAssociation.
	self justDefined: anAssociation key.
	^anAssociation
]

{ #category : #private }
SmalltalkSystem >> basicAt: aSymbol put: anObject [
	| assoc |
	assoc := Association key: aSymbol value: anObject.
	self basicAdd: assoc.
	^anObject
]

{ #category : #removing }
SmalltalkSystem >> basicRemoveKey: key ifAbsent: aBlock [
	^globals removeKey: key ifAbsent: aBlock
]

{ #category : #services }
SmalltalkSystem >> beep [
	^self operatingSystem beep
]

{ #category : #services }
SmalltalkSystem >> bindEventTable: aDictionary to: anObject [
	aDictionary isNil
		ifTrue: [eventHandlers removeKey: anObject ifAbsent: []]
		ifFalse: [eventHandlers at: anObject put: aDictionary]
]

{ #category : #initializing }
SmalltalkSystem >> bootstrapInitialize [
	CompiledBlock initializeFormatFlags.
	CompiledMethod initializeFormatFlags.
	SendSite initializeFormatFlags.
	Species initializeFormatFlags.
	ProtoObject initializeConstants; initializeBitMasks.
	Character initializeCharacters; initializeCharacterConstants.
	Closure initializeIndexes.
	ExternalMemory initializeConstants.
	Float initializeConstants.
	HashTable initializeConstants; initializeSizes.
	HashTablePolicy initializeEmptySlot.
	HashedCollection initializePolicies.
	LargeInteger initializeBase.
	LargeNegativeInteger initializeConstants.
	SmallInteger initializeConstants.
	StarToken initializeCurrent.
	Unicode allSubclasses do: [:c | c initializeCurrent]
]

{ #category : #testing }
SmalltalkSystem >> canOpenBacktrace [
	^true
]

{ #category : #services }
SmalltalkSystem >> classesUsingPool: aPoolDictionary [
	| string |
	string := aPoolDictionary name.
	^ProtoObject allSubclasses
		select: [:cls | cls sharedPools includes: string]
]

{ #category : #accessing }
SmalltalkSystem >> classNamed: aString [
	| name tag meta global |
	name := aString.
	tag := ' class'.
	meta := aString endsWith: tag.
	meta ifTrue: [name := name allButLast: tag size].
	global := self at: name asSymbol ifAbsent: [^nil].
	^global isSpecies ifTrue: [meta ifTrue: [global class] ifFalse: [global]]
]

{ #category : #'startup/shutdown' }
SmalltalkSystem >> closeExternalResources [
	resources do: [:object | object sessionShutdown].
	externals do: [:object | object sessionShutdown]
]

{ #category : #services }
SmalltalkSystem >> collectGarbage [
	memory collect
]

{ #category : #accessing }
SmalltalkSystem >> ensurePropertyTableFor: anObject [
	^properties at: anObject ifAbsentPut: [IdentityDictionary new]
]

{ #category : #'startup/shutdown' }
SmalltalkSystem >> ephemeronsDo: aBlock [
	resources ephemeronsDo: aBlock.
	finalizer ephemeronsDo: aBlock.
	properties ephemeronsDo: aBlock
]

{ #category : #accessing }
SmalltalkSystem >> eventDispatcher [
	^eventDispatcher
]

{ #category : #accessing }
SmalltalkSystem >> eventDispatcher: anEventDispatcher [
	eventDispatcher := anEventDispatcher
]

{ #category : #services }
SmalltalkSystem >> eventTableFor: anObject [
	^eventHandlers at: anObject ifAbsent: nil
]

{ #category : #'startup/shutdown' }
SmalltalkSystem >> exit [
	session exit
]

{ #category : #accessing }
SmalltalkSystem >> finalizer [
	^finalizer
]

{ #category : #services }
SmalltalkSystem >> flushDispatchCaches [
]

{ #category : #accessing }
SmalltalkSystem >> globals [
	^globals
]

{ #category : #accessing }
SmalltalkSystem >> hasDebugger [
	^false
]

{ #category : #testing }
SmalltalkSystem >> hasDebuggerTool [
	^false
]

{ #category : #services }
SmalltalkSystem >> ignoreHalts: aBoolean [
	Halt ignoreSignals: aBoolean.
	AssertionFailure ignoreSignals: aBoolean
]

{ #category : #services }
SmalltalkSystem >> ignoreOSMessagesWhile: aBlock [
	^eventDispatcher isNil
		ifTrue: [aBlock value]
		ifFalse: [aBlock evaluateAtomically]
]

{ #category : #testing }
SmalltalkSystem >> includes: anObject [
	^globals includes: anObject
]

{ #category : #testing }
SmalltalkSystem >> includesKey: aSymbol [
	^globals includesKey: aSymbol
]

{ #category : #initialization }
SmalltalkSystem >> initialize [
	globals := Dictionary new.
	self initializeDMRMemory
]

{ #category : #initialization }
SmalltalkSystem >> initializeDMRMemory [
	| kernel |
	kernel := GCSpace new.
	kernel name: 'Kernel'.
	memory := Memory new
		addKernelSpace: kernel;
		fromSpace: kernel;
		eden: kernel
]

{ #category : #initialization }
SmalltalkSystem >> initializeEvents [
	eventHandlers := WeakIdentityDictionary new.
	registeredEvents := WeakIdentityDictionary new
]

{ #category : #initialization }
SmalltalkSystem >> initializeExternals [
	externals := OrderedCollection new
]

{ #category : #initialization }
SmalltalkSystem >> initializeFinalizationBlocks [
	"
	done in a separate stage because storing closures
	in the kernel library is not supported yet
	"
	finalizer finalizer: [:object | object finalize].
	resources finalizer: [:object | object finalize]
]

{ #category : #initialization }
SmalltalkSystem >> initializeFinalizer [
	finalizer := WeakIdentitySet new asCriticalSet
]

{ #category : #initialization }
SmalltalkSystem >> initializeProperties [
	properties := WeakIdentityDictionary new
]

{ #category : #initialization }
SmalltalkSystem >> initializeResources [
	resources := WeakIdentitySet new
]

{ #category : #initialization }
SmalltalkSystem >> initializeWeakRegistries [
	self
		initializeFinalizer;
		initializeResources;
		initializeProperties;
		initializeEvents
]

{ #category : #testing }
SmalltalkSystem >> isDMR [
	^true
]

{ #category : #private }
SmalltalkSystem >> justDefined: aSymbol [
	| s unresolved |
	s := aSymbol asString.
	unresolved := UnresolvedObjects
		select: [:u | (u isKindOf: SymbolicReference) and: [u canBeSolvedWith: s]].
	unresolved do: [:u | | object |
		object := u bind.
		object isNil ifTrue: [^self].
		object == u ifFalse: [
			UnresolvedObjects remove: u.
			u become: object]]
]

{ #category : #accessing }
SmalltalkSystem >> keyAtValue: anObject [
	^globals keyAtValue: anObject
]

{ #category : #accessing }
SmalltalkSystem >> keys [
	^globals keys
]

{ #category : #accessing }
SmalltalkSystem >> memory [
	^memory
]

{ #category : #accessing }
SmalltalkSystem >> messageQueue [
	^eventDispatcher messageQueue
]

{ #category : #accessing }
SmalltalkSystem >> nameOfGlobal: anObject [
	^globals keyAtValue: anObject
]

{ #category : #accessing }
SmalltalkSystem >> nativizer [
	^nativizer
]

{ #category : #accessing }
SmalltalkSystem >> nativizer: anObject [
	nativizer := anObject
]

{ #category : #accessing }
SmalltalkSystem >> poolDictionaries [
	^globals associations
		select: [:assoc | assoc value class == PoolDictionary]
]

{ #category : #services }
SmalltalkSystem >> primitiveNamed: aString [
	^NamedPrimitives at: aString ifAbsent: nil
]

{ #category : #printing }
SmalltalkSystem >> printOn: aStream [
	self == Smalltalk
		ifTrue: [aStream nextPutAll: 'Smalltalk']
		ifFalse: [super printOn: aStream]
]

{ #category : #accessing }
SmalltalkSystem >> processAllMessages [
	eventDispatcher processAllMessages
]

{ #category : #accessing }
SmalltalkSystem >> properties [
	^properties
]

{ #category : #accessing }
SmalltalkSystem >> propertiesFor: anObject [
	^properties at: anObject ifAbsent: nil
]

{ #category : #accessing }
SmalltalkSystem >> put: aCompiledMethod at: aSymbol in: aMethodDictionary [
	| original |
	original := aMethodDictionary at: aSymbol ifAbsent: nil.
	(aMethodDictionary shouldNativizeBeforeInstalling: original)
		ifTrue: [aCompiledMethod prepareForExecution].
	self put: aCompiledMethod withoutFlushing: aSymbol in: aMethodDictionary.
	original
		ifNil: [aSymbol flushFromCachesWith: aCompiledMethod classBinding]
		ifNotNil: [original flushFromCaches].
	^aCompiledMethod beNotFlushed
]

{ #category : #accessing }
SmalltalkSystem >> put: aCompiledMethod withoutFlushing: aSymbol in: aMethodDictionary [
	aCompiledMethod canBeInstalled
		ifTrue: [aMethodDictionary basicAt: aSymbol put: aCompiledMethod]
]

{ #category : #services }
SmalltalkSystem >> recursiveBacktrace: aString [
	Smalltalk exit
]

{ #category : #accessing }
SmalltalkSystem >> register: aSet for: aClass [
	registeredEvents at: aClass put: aSet
]

{ #category : #accessing }
SmalltalkSystem >> registeredEventsFor: aClass [
	^registeredEvents at: aClass ifAbsent: nil
]

{ #category : #services }
SmalltalkSystem >> registerExternal: externalObject [
	externals add: externalObject
]

{ #category : #initialization }
SmalltalkSystem >> rehashWeakRegistries [
	eventHandlers rehash.
	resources rehash.
	finalizer rehash.
	properties rehash.
	registeredEvents rehash
]

{ #category : #accessing }
SmalltalkSystem >> releasePropertiesFor: anObject [
	properties removeKey: anObject ifAbsent: nil
]

{ #category : #accessing }
SmalltalkSystem >> removeClass: aClass [
	aClass isDeleted ifTrue: [^self].
	self devenv forgetClass: aClass.
	globals basicRemoveKey: aClass symbol ifAbsent: nil.
	aClass class superclass isNil
		ifFalse: [aClass class superclass removeSubclass: aClass class].
	aClass superclass isNil ifFalse: [aClass superclass removeSubclass: aClass].
	aClass beDeleted
]

{ #category : #removing }
SmalltalkSystem >> removeKey: key [
	^globals removeKey: key
]

{ #category : #accessing }
SmalltalkSystem >> removeKey: aSymbol from: aMethodDictionary ifAbsent: aBlock [
	| cm symbol |
	symbol := aSymbol asSymbol.
	self isRuntime ifFalse: [
		cm := aMethodDictionary at: symbol ifAbsent: [^aBlock value].
		self updateWithoutMethod: cm].
	^aMethodDictionary basicRemoveKey: symbol ifAbsent: aBlock
]

{ #category : #removing }
SmalltalkSystem >> removeKey: aSymbol ifAbsent: aBlock [
	| selector global |
	selector := aSymbol asSymbol.
	global := globals at: selector ifAbsent: [^aBlock value].
	(global isClass and: [global symbol == selector]) ifTrue: [
		global allInstances notEmpty
			ifTrue: [^self error: 'The class being removed still has instances'].
		global delete.
		^selector].
	^globals basicRemoveKey: selector ifAbsent: aBlock
]

{ #category : #updating }
SmalltalkSystem >> renameClass: aClass to: aSymbol [
	| symbol token assoc |
	symbol := aSymbol asSymbol.
	(globals includesKey: symbol)
		ifTrue: [self error: 'the global ' , symbol , ' already exists'].
	token := aClass symbol.
	assoc := globals associationAt: token.
	globals basicRemoveKey: token ifAbsent: nil.
	assoc key: symbol.
	globals basicAdd: assoc.
	aClass name: symbol
]

{ #category : #accessing }
SmalltalkSystem >> resourceRegistry [
	^resources
]

{ #category : #'binding libraries' }
SmalltalkSystem >> segmentLoaded: anImageSegment [
	
]

{ #category : #'binding libraries' }
SmalltalkSystem >> segmentUnloaded: anImageSegment [
	
]

{ #category : #enumerating }
SmalltalkSystem >> select: aBlock thenDo: anotherBlock [
	globals select: aBlock thenDo: anotherBlock
]

{ #category : #services }
SmalltalkSystem >> showBacktraceOf: aProcess label: aString [
	| writer logger |
	writer := '' writeStream.
	aProcess
		backtraceOn: writer
		maxLevels: 100
		stopWhen: [:cm | cm isDoit]
		filtered: false
		arguments: false.
	logger := self at: #Transcript ifAbsent: nil.
	logger isNil
		ifTrue: [session logError: writer contents]
		ifFalse: [logger nextPutAll: aString; cr; nextPutAll: writer contents].
	aProcess isResumable ifTrue: [aProcess performDeferred: #resume]
]

{ #category : #'startup/shutdown' }
SmalltalkSystem >> startUp [
	self
		initializeTranscript;
		initializeFinalizationBlocks;
		ephemeronsDo: [:e | e activate];
		initializeExternals
]

{ #category : #'startup/shutdown' }
SmalltalkSystem >> startUpResources [
	resources do: [:object | object sessionStartup]
]

{ #category : #accessing }
SmalltalkSystem >> transcript [
	^globals at: #Transcript
]

{ #category : #accessing }
SmalltalkSystem >> version [
	^'0.1.1'
]

