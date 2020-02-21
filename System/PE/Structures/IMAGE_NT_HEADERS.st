Class {
	#name : #IMAGE_NT_HEADERS,
	#superclass : #PEFileStructure,
	#category : #PE
}

{ #category : #accessing }
IMAGE_NT_HEADERS class >> offsets64 [
^PoolDictionary new
		at: 'FileHeader' put: 4;
		at: 'sizeInBytes' put: 264;
		at: 'Signature' put: 0;
		at: 'OptionalHeader' put: 24;
		yourself
]

{ #category : #private }
IMAGE_NT_HEADERS class >> signatureNT [
	"
	ascii for PE
	"
	^16r4550
]

{ #category : #accessing }
IMAGE_NT_HEADERS >> baseOfCode: anInteger [
	self OptionalHeader BaseOfCode: anInteger
]

{ #category : #accessing }
IMAGE_NT_HEADERS >> baseOfData: anInteger [
	self OptionalHeader BaseOfData: anInteger
]

{ #category : #initialization }
IMAGE_NT_HEADERS >> beDLL [
	self FileHeader isDLL
]

{ #category : #initialization }
IMAGE_NT_HEADERS >> beExecutableImage [
	self FileHeader beExecutableImage
]

{ #category : #accessing }
IMAGE_NT_HEADERS >> entrypoint: rva [
	self OptionalHeader AddressOfEntryPoint: rva
]

{ #category : #constants }
IMAGE_NT_HEADERS >> fileAlignment [
	^self OptionalHeader FileAlignment
]

{ #category : #initialization }
IMAGE_NT_HEADERS >> imageBase [
	^self OptionalHeader imageBase
]

{ #category : #initialization }
IMAGE_NT_HEADERS >> imageBase: base [
	self OptionalHeader ImageBase: base
]

{ #category : #initialization }
IMAGE_NT_HEADERS >> initializeDefault [
	self Signature: self class signatureNT.
	self OptionalHeader initializeDefault.
	self FileHeader
		initializeDefault: self class defaultCharacteristics;
		Machine: self class defaultMachineType;
		SizeOfOptionalHeader: self OptionalHeader sizeInBytes
]

{ #category : #input }
IMAGE_NT_HEADERS >> numberOfSections: anInteger [
	self FileHeader NumberOfSections: anInteger
]

{ #category : #accessing }
IMAGE_NT_HEADERS >> sectionAlignment [
	^self OptionalHeader SectionAlignment
]

{ #category : #accessing }
IMAGE_NT_HEADERS >> sizeOfCode: anInteger [
	self OptionalHeader SizeOfCode: anInteger
]

{ #category : #accessing }
IMAGE_NT_HEADERS >> sizeOfHeaders: anInteger [
	self OptionalHeader SizeOfHeaders: anInteger
]

{ #category : #accessing }
IMAGE_NT_HEADERS >> sizeOfImage: anInteger [
	self OptionalHeader SizeOfImage: anInteger
]

{ #category : #accessing }
IMAGE_NT_HEADERS >> sizeOfInitializedData: anInteger [
	self OptionalHeader SizeOfInitializedData: anInteger
]

{ #category : #accessing }
IMAGE_NT_HEADERS >> sizeOfUninitializedData: anInteger [
	self OptionalHeader SizeOfUninitializedData: anInteger
]

