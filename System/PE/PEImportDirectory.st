Class {
	#name : #PEImportDirectory,
	#superclass : #Object,
	#instVars : [
		'#imports',
		'#segment',
		'#bytes',
		'#descriptors',
		'#thunks',
		'#originalThunks',
		'#stringTable'
	],
	#category : #PE
}

{ #category : #'instance creation' }
PEImportDirectory class >> new [
	^super new initialize
]

{ #category : #accessing }
PEImportDirectory >> addressOfResolvedImport: symbol in: module [
	| i thunk |
	i := imports findFirst: [:assoc | assoc key = module].
	thunk := (imports at: i) value indexOf: symbol.
	^(thunks at: i) offset + (thunk - 1 * segment wordSize)
]

{ #category : #accessing }
PEImportDirectory >> fillAddresses [
	1
		to: descriptors size
		do: [:index | self setupDescriptorAt: index; setupThunksAt: index].
	segment pefile
		importDirectoryAddress: (segment @ 0) rva;
		importDirectorySize: self totalMemorySize.
	segment pebuilder importReferences keysAndValuesDo: [:source :assoc | | offset |
		offset := self addressOfResolvedImport: assoc value in: assoc key.
		source uLongPut: (segment @ offset) va]
]

{ #category : #accessing }
PEImportDirectory >> imports: aDictionary [
	| strings |
	imports := aDictionary.
	strings := imports gather: [:assoc | assoc value copyWith: assoc key].
	stringTable addStrings: strings
]

{ #category : #initialization }
PEImportDirectory >> initialize [
	stringTable := PEStringTable new
]

{ #category : #initialization }
PEImportDirectory >> initializeDescriptors [
	| offset |
	offset := 0.
	descriptors := OrderedCollection new.
	imports size timesRepeat: [| descriptor |
		descriptor := bytes
			structureAtOffset: offset
			ofClass: IMAGE_IMPORT_DESCRIPTOR.
		descriptors add: descriptor.
		offset := descriptor contents endOffset]
]

{ #category : #initialization }
PEImportDirectory >> initializeStringsTable [
	stringTable
		at: originalThunks last endOffset in: segment;
		bytes: bytes;
		setup
]

{ #category : #initialization }
PEImportDirectory >> initializeStructures [
	bytes := ExternalStructure new: self totalMemorySize.
	segment bytes: bytes contents.
	self initializeDescriptors; initializeThunks; initializeStringsTable
]

{ #category : #accessing }
PEImportDirectory >> initializeThunks [
	| offset size octets |
	offset := self sizeOfDescriptorsTable.
	size := self sizeOfThunksTable.
	thunks := OrderedCollection new.
	originalThunks := OrderedCollection new.
	octets := segment wordSize.
	imports do: [:assoc | | symbols n thunk original |
		symbols := assoc value.
		n := symbols size + 1 * octets.
		thunk := bytes bytesAtOffset: offset count: n.
		original := bytes bytesAtOffset: offset + size count: n.
		thunks add: thunk.
		originalThunks add: original.
		offset := thunk endOffset]
]

{ #category : #accessing }
PEImportDirectory >> offsetOfOriginalThunksTable [
	^self offsetOfThunksTable + self sizeOfThunksTable
]

{ #category : #accessing }
PEImportDirectory >> segment: aLogicalSegment [
	segment := aLogicalSegment
]

{ #category : #accessing }
PEImportDirectory >> setupDescriptorAt: index [
	| descriptor thunk original assoc module offset |
	descriptor := descriptors at: index.
	thunk := thunks at: index.
	original := originalThunks at: index.
	assoc := imports at: index.
	module := assoc key.
	offset := stringTable offsetOf: module.
	descriptor
		Name: (segment @ offset) rva;
		FirstThunk: (segment @ thunk offset) rva;
		OriginalFirstThunk: (segment @ original offset) rva
]

{ #category : #accessing }
PEImportDirectory >> setupThunksAt: index [
	| symbols thunk original offset |
	symbols := (imports at: index) value.
	thunk := thunks at: index.
	original := originalThunks at: index.
	offset := 0.
	symbols do: [:symbol | | displ |
		displ := (stringTable offsetOf: symbol) - 2.
		thunk uLongAtOffset: offset put: (segment @ displ) rva.
		original uLongAtOffset: offset put: (segment @ displ) rva.
		offset := offset + segment wordSize]
]

{ #category : #accessing }
PEImportDirectory >> sizeOfDescriptorsTable [
	^imports size + 1 * IMAGE_IMPORT_DESCRIPTOR sizeInBytes
]

{ #category : #accessing }
PEImportDirectory >> sizeOfThunksTable [
	| s |
	s := imports sum: [:assoc | assoc value size + 1].
	^s * segment wordSize
]

{ #category : #accessing }
PEImportDirectory >> totalMemorySize [
	^self sizeOfDescriptorsTable + (self sizeOfThunksTable * 2)
		+ stringTable size
]

