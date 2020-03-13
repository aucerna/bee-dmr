"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #IMAGE_OPTIONAL_HEADER32,
	#superclass : #IMAGE_OPTIONAL_HEADER,
	#classVars : [
		'#Offsets'
	],
	#category : #PE
}

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 class >> def [
	^<def>
	typedef struct _IMAGE_OPTIONAL_HEADER {
		WORD                 Magic;
		BYTE                 MajorLinkerVersion;
		BYTE                 MinorLinkerVersion;
		DWORD                SizeOfCode;
		DWORD                SizeOfInitializedData;
		DWORD                SizeOfUninitializedData;
		DWORD                AddressOfEntryPoint;
		DWORD                BaseOfCode;
		DWORD                BaseOfData;
		DWORD                ImageBase;
		DWORD                SectionAlignment;
		DWORD                FileAlignment;
		WORD                 MajorOperatingSystemVersion;
		WORD                 MinorOperatingSystemVersion;
		WORD                 MajorImageVersion;
		WORD                 MinorImageVersion;
		WORD                 MajorSubsystemVersion;
		WORD                 MinorSubsystemVersion;
		DWORD              		Win32VersionValue;
		DWORD                SizeOfImage;
		DWORD                SizeOfHeaders;
		DWORD                CheckSum;
		WORD                 Subsystem;
		WORD                 DllCharacteristics;
		DWORD                SizeOfStackReserve;
		DWORD                SizeOfStackCommit;
		DWORD                SizeOfHeapReserve;
		DWORD                SizeOfHeapCommit;
		DWORD                LoaderFlags;
		DWORD                NumberOfRvaAndSizes;
		IMAGE_DATA_DIRECTORY DataDirectory[IMAGE_NUMBEROF_DIRECTORY_ENTRIES];
	} IMAGE_OPTIONAL_HEADER, *PIMAGE_OPTIONAL_HEADER;
	</def>
]

