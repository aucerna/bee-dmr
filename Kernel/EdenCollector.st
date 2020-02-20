Class {
	#name : #EdenCollector,
	#superclass : #CopyingCollector,
	#instVars : [
		'#oldSpace',
		'#edenSpace',
		'#youngBase',
		'#youngLimit',
		'#rememberedSet',
		'#rememberedNext'
	],
	#category : #Kernel
}

{ #category : #cleaning }
EdenCollector >> copyToOld: object [
	| copy |
]

{ #category : #cleaning }
EdenCollector >> copyToTo: object [
	| copy |
]

{ #category : #cleaning }
EdenCollector >> doCollect [
	self rememberOldStacks; purgeRememberedSet.
]

{ #category : #cleaning }
EdenCollector >> doCopy: object [
	^object _isSecondGeneration
]

{ #category : #cleaning }
EdenCollector >> followNativeCodeObject: offset from: bytes [
	| object moved |
]

{ #category : #cleaning }
EdenCollector >> followRemembered: object at: index [
	"
]

{ #category : #cleaning }
EdenCollector >> forwardingIndexOf: anObject [
	^(anObject _asPointer - youngBase bitShift: 0 - WordSizeShift + 1) + 1
]

{ #category : #cleaning }
EdenCollector >> hasToPurge: object [
	"
]

{ #category : #cleaning }
EdenCollector >> initializeLocals [
	memory rememberedSet: (CriticalArray on: workSpace reserving: 1024).
]

{ #category : #cleaning }
EdenCollector >> newspaceIncludes: object [
	^object _asPointer between: youngBase and: youngLimit
]

{ #category : #cleaning }
EdenCollector >> newspaceIsRefererredByStack: aStackWrapper [
	aStackWrapper objectsDo: [:o | 
]

{ #category : #cleaning }
EdenCollector >> newspaceIsReferredBy: object [
	| max slot |
]

{ #category : #cleaning }
EdenCollector >> newspaceIsReferredByNativeCode: nativeCode [
	nativeCode isFresh ifFalse: [^false].
]

{ #category : #cleaning }
EdenCollector >> nextEden [
	^edenSpace
]

{ #category : #cleaning }
EdenCollector >> postInitialize [
	rememberedSet := memory rememberedSet.
]

{ #category : #cleaning }
EdenCollector >> purgeRememberedSet [
	| object kept |
]

{ #category : #cleaning }
EdenCollector >> remember: anObject [
	anObject _beRemembered.
]

{ #category : #cleaning }
EdenCollector >> rememberOldStacks [
	StackWrapper registeredInstances
]

{ #category : #cleaning }
EdenCollector >> rememberStackIfNeeded: stack [
	stack _isRemembered ifTrue: [^self].
]

{ #category : #cleaning }
EdenCollector >> restoreRememberedSet [
	"
]

{ #category : #cleaning }
EdenCollector >> scanBehavior: current [
	| behavior moved |
]

{ #category : #cleaning }
EdenCollector >> scanExternals [
	self scanRememberedSet
]

{ #category : #cleaning }
EdenCollector >> scanRememberedSet [
	[rememberedNext <= rememberedSet size] whileTrue: [| object |
]

{ #category : #cleaning }
EdenCollector >> scanThreadLocalStorage: thread [
	thread localStorageIndices do: [:index | | object moved |
]

{ #category : #ephemerons }
EdenCollector >> strenghtenAndMigrateEphemerons [
	| copy contents |
]

{ #category : #cleaning }
EdenCollector >> swapMemoryFromAndTo [
	"
]

{ #category : #cleaning }
EdenCollector >> unmarkAll [
	
]

{ #category : #cleaning }
EdenCollector >> unscannedExternalsRemain [
	^rememberedNext <= rememberedSet size
]

{ #category : #cleaning }
EdenCollector >> update: current at: index [
	"
]

{ #category : #cleaning }
EdenCollector >> validate [
	"
]

{ #category : #cleaning }
EdenCollector >> validate: anObject [
	"
]

{ #category : #private }
EdenCollector >> workSpaceSize [
	^edenSpace reservedSize * 3
]
