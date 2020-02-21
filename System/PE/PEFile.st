Class {
	#name : #PEFile,
	#superclass : #Object,
	#instVars : [
		'#dosHeader',
		'#dosStub',
		'#ntHeader',
		'#sectionHeaders'
	],
	#category : #PE
}

{ #category : #private }
PEFile class >> codeForMessage: aString exitCode: aByte [
	| code |
	code := ByteArray streamContents: [:strm | 
		strm
			nextPutAll: #[
				16r0E				" push cs "
				16r1F				" pop ds "
				16rBA 16r0E 16r00	" mov dx, 0e "
				16rB4 16r09			" mov ah, 9 "
				16rCD 16r21			" int 21 "
				16rB8];
			nextPut: aByte;
			nextPutAll: #[
				16r4C				" mov ax, 4c00 + aByte "
				16rCD 16r21			" int 21 "];
			nextPutAll: aString;
			nextPut: 16r24].
	^code
]

{ #category : #'instance creation' }
PEFile class >> fromFileNamed: filename [
	| file |
	file := filename asFilename asFile binaryReadStream.
	^[self fromStream: file] ensure: [file close]
]

{ #category : #'instance creation' }
PEFile class >> fromStream: strm [
	^self new fromStream: strm
]

{ #category : #'instance creation' }
PEFile class >> new [
	^super new initialize
]

{ #category : #references }
PEFile class >> references [
	"
	PEFile references
	"
	ShellDLL current
		openWebPage: 'http://www.microsoft.com/whdc/system/platform/firmware/PECOFFdwn.mspx'.
	ShellDLL current
		openWebPage: 'http://win32assembly.online.fr/tutorials.html'.
	ShellDLL current
		openWebPage: 'http://www.csn.ul.ie/~caolan/publink/winresdump/winresdump/doc/pefile.html'.
	ShellDLL current openWebPage: 'http://www.ntcore.com/exsuite.php'.
	ShellDLL current
		openWebPage: 'http://webster.cs.ucr.edu/Page_TechDocs/pe.txt'.
	ShellDLL current
		openWebPage: 'http://msdn.microsoft.com/es-ar/magazine/cc301808(en-us).aspx'
]

{ #category : #accessing }
PEFile >> addNewSectionHeader [
	| header aligned |
	header := IMAGE_SECTION_HEADER new.
	sectionHeaders add: header.
	ntHeader numberOfSections: sectionHeaders size.
	aligned := self totalSizeOfHeaders alignedTo: self fileAlignment.
	ntHeader sizeOfHeaders: aligned.
	^header
]

{ #category : #actions }
PEFile >> beDLL [
	ntHeader beDLL
]

{ #category : #actions }
PEFile >> beExecutableImage [
	ntHeader beExecutableImage
]

{ #category : #accessing }
PEFile >> entrypoint: anRva [
	ntHeader entrypoint: anRva
]

{ #category : #accessing }
PEFile >> exportDirectoryAddress: anInteger [
	ntHeader OptionalHeader exportDirectoryAddress: anInteger
]

{ #category : #accessing }
PEFile >> exportDirectorySize: anInteger [
	ntHeader OptionalHeader exportDirectorySize: anInteger
]

{ #category : #accessing }
PEFile >> fileAlignment [
	^ntHeader fileAlignment
]

{ #category : #accessing }
PEFile >> fileHeader [
	^ntHeader FileHeader
]

{ #category : #reading }
PEFile >> fromStream: aStream [
	| fileHeader n offset |
	dosHeader := dosHeader fromStream: aStream reset.
	aStream position: self newHeaderOffset.
	ntHeader := IMAGE_NT_HEADERS64 fromStream: aStream.
	fileHeader := ntHeader FileHeader.
	n := fileHeader NumberOfSections.
	n > 0 ifTrue: [
		offset := self newHeaderOffset + ntHeader sizeInBytes.
		aStream position: offset.
		n timesRepeat: [| section |
			section := PESection fromStream: aStream.
			sectionHeaders add: section header]]
]

{ #category : #accessing }
PEFile >> imageBase [
	^ntHeader imageBase
]

{ #category : #accessing }
PEFile >> imageBase: base [
	ntHeader imageBase: base
]

{ #category : #accessing }
PEFile >> importDirectoryAddress: anInteger [
	ntHeader OptionalHeader importDirectoryAddress: anInteger
]

{ #category : #accessing }
PEFile >> importDirectorySize: anInteger [
	ntHeader OptionalHeader importDirectorySize: anInteger
]

{ #category : #initialization }
PEFile >> initialize [
	super initialize.
	dosHeader := IMAGE_DOS_HEADER new initializeDefault.
	self initializeTypicalDOSStub.
	sectionHeaders := OrderedCollection new
]

{ #category : #initialization }
PEFile >> initializeEmptyPE32 [
	ntHeader := IMAGE_NT_HEADERS32 new initializeDefault
]

{ #category : #initialization }
PEFile >> initializeEmptyPE32Plus [
	ntHeader := IMAGE_NT_HEADERS64 new initializeDefault
]

{ #category : #initialization }
PEFile >> initializeTypicalDOSStub [
	| bytes |
	bytes := self class
		codeForMessage: 'This program cannot be run in DOS mode.'
		exitCode: 1.
	self setupDOSStub: bytes
]

{ #category : #testing }
PEFile >> isDLL [
	^ntHeader isDLL
]

{ #category : #testing }
PEFile >> isDOS [
	^dosHeader e_magic = IMAGE_DOS_HEADER magicDOS
]

{ #category : #testing }
PEFile >> isNT [
	^self isDOS and: [ntHeader Signature = IMAGE_NT_HEADERS32 signatureNT]
]

{ #category : #testing }
PEFile >> isPE32 [
	^self isNT
		and: [ntHeader OptionalHeader Magic = IMAGE_OPTIONAL_HEADER magicPE32]
]

{ #category : #testing }
PEFile >> isPE32Plus [
	^self isNT
		and: [ntHeader OptionalHeader Magic = IMAGE_OPTIONAL_HEADER magicPE32Plus]
]

{ #category : #accessing }
PEFile >> newHeaderOffset [
	^dosHeader e_lfanew
]

{ #category : #accessing }
PEFile >> ntHeader [
	^ntHeader
]

{ #category : #reading }
PEFile >> numberOfSections [
	^sectionHeaders size
]

{ #category : #storing }
PEFile >> saveAs: aFilename [
	| stream |
	stream := aFilename asFilename newBinaryFile.
	[self storeOn: stream] ensure: [stream close]
]

{ #category : #accessing }
PEFile >> sectionAlignment [
	^ntHeader sectionAlignment
]

{ #category : #accessing }
PEFile >> sections [
	^sectionHeaders
]

{ #category : #initialization }
PEFile >> setupDOSStub: bytes [
	| size |
	dosStub := bytes.
	size := bytes size.
	dosHeader
		setupStackAt: size + 100;
		setupSizeForStubSized: size
]

{ #category : #accessing }
PEFile >> startOfSectionContents [
	| bytes |
	bytes := IMAGE_SECTION_HEADER sizeInBytes.
	^self startOfSectionHeaders + (sectionHeaders size * bytes)
]

{ #category : #accessing }
PEFile >> startOfSectionHeaderIndex: index [
	| offset |
	offset := IMAGE_SECTION_HEADER sizeInBytes * (index - 1).
	^self startOfSectionHeaders + offset
]

{ #category : #accessing }
PEFile >> startOfSectionHeaders [
	^dosHeader e_lfanew + ntHeader sizeInBytes
]

{ #category : #storing }
PEFile >> storeHeadersOn: aStream [
	dosHeader storeOn: aStream.
	aStream position: self newHeaderOffset.
	ntHeader storeOn: aStream.
	sectionHeaders withIndexDo: [:sectionHeader :index | | address |
		address := self startOfSectionHeaderIndex: index.
		sectionHeader storeOn: aStream at: address]
]

{ #category : #updating }
PEFile >> totalSizeOfHeaders [
	^self startOfSectionContents
]

{ #category : #updating }
PEFile >> updateBaseOfCode [
	| base |
	base := (sectionHeaders select: [:section | section hasCode])
		minValue: [:section | section VirtualAddress].
	base := base ifNil: [0].
	ntHeader baseOfCode: base
]

{ #category : #updating }
PEFile >> updateBaseOfData [
	| base |
	base := (sectionHeaders select: [:header | header hasInitializedData])
		minValue: [:header | header VirtualAddress].
	base := base ifNil: [0].
	ntHeader baseOfData: base
]

{ #category : #updating }
PEFile >> updateSectionsSummary [
	self
		updateSizeOfCode;
		updateBaseOfCode;
		updateSizeOfData;
		updateBaseOfData;
		updateSizeOfImage
]

{ #category : #updating }
PEFile >> updateSizeOfCode [
	| size |
	size := sectionHeaders
		select: [:section | section hasCode]
		thenSum: [:section | section SizeOfRawData].
	size := size ifNil: 0.
	ntHeader sizeOfCode: size
]

{ #category : #updating }
PEFile >> updateSizeOfData [
	| initialized uninitialized |
	initialized := sectionHeaders
		select: [:section | section hasInitializedData]
		thenSum: [:section | section sizeOfInitializedData].
	uninitialized := sectionHeaders
		select: [:section | section hasUninitializedData]
		thenSum: [:section | section sizeOfUninitializedData].
	initialized := initialized ifNil: 0.
	uninitialized := uninitialized ifNil: 0.
	ntHeader
		sizeOfInitializedData: initialized;
		sizeOfUninitializedData: uninitialized
]

{ #category : #updating }
PEFile >> updateSizeOfImage [
	| headers contents |
	headers := self startOfSectionContents alignedTo: self sectionAlignment.
	contents := sectionHeaders
		sum: [:section | section VirtualSize alignedTo: self sectionAlignment]
		ifNone: 0.
	ntHeader sizeOfImage: headers + contents
]

{ #category : #testing }
PEFile >> wordSize [
	^self isPE32Plus ifTrue: [8] ifFalse: [4]
]