{ #category : #private }
IMAGE_OPTIONAL_HEADER32 class >> defaultMagic [
	^self magicPE32
]

{ #category : #'instance creation' }
IMAGE_OPTIONAL_HEADER32 class >> from: aPeFileModel [
	^self new from: aPeFileModel
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 class >> sizeInBytes [
	^sizeInBytes
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> AddressOfEntryPoint [
	^self uLongAtOffset: AddressOfEntryPoint
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> AddressOfEntryPoint: anInteger [
	self uLongAtOffset: AddressOfEntryPoint put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> BaseOfCode [
	^self uLongAtOffset: BaseOfCode
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> BaseOfCode: anInteger [
	self uLongAtOffset: BaseOfCode put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> BaseOfData [
	^self uLongAtOffset: BaseOfData
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> BaseOfData: anInteger [
	self uLongAtOffset: BaseOfData put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> CheckSum [
	^self uLongAtOffset: CheckSum
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> CheckSum: anInteger [
	self uLongAtOffset: CheckSum put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> DataDirectory [
	^self structureAtOffset: DataDirectory ofClass: IMAGE_DATA_DIRECTORY
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> DataDirectory: anIMAGE_DATA_DIRECTORY [
	self bytesAtOffset: DataDirectory put: anIMAGE_DATA_DIRECTORY asParameter
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> DllCharacteristics [
	^self uShortAtOffset: DllCharacteristics
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> DllCharacteristics: anInteger [
	self uShortAtOffset: DllCharacteristics put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> FileAlignment [
	^self uLongAtOffset: FileAlignment
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> FileAlignment: anInteger [
	self uLongAtOffset: FileAlignment put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> imageBase [
	^self ImageBase
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> ImageBase [
	^self uLongAtOffset: ImageBase
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> ImageBase: anInteger [
	self uLongAtOffset: ImageBase put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> LoaderFlags [
	^self uLongAtOffset: LoaderFlags
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> LoaderFlags: anInteger [
	self uLongAtOffset: LoaderFlags put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> Magic [
	^self uShortAtOffset: Magic
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> Magic: anInteger [
	self uShortAtOffset: Magic put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> MajorImageVersion [
	^self uShortAtOffset: MajorImageVersion
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> MajorImageVersion: anInteger [
	self uShortAtOffset: MajorImageVersion put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> MajorLinkerVersion [
	^self byteAtOffset: MajorLinkerVersion
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> MajorLinkerVersion: anInteger [
	self byteAtOffset: MajorLinkerVersion put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> MajorOperatingSystemVersion [
	^self uShortAtOffset: MajorOperatingSystemVersion
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> MajorOperatingSystemVersion: anInteger [
	self uShortAtOffset: MajorOperatingSystemVersion put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> MajorSubsystemVersion [
	^self uShortAtOffset: MajorSubsystemVersion
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> MajorSubsystemVersion: anInteger [
	self uShortAtOffset: MajorSubsystemVersion put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> MinorImageVersion [
	^self uShortAtOffset: MinorImageVersion
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> MinorImageVersion: anInteger [
	self uShortAtOffset: MinorImageVersion put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> MinorLinkerVersion [
	^self byteAtOffset: MinorLinkerVersion
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> MinorLinkerVersion: anInteger [
	self byteAtOffset: MinorLinkerVersion put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> MinorOperatingSystemVersion [
	^self uShortAtOffset: MinorOperatingSystemVersion
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> MinorOperatingSystemVersion: anInteger [
	self uShortAtOffset: MinorOperatingSystemVersion put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> MinorSubsystemVersion [
	^self uShortAtOffset: MinorSubsystemVersion
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> MinorSubsystemVersion: anInteger [
	self uShortAtOffset: MinorSubsystemVersion put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> NumberOfRvaAndSizes [
	^self uLongAtOffset: NumberOfRvaAndSizes
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> NumberOfRvaAndSizes: anInteger [
	self uLongAtOffset: NumberOfRvaAndSizes put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> SectionAlignment [
	^self uLongAtOffset: SectionAlignment
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> SectionAlignment: anInteger [
	self uLongAtOffset: SectionAlignment put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> SizeOfCode [
	^self uLongAtOffset: SizeOfCode
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> SizeOfCode: anInteger [
	self uLongAtOffset: SizeOfCode put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> SizeOfHeaders [
	^self uLongAtOffset: SizeOfHeaders
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> SizeOfHeaders: anInteger [
	self uLongAtOffset: SizeOfHeaders put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> SizeOfHeapCommit [
	^self uLongAtOffset: SizeOfHeapCommit
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> SizeOfHeapCommit: anInteger [
	self uLongAtOffset: SizeOfHeapCommit put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> SizeOfHeapReserve [
	^self uLongAtOffset: SizeOfHeapReserve
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> SizeOfHeapReserve: anInteger [
	self uLongAtOffset: SizeOfHeapReserve put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> SizeOfImage [
	^self uLongAtOffset: SizeOfImage
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> SizeOfImage: anInteger [
	self uLongAtOffset: SizeOfImage put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> SizeOfInitializedData [
	^self uLongAtOffset: SizeOfInitializedData
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> SizeOfInitializedData: anInteger [
	self uLongAtOffset: SizeOfInitializedData put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> SizeOfStackCommit [
	^self uLongAtOffset: SizeOfStackCommit
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> SizeOfStackCommit: anInteger [
	self uLongAtOffset: SizeOfStackCommit put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> SizeOfStackReserve [
	^self uLongAtOffset: SizeOfStackReserve
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> SizeOfStackReserve: anInteger [
	self uLongAtOffset: SizeOfStackReserve put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> SizeOfUninitializedData [
	^self uLongAtOffset: SizeOfUninitializedData
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> SizeOfUninitializedData: anInteger [
	self uLongAtOffset: SizeOfUninitializedData put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> Subsystem [
	^self uShortAtOffset: Subsystem
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> Subsystem: anInteger [
	self uShortAtOffset: Subsystem put: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> Win32VersionValue [
	^self uLongAtOffset: Win32VersionValue
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER32 >> Win32VersionValue: anInteger [
	self uLongAtOffset: Win32VersionValue put: anInteger
]

