Class {
	#name : #PEBuilder,
	#superclass : #Object,
	#instVars : [
		'#pefile',
		'#sections',
		'#imports',
		'#importReferences',
		'#exports',
		'#relocations',
		'#entrypoint',
		'#name'
	],
	#category : #PE
}

{ #category : #'instance creation' }
PEBuilder class >> new [
	^super new initialize
]

{ #category : #'instance creation' }
PEBuilder class >> newForPE32 [
	^self new initializeEmptyPE32
]

{ #category : #'instance creation' }
PEBuilder class >> newForPE32Plus [
	^self new initializeEmptyPE32Plus
]

{ #category : #initialization }
PEBuilder >> addCodeSection [
	| section |
	section := self addNewSectionNamed: '.text'.
	^section beWritableCode
]

{ #category : #initialization }
PEBuilder >> addInitializedDataSection [
	| section |
	section := self addNewSectionNamed: '.idata'.
	^section beReadWrite; beInitializedData
]

{ #category : #initialization }
PEBuilder >> addNewSectionNamed: aString [
	| new |
	new := PESection new
		header: pefile addNewSectionHeader;
		name: aString;
		builder: self.
	sections add: new.
	^new
]

{ #category : #accessing }
PEBuilder >> anySectionOverlaps: aSection at: address [
	^sections
		anySatisfy: [:section | section overlapsWith: aSection at: address]
]

{ #category : #accessing }
PEBuilder >> anySectionOverlapsInFile: aSection at: address [
	^sections
		anySatisfy: [:section | section overlapsInFileWith: aSection at: address]
]

{ #category : #initialization }
PEBuilder >> createExportDirectory [
	| segment |
	exports isEmpty ifTrue: [^nil].
	segment := self dataSection addNewSegmentNamed: 'exports'.
	^PEExportDirectory new
		name: name;
		exports: exports;
		segment: segment;
		initializeStructures
]

{ #category : #initialization }
PEBuilder >> createImportDirectory [
	| segment modules |
	imports isEmpty ifTrue: [^nil].
	segment := self dataSection addNewSegmentNamed: 'imports'.
	modules := imports associations sortBy: [:a :b | a key < b key].
	^PEImportDirectory new
		imports: modules;
		segment: segment;
		initializeStructures
]

{ #category : #initialization }
PEBuilder >> createRelocationDirectory [
	relocations isEmpty ifTrue: [^nil] ifFalse: [self halt]
]

{ #category : #initialization }
PEBuilder >> dataSection [
	^sections
		detect: [:section | section name = '.idata']
		ifNone: [self addInitializedDataSection]
]

{ #category : #initialization }
PEBuilder >> entrypoint: aLogicalAddress [
	entrypoint := aLogicalAddress
]

{ #category : #initialization }
PEBuilder >> export: aLogicalAddress as: aString [
	^exports add: aString -> aLogicalAddress
]

{ #category : #initialization }
PEBuilder >> exports [
	^exports
]

{ #category : #accessing }
PEBuilder >> fileAlignment [
	^pefile fileAlignment
]

{ #category : #accessing }
PEBuilder >> imageBase [
	^pefile imageBase
]

{ #category : #initialization }
PEBuilder >> import: symbol from: moduleName at: aLogicalAddress [
	| module |
	module := imports at: moduleName ifAbsentPut: [OrderedCollection new].
	module add: symbol.
	importReferences at: aLogicalAddress put: moduleName -> symbol
]

{ #category : #initialization }
PEBuilder >> importReferences [
	^importReferences
]

{ #category : #initialization }
PEBuilder >> initialize [
	pefile := PEFile new.
	sections := OrderedCollection new.
	imports := Dictionary new.
	importReferences := Dictionary new.
	exports := OrderedCollection new.
	relocations := OrderedCollection new.
	name := ''
]

{ #category : #initialization }
PEBuilder >> initializeEmptyPE32 [
	pefile initializeEmptyPE32
]

{ #category : #initialization }
PEBuilder >> initializeEmptyPE32Plus [
	pefile initializeEmptyPE32Plus
]

{ #category : #initialization }
PEBuilder >> layoutPE [
	| importDirectory exportDirectory relocationDirectory |
	importDirectory := self createImportDirectory.
	exportDirectory := self createExportDirectory.
	relocationDirectory := self createRelocationDirectory.
	self layoutSections.
	importDirectory notNil ifTrue: [importDirectory fillAddresses].
	exportDirectory notNil ifTrue: [exportDirectory fillAddresses].
	relocationDirectory notNil ifTrue: [relocationDirectory fillAddresses].
	pefile updateSectionsSummary; entrypoint: entrypoint rva
]

{ #category : #initialization }
PEBuilder >> layoutSections [
	| priority other |
	sections do: #assignSegmentOffsets.
	priority := sections select: #hasPreferredRva.
	other := sections copy removeAll: priority; yourself.
	priority do: [:section | section assignAddresses].
	other do: [:section | section assignAddresses]
]

{ #category : #initialization }
PEBuilder >> nextFreeFileChunkAfter: address [
	| section |
	section := sections
		detect: [:candidate | candidate includesFileAddress: address].
	^section endFileAddress alignedTo: self fileAlignment
]

{ #category : #initialization }
PEBuilder >> nextFreeVirtualChunkAfter: address [
	| section |
	section := sections
		detect: [:candidate | candidate includesVirtualAddress: address].
	^section endVirtualAddress alignedTo: self sectionAlignment
]

{ #category : #accessing }
PEBuilder >> pefile [
	^pefile
]

{ #category : #storing }
PEBuilder >> saveAs: filename [
	| stream |
	name := filename entityName.
	stream := filename newFile.
	stream beBinary.
	[self writeOn: stream] ensure: [stream close]
]

{ #category : #accessing }
PEBuilder >> sectionAlignment [
	^pefile sectionAlignment
]

{ #category : #accessing }
PEBuilder >> startOfSectionContents [
	^pefile startOfSectionContents
]

{ #category : #initialization }
PEBuilder >> wordSize [
	^pefile wordSize
]

{ #category : #initialization }
PEBuilder >> writeOn: aStream [
	self layoutPE.
	pefile storeHeadersOn: aStream.
	sections do: [:section | section storeContentsOn: aStream]
]

