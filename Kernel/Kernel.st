"
    Copyright (c) 2022 Javier Pimás.
    Copyright (c) 2020 LabWare.
    See (MIT) license in root directory.
"

Class {
	#name : #Kernel,
	#superclass : #Module,
	#instVars : [
		'memory'
	],
	#category : #Kernel
}


{ #category : #initializing }
Kernel >> initialize [
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
	self initializeMemory.
]


Kernel >> entry: argc argv: argv [
	<callback: long (long, pointer)>
	"^Smalltalk startSession"
	^Kernel new foo.

]

{ #category : #initialization }
Kernel >> initializeMemory [
	| kernel rs |
	kernel := GCSpace new.
	rs := CriticalArray on: (Array new: 16 * 1024).
	memory := Memory new
		addSpace: kernel;
		fromSpace: kernel;
		eden: kernel;
		rememberedSet: rs.
]

{ #category : #accessing }
SmalltalkSystem >> memory [
	^memory
]

Kernel >> foo [
	| result |
	"self _halt."
	"#(1 2 3 4 5) do: [:i | result := i]."
	result := 42 factorial "0x10000000000000000 * 1".
	^result = 0x3C1581D491B28F523C23ABDF35B689C908000000000 ifTrue: [1] ifFalse: [0]
]


