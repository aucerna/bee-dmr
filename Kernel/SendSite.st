"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #SendSite,
	#superclass : #Object,
	#instVars : [
		'instructions',
		'selector',
		'cache',
		'tally',
		'format'
	],
	#classVars : [
		'FormatFlags',
		'Instances',
		'Invoke',
		'LookupCount',
		'MICs',
		'MonomorphicStub',
		'NextMIC',
		'NextPIC',
		'PICs',
		'PolymorphicStub'
	],
	#category : #Kernel
}

{ #category : #initialization }
SendSite class >> allocateMICs: amount [
	| memory array mic |
	memory := Smalltalk memory.
	array := memory newLargeArray: amount.
	mic := Array new: 2.
	1 to: amount do: [:i | array basicAt: i put: (memory pinnedCopy: mic)].
	MICs := array.
	NextMIC := 1
]

{ #category : #initialization }
SendSite class >> allocatePICs: amount [
	self allocatePICs: amount lookup: (Smalltalk at: #Lookup)
]

{ #category : #initialization }
SendSite class >> allocatePICs: amount lookup: aNativeCode [
	| memory array pic |
	memory := Smalltalk memory.
	array := memory newLargeArray: amount.
	pic := (Array new: 15)
		at: 15 put: aNativeCode;
		yourself.
	1 to: amount do: [:i | array basicAt: i put: (memory pinnedCopy: pic)].
	PICs := array.
	NextPIC := 1
]

{ #category : #private }
SendSite class >> flush [
	self instances do: [:sites | sites do: [:s | s flush]].
	self allocateMICs: 3000; allocatePICs: 3000
]

{ #category : #initialization }
SendSite class >> flush: selector [
	| sends count copy |
	sends := self instances at: selector ifAbsent: [^self].
	count := 0.
	sends do: [:send | 
		send ifNotNil: [
			count := count + 1.
			send flush: selector]].
	count * 3 < sends size ifFalse: [^self].
	count = 0 ifTrue: [^sends removeKey: selector].
	copy := WeakArray new: (count * 1.5) asInteger.
	count := 0.
	sends do: [:send | 
		send ifNotNil: [
			count := count + 1.
			copy at: count put: send]].
	self instances at: selector put: copy
]

{ #category : #private }
SendSite class >> flushInstances [
	Instances := nil
]

{ #category : #private }
SendSite class >> initializeFormatFlags [
	"
	SendSite initializeFormatFlags
	"
	FormatFlags := PoolDictionary newConstantPool
		at: 'IsStaticSend' put: 0x1;
		at: 'IsSuperSend' put: 0x2;
		at: 'IsPolymorphic' put: 0x4;
		at: 'HasBeenReset' put: 0x8;
		yourself
]

{ #category : #initialization }
SendSite class >> initializeFrom: aNativizationEnvironment [
	self
		allocateMICs: 3000;
		allocatePICs: 3000 lookup: aNativizationEnvironment lookup;
		initializeMICStubFor: aNativizationEnvironment abi;
		initializePICStubFor: aNativizationEnvironment abi.
	Invoke := aNativizationEnvironment invokeStub
]

{ #category : #initialization }
SendSite class >> instances [
	Instances ifNil: [
		Instances := IdentityDictionary new.
		self allInstances do: [:send | send register]].
	^Instances
]

{ #category : #private }
SendSite class >> invoking: aCompiledMethod using: instructions [
	^self new beStaticSend; beInvoke: aCompiledMethod
	using: instructions
]

{ #category : #accessing }
SendSite class >> lookupCount [
	^LookupCount
]

{ #category : #initialization }
SendSite class >> mics [
	^MICs
]

{ #category : #initialization }
SendSite class >> newPICUsing: aNativeCode [
	| new |
	new := Array new: 15.
	new at: 15 put: aNativeCode.
	^new
]

{ #category : #private }
SendSite class >> sending: aSelector with: instructions [
	^self new selector: aSelector; instructions: instructions
]

{ #category : #'meta accessing' }
SendSite >> _dispatchDebuggableOn: anObject [
	| cm nativeCode invoked |
	#specialABIBegin.
	#anObject -> #regR.
	#self -> #regA.
	#specialABIEnd.
	LookupCount := LookupCount + 1.
	cm := anObject _cachedLookup: selector.
	cm == nil ifTrue: [^anObject doesNotUnderstandSelector: selector].
	invoked := ActiveProcess wantsToStepInto
		ifTrue: [cm debuggableCopy]
		ifFalse: [cm].
	invoked prepareForExecution.
	nativeCode := invoked nativeCode.
	"self when: anObject behavior use: nativeCode code."
	^anObject _transferControlTo: nativeCode
]

{ #category : #'meta accessing' }
SendSite >> _dispatchDebuggableOn: anObject startingAt: aBehavior [
	| cm nativeCode invoked |
	#specialABIBegin.
	#anObject -> #regR.
	#self -> #regA.
	#aBehavior -> #regT.
	#specialABIEnd.
	LookupCount := LookupCount + 1.
	cm := anObject _cachedLookup: selector in: aBehavior.
	cm == nil ifTrue: [^anObject doesNotUnderstandSelector: selector].
	invoked := ActiveProcess wantsToStepInto
		ifTrue: [cm debuggableCopy]
		ifFalse: [cm].
	invoked prepareForExecution.
	nativeCode := invoked nativeCode.
	"self when: aBehavior use: nativeCode code."
	^anObject _transferControlTo: nativeCode
]

{ #category : #'meta accessing' }
SendSite >> _dispatchOn: anObject [
	| cm nativeCode |
	#specialABIBegin.
	#anObject -> #regR.
	#self -> #regA.
	#specialABIEnd.
	LookupCount := LookupCount + 1.
	cm := anObject _cachedLookup: selector.
	cm == nil ifTrue: [^anObject doesNotUnderstandSelector: selector].
	cm prepareForExecution.
	nativeCode := cm nativeCode.
	self when: anObject behavior use: nativeCode.
	^anObject _transferControlTo: nativeCode
]

{ #category : #'meta accessing' }
SendSite >> _dispatchOn: anObject startingAt: aBehavior [
	| cm nativeCode |
	#specialABIBegin.
	#anObject -> #regR.
	#self -> #regA.
	#aBehavior -> #regT.
	#specialABIEnd.
	LookupCount := LookupCount + 1.
	cm := anObject _cachedLookup: selector in: aBehavior.
	cm == nil ifTrue: [^anObject doesNotUnderstandSelector: selector].
	cm prepareForExecution.
	nativeCode := cm nativeCode.
	self beInvoke: cm using: Invoke.
	^anObject _transferControlTo: nativeCode
]

{ #category : #'meta accessing' }
SendSite >> _invokeOn: anObject [
	#savePreviousSelf.
	#specialABIBegin.
	#anObject -> #regR.
	#self -> #regA.
	#specialABIEnd.
	^anObject _transferControlTo: cache nativeCode
]

{ #category : #private }
SendSite >> beInvoke: aCompiledMethod using: invokeInstructions [
	instructions := invokeInstructions.
	cache := aCompiledMethod
]

{ #category : #private }
SendSite >> bePolymorphic [
	format := format bitOr: IsPolymorphic
]

{ #category : #private }
SendSite >> beStaticSend [
	format := format bitOr: IsStaticSend
]

{ #category : #private }
SendSite >> beSuperSend [
	format := format bitOr: IsSuperSend
]

{ #category : #private }
SendSite >> cache [
	^cache
]

{ #category : #private }
SendSite >> flush [
	self isStaticSend ifTrue: [^self].
	instructions := self isSuperSend
		ifTrue: [Smalltalk at: #LookupSuperCode]
		ifFalse: [Smalltalk at: #LookupCode].
	cache := nil
]

{ #category : #private }
SendSite >> flush: aSelector [
	aSelector == selector ifTrue: [self flush]
]

{ #category : #private }
SendSite >> hasBeenReset [
	^format isOnBit: HasBeenReset
]

{ #category : #initialization }
SendSite >> initialize [
	tally := 0.
	format := 0
]

{ #category : #private }
SendSite >> instructions [
	^instructions
]

{ #category : #private }
SendSite >> instructions: aByteArray [
	instructions := aByteArray
]

{ #category : #printing }
SendSite >> isFakeMegamorphic [
	^self isFakeMegamorphic: 3
]

{ #category : #printing }
SendSite >> isFakeMegamorphic: maxImplementations [
	| d |
	self isMegamorphic ifFalse: [^false].
	d := IdentitySet new.
	cache size = 15 ifFalse: [^false].
	1 to: cache size - 1 by: 2 do: [:i | | code |
		code := cache at: i + 1.
		d add: code].
	(cache at: cache size) ifNotNil: [:code | d add: code].
	^d size <= maxImplementations
]

{ #category : #private }
SendSite >> isMegamorphic [
	^self isPolymorphic and: [self hasBeenReset]
]

{ #category : #private }
SendSite >> isPolymorphic [
	^format isOnBit: IsPolymorphic
]

{ #category : #testing }
SendSite >> isStaticSelector [
	(#(#basicByteAt: #basicByteAt:put: #basicInstVarAt: #basicInstVarAt:put:
		#behavior #class #allocate:size:
		 #memory #instanceBehavior
		#_instancesAreArrayed #_instancesHavePointers #nil:slotsOf:
		#initializeExtended:contentSize: #primitiveNew
		#primitiveNewBytes: #primitiveNewPointers: #_return: #_returnTo: #zero:bytesOf:)
		includes: selector)
		ifTrue: [^true].
	^ProtoObject staticSelectors includes: selector
]

{ #category : #testing }
SendSite >> isStaticSend [
	^(format bitAnd: 1) == 1
]

{ #category : #testing }
SendSite >> isSuperSend [
	^(format bitAnd: 2) == 2
]

{ #category : #private }
SendSite >> maxSize [
	^14
]

{ #category : #private }
SendSite >> monomorphicMap: aBehavior to: code [
	cache := self takeNextFreeMIC ifNil: [^self].
	instructions := self monomorphicStub.
	cache
		objectAtValid: 1 put: aBehavior;
		objectAtValid: 2 put: code
]

{ #category : #private }
SendSite >> monomorphicStub [
	^MonomorphicStub code
]

{ #category : #private }
SendSite >> polymorphicMap: aBehavior to: code [
	cache _size == 2 ifTrue: [
		cache := self takeNextFreePIC ifNil: [^self].
		instructions := self polymorphicStub.
		self bePolymorphic].
	aBehavior == SmallInteger instanceBehavior
		ifTrue: [cache objectAtValid: self maxSize + 1 put: code]
		ifFalse: [
			tally == self maxSize ifTrue: [self reset].
			cache
				objectAtValid: tally + 1 put: aBehavior;
				objectAtValid: tally + 2 put: code.
			tally := tally + 2]
]

{ #category : #private }
SendSite >> polymorphicStub [
	^PolymorphicStub code
]

{ #category : #printing }
SendSite >> printInvokeTypeOn: aStream [
	aStream nextPutAll: 'invoke '; print: cache
]

{ #category : #printing }
SendSite >> printMonomorphicTypeOn: aStream [
	aStream
		nextPutAll: 'mono (';
		print: cache first;
		nextPutAll: ')'
]

{ #category : #printing }
SendSite >> printOn: aStream [
	aStream
		nextPutAll: 'SendSite (';
		nextPutAll: selector;
		nextPutAll: ') ['.
	self printTypeOn: aStream.
	aStream nextPut: $]
]

{ #category : #printing }
SendSite >> printPolymorphicTypeOn: aStream [
	aStream nextPutAll: 'poly '.
	(1 to: tally by: 2)
		do: [:i | | behavior |
			behavior := cache at: i.
			aStream print: behavior]
		separatedBy: [aStream nextPut: $,; space].
	(cache at: cache size)
		ifNotNil: [aStream nextPutAll: ', '; print: SmallInteger behavior].
	aStream nextPutAll: ' -- old: '.
	(tally + 1 to: cache size - 1 by: 2)
		do: [:i | | behavior |
			behavior := cache at: i.
			aStream print: behavior]
		separatedBy: [aStream nextPut: $,; space]
]

{ #category : #printing }
SendSite >> printTypeOn: aStream [
	cache isCompiledMethod ifTrue: [^self printInvokeTypeOn: aStream].
	instructions == MonomorphicStub code
		ifTrue: [^self printMonomorphicTypeOn: aStream].
	instructions == PolymorphicStub code
		ifTrue: [^self printPolymorphicTypeOn: aStream].
	instructions == (Smalltalk at: #Lookup ifAbsent: [''])
		ifTrue: [^aStream nextPutAll: 'lookup'].
	cache isCompiledMethod
		ifTrue: [^aStream nextPutAll: 'dispatch ' , cache printString].
	aStream nextPutAll: 'other '; print: cache
]

{ #category : #services }
SendSite >> register [
	| sends |
	sends := self class instances
		at: self selector
		ifAbsentPut: [OrderedCollection new].
	sends add: self
]

{ #category : #private }
SendSite >> reset [
	tally := 0.
	format := format bitOr: HasBeenReset
]

{ #category : #private }
SendSite >> selector [
	^selector
]

{ #category : #private }
SendSite >> selector: aSelector [
	selector := aSelector.
	self isStaticSelector ifTrue: [self beStaticSend].
	Smalltalk isDMR ifTrue: [self register]
]

{ #category : #private }
SendSite >> sentSelector [
	^selector
]

{ #category : #private }
SendSite >> takeNextFreeMIC [
	| position size |
	position := NextMIC.
	NextMIC := NextMIC + 1.
	size := MICs _size.
	^position >= size
		ifTrue: [
			position = size ifTrue: [self class allocateMICs: 3000].
			nil]
		ifFalse: [MICs _basicAt: position]
]

{ #category : #private }
SendSite >> takeNextFreePIC [
	| position size |
	position := NextPIC.
	NextPIC := NextPIC + 1.
	size := PICs _size.
	^position >= size
		ifTrue: [
			position = size ifTrue: [self class allocatePICs: 3000].
			nil]
		ifFalse: [PICs _basicAt: position]
]

{ #category : #private }
SendSite >> unreset [
	format := format bitAnd: HasBeenReset bitInvert
]

{ #category : #private }
SendSite >> when: aBehavior use: aNativeCode [
	cache == nil
		ifTrue: [
			self isStaticSend
				ifTrue: [
					instructions := Invoke.
					cache := aNativeCode compiledCode]
				ifFalse: [self monomorphicMap: aBehavior to: aNativeCode]]
		ifFalse: [self polymorphicMap: aBehavior to: aNativeCode]
]

