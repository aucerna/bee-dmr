"
    Copyright (c) 2020 LabWare.
    See (MIT) license in root directory.
"

Class {
	#name : #Kernel,
	#superclass : #Module,
	#instVars : [
		'runtime'
	],
	#category : #Kernel
}

{ #category : #initializing }
Kernel >> bootstrap [
	WordSizeShift := WordSize = 8 ifTrue: [3] ifFalse: [2].
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
	GlobalDispatchCache initialize.
	StarToken initializeCurrent.
	Unicode allSubclasses do: [:c | c initializeCurrent].
	Smalltalk := SmalltalkSystem new globals: exports.
]

{ #category : #initializing }
Kernel >> declaredGlobals [
	^#( #ActiveProcess #ActiveLocale #ByteCharacters #CharacterConstants
		#FrameMarker #KernelLibrary #NamedPrimitives #ProcessFrameOffsets
		#Processor #Smalltalk #UnresolvedObjects #UserLibrary #WordSizeShift
		#Lookup #LookupCode #LookupSuper #LookupSuperCode #Invoke #InvokeCode #WriteBarrier)
]

Kernel >> entry: argc argv: argv [
	<callback: long (long, pointer)>
	"^Smalltalk startSession"
	^Kernel new foo.

]

Kernel >> foo [
	| result |
	"self _halt."
	"#(1 2 3 4 5) do: [:i | result := i]."
	result := 42 factorial "0x10000000000000000 * 1".
	^result = 0x3C1581D491B28F523C23ABDF35B689C908000000000 ifTrue: [1] ifFalse: [0]
]


