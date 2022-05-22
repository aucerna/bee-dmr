Class {
	#name : #NativizationEnvironment,
	#superclass : #Object,
	#instVars : [
		'platform',
		'optimizedMethods',
		'invokedMethods',
		'inlinedMethods',
		'messageLinker',
		'globals',
		'writeBarrier',
		'safepointCheck',
		'cachedNativizer',
		'busy'
	],
	#category : #'Powerlang-Core-Nativization'
}

{ #category : #accessing }
NativizationEnvironment class >> globalNames [
	^#(Lookup LookupSuper WriteBarrier Safepoint SmallIntegerBehavior Invoke DebuggableLookup DebuggableLookupSuper)
]

{ #category : #accessing }
NativizationEnvironment class >> indexOfGlobal: aSymbol [
	^self globalNames
		indexOf: aSymbol
		ifAbsent: [self error: 'global not found']
]

{ #category : #accessing }
NativizationEnvironment class >> inlinedMethods [
	| map |
	map := {
		(ProtoObject -> #(#objectAtValid: #objectAtValid:put: #behavior #class #primitiveAt: #_cachedLookup: #_cachedLookup:in:)).
		(Object -> #(#byteAtValid: #byteAtValid:put: #basicObjectIndexOf: #at:put:)).
		(Species -> #(#instSize #_instancesAreArrayed #_instancesHavePointers #memory #instanceBehavior #primitiveNew #primitiveNew:)).
		(CompiledMethod -> #(#prepareForExecution #isNativized #nativeCode #blockCount #literalIndexFrom:)).
		(CompiledBlock -> #(#argumentCount #blockNumber #blockCode #method)).
		(NativeCode -> #(#code)).
		(GCSpace -> #(#commitedLimit #nextFree #nextFree:)).
		(CharacterArray -> #(#characterAtValid:))}.
	^self undermethods , (self methodSubset: map)
]

{ #category : #accessing }
NativizationEnvironment class >> invokedMethods [
	| map |
	map := {
		(ProtoObject -> #(behavior class primitiveAt: #initializeExtended:contentSize:)).
		(Object -> #(#_replaceFrom:to:with:)).
		(Species -> #(#allocate:size: instanceBehavior _instancesAreArrayed _instancesHavePointers #nil:slotsOf: memory primitiveNewBytes: primitiveNewPointers: #zero:bytesOf:))}.
	^self undermethods , (self methodSubset: map)
]

{ #category : #accessing }
NativizationEnvironment class >> methodSubset: aDictionary [
	| result |
	result := OrderedCollection new.
	aDictionary keysAndValuesDo: [ :species :selectors | 
		selectors collect: [:sel | | m | species >> sel ifNil: [self ASSERT: false] ] into: result].
	^result
]

{ #category : #accessing }
NativizationEnvironment class >> optimizedMethods [
	| map |
	map := {
		(ProtoObject -> #(behavior class primitiveAt: #primitiveAt:put: #initializeExtended:contentSize:)).
		(Object -> #(at: #at:put: basicByteAt: #basicByteAt:put: byteAtValid: #byteAtValid:put:
					 basicObjectAt: #basicObjectAt:put: #replaceBytesForwardFrom:to:with:startingAt:)).
		(SendSite -> #(_dispatchOn: #_dispatchOn:startingAt: _dispatchDebuggableOn: #_dispatchDebuggableOn:startingAt:)).
		(Species -> #(#allocate:size: primitiveNew primitiveNew: instSize primitiveNewBytes: primitiveNewPointers:)).
		('Float class' -> #(new)).
		(CompiledBlock -> #(argumentCount arity blockCode method)).
		(Closure -> #(value value: #value:value:)).
		(CompiledMethod -> #(blockCount isNativized)).
		(String -> #(at: #at:put: byteAt: #byteAt:put:)).
		(GCSpace -> #(lockedAllocateIfPossible: lockedAllocateUnsafe: shallowCopy:)).
		(Memory -> #(shallowCopy:))}.
	^self undermethods , (self methodSubset: map)
]

{ #category : #accessing }
NativizationEnvironment >> abi [
	^platform abi
]

{ #category : #accessing }
NativizationEnvironment >> addLinker: aLinker [
	messageLinker add: aLinker
]

{ #category : #initialization }
NativizationEnvironment >> completeInitialization [
	cachedNativizer := self newExpressionNativizer 
]

{ #category : #accessing }
NativizationEnvironment >> globalNamed: aSymbol [
	| index |
	index := self class indexOfGlobal: aSymbol.
	^globals at: index
]

{ #category : #accessing }
NativizationEnvironment >> globalNamed: aSymbol put: anObject [
	| index |
	index := self class indexOfGlobal: aSymbol.
	globals at: index put: anObject
]

{ #category : #accessing }
NativizationEnvironment >> globals [
	^globals
]

{ #category : #accessing }
NativizationEnvironment >> globals: anArray [
	globals := anArray
]

{ #category : #initialization }
NativizationEnvironment >> initialize [
	busy := false.
	optimizedMethods := OrderedCollection new.
	invokedMethods := OrderedCollection new.
	inlinedMethods := OrderedCollection new.
	messageLinker := CompositeMessageLinker new.
	messageLinker add: InlineMessageLinker new.
	globals := Array new: self class globalNames size.
	self
		initializeGlobals;
		inlinedMethods: self class inlinedMethods;
		invokedMethods: self class invokedMethods;
		optimizedMethods: self class optimizedMethods
]

{ #category : #bootstrapping }
NativizationEnvironment >> initializeForBootstrap [
	self
		nativizeInvoke;
		nativizeWriteBarrier;
		nativizeLookup;
		setupMessageLinkers.
]

{ #category : #bootstrapping }
NativizationEnvironment >> initializeGlobals [
	| items |
	self globalNamed: #SmallIntegerBehavior put: SmallInteger instanceBehavior.
	items := Dictionary newFromPairs: {
		#Lookup .           (NativeCode new code: 'Lookup Placeholder').
		#LookupSuper .      (NativeCode new code: 'LookupSuper Placeholder').
		#DebuggableLookup . (NativeCode new code: 'DebuggableLookup placeholder').
		#DebuggableLookupSuper. (NativeCode new code: 'DebuggableLookupSuper placholder').
		#Invoke .           (NativeCode new code: 'Invoke placeholder').
		#Safepoint .        (NativeCode new code: 'SafepointCheck placeholder').
		#WriteBarrier .     (NativeCode new code: 'Write Barrier placeholder')}.
	items
		keysAndValuesDo: [ :key :placeholder | self globalNamed: key put: placeholder ]
]

{ #category : #bootstrapping }
NativizationEnvironment >> initializeOptimizedMethods [
	
]

{ #category : #accessing }
NativizationEnvironment >> inlinedMethods [
	^inlinedMethods
]

{ #category : #accessing }
NativizationEnvironment >> inlinedMethods: aCollection [
	inlinedMethods := aCollection
]

{ #category : #accessing }
NativizationEnvironment >> invokeStub [
	| index |
	index := self class indexOfGlobal: #Invoke.
	^(globals at: index) code
]

{ #category : #accessing }
NativizationEnvironment >> invokedMethods [
	^invokedMethods
]

{ #category : #accessing }
NativizationEnvironment >> invokedMethods: aCollection [
	invokedMethods := aCollection asOrderedCollection 
]

{ #category : #accessing }
NativizationEnvironment >> lookup [
	| index |
	index := self class indexOfGlobal: #Lookup.
	^globals at: index
]

{ #category : #accessing }
NativizationEnvironment >> lookupDebuggableStub [
	| index |
	index := self class indexOfGlobal: #DebuggableLookup.
	^(globals at: index) code
]

{ #category : #accessing }
NativizationEnvironment >> lookupStub [
	| index |
	index := self class indexOfGlobal: #Lookup.
	^(globals at: index) code
]

{ #category : #accessing }
NativizationEnvironment >> lookupSuper [
	| index |
	index := self class indexOfGlobal: #LookupSuper.
	^globals at: index
]

{ #category : #accessing }
NativizationEnvironment >> lookupSuperDebuggableStub [
	| index |
	index := self class indexOfGlobal: #DebuggableLookupSuper.
	^(globals at: index) code
]

{ #category : #accessing }
NativizationEnvironment >> lookupSuperStub [
	| index |
	index := self class indexOfGlobal: #LookupSuper.
	^(globals at: index) code
]

{ #category : #private }
NativizationEnvironment >> mapGlobal: aSymbol to: nativeCode [
	placeholder := self globalNamed: aSymbol.
	placeholder code become: nativeCode code.
	placeholder become: nativeCode.
	Kernel namespace at: aSymbol put: nativeCode
]

{ #category : #accessing }
NativizationEnvironment >> messageLinker [
	^messageLinker
]

{ #category : #accessing }
NativizationEnvironment >> messageLinker: aLinker [
	messageLinker := aLinker 
]

{ #category : #accessing }
NativizationEnvironment >> methodNativizer [
	^cachedNativizer
]

{ #category : #services }
NativizationEnvironment >> monomorphicCache [
	| asm lookup next |
	asm := platform newAssembler.
	lookup := asm newLabel.
	asm
		loadTwithAindex: 3;
		loadSwithGlobal: #SmallIntegerBehavior.
	next := asm labeledNonIntegerBitTestOfR.
	asm
		loadLongSwithRindex: 0;
		@ next;
		compareSwithTindex: 1;
		shortJumpIfNotEqualTo: lookup;
		loadMwithTindex: 2;
		jumpToMindex: 1;
		@ lookup;
		loadMwithGlobal: #Lookup;
		jumpToMindex: 1;
		applyFixups.
	^asm nativeCode code
]

{ #category : #services }
NativizationEnvironment >> nativize: aCompiledMethod [
	^(self shouldOptimize: aCompiledMethod)
		  ifTrue: [ self nativizeOptimizing: aCompiledMethod ]
		  ifFalse: [ self nativizeWithoutOptimizing: aCompiledMethod ] 
]

{ #category : #bootstrapping }
NativizationEnvironment >> nativizeInvoke [
	| invoke |
	invoke := SendSite >> #_invokeOn:.
	self 
		nativizeOptimizing: invoke;
		mapGlobal: #Invoke to: invoke
]

{ #category : #bootstrapping }
NativizationEnvironment >> nativizeLookup [
	| nativizer transferred species lookup lookupSuper |
	nativizer := LookupNativizer new
		bootstrapper: self;
		nativizeMethods.
	lookup := nativizer methodFor: #_dispatchOn:.
	lookupSuper := nativizer methodFor: #_dispatchOn:startingAt:.
	self
		mapGlobal: #Lookup to: lookup nativeCode;
		mapGlobal: #LookupSuper to: lookupSuper nativeCode
]

{ #category : #services }
NativizationEnvironment >> nativizeOptimizing: aCompiledMethod [
	self optimizingNativizer
		method: aCompiledMethod;
		nativize
]

{ #category : #services }
NativizationEnvironment >> nativizeWithoutOptimizing: aCompiledMethod [
	| method |
	method := self
		nativizerDuring: [ :nativizer | nativizer nativize: aCompiledMethod ].
	^method
]

{ #category : #bootstrapping }
NativizationEnvironment >> nativizeWriteBarrier [
	| map inlined dispatcher barrier |
	map := {('Memory class' -> #(current)).
	(#Memory -> #(isYoung: isYoungSafe: remember:)).
	(#CriticalArray -> #(unsafeAdd: #unsafeAt:put:)).
	(#Magnitude -> #(#between:and:))}.
	inlined := builder methodSubset: map.
	inlined addAll: builder undermethods.
	inlined := inlined collect: [ :m | builder compile: m ].
	barrier := builder
		compile: builder => #ProtoObject >> #holdRefererIfNeeded:.
	dispatcher := LookupLinker new initializeFrom: nativizer.
	(NativizationEnvironment forTarget: target)
		globals: nativizer globals;
		inlinedMethods: inlined;
		messageLinker: dispatcher;
		completeInitialization;
		nativizeOptimizing: barrier.
	self
		transfer: barrier
		in: #ProtoObject
		asNativizerGlobal: #WriteBarrier
]

{ #category : #services }
NativizationEnvironment >> nativizerDuring: aBlock [
	^busy
		  ifFalse: [ 
			  busy := true.
			  [ aBlock value: cachedNativizer ] ensure: [ busy := false ] ]
		  ifTrue: [ 
			  | old |
			  old := cachedNativizer. 
			  [ 
			  cachedNativizer := self newExpressionNativizer.
			  aBlock value: cachedNativizer ] ensure: [ cachedNativizer := old ] ]
]

{ #category : #services }
NativizationEnvironment >> newExpressionNativizer [
	^SExpressionNativizer new environment: self
]

{ #category : #accessing }
NativizationEnvironment >> optimizedMethods [
	^optimizedMethods
]

{ #category : #accessing }
NativizationEnvironment >> optimizedMethods: aCollection [
	optimizedMethods := aCollection
]

{ #category : #services }
NativizationEnvironment >> optimizingNativizer [
	^OptimizingNativizer new environment: self
]

{ #category : #accessing }
NativizationEnvironment >> platform [
	^platform
]

{ #category : #accessing }
NativizationEnvironment >> platform: aNativizationPlatform [
	platform := aNativizationPlatform
]

{ #category : #services }
NativizationEnvironment >> polymorphicCache [
	| asm smi case2 case3 case4 case5 case6 case7 lookup |
	asm := platform newAssembler.
	smi := asm newLabel.
	case2 := asm newLabel.
	case3 := asm newLabel.
	case4 := asm newLabel.
	case5 := asm newLabel.
	case6 := asm newLabel.
	case7 := asm newLabel.
	lookup := asm newLabel.
	asm loadTwithAindex: 3.
	smi := asm labeledNonIntegerBitTestOfR.
	asm
		loadLongSwithRindex: 0;
		compareSwithTindex: 1;
		shortJumpIfNotEqualTo: case2;
		loadMwithTindex: 2;
		jumpToMindex: 1;
		@ case2;
		compareSwithTindex: 3;
		shortJumpIfNotEqualTo: case3;
		loadMwithTindex: 4;
		jumpToMindex: 1;
		@ case3;
		compareSwithTindex: 5;
		shortJumpIfNotEqualTo: case4;
		loadMwithTindex: 6;
		jumpToMindex: 1;
		@ case4;
		compareSwithTindex: 7;
		shortJumpIfNotEqualTo: case5;
		loadMwithTindex: 8;
		jumpToMindex: 1;
		@ case5;
		compareSwithTindex: 9;
		shortJumpIfNotEqualTo: case6;
		loadMwithTindex: 10;
		jumpToMindex: 1;
		@ case6;
		compareSwithTindex: 11;
		shortJumpIfNotEqualTo: case7;
		loadMwithTindex: 12;
		jumpToMindex: 1;
		@ case7;
		compareSwithTindex: 13;
		shortJumpIfNotEqualTo: lookup;
		loadMwithTindex: 14;
		jumpToMindex: 1;
		@ lookup;
		loadMwithGlobal: #Lookup;
		jumpToMindex: 1;
		@ smi;
		loadMwithTindex: 15;
		jumpToMindex: 1;
		applyFixups.
	^asm nativeCode code
]

{ #category : #'printing & storing' }
NativizationEnvironment >> printOn:aStream [
	"append a printed representation of the receiver to the argument, aStream"

	super printOn:aStream.
	aStream nextPutAll:'(platform: '.
	platform name printOn:aStream.
	aStream nextPut:$)
]

{ #category : #accessing }
NativizationEnvironment >> safepoint [
	| index |
	index := self class indexOfGlobal: #Safepoint.
	^(globals at: index) code
]

{ #category : #accessing }
NativizationEnvironment >> safepointCheck: anObject [
	safepointCheck := anObject 
]

{ #category : #bootstrapping }
NativizationEnvironment >> setupMessageLinkers [
	| invoker dispatcher |
	invoker := InvokeLinker new invoker: self invokeStub; addMethods: invokedMethods.
	dispatcher := LookupLinker new initializeFrom: self.
	self
		addLinker: invoker;
		addLinker: dispatcher;
		completeInitialization
]

{ #category : #services }
NativizationEnvironment >> sexpressionOffsetsOf: code [
	| method |
	method := code method.
	(self shouldOptimize: method) ifTrue: [ ^#(  ) ].
	^self nativizerDuring: [ :nativizer | 
		  method nativeCode ifNotNil: [ method := method copy ]. 
		  nativizer compile: method.
		  nativizer sexpressionOffsetsOf: code ]
]

{ #category : #queries }
NativizationEnvironment >> shouldInline: aSymbol [
	^inlinedMethods anySatisfy: [ :m | m selector = aSymbol ]
]

{ #category : #queries }
NativizationEnvironment >> shouldOptimize: method [
	| selector classname |
	selector := method selector.
	classname := method classBinding name.
	^optimizedMethods anySatisfy: [:m | m selector = selector and: [ m classBinding name = classname ]  ]
]

{ #category : #accessing }
NativizationEnvironment >> wordSize [
	^self abi wordSize
]

{ #category : #accessing }
NativizationEnvironment >> wordSizeShift [
	^self abi wordSizeShift
]

{ #category : #accessing }
NativizationEnvironment >> writeBarrier [
	^writeBarrier
]

{ #category : #accessing }
NativizationEnvironment >> writeBarrier: aCompiledMethod [
	writeBarrier := aCompiledMethod.
	invokedMethods add: writeBarrier 
]
