Class {
	#name : #GCSpace,
	#superclass : #Object,
	#instVars : [
		'#base',
		'#commitedLimit',
		'#nextFree',
		'#reservedLimit',
		'#softLimit',
		'#prev',
		'#mutex'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
GCSpace class >> copyFrom: aGCSpace [
	^self new copyFrom: aGCSpace
]

{ #category : #'instance creation' }
GCSpace class >> from: anImageSegment [
	^self new
]

{ #category : #'instance creation' }
GCSpace class >> newAt: base limit: limit [
	^self new base: base; commitedLimit: limit
]

{ #category : #'instance creation' }
GCSpace class >> newAtAddress: address size: size [
	| p |
]

{ #category : #'instance creation' }
GCSpace class >> reservedAt: address sized: size [
	| space |
]

{ #category : #enumeration }
GCSpace >> addInstancesOf: aSpecies into: result [
	"
]

{ #category : #enumeration }
GCSpace >> addMarkedInstancesOf: aSpecies into: result [
	"
]

{ #category : #enumeration }
GCSpace >> addReferencesTo: anObject into: aCollection [
	"
]

{ #category : #actions }
GCSpace >> allocateIfPossible: size [
	| answer |
]

{ #category : #actions }
GCSpace >> allocateUnsafe: size [
	| answer |
]

{ #category : #asserting }
GCSpace >> assert: aBoolean [
	aBoolean ifFalse: [self _halt]
]

{ #category : #accessing }
GCSpace >> available [
	^softLimit - nextFree
]

{ #category : #accessing }
GCSpace >> availableBytes [
	^self available * 2
]

{ #category : #accessing }
GCSpace >> base [
	^base
]

{ #category : #accessing }
GCSpace >> base: baseAddress [
	base := baseAddress.
]

{ #category : #actions }
GCSpace >> commit: bytes [
	| size result |
]

{ #category : #actions }
GCSpace >> commitAtLeast: bytes [
	| padding size |
]

{ #category : #accessing }
GCSpace >> commitedLimit [
	^commitedLimit
]

{ #category : #accessing }
GCSpace >> commitedLimit: anInteger [
	commitedLimit := anInteger.
]

{ #category : #accessing }
GCSpace >> commitedSize [
	^commitedLimit - base
]

{ #category : #actions }
GCSpace >> commitMoreMemory [
	| newLimit padding |
]

{ #category : #actions }
GCSpace >> commitSized: size [
	| result |
]

{ #category : #actions }
GCSpace >> copyFrom: space [
	softLimit := space softLimit.
]

{ #category : #accessing }
GCSpace >> dataBase [
	^base * 2
]

{ #category : #accessing }
GCSpace >> dataBase: address size: anInteger [
	| p |
]

{ #category : #accessing }
GCSpace >> dataSize [
	^reservedLimit - base * 2
]

{ #category : #actions }
GCSpace >> deepCopy: object [
	| copy class ivars |
]

{ #category : #actions }
GCSpace >> dispenseReservedSpace [
	softLimit := commitedLimit
]

{ #category : #accessing }
GCSpace >> finalize [
	| success |
]

{ #category : #accessing }
GCSpace >> histogram [
	| sizes |
]

{ #category : #accessing }
GCSpace >> histogramInto: sizes [
	self objectsDo: [:object | | size association |
]

{ #category : #testing }
GCSpace >> includes: anObject [
	^anObject _isSmallInteger not
]

{ #category : #initialization }
GCSpace >> initialize [
	self initializeMutex
]

{ #category : #initialization }
GCSpace >> initializeMutex [
	mutex := #[16rFF 16rFF 16rFF 16rFF] shallowCopy
]

{ #category : #testing }
GCSpace >> isReferredBy: object [
	| max |
]

{ #category : #actions }
GCSpace >> leaveDispenseSpace [
	self leaveDispenseSpace: 4096
]

{ #category : #actions }
GCSpace >> leaveDispenseSpace: anInteger [
	self softLimit: self commitedLimit - anInteger
]

{ #category : #actions }
GCSpace >> lock [
	mutex _busyWait
]

{ #category : #actions }
GCSpace >> lockedAllocateIfPossible: size [
	| answer next |
]

{ #category : #actions }
GCSpace >> lockedAllocateUnsafe: size [
	| answer |
]

{ #category : #enumeration }
GCSpace >> make: anObject become: anotherObject [
	"
]

{ #category : #enumeration }
GCSpace >> markedDo: aBlock [
	self
]

{ #category : #actions }
GCSpace >> newExtendedArray: size [
	^self shallowCopy: #() growingTo: size
]

{ #category : #accessing }
GCSpace >> nextFree [
	^nextFree
]

{ #category : #accessing }
GCSpace >> nextFree: anInteger [
	nextFree := anInteger
]

{ #category : #enumeration }
GCSpace >> objectsDo: aBlock [
	| objectBase object endOop |
]

{ #category : #accessing }
GCSpace >> percentageOfCommitedUsed [
	^self used * 100 // self commitedSize
]

{ #category : #accessing }
GCSpace >> percentageOfReservedUsed [
	^self used * 100 // self reservedSize
]

{ #category : #accessing }
GCSpace >> prevAddress [
	^prev
]

{ #category : #accessing }
GCSpace >> prevAddress: address [
	prev := address
]

{ #category : #actions }
GCSpace >> printOn: stream [
	| commited reserved used |
]

{ #category : #actions }
GCSpace >> release [
	mutex _release
]

{ #category : #accessing }
GCSpace >> reservedLimit [
	^reservedLimit
]

{ #category : #accessing }
GCSpace >> reservedLimit: anInteger [
	reservedLimit := anInteger
]

{ #category : #accessing }
GCSpace >> reservedSize [
	^reservedLimit - base
]

{ #category : #actions }
GCSpace >> reset [
	nextFree := base
]

{ #category : #actions }
GCSpace >> shallowCopy: object [
	| size extra allocation oop copy |
]

{ #category : #actions }
GCSpace >> shallowCopy: array growingTo: newSize [
	| headerSize total buffer copy |
]

{ #category : #accessing }
GCSpace >> size [
	^reservedLimit - base
]

{ #category : #accessing }
GCSpace >> softAvailable [
	^softLimit - nextFree
]

{ #category : #accessing }
GCSpace >> softLimit [
	^softLimit
]

{ #category : #accessing }
GCSpace >> softLimit: ptr [
	softLimit := ptr
]

{ #category : #enumeration }
GCSpace >> unmarkAll [
	self objectsDo: [:object | object _beUnseen]
]

{ #category : #enumeration }
GCSpace >> unmarkedDo: aBlock [
	self
]

{ #category : #accessing }
GCSpace >> used [
	^nextFree - base
]

{ #category : #accessing }
GCSpace >> usedBytes [
	^nextFree - base * 2
]

{ #category : #accessing }
GCSpace >> usedBytes: used [
	nextFree := base + (used / 2)
]

{ #category : #actions }
GCSpace >> wipeOut [
	base _asObject _zeroSlots: (self used bitShift: 0 - WordSizeShift + 1)
]
