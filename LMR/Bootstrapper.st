Class {
	#name : #Bootstrapper,
	#superclass : #Object,
	#instVars : [
		'environment'
	],
	#category : #'Powerlang-Core-LMR'
}

{ #category : #bootstrapping }
Bootstrapper >> neededModules [
	^#(Files Tonel Nativizer Compiler SegmentWriter)
]

{ #category : #bootstrapping }
Bootstrapper >> builtModules [
	^#{Kernel. Files. Tonel. Nativizer. Compiler}
]

{ #category : #bootstrapping }
Bootstrapper >> bindModules: aCollection [
	aCollection do: [:module | self bind: module]
]

{ #category : #bootstrapping }
Bootstrapper >> buildBootstrapSegmentsFor: platformName [
	platform := Platform named: platformName.
	self bootstrapBuiltModules do: [:module |
		Nativizer nativize: module for: platform.
		SegmentWriter build: module]
]

{ #category : #bootstrapping }
Bootstrapper >> environment: aNativizationEnvironment [
	environment := aNativizationEnvironment
]

{ #category : #bootstrapping }
Bootstrapper >> initializeGlobals [
	| items |
	environment globalNamed: #SmallIntegerBehavior put: SmallInteger instanceBehavior.
	items := Dictionary newFromPairs: {
		#Lookup .           (NativeCode new code: 'Lookup Placeholder').
		#LookupSuper .      (NativeCode new code: 'LookupSuper Placeholder').
		#DebuggableLookup . (NativeCode new code: 'DebuggableLookup placeholder').
		#DebuggableLookupSuper. (NativeCode new code: 'DebuggableLookupSuper placholder').
		#Invoke .           (NativeCode new code: 'Invoke placeholder').
		#Safepoint .        (NativeCode new code: 'SafepointCheck placeholder').
		#WriteBarrier .     (NativeCode new code: 'Write Barrier placeholder')}.
	items
		keysAndValuesDo: [ :key :placeholder | environment globalNamed: key put: placeholder ]
]

{ #category : #private }
Bootstrapper >> mapGlobal: aSymbol to: nativeCode [
	placeholder := environment globalNamed: aSymbol.
	placeholder code become: nativeCode code.
	placeholder become: nativeCode.
	Kernel namespace at: aSymbol put: nativeCode
]

{ #category : #bootstrapping }
Bootstrapper >> nativizeInvoke [
	| invoke |
	invoke := SendSite >> #_invokeOn:.
	environment 
		nativizeOptimizing: invoke;
		mapGlobal: #Invoke to: invoke
]

{ #category : #bootstrapping }
Bootstrapper >> nativizeLookup [
	| nativizer transferred species lookup lookupSuper |
	nativizer := LookupNativizer new
		bootstrapper: environment;
		nativizeMethods.
	lookup := nativizer methodFor: #_dispatchOn:.
	lookupSuper := nativizer methodFor: #_dispatchOn:startingAt:.
	environment
		mapGlobal: #Lookup to: lookup nativeCode;
		mapGlobal: #LookupSuper to: lookupSuper nativeCode
]

{ #category : #bootstrapping }
Bootstrapper >> nativizeWriteBarrier [
	| map inlined dispatcher barrier |
	map := {
		(Memory class -> #(current)).
		(Memory -> #(isYoung: isYoungSafe: remember:)).
		(CriticalArray -> #(unsafeAdd: #unsafeAt:put:)).
		(Magnitude -> #(#between:and:))
	}.
	inlined := NativizationEnvironment methodSubset: map.
	inlined addAll: self class undermethods.
	barrier := ProtoObject >> #holdRefererIfNeeded:.
	dispatcher := LookupLinker new initializeFrom: nativizer.
	(Bootstrapper forTarget: target)
		globals: nativizer globals;
		inlinedMethods: inlined;
		messageLinker: dispatcher;
		completeInitialization;
		nativizeOptimizing: barrier.
	self mapGlobal: #WriteBarrier to: barrier nativeCode
]

