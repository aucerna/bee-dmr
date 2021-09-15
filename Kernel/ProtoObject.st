"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #ProtoObject,
	#superclass : nil,
	#classVars : [
		'ObjectBitsMasks',
		'ObjectFieldsOffset'
	],
	#category : #Kernel
}

{ #category : #initialization }
ProtoObject class >> initializeBitMasks [
	"
	self initializeBitMasks
	"
	ObjectBitsMasks := PoolDictionary new.
	ObjectBitsMasks
		add: 'IsBytes' -> 16r1;
		add: 'IsArrayed' -> 16r2;
		add: 'IsNamed' -> 16r4;
		add: 'IsRemembered' -> 16r8;
		add: 'IsSpecial' -> 16r10;
		add: 'Bit1' -> 16r20;
		add: 'IsSecondGeneration' -> 16r40;
		add: 'IsSmall' -> 16r80;
		add: 'HasBeenSeen' -> 16r20.
	ObjectBitsMasks keys
		do: [:key | ObjectBitsMasks
			at: key , 'Mask'
			put: 16rFF - (ObjectBitsMasks at: key)]
]

{ #category : #initialization }
ProtoObject class >> initializeConstants [
	"
	ProtoObject initializeConstants
	"
	ObjectFieldsOffset := PoolDictionary new.
	ObjectFieldsOffset
		at: '_Behavior' put: 0;
		at: '_Reserved' put: -2;
		at: '_ExtendedSize' put: -3;
		at: '_Flags' put: -5;
		at: '_SmallSize' put: -6;
		at: '_Hash' put: -8
]

{ #category : #'instance creation' }
ProtoObject class >> new [
	^self basicNew initialize
]

{ #category : #private }
ProtoObject class >> staticSelectors [
	"
	ProtoObject undermethodSelectors asArray sort
	"
	^#(#_beArrayed #_beBytes #_beFirstGeneration #_beLarge #_beNamed #_beNotRemembered #_beNotSpecial #_beRemembered #_beSecondGeneration #_beSeen #_beSmall #_beSpecial #_beUnseen #_bodySizeInBytes #_copyBasicHeaderFrom: #_copyHeaderSized:from: #_flagsMask: #_flagsSet: #_hasBeenSeen #_hasNamedSlots #_headerSizeInBytes #_isArrayed #_isBytes #_isFixed #_isLarge #_isProxy #_isRemembered #_isSecondGeneration #_isSmall #_isSpecial #_largeSize: #_longAtValidOffset: #_makeExtendedSize: #_nextBasePointer #_objectFromBasePointer #_pointersSize #_shortAtValidOffset: #_size #_sizeInBytes #_strongPointersSize #_uLargeAtValidOffset: #_uLargeAtValidOffset:put: #_uLongAtValidOffset: #_uLongAtValidOffset:put: #_uShortAtValidOffset: #_uShortAtValidOffset:put: #initializeExtended:contentSize:)
]

{ #category : #private }
ProtoObject class >> undermethods [
	^self undermethodSelectors collect: [:selector | self >> selector]
]

{ #category : #private }
ProtoObject class >> undermethodSelectors [
	^self organization selectorsFor: 'header access'
]

{ #category : #comparing }
ProtoObject >> !== anObject [
	^self == anObject ifTrue: [false] ifFalse: [true]
]

{ #category : #'header access' }
ProtoObject >> _beArrayed [
	self _flagsSet: IsArrayed
]

{ #category : #'header access' }
ProtoObject >> _beBytes [
	self _flagsSet: IsBytes
]

{ #category : #'header access' }
ProtoObject >> _beFirstGeneration [
	self _flagsMask: IsSecondGenerationMask
]

{ #category : #'header access' }
ProtoObject >> _beLarge [
	self _flagsMask: IsSmallMask
]

{ #category : #'header access' }
ProtoObject >> _beNamed [
	self _flagsSet: IsNamed
]

{ #category : #'header access' }
ProtoObject >> _beNotRemembered [
	self _flagsMask: IsRememberedMask
]

{ #category : #'header access' }
ProtoObject >> _beNotSpecial [
	self _flagsMask: IsSpecialMask
]

{ #category : #'header access' }
ProtoObject >> _beRemembered [
	self _flagsSet: IsRemembered
]

{ #category : #'header access' }
ProtoObject >> _beSecondGeneration [
	self _flagsSet: IsSecondGeneration
]

{ #category : #'header access' }
ProtoObject >> _beSeen [
	self _flagsSet: HasBeenSeen
]

{ #category : #'header access' }
ProtoObject >> _beSmall [
	self _flagsSet: IsSmall
]

{ #category : #'header access' }
ProtoObject >> _beSpecial [
	self _flagsSet: IsSpecial
]

{ #category : #'header access' }
ProtoObject >> _beUnseen [
	self _flagsMask: HasBeenSeenMask
]

{ #category : #'header access' }
ProtoObject >> _bodySizeInBytes [
	| total |
	total := self _size.
	^self _isBytes
		ifTrue: [total + WordSize - 1 bitAnd: 0 - WordSize]
		ifFalse: [total * WordSize]
]

{ #category : #lookup }
ProtoObject >> _cachedLookup: aSymbol [
	^self _cachedLookup: aSymbol in: self behavior
]

{ #category : #lookup }
ProtoObject >> _cachedLookup: aSymbol in: behavior [
	^GlobalDispatchCache current lookupAndCache: aSymbol in: behavior
]

{ #category : #'header access' }
ProtoObject >> _copyBasicHeaderFrom: other [
	self
		_longSlotAt: -1 put: (other _longSlotAt: -1);
		_longSlotAt: 0 put: (other _longSlotAt: 0)
]

{ #category : #'header access' }
ProtoObject >> _copyHeaderSized: byteSize from: anObject [
	byteSize = 16 ifTrue: [
		self
			_longSlotAt: -3 put: (anObject _longSlotAt: -3);
			_longSlotAt: -2 put: (anObject _longSlotAt: -2)].
	self
		_longSlotAt: -1 put: (anObject _longSlotAt: -1);
		_longSlotAt: 0 put: (anObject _longSlotAt: 0)
]

{ #category : #'header access' }
ProtoObject >> _flagsMask: mask [
	self _basicFlags: (self _basicFlags bitAnd: mask)
]

{ #category : #'header access' }
ProtoObject >> _flagsSet: mask [
	self _basicFlags: (self _basicFlags bitOr: mask)
]

{ #category : #'header access' }
ProtoObject >> _hasBeenSeen [
	^(self _basicFlags bitAnd: HasBeenSeen) == HasBeenSeen
]

{ #category : #'header access' }
ProtoObject >> _hasNamedSlots [
	^(self _basicFlags bitAnd: IsNamed) = IsNamed
]

{ #category : #'header access' }
ProtoObject >> _headerSizeInBytes [
	^self _isSmall ifTrue: [8] ifFalse: [16]
]

{ #category : #lookup }
ProtoObject >> _invoke: aNativeCode [
	"
	senders of _invoke: MUST have at least 1 temporary. The argument of
	_invoke: is removed twice: once here and once again after returning from
	_invoke. If no temps are present, the second pop smashes the compiled
	method of the frame, which happens to be in the top of the stack. This
	would only be noticed by random crashes when executing debuggable
	methods (because they send a message after _invoke: and before returning)
	"
	^self _transferControlDiscardingLastArgTo: aNativeCode
]

{ #category : #'header access' }
ProtoObject >> _isArrayed [
	^false == self _isFixed
]

{ #category : #'header access' }
ProtoObject >> _isBytes [
	^(self _basicFlags bitAnd: IsBytes) = IsBytes
]

{ #category : #'header access' }
ProtoObject >> _isFixed [
	^(self _basicFlags bitAnd: IsArrayed) == 0
]

{ #category : #'header access' }
ProtoObject >> _isLarge [
	^(self _basicFlags bitAnd: IsSmall) == 0
]

{ #category : #'header access' }
ProtoObject >> _isProxy [
	^self _hasBeenSeen
]

{ #category : #'header access' }
ProtoObject >> _isRemembered [
	^(self _basicFlags bitAnd: IsRemembered) = IsRemembered
]

{ #category : #'header access' }
ProtoObject >> _isSecondGeneration [
	^(self _basicFlags bitAnd: IsSecondGeneration) = IsSecondGeneration
]

{ #category : #'header access' }
ProtoObject >> _isSmall [
	^(self _basicFlags bitAnd: IsSmall) = IsSmall
]

{ #category : #'header access' }
ProtoObject >> _isSpecial [
	^(self _basicFlags bitAnd: IsSpecial) = IsSpecial
]

{ #category : #'header access' }
ProtoObject >> _largeSize: size [
	self _longSlotAt: _ExtendedSize put: size _asNative
]

{ #category : #undermethods }
ProtoObject >> _longAtValidOffset: offset [
	| lo hi sign |
	lo := self _uShortAtValidOffset: offset.
	hi := self _uShortAtValidOffset: offset + 2.
	sign := hi bitAnd: 16r8000.
	hi := hi - (sign * 2).
	^hi * 16r10000 + lo
]

{ #category : #lookup }
ProtoObject >> _lookup: aSymbol [
	^self _lookup: aSymbol in: self behavior
]

{ #category : #lookup }
ProtoObject >> _lookup: aSymbol in: aBehavior [
	| methods cm next |
	methods := aBehavior _basicAt: 1.
	cm := self _lookup: aSymbol inDictionary: methods.
	cm == nil ifFalse: [^cm].
	next := aBehavior _basicAt: 2.
	^next == nil ifFalse: [self _lookup: aSymbol in: next]
]

{ #category : #lookup }
ProtoObject >> _lookup: aSymbol inDictionary: methodDictionary [
	| table |
	table := methodDictionary _basicAt: 2.
	2
		to: table _size
		by: 2
		do: [:j | (table _basicAt: j) == aSymbol ifTrue: [^table _basicAt: j + 1]].
	^nil
]

{ #category : #'header access' }
ProtoObject >> _makeExtendedSize: size [
	self
		_beLarge;
		_smallSize: 4;
		_largeSize: size;
		_longSlotAt: _Reserved put: 0 _asNative
]

{ #category : #'header access' }
ProtoObject >> _nextBasePointer [
	^self _asPointer + self _bodySizeInBytes _asPointer
]

{ #category : #'header access' }
ProtoObject >> _objectFromBasePointer [
	| offset |
	offset := (self _asObject _byteAt: 4) > 127 ifTrue: [8] ifFalse: [16].
	^(self + offset _asPointer) _asObject
]

{ #category : #underprimitives }
ProtoObject >> _oop [
	^self _asPointer * 2
]

{ #category : #'header access' }
ProtoObject >> _pointersSize [
	^self _isBytes ifTrue: [0] ifFalse: [self _size]
]

{ #category : #unwinding }
ProtoObject >> _returnTo: aBeeFrame [
	[#forceEnvironment].
	aBeeFrame _beCurrent.
	^self
]

{ #category : #undermethods }
ProtoObject >> _shortAtValidOffset: offset [
	| ushort |
	ushort := self _primitiveUShortAtOffset: offset.
	^ushort >= 0x8000 ifTrue: [-0x10000 + ushort] ifFalse: [ushort]
]

{ #category : #'header access' }
ProtoObject >> _size [
	^self _isSmall ifTrue: [self _smallSize] ifFalse: [self _largeSize]
]

{ #category : #'header access' }
ProtoObject >> _sizeInBytes [
	^self _headerSizeInBytes + self _bodySizeInBytes
]

{ #category : #'header access' }
ProtoObject >> _strongPointersSize [
	^(self _isBytes or: [self _isSpecial]) ifTrue: [0] ifFalse: [0 + self _size]
]

{ #category : #undermethods }
ProtoObject >> _uLargeAtValidOffset: offset [
	^(self _primitiveULargeAtOffset: offset)
		ifNil: [self
			_primitiveULargeAtOffset: offset
			into: (LargePositiveInteger new: 8)]
]

{ #category : #undermethods }
ProtoObject >> _uLargeAtValidOffset: offset put: anInteger [
	anInteger size > 8 ifTrue: [self error: 'does not fit in 64 bits'].
	self _primitiveULargeAtOffset: offset put: anInteger.
	^anInteger
]

{ #category : #undermethods }
ProtoObject >> _uLongAtValidOffset: offset [
	^(self _primitiveULongAtOffset: offset)
		ifNil: [self
			_primitiveULongAtOffset: offset
			into: (LargePositiveInteger new: 4)]
]

{ #category : #undermethods }
ProtoObject >> _uLongAtValidOffset: offset put: anInteger [
	anInteger size > 4 ifTrue: [self error: 'does not fit in 32 bits'].
	self _primitiveULongAtOffset: offset put: anInteger.
	^anInteger
]

{ #category : #undermethods }
ProtoObject >> _uShortAtValidOffset: offset [
	^self _primitiveUShortAtOffset: offset
]

{ #category : #undermethods }
ProtoObject >> _uShortAtValidOffset: offset put: anInteger [
	anInteger size > 2 ifTrue: [self error: 'does not fit in 16 bits'].
	self _primitiveUShortAtOffset: offset put: anInteger.
	^anInteger
]

{ #category : #comparing }
ProtoObject >> ~~ anObject [
	^self == anObject ifTrue: [false] ifFalse: [true]
]

{ #category : #comparing }
ProtoObject >> = other [
	^self == other
]

{ #category : #system }
ProtoObject >> == anObject [
	^self == anObject
]

{ #category : #system }
ProtoObject >> allReferences [
	^Memory current collectAndCompactOldSpace; referencesTo: self
]

{ #category : #accessing }
ProtoObject >> basicAt: anInteger [
	^self primitiveAt: anInteger
]

{ #category : #system }
ProtoObject >> basicHash [
	| hash shifted |
	"
	LastHash := 1. 
	LFSR implementation (avoids 0 by definition)
	"
	hash := self _basicHash.
	hash == 0 ifFalse: [^hash].
	shifted := LastHash bitShift: -1.
	hash := (LastHash bitAnd: 1) = 0
		ifTrue: [shifted]
		ifFalse: [shifted bitXor: 16rD561].
	self _basicHash: hash.
	^LastHash := hash
]

{ #category : #system }
ProtoObject >> basicHash: anInteger [
	self _basicHash: anInteger
]

{ #category : #private }
ProtoObject >> basicInstVarAt: index [
	| max |
	index _isSmallInteger ifFalse: [^self outOfBoundsIndex: index].
	max := self _size
		+ ((self _hasNamedSlots and: [self _isArrayed])
			ifTrue: [self class instSize]
			ifFalse: [0]).
	(1 <= index and: [index <= max]) ifFalse: [^self outOfBoundsIndex: index].
	^self objectAtValid: index
]

{ #category : #private }
ProtoObject >> basicInstVarAt: index put: anObject [
	| max |
	index _isSmallInteger ifFalse: [^self outOfBoundsIndex: index].
	max := self _size
		+ ((self _hasNamedSlots and: [self _isArrayed])
			ifTrue: [self class instSize]
			ifFalse: [0]).
	(1 <= index and: [index <= max]) ifFalse: [^self outOfBoundsIndex: index].
	^self objectAtValid: index put: anObject
]

{ #category : #private }
ProtoObject >> basicSize [
	^self primitiveSize
]

{ #category : #services }
ProtoObject >> become: anotherObject [
	Smalltalk memory make: self become: anotherObject
]

{ #category : #'meta accessing' }
ProtoObject >> behavior [
	^self _isSmallInteger
		ifTrue: [SmallInteger instanceBehavior]
		ifFalse: [self _longSlotAt: 0]
]

{ #category : #'meta accessing' }
ProtoObject >> behavior: aBehavior [
	^self _isSmallInteger
		ifTrue: [self error: 'can''t change behavior of a small integer']
		ifFalse: [
			aBehavior _holdRefererIfNeeded: self.
			self _longSlotAt: 0 put: aBehavior]
]

ProtoObject >> class [
	^self behavior classBinding
]

{ #category : #system }
ProtoObject >> doesNotUnderstand: aMessage [
	^MessageNotUnderstood message: aMessage receiver: self
]

{ #category : #private }
ProtoObject >> doesNotUnderstand: selector with: arguments [
	| message |
	message := Message receiver: self selector: selector arguments: arguments.
	^self doesNotUnderstand: message
]

{ #category : #private }
ProtoObject >> doesNotUnderstandSelector: selector [
	| arguments message |
	arguments := StackFrameCursor top moveNext
		argumentsWithArity: selector arity.
	message := Message selector: selector arguments: arguments.
	^self doesNotUnderstand: message
]

{ #category : #errors }
ProtoObject >> error: aString [
	^Error signal: aString
]

{ #category : #errors }
ProtoObject >> error: message title: title resumable: resumable [
	| type result text caption |
	type := 16r10 + (resumable ifTrue: [16r5] ifFalse: [0]).
	text := message externalCopy.
	caption := title externalCopy.
	result := UserLibrary
		MessageBoxExW: 0
		lpText: text asParameter
		lpCaption: caption asParameter
		uType: type asParameter
		wLanguageId: 0.
	text free.
	caption free.
	^resumable and: [result = 4]
]

{ #category : #finalization }
ProtoObject >> finalizationRegistry [
	^Smalltalk finalizer
]

{ #category : #finalization }
ProtoObject >> finalize [
	
]

{ #category : #system }
ProtoObject >> halt [
	Halt signal
]

{ #category : #accessing }
ProtoObject >> hash [
	^self basicHash
]

{ #category : #testing }
ProtoObject >> hasIndexedSlots [
	^self class instancesAreArrayed
]

{ #category : #private }
ProtoObject >> holdRefererIfNeeded: referent [
	| memory |
	#savePreviousSelf.
	self _isSmallInteger ifTrue: [^self].
	referent _isRemembered ifTrue: [^self].
	memory := Memory current.
	(memory isYoungSafe: referent)
		ifFalse: [(memory isYoungSafe: self) ifTrue: [memory remember: referent]]
]

{ #category : #comparing }
ProtoObject >> identityHash [
	^self basicHash
]

{ #category : #services }
ProtoObject >> ifNil: aBlock [
	^self
]

{ #category : #services }
ProtoObject >> ifNotNil: aBlock [
	^aBlock argumentCount = 1
		ifTrue: [aBlock evaluateWith: self]
		ifFalse: [aBlock evaluate]
]

{ #category : #finalization }
ProtoObject >> ignoreFinalization [
	self finalizationRegistry remove: self ifAbsent: nil
]

{ #category : #'header access' }
ProtoObject >> initializeExtended: aBoolean contentSize: size [
	self _longSlotAt: -1 put: 0 _asNative.
	aBoolean
		ifTrue: [
			self
				_smallSize: 4;
				_longSlotAt: _ExtendedSize put: size _asNative;
				_longSlotAt: _Reserved put: 0 _asNative]
		ifFalse: [self _smallSize: size; _beSmall]
]

{ #category : #system }
ProtoObject >> instVarAt: i [
	self _isSmallInteger ifTrue: [^self shouldNotImplement].
	^self _isBytes
		ifTrue: [self basicByteAt: i]
		ifFalse: [self basicInstVarAt: i]
]

{ #category : #system }
ProtoObject >> instVarAt: i put: anObject [
	self _isSmallInteger ifTrue: [^self shouldNotImplement].
	^self _isBytes
		ifTrue: [self basicByteAt: i put: anObject]
		ifFalse: [self basicInstVarAt: i put: anObject]
]

{ #category : #system }
ProtoObject >> isNil [
	^false
]

{ #category : #testing }
ProtoObject >> isSmallInteger [
	^false
]

{ #category : #accessing }
ProtoObject >> literalString [
	^nil
]

{ #category : #system }
ProtoObject >> notNil [
	^true
]

{ #category : #private }
ProtoObject >> objectAtValid: index [
	^self _basicAt: index
]

{ #category : #private }
ProtoObject >> objectAtValid: index put: anObject [
	anObject _holdRefererIfNeeded: self.
	^self _basicAt: index put: anObject
]

{ #category : #system }
ProtoObject >> perform: aSymbol [
	| cm debug |
	aSymbol arity = 0 ifFalse: [^self error: 'incorrect arity'].
	cm := self _cachedLookup: aSymbol.
	cm == nil ifTrue: [^self doesNotUnderstand: aSymbol with: #()].
	debug ifNotNil: [cm := cm debuggableCopy].
	cm prepareForExecution.
	^self _invoke: cm nativeCode
]

{ #category : #system }
ProtoObject >> perform: aSymbol with: anObject [
	^self perform: aSymbol withArguments: {anObject}
]

{ #category : #system }
ProtoObject >> perform: aSymbol withArguments: anArray [
	| size cm debug |
	size := anArray basicSize.
	aSymbol arity = size ifFalse: [^self error: 'incorrect arity'].
	cm := self _cachedLookup: aSymbol.
	cm == nil ifTrue: [^self doesNotUnderstand: aSymbol with: anArray].
	debug ifNotNil: [cm := cm debuggableCopy].
	cm prepareForExecution.
	anArray _expandInStackSized: size.
	^self _invoke: cm nativeCode
]

{ #category : #accessing }
ProtoObject >> primitiveAt: i [
	self _isSmallInteger ifTrue: [^self shouldNotImplement].
	^self _isBytes
		ifTrue: [self basicByteAt: i]
		ifFalse: [self basicObjectAt: i]
]

{ #category : #underprimitives }
ProtoObject >> primitiveSize [
	| size |
	self _isSmallInteger ifTrue: [^0].
	self _isArrayed ifFalse: [^0].
	size := self _size.
	^self _hasNamedSlots ifTrue: [size - self class instSize] ifFalse: [size]
]

{ #category : #printing }
ProtoObject >> printOn: aStream [
	| string article |
	string := self class name.
	article := string first isVowel ifTrue: ['an '] ifFalse: ['a '].
	aStream nextPutAll: article; nextPutAll: string
]

{ #category : #printing }
ProtoObject >> printString [
	| stream |
	stream := '' writeStream.
	self printOn: stream.
	^stream contents
]

{ #category : #finalization }
ProtoObject >> requireFinalization [
	self finalizationRegistry add: self
]

{ #category : #testing }
ProtoObject >> requiresFinalization [
	^self finalizationRegistry includes: self
]

{ #category : #interrupts }
ProtoObject >> signalStep [
	ActiveProcess handleStepSignal
]

{ #category : #interrupts }
ProtoObject >> signalStep: aSymbol [
	ActiveProcess handleStepSignal
]

{ #category : #underprimitives }
ProtoObject >> smallOop [
	^self _asPointer
]

{ #category : #system }
ProtoObject >> yourself [
	^self
]

