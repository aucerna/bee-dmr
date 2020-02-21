Class {
	#name : #PEExportDirectory,
	#superclass : #Object,
	#instVars : [
		'#exports',
		'#segment',
		'#bytes',
		'#directory',
		'#functions',
		'#names',
		'#ordinals',
		'#symbols',
		'#name'
	],
	#category : #PE
}

{ #category : #initialization }
PEExportDirectory class >> new [
	^super new initialize
]

{ #category : #accessing }
PEExportDirectory >> exportedNames [
	^exports collect: #key
]

{ #category : #accessing }
PEExportDirectory >> exports: aCollection [
	exports := aCollection sortBy: [:a :b | a key < b key].
	symbols addStrings: self exportedNames
]

{ #category : #accessing }
PEExportDirectory >> fillAddresses [
	segment pefile
		exportDirectoryAddress: (segment @ 0) rva;
		exportDirectorySize: self totalMemorySize.
	directory
		AddressOfFunctions: (segment @ functions offset) rva;
		AddressOfNames: (segment @ names offset) rva;
		AddressOfNameOrdinals: (segment @ ordinals offset) rva;
		Name: (segment @ (symbols offsetOf: name)) rva.
	exports withIndexDo: [:assoc :index | | function functionNameOffset |
		function := assoc value.
		functions uLongAtOffset: index - 1 * 4 put: function rva.
		functionNameOffset := symbols offsetOf: assoc key.
		names uLongAtOffset: index - 1 * 4 put: (segment @ functionNameOffset) rva]
]

{ #category : #initialization }
PEExportDirectory >> initialize [
	super initialize.
	symbols := PEStringTable new
]

{ #category : #initialization }
PEExportDirectory >> initializeAddressTables [
	| n |
	n := exports size.
	functions := bytes
		bytesAtOffset: IMAGE_EXPORT_DIRECTORY sizeInBytes
		count: n * 4.
	names := bytes bytesAtOffset: functions endOffset count: n * 4.
	ordinals := bytes bytesAtOffset: names endOffset count: n * 2.
	1 to: n do: [:i | ordinals uShortAtOffset: i - 1 * 2 put: i - 1]
]

{ #category : #initialization }
PEExportDirectory >> initializeExportDirectory [
	directory := bytes structureAtOffset: 0 ofClass: IMAGE_EXPORT_DIRECTORY.
	directory
		initializeDefault;
		NumberOfFunctions: exports size;
		NumberOfNames: exports size
]

{ #category : #initialization }
PEExportDirectory >> initializeStringsTable [
	symbols
		at: ordinals endOffset in: segment;
		bytes: bytes;
		setup
]

{ #category : #initialization }
PEExportDirectory >> initializeStructures [
	bytes := ExternalStructure new: self totalMemorySize.
	segment bytes: bytes contents.
	self
		initializeExportDirectory;
		initializeAddressTables;
		initializeStringsTable
]

{ #category : #initialization }
PEExportDirectory >> name: aString [
	name := aString.
	symbols add: aString
]

{ #category : #accessing }
PEExportDirectory >> segment: aLogicalSegment [
	segment := aLogicalSegment
]

{ #category : #accessing }
PEExportDirectory >> totalMemorySize [
	| n dir func strings ords |
	n := exports size.
	dir := IMAGE_EXPORT_DIRECTORY sizeInBytes.
	func := n * 4.
	strings := n * 4.
	ords := n * 2.
	^dir + func + strings + ords + symbols size
]

