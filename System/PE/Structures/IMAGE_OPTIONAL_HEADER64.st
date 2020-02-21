Class {
	#name : #IMAGE_OPTIONAL_HEADER64,
	#superclass : #IMAGE_OPTIONAL_HEADER,
	#classVars : [
		'#Offsets'
	],
	#category : #PE
}

{ #category : #private }
IMAGE_OPTIONAL_HEADER64 class >> def [
	^<def>
	typedef struct _IMAGE_OPTIONAL_HEADER64 {
		WORD        Magic;
		BYTE        MajorLinkerVersion;
		BYTE        MinorLinkerVersion;
		DWORD       SizeOfCode;
		DWORD       SizeOfInitializedData;
		DWORD       SizeOfUninitializedData;
		DWORD       AddressOfEntryPoint;
		DWORD       BaseOfCode;
		ULONGLONG   ImageBase;
		DWORD       SectionAlignment;
		DWORD       FileAlignment;
		WORD        MajorOperatingSystemVersion;
		WORD        MinorOperatingSystemVersion;
		WORD        MajorImageVersion;
		WORD        MinorImageVersion;
		WORD        MajorSubsystemVersion;
		WORD        MinorSubsystemVersion;
		DWORD      		Win32VersionValue;
		DWORD       SizeOfImage;
		DWORD       SizeOfHeaders;
		DWORD       CheckSum;
		WORD        Subsystem;
		WORD        DllCharacteristics;
		ULONGLONG   SizeOfStackReserve;
		ULONGLONG   SizeOfStackCommit;
		ULONGLONG   SizeOfHeapReserve;
		ULONGLONG   SizeOfHeapCommit;
		DWORD       LoaderFlags;
		DWORD       NumberOfRvaAndSizes;
		IMAGE_DATA_DIRECTORY DataDirectory[IMAGE_NUMBEROF_DIRECTORY_ENTRIES];
	} IMAGE_OPTIONAL_HEADER64, *PIMAGE_OPTIONAL_HEADER64;
	</def>
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 class >> defaultMagic [
	^self magicPE32Plus
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 class >> sizeInBytes [
	^sizeInBytes
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> AddressOfEntryPoint [
	^self uLongAtOffset: AddressOfEntryPoint
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> AddressOfEntryPoint: anInteger [
	self uLongAtOffset: AddressOfEntryPoint put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> BaseOfCode [
	^self uLongAtOffset: BaseOfCode
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> BaseOfCode: anInteger [
	self uLongAtOffset: BaseOfCode put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> BaseOfData: anInteger [
	
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> CheckSum [
	^self uLongAtOffset: CheckSum
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> CheckSum: anInteger [
	self uLongAtOffset: CheckSum put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> DataDirectory [
	^self structureAtOffset: DataDirectory ofClass: IMAGE_DATA_DIRECTORY
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> DataDirectory: anIMAGE_DATA_DIRECTORY [
	self bytesAtOffset: DataDirectory put: anIMAGE_DATA_DIRECTORY asParameter
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> DllCharacteristics [
	^self uShortAtOffset: DllCharacteristics
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> DllCharacteristics: anInteger [
	self uShortAtOffset: DllCharacteristics put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> FileAlignment [
	^self uLongAtOffset: FileAlignment
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> FileAlignment: anInteger [
	self uLongAtOffset: FileAlignment put: anInteger
]

{ #category : #output }
IMAGE_OPTIONAL_HEADER64 >> imageBase [
	^self ImageBase asInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> ImageBase [
	^self structureAtOffset: ImageBase ofClass: LARGE_INTEGER
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> ImageBase: aLARGE_INTEGER [
	self bytesAtOffset: ImageBase put: aLARGE_INTEGER asParameter
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> LoaderFlags [
	^self uLongAtOffset: LoaderFlags
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> LoaderFlags: anInteger [
	self uLongAtOffset: LoaderFlags put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> Magic [
	^self uShortAtOffset: Magic
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> Magic: anInteger [
	self uShortAtOffset: Magic put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> MajorImageVersion [
	^self uShortAtOffset: MajorImageVersion
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> MajorImageVersion: anInteger [
	self uShortAtOffset: MajorImageVersion put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> MajorLinkerVersion [
	^self byteAtOffset: MajorLinkerVersion
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> MajorLinkerVersion: anInteger [
	self byteAtOffset: MajorLinkerVersion put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> MajorOperatingSystemVersion [
	^self uShortAtOffset: MajorOperatingSystemVersion
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> MajorOperatingSystemVersion: anInteger [
	self uShortAtOffset: MajorOperatingSystemVersion put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> MajorSubsystemVersion [
	^self uShortAtOffset: MajorSubsystemVersion
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> MajorSubsystemVersion: anInteger [
	self uShortAtOffset: MajorSubsystemVersion put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> MinorImageVersion [
	^self uShortAtOffset: MinorImageVersion
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> MinorImageVersion: anInteger [
	self uShortAtOffset: MinorImageVersion put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> MinorLinkerVersion [
	^self byteAtOffset: MinorLinkerVersion
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> MinorLinkerVersion: anInteger [
	self byteAtOffset: MinorLinkerVersion put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> MinorOperatingSystemVersion [
	^self uShortAtOffset: MinorOperatingSystemVersion
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> MinorOperatingSystemVersion: anInteger [
	self uShortAtOffset: MinorOperatingSystemVersion put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> MinorSubsystemVersion [
	^self uShortAtOffset: MinorSubsystemVersion
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> MinorSubsystemVersion: anInteger [
	self uShortAtOffset: MinorSubsystemVersion put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> NumberOfRvaAndSizes [
	^self uLongAtOffset: NumberOfRvaAndSizes
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> NumberOfRvaAndSizes: anInteger [
	self uLongAtOffset: NumberOfRvaAndSizes put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> SectionAlignment [
	^self uLongAtOffset: SectionAlignment
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> SectionAlignment: anInteger [
	self uLongAtOffset: SectionAlignment put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> SizeOfCode [
	^self uLongAtOffset: SizeOfCode
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> SizeOfCode: anInteger [
	self uLongAtOffset: SizeOfCode put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> SizeOfHeaders [
	^self uLongAtOffset: SizeOfHeaders
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> SizeOfHeaders: anInteger [
	self uLongAtOffset: SizeOfHeaders put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> SizeOfHeapCommit [
	^self structureAtOffset: SizeOfHeapCommit ofClass: LARGE_INTEGER
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> SizeOfHeapCommit: aLARGE_INTEGER [
	self bytesAtOffset: SizeOfHeapCommit put: aLARGE_INTEGER asParameter
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> SizeOfHeapReserve [
	^self structureAtOffset: SizeOfHeapReserve ofClass: LARGE_INTEGER
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> SizeOfHeapReserve: aLARGE_INTEGER [
	self bytesAtOffset: SizeOfHeapReserve put: aLARGE_INTEGER asParameter
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> SizeOfImage [
	^self uLongAtOffset: SizeOfImage
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> SizeOfImage: anInteger [
	self uLongAtOffset: SizeOfImage put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> SizeOfInitializedData [
	^self uLongAtOffset: SizeOfInitializedData
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> SizeOfInitializedData: anInteger [
	self uLongAtOffset: SizeOfInitializedData put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> SizeOfStackCommit [
	^self structureAtOffset: SizeOfStackCommit ofClass: LARGE_INTEGER
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> SizeOfStackCommit: aLARGE_INTEGER [
	self bytesAtOffset: SizeOfStackCommit put: aLARGE_INTEGER asParameter
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> SizeOfStackReserve [
	^self structureAtOffset: SizeOfStackReserve ofClass: LARGE_INTEGER
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> SizeOfStackReserve: aLARGE_INTEGER [
	self bytesAtOffset: SizeOfStackReserve put: aLARGE_INTEGER asParameter
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> SizeOfUninitializedData [
	^self uLongAtOffset: SizeOfUninitializedData
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> SizeOfUninitializedData: anInteger [
	self uLongAtOffset: SizeOfUninitializedData put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> Subsystem [
	^self uShortAtOffset: Subsystem
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> Subsystem: anInteger [
	self uShortAtOffset: Subsystem put: anInteger
]

{ #category : #input }
IMAGE_OPTIONAL_HEADER64 >> usePE32PlusMagic [
	self Magic: self class magicPE32Plus
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> Win32VersionValue [
	^self uLongAtOffset: Win32VersionValue
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER64 >> Win32VersionValue: anInteger [
	self uLongAtOffset: Win32VersionValue put: anInteger
]

