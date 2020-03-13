"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #IMAGE_FILE_HEADER,
	#superclass : #PEFileStructure,
	#classVars : [
		'#Constants',
		'#Offsets'
	],
	#category : #PE
}

{ #category : #inspecting }
IMAGE_FILE_HEADER class >> aspects [
	^(super aspects , #(pointerToSymbolTableHex characteristics)
		copyWithout: #Characteristics)
		copyWithout: #PointerToSymbolTable
]

{ #category : #accessing }
IMAGE_FILE_HEADER class >> def [
	^<def>
	typedef struct _IMAGE_FILE_HEADER {
		WORD  Machine;
		WORD  NumberOfSections;
		DWORD TimeDateStamp;
		DWORD PointerToSymbolTable;
		DWORD NumberOfSymbols;
		WORD  SizeOfOptionalHeader;
		WORD  Characteristics;
	} IMAGE_FILE_HEADER, *PIMAGE_FILE_HEADER;
	</def>
]

{ #category : #initialization }
IMAGE_FILE_HEADER class >> defaultCharacteristicsAMD64 [
	^IMAGE_FILE_EXECUTABLE_IMAGE | IMAGE_FILE_LARGE_ADDRESS_AWARE
]

{ #category : #initialization }
IMAGE_FILE_HEADER class >> defaultCharacteristicsI386 [
	^IMAGE_FILE_EXECUTABLE_IMAGE | IMAGE_FILE_32BIT_MACHINE
]

{ #category : #'instance creation' }
IMAGE_FILE_HEADER class >> from: aPeFileModel [
	^self new from: aPeFileModel
]

{ #category : #'instance creation' }
IMAGE_FILE_HEADER class >> fromStream: aStream [
	| data |
	data := aStream next: self sizeInBytes.
	^self usingBytes: data
]

{ #category : #initialization }
IMAGE_FILE_HEADER class >> initializeConstants [
	"
	self initializeConstants
	"
	Constants isNil ifTrue: [Constants := PoolDictionary new].
	Constants
		at: 'IMAGE_FILE_EXECUTABLE_IMAGE' put: 0x2;
		at: 'IMAGE_FILE_32BIT_MACHINE' put: 0x100;
		at: 'IMAGE_FILE_LARGE_ADDRESS_AWARE' put: 0x20
]

{ #category : #private }
IMAGE_FILE_HEADER class >> machineFlagAMD64 [
	^16r8664
]

{ #category : #private }
IMAGE_FILE_HEADER class >> machineFlagI386 [
	^16r14C
]

{ #category : #accessing }
IMAGE_FILE_HEADER class >> sizeInBytes [
	^sizeInBytes
]

{ #category : #printing }
IMAGE_FILE_HEADER >> addValidationSelectorsTo: aCollection [
	super addValidationSelectorsTo: aCollection.
	aCollection add: #coffValidation
]

{ #category : #initialization }
IMAGE_FILE_HEADER >> beDLL [
	| {IMAGE_FILE_DLL} new |
	{IMAGE_FILE_DLL} := 16r2000.
	new := self Characteristics bitOr: {IMAGE_FILE_DLL}.
	self Characteristics: new
]

{ #category : #initialization }
IMAGE_FILE_HEADER >> beExecutableImage [
	| new |
	{IMAGE_FILE_EXECUTABLE_IMAGE} := 16r2.
	new := self Characteristics bitOr: {IMAGE_FILE_EXECUTABLE_IMAGE}.
	self Characteristics: new
]

{ #category : #printing }
IMAGE_FILE_HEADER >> characteristics [
	^self flags: self Characteristics using: self class characteristics
]

{ #category : #accessing }
IMAGE_FILE_HEADER >> Characteristics [
	^self uShortAtOffset: Characteristics
]

{ #category : #accessing }
IMAGE_FILE_HEADER >> Characteristics: anInteger [
	self uShortAtOffset: Characteristics put: anInteger
]

{ #category : #private }
IMAGE_FILE_HEADER >> from: aPeFileModel [
	self
		Machine: aPeFileModel vExeMagic;
		NumberOfSections: aPeFileModel sections size;
		TimeDateStamp: aPeFileModel timestamp;
		PointerToSymbolTable: aPeFileModel symbolTablePosition;
		NumberOfSymbols: aPeFileModel symbolTableSize;
		SizeOfOptionalHeader: aPeFileModel sizeOfOptionalHeader;
		Characteristics: aPeFileModel flags
]

{ #category : #initialization }
IMAGE_FILE_HEADER >> initializeDefault: characteristics [
	self
		Characteristics: characteristics;
		TimeDateStamp: Timestamp now asUnixTime
]

{ #category : #initialization }
IMAGE_FILE_HEADER >> isDLL [
	| {IMAGE_FILE_DLL} |
	{IMAGE_FILE_DLL} := 16r2000.
	^self Characteristics anyMask: {IMAGE_FILE_DLL}
]

{ #category : #accessing }
IMAGE_FILE_HEADER >> Machine [
	^self uShortAtOffset: Machine
]

{ #category : #accessing }
IMAGE_FILE_HEADER >> Machine: anInteger [
	self uShortAtOffset: Machine put: anInteger
]

{ #category : #accessing }
IMAGE_FILE_HEADER >> machineId [
	| machine |
	machine := self Machine.
	machine = 16r1D3 ifTrue: [^'AM33'].
	machine = 16r8664 ifTrue: [^'AMD64'].
	machine = 16r1C0 ifTrue: [^'ARM'].
	machine = 16rEBC ifTrue: [^'EBC'].
	machine = 16r14C ifTrue: [^'I386'].
	machine = 16r200 ifTrue: [^'IA64'].
	machine = 16r9041 ifTrue: [^'M32R'].
	machine = 16r266 ifTrue: [^'MIPS16'].
	machine = 16r366 ifTrue: [^'MIPSFPU'].
	machine = 16r466 ifTrue: [^'MIPSFPU16'].
	machine = 16r1F0 ifTrue: [^'POWERPC'].
	machine = 16r1F1 ifTrue: [^'POWERPCFP'].
	machine = 16r166 ifTrue: [^'R4000'].
	machine = 16r1A2 ifTrue: [^'SH3'].
	machine = 16r1A4 ifTrue: [^'SH3E'].
	machine = 16r1A3 ifTrue: [^'SH3DSP'].
	machine = 16r1A6 ifTrue: [^'SH4'].
	machine = 16r1A8 ifTrue: [^'SH5'].
	machine = 16r1C2 ifTrue: [^'THUMB'].
	machine = 16r169 ifTrue: [^'WCEMIPSV2'].
	machine = 16r162 ifTrue: [^'R3000'].
	machine = 16r168 ifTrue: [^'R10000'].
	machine = 16r184 ifTrue: [^'ALPHA'].
	machine = 16r284 ifTrue: [^'ALPHA64'].
	machine = 16rC0EE ifTrue: [^'CEE'].
	machine = 16r520 ifTrue: [^'TRICORE'].
	machine = 16rCEF ifTrue: [^'CEF']
]

{ #category : #accessing }
IMAGE_FILE_HEADER >> NumberOfSections [
	^self uShortAtOffset: NumberOfSections
]

{ #category : #accessing }
IMAGE_FILE_HEADER >> NumberOfSections: anInteger [
	self uShortAtOffset: NumberOfSections put: anInteger
]

{ #category : #accessing }
IMAGE_FILE_HEADER >> NumberOfSymbols [
	^self uLongAtOffset: NumberOfSymbols
]

{ #category : #accessing }
IMAGE_FILE_HEADER >> NumberOfSymbols: anInteger [
	self uLongAtOffset: NumberOfSymbols put: anInteger
]

{ #category : #accessing }
IMAGE_FILE_HEADER >> PointerToSymbolTable [
	^self uLongAtOffset: PointerToSymbolTable
]

{ #category : #accessing }
IMAGE_FILE_HEADER >> PointerToSymbolTable: anInteger [
	self uLongAtOffset: PointerToSymbolTable put: anInteger
]

{ #category : #accessing }
IMAGE_FILE_HEADER >> pointerToSymbolTableHex [
	^'0x' , self PointerToSymbolTable hex
]

{ #category : #accessing }
IMAGE_FILE_HEADER >> SizeOfOptionalHeader [
	^self uShortAtOffset: SizeOfOptionalHeader
]

{ #category : #accessing }
IMAGE_FILE_HEADER >> SizeOfOptionalHeader: anInteger [
	self uShortAtOffset: SizeOfOptionalHeader put: anInteger
]

{ #category : #accessing }
IMAGE_FILE_HEADER >> TimeDateStamp [
	^self uLongAtOffset: TimeDateStamp
]

{ #category : #accessing }
IMAGE_FILE_HEADER >> TimeDateStamp: anInteger [
	self uLongAtOffset: TimeDateStamp put: anInteger
]

{ #category : #accessing }
IMAGE_FILE_HEADER >> timestamp [
	^self TimeDateStamp
]

{ #category : #accessing }
IMAGE_FILE_HEADER >> useAMD64Machine [
	self Machine: self class machineFlagAMD64
]

