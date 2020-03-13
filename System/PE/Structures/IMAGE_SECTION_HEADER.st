"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #IMAGE_SECTION_HEADER,
	#superclass : #PEFileStructure,
	#classVars : [
		'#Constants',
		'#Offsets'
	],
	#category : #PE
}

{ #category : #accessing }
IMAGE_SECTION_HEADER class >> aspects [
	^#(name) , super aspects copyWithout: #Name
]

{ #category : #accessing }
IMAGE_SECTION_HEADER class >> def [
	^<def>
	typedef struct _IMAGE_SECTION_HEADER {
		BYTE  Name[IMAGE_SIZEOF_SHORT_NAME];
		union {
			DWORD PhysicalAddress;
			DWORD VirtualSize;
		} Misc;
		DWORD VirtualAddress;
		DWORD SizeOfRawData;
		DWORD PointerToRawData;
		DWORD PointerToRelocations;
		DWORD PointerToLinenumbers;
		WORD  NumberOfRelocations;
		WORD  NumberOfLinenumbers;
		DWORD Characteristics;
	} IMAGE_SECTION_HEADER, *PIMAGE_SECTION_HEADER;
	</def>
]

{ #category : #initialization }
IMAGE_SECTION_HEADER class >> initializeConstants [
	Constants isNil ifTrue: [Constants := PoolDictionary new].
	Constants
		at: 'IMAGE_SCN_TYPE_NO_PAD' put: 8;
		at: 'IMAGE_SCN_CNT_CODE' put: 32;
		at: 'IMAGE_SCN_CNT_INITIALIZED_DATA' put: 64;
		at: 'IMAGE_SCN_CNT_UNINITIALIZED_DATA' put: 128;
		at: 'IMAGE_SCN_LNK_OTHER' put: 256;
		at: 'IMAGE_SCN_LNK_INFO' put: 512;
		at: 'IMAGE_SCN_LNK_REMOVE' put: 2048;
		at: 'IMAGE_SCN_LNK_COMDAT' put: 4096;
		at: 'IMAGE_SCN_MEM_FARDATA	' put: 32768;
		at: 'IMAGE_SCN_MEM_PURGEABLE' put: 131072;
		at: 'IMAGE_SCN_MEM_16BIT' put: 131072;
		at: 'IMAGE_SCN_MEM_LOCKED' put: 262144;
		at: 'IMAGE_SCN_MEM_PRELOAD' put: 524288;
		at: 'IMAGE_SCN_ALIGN_1BYTES' put: 1048576;
		at: 'IMAGE_SCN_ALIGN_2BYTES' put: 2097152;
		at: 'IMAGE_SCN_ALIGN_4BYTES' put: 3145728;
		at: 'IMAGE_SCN_ALIGN_8BYTES' put: 4194304;
		at: 'IMAGE_SCN_ALIGN_16BYTES' put: 5242880;
		at: 'IMAGE_SCN_ALIGN_32BYTES' put: 6291456;
		at: 'IMAGE_SCN_ALIGN_64BYTES' put: 7340032;
		at: 'IMAGE_SCN_ALIGN_128BYTES' put: 8388608;
		at: 'IMAGE_SCN_ALIGN_256BYTES' put: 9437184;
		at: 'IMAGE_SCN_ALIGN_512BYTES' put: 10485760;
		at: 'IMAGE_SCN_ALIGN_1024BYTES' put: 11534336;
		at: 'IMAGE_SCN_ALIGN_2048BYTES' put: 12582912;
		at: 'IMAGE_SCN_ALIGN_4096BYTES' put: 13631488;
		at: 'IMAGE_SCN_ALIGN_8192BYTES' put: 14680064;
		at: 'IMAGE_SCN_ALIGN_MASK' put: 15728640;
		at: 'IMAGE_SCN_LNK_NRELOC_OVFL' put: 16777216;
		at: 'IMAGE_SCN_MEM_DISCARDABLE' put: 33554432;
		at: 'IMAGE_SCN_MEM_NOT_CACHED' put: 67108864;
		at: 'IMAGE_SCN_MEM_NOT_PAGED' put: 134217728;
		at: 'IMAGE_SCN_MEM_SHARED' put: 268435456;
		at: 'IMAGE_SCN_MEM_EXECUTE' put: 536870912;
		at: 'IMAGE_SCN_MEM_READ' put: 1073741824;
		at: 'IMAGE_SCN_MEM_WRITE' put: 2147483648
]

{ #category : #accessing }
IMAGE_SECTION_HEADER class >> sizeInBytes [
	^sizeInBytes
]

{ #category : #private }
IMAGE_SECTION_HEADER >> addCharacteristic: anInteger [
	| characteristics |
	characteristics := self Characteristics bitOr: anInteger.
	self Characteristics: characteristics
]

{ #category : #input }
IMAGE_SECTION_HEADER >> beCode [
	self addCharacteristic: IMAGE_SCN_CNT_CODE
]

{ #category : #input }
IMAGE_SECTION_HEADER >> beExecutable [
	self addCharacteristic: IMAGE_SCN_MEM_EXECUTE
]

{ #category : #input }
IMAGE_SECTION_HEADER >> beInitializedData [
	self addCharacteristic: IMAGE_SCN_CNT_INITIALIZED_DATA
]

{ #category : #input }
IMAGE_SECTION_HEADER >> beReadable [
	self addCharacteristic: IMAGE_SCN_MEM_READ
]

{ #category : #input }
IMAGE_SECTION_HEADER >> beUninitializedData [
	self addCharacteristic: IMAGE_SCN_CNT_UNINITIALIZED_DATA
]

{ #category : #input }
IMAGE_SECTION_HEADER >> beWritable [
	self addCharacteristic: IMAGE_SCN_MEM_WRITE
]

{ #category : #input }
IMAGE_SECTION_HEADER >> beWritableCode [
	self
		beCode;
		beExecutable;
		beReadable;
		beWritable
]

{ #category : #accessing }
IMAGE_SECTION_HEADER >> Characteristics [
	^self uLongAtOffset: Characteristics
]

{ #category : #accessing }
IMAGE_SECTION_HEADER >> Characteristics: anInteger [
	self uLongAtOffset: Characteristics put: anInteger
]

{ #category : #private }
IMAGE_SECTION_HEADER >> characteristics: mask set: aBoolean [
	| characteristics |
	characteristics := aBoolean
		ifTrue: [self Characteristics bitOr: mask]
		ifFalse: [self Characteristics bitAnd: mask bitInvert].
	self Characteristics: characteristics
]

{ #category : #private }
IMAGE_SECTION_HEADER >> characteristicsGet: mask [
	^self Characteristics anyMask: mask
]

{ #category : #output }
IMAGE_SECTION_HEADER >> hasCode [
	^self characteristicsGet: 16r20
]

{ #category : #output }
IMAGE_SECTION_HEADER >> hasInitializedData [
	^self characteristicsGet: 16r40
]

{ #category : #output }
IMAGE_SECTION_HEADER >> hasUninitializedData [
	^self characteristicsGet: 16r80
]

{ #category : #accessing }
IMAGE_SECTION_HEADER >> name [
	^self Name asString trimNullEnd
]

{ #category : #accessing }
IMAGE_SECTION_HEADER >> Name [
	^self bytesAtOffset: Name count: IMAGE_SIZEOF_SHORT_NAME
]

{ #category : #accessing }
IMAGE_SECTION_HEADER >> Name: anInteger [
	self bytesAtOffset: Name put: anInteger
]

{ #category : #input }
IMAGE_SECTION_HEADER >> name: aString [
	| bytes |
	bytes := ByteArray new: IMAGE_SIZEOF_SHORT_NAME.
	bytes replaceFirst: aString size with: aString.
	self Name: bytes
]

{ #category : #accessing }
IMAGE_SECTION_HEADER >> NumberOfLinenumbers [
	^self uShortAtOffset: NumberOfLinenumbers
]

{ #category : #accessing }
IMAGE_SECTION_HEADER >> NumberOfLinenumbers: anInteger [
	self uShortAtOffset: NumberOfLinenumbers put: anInteger
]

{ #category : #accessing }
IMAGE_SECTION_HEADER >> NumberOfRelocations [
	^self uShortAtOffset: NumberOfRelocations
]

{ #category : #accessing }
IMAGE_SECTION_HEADER >> NumberOfRelocations: anInteger [
	self uShortAtOffset: NumberOfRelocations put: anInteger
]

{ #category : #accessing }
IMAGE_SECTION_HEADER >> PhysicalAddress [
	^self uLongAtOffset: PhysicalAddress
]

{ #category : #accessing }
IMAGE_SECTION_HEADER >> PhysicalAddress: anInteger [
	self uLongAtOffset: PhysicalAddress put: anInteger
]

{ #category : #accessing }
IMAGE_SECTION_HEADER >> PointerToLinenumbers [
	^self uLongAtOffset: PointerToLinenumbers
]

{ #category : #accessing }
IMAGE_SECTION_HEADER >> PointerToLinenumbers: anInteger [
	self uLongAtOffset: PointerToLinenumbers put: anInteger
]

{ #category : #accessing }
IMAGE_SECTION_HEADER >> PointerToRawData [
	^self uLongAtOffset: PointerToRawData
]

{ #category : #accessing }
IMAGE_SECTION_HEADER >> PointerToRawData: anInteger [
	self uLongAtOffset: PointerToRawData put: anInteger
]

{ #category : #accessing }
IMAGE_SECTION_HEADER >> PointerToRelocations [
	^self uLongAtOffset: PointerToRelocations
]

{ #category : #accessing }
IMAGE_SECTION_HEADER >> PointerToRelocations: anInteger [
	self uLongAtOffset: PointerToRelocations put: anInteger
]

{ #category : #output }
IMAGE_SECTION_HEADER >> sizeOfInitializedData [
	^self SizeOfRawData
]

{ #category : #accessing }
IMAGE_SECTION_HEADER >> SizeOfRawData [
	^self uLongAtOffset: SizeOfRawData
]

{ #category : #accessing }
IMAGE_SECTION_HEADER >> SizeOfRawData: anInteger [
	self uLongAtOffset: SizeOfRawData put: anInteger
]

{ #category : #output }
IMAGE_SECTION_HEADER >> sizeOfUninitializedData [
	^self VirtualSize - self SizeOfRawData max: 0
]

{ #category : #output }
IMAGE_SECTION_HEADER >> storeOn: aStream at: address [
	aStream position: address.
	self storeOn: aStream
]

{ #category : #accessing }
IMAGE_SECTION_HEADER >> VirtualAddress [
	^self uLongAtOffset: VirtualAddress
]

{ #category : #accessing }
IMAGE_SECTION_HEADER >> VirtualAddress: anInteger [
	self uLongAtOffset: VirtualAddress put: anInteger
]

{ #category : #accessing }
IMAGE_SECTION_HEADER >> VirtualSize [
	^self uLongAtOffset: VirtualSize
]

{ #category : #accessing }
IMAGE_SECTION_HEADER >> VirtualSize: anInteger [
	self uLongAtOffset: VirtualSize put: anInteger
]

