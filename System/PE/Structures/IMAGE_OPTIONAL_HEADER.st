Class {
	#name : #IMAGE_OPTIONAL_HEADER,
	#superclass : #PEFileStructure,
	#category : #PE
}

{ #category : #defaults }
IMAGE_OPTIONAL_HEADER class >> defaultFileAlignment [
	^16r200
]

{ #category : #defaults }
IMAGE_OPTIONAL_HEADER class >> defaultImageBase [
	^16r400000
]

{ #category : #defaults }
IMAGE_OPTIONAL_HEADER class >> defaultSectionAlignment [
	^16r1000
]

{ #category : #defaults }
IMAGE_OPTIONAL_HEADER class >> defaultStackCommited [
	^16r1000
]

{ #category : #defaults }
IMAGE_OPTIONAL_HEADER class >> defaultStackReserved [
	^16r40000
]

{ #category : #defaults }
IMAGE_OPTIONAL_HEADER class >> defaultSubsystem [
	^IMAGE_SUBSYSTEM_WINDOWS_CUI
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER class >> exportDirectoryIndex [
	^0
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER class >> importDirectoryIndex [
	^1
]

{ #category : #private }
IMAGE_OPTIONAL_HEADER class >> magicPE32 [
	^16r10B
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER class >> magicPE32Plus [
	^16r20B
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER class >> numberOfDirectoryEntries [
	^16
]

{ #category : #input }
IMAGE_OPTIONAL_HEADER >> dataDirectory: aBufferArray [
	self DataDirectory: aBufferArray contents
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER >> exportDirectory [
	| directory |
	directory := self DataDirectory.
	directory contents
		offset: directory contents offset
			+ (IMAGE_DATA_DIRECTORY sizeInBytes * self class exportDirectoryIndex).
	^directory
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER >> exportDirectoryAddress: anInteger [
	self exportDirectory VirtualAddress: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER >> exportDirectorySize: anInteger [
	self exportDirectory Size: anInteger
]

{ #category : #private }
IMAGE_OPTIONAL_HEADER >> from: aPeFileModel [
	self
		Magic: aPeFileModel peHeaderMagic;
		linkerVersion: aPeFileModel peVersionStamp;
		SizeOfCode: aPeFileModel textSize;
		SizeOfInitializedData: aPeFileModel initializedDataSize;
		SizeOfUninitializedData: aPeFileModel uninitializedDataSize;
		AddressOfEntryPoint: aPeFileModel entry;
		BaseOfCode: aPeFileModel textStart;
		BaseOfData: aPeFileModel dataStart;
		ImageBase: aPeFileModel base;
		SectionAlignment: aPeFileModel sectionAlignment;
		FileAlignment: aPeFileModel fileAlignment;
		MajorOperatingSystemVersion: aPeFileModel osMajor;
		MinorOperatingSystemVersion: aPeFileModel osMinor;
		MajorSubsystemVersion: aPeFileModel ntSubsystemMajor;
		MinorSubsystemVersion: aPeFileModel ntSubsystemMinor;
		SizeOfImage: aPeFileModel sizeOfImage;
		SizeOfHeaders: aPeFileModel sizeOfHeaders;
		Subsystem: aPeFileModel windowsSubsystem;
		SizeOfStackReserve: 16r100000;
		SizeOfStackCommit: 16r1000;
		SizeOfHeapReserve: 16r100000;
		SizeOfHeapCommit: 16r1000;
		NumberOfRvaAndSizes: IMAGE_NUMBEROF_DIRECTORY_ENTRIES
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER >> importDirectory [
	| directory offset |
	directory := self DataDirectory.
	offset := IMAGE_DATA_DIRECTORY sizeInBytes
		* self class importDirectoryIndex.
	directory contents offset: directory contents offset + offset.
	^directory
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER >> importDirectoryAddress: anInteger [
	self importDirectory VirtualAddress: anInteger
]

{ #category : #accessing }
IMAGE_OPTIONAL_HEADER >> importDirectorySize: anInteger [
	self importDirectory Size: anInteger
]

{ #category : #private }
IMAGE_OPTIONAL_HEADER >> initializeDefault [
	self
		Magic: self class defaultMagic;
		ImageBase: self class defaultImageBase;
		Subsystem: self class defaultSubsystem;
		SizeOfStackReserve: self class defaultStackReserved;
		SizeOfStackCommit: self class defaultStackCommited;
		FileAlignment: self class defaultFileAlignment;
		SectionAlignment: self class defaultSectionAlignment;
		NumberOfRvaAndSizes: self class numberOfDirectoryEntries;
		MajorOperatingSystemVersion: 5;
		MajorSubsystemVersion: 4
]

{ #category : #input }
IMAGE_OPTIONAL_HEADER >> linkerVersion: anInteger [
	| major minor |
	major := anInteger at: 2.
	minor := anInteger at: 1.
	self MajorLinkerVersion: major; MinorLinkerVersion: minor
]

