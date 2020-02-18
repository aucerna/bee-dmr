Class {
	#name : #ProtoObject,
	#superclass : nil,
	#classVars : [
		'#ObjectBitsMasks',
		'#ObjectFieldsOffset'
	],
	#category : #Kernel
}


{ #category : #initialization }
ProtoObject class >> initializeBitMasks [
	"
]

{ #category : #initialization }
ProtoObject class >> initializeConstants [
	"
]

{ #category : #testing }
ProtoObject class >> isUndermethod: aSelector [
	^self undermethodSelectors includes: aSelector
]

{ #category : #'instance creation' }
ProtoObject class >> new [
	^self basicNew initialize
]

{ #category : #private }
ProtoObject class >> staticSelectors [
	"
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

{ #category : #underprimitives }
ProtoObject >> _basicAt: anInteger [
	^self basicAt: anInteger
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
]

{ #category : #'header access' }
ProtoObject >> _copyHeaderSized: byteSize from: anObject [
	byteSize = 16 ifTrue: [
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

{ #category : #underprimitives }
ProtoObject >> _highHalf [
	^self _oop bitShift: WordSize * 8 / -2
]

{ #category : #lookup }
ProtoObject >> _invoke: aNativeCode [
	"
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

{ #category : #underprimitives }
ProtoObject >> _isSmallInteger [
	^false
]

{ #category : #'header access' }
ProtoObject >> _isSpecial [
	^(self _basicFlags bitAnd: IsSpecial) = IsSpecial
]

{ #category : #'header access' }
ProtoObject >> _largeSize: size [
	self _basicULongAt: _ExtendedSize put: size _asNative
]

{ #category : #lookup }
ProtoObject >> _lookup: aSymbol [
	^self _lookup: aSymbol in: self behavior
]

{ #category : #lookup }
ProtoObject >> _lookup: aSymbol in: behavior [
	| methods cm next |
]

{ #category : #lookup }
ProtoObject >> _lookup: aSymbol inDictionary: methodDictionary [
	| table |
]

{ #category : #underprimitives }
ProtoObject >> _low32 [
	^WordSize > 4 ifTrue: [self bitAnd: 0xFFFFFFFF] ifFalse: [self]
]

{ #category : #underprimitives }
ProtoObject >> _lowHalf [
	^self _oop bitAnd: 16rFFFF
]

{ #category : #'header access' }
ProtoObject >> _makeExtendedSize: size [
	self
]

{ #category : #'header access' }
ProtoObject >> _nextBasePointer [
	^self _asPointer + self _sizeInBytes _asPointer
]

{ #category : #'header access' }
ProtoObject >> _objectFromBasePointer [
	| offset |
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
]

{ #category : #'header access' }
ProtoObject >> _size [
	^self _isSmall ifTrue: [self _smallSize] ifFalse: [self _largeSize]
]

{ #category : #'header access' }
ProtoObject >> _sizeInBytes [
	| total |
]

{ #category : #'header access' }
ProtoObject >> _strongPointersSize [
	^(self _isBytes or: [self _isSpecial]) ifTrue: [0] ifFalse: [0 + self _size]
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
]

{ #category : #system }
ProtoObject >> basicHash: anInteger [
	self _basicHash: anInteger
]

{ #category : #private }
ProtoObject >> basicInstVarAt: index [
	| max |
]

{ #category : #private }
ProtoObject >> basicInstVarAt: index put: anObject [
	| max |
]

{ #category : #private }
ProtoObject >> basicSize [
	^self primitiveSize
]

{ #category : #services }
ProtoObject >> become: anotherObject [
	Memory current make: self become: anotherObject
]

{ #category : #'meta accessing' }
ProtoObject >> behavior [
	^self _isSmallInteger
]

{ #category : #'meta accessing' }
ProtoObject >> behavior: aBehavior [
	^self _isSmallInteger
]

{ #category : #system }
ProtoObject >> class [
	^self behavior classBinding
]

{ #category : #system }
ProtoObject >> doesNotUnderstand: aMessage [
	| stream |
]

{ #category : #private }
ProtoObject >> doesNotUnderstandSelector: selector [
	| arguments message |
]

{ #category : #errors }
ProtoObject >> error: aString [
	^Error signal: aString
]

{ #category : #errors }
ProtoObject >> error: message title: title resumable: resumable [
	| type result text caption |
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
	^self class _instancesAreArrayed
]

{ #category : #private }
ProtoObject >> holdRefererIfNeeded: referent [
	| memory |
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
]

{ #category : #finalization }
ProtoObject >> ignoreFinalization [
	self finalizationRegistry remove: self ifAbsent: nil
]

{ #category : #'header access' }
ProtoObject >> initializeExtended: aBoolean contentSize: size [
	self _basicULongAt: -1 put: 0 _asNative.
]

{ #category : #system }
ProtoObject >> instVarAt: i [
	self _isSmallInteger ifTrue: [^self shouldNotImplement].
]

{ #category : #system }
ProtoObject >> instVarAt: i put: anObject [
	self _isSmallInteger ifTrue: [^self shouldNotImplement].
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

{ #category : #lookup }
ProtoObject >> lookupAndInvoke: aSymbol [
	| cm |
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
	anObject holdRefererIfNeeded: self.
]

{ #category : #system }
ProtoObject >> perform: aSymbol [
	aSymbol arity = 0 ifFalse: [^self error: 'incorrect arity'].
]

{ #category : #system }
ProtoObject >> perform: aSymbol with: anObject [
	^self perform: aSymbol withArguments: {anObject}
]

{ #category : #system }
ProtoObject >> perform: aSymbol withArguments: anArray [
	| size |
]

{ #category : #accessing }
ProtoObject >> primitiveAt: i [
	self _isSmallInteger ifTrue: [^self shouldNotImplement].
]

{ #category : #underprimitives }
ProtoObject >> primitiveSize [
	| size |
]

{ #category : #printing }
ProtoObject >> printOn: aStream [
	| string article |
]

{ #category : #printing }
ProtoObject >> printString [
	| stream |
]

{ #category : #finalization }
ProtoObject >> requireFinalization [
	self finalizationRegistry add: self
]

{ #category : #testing }
ProtoObject >> requiresFinalization [
	^self finalizationRegistry includes: self
]

{ #category : #private }
ProtoObject >> shouldBeInRememberedSet [
	| m |
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
